import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/ajustes/viewmodels/settings_viewmodel.dart';
import '../features/auth/auth_service.dart';
import '../features/auth/pin_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/rol_selector/role_selector_screen.dart';
import 'main_shell.dart';

/// Decide qué pantalla raíz mostrar.
///
/// Flujo:
///   1. Si no se completó onboarding → Onboarding.
///   2. Si aún no se eligió rol → RoleSelector.
///   3. Si hay PIN configurado → PinScreen (lock).
///   4. Caso contrario → MainShell.
class RootRouter extends StatefulWidget {
  const RootRouter({super.key});

  @override
  State<RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<RootRouter> {
  bool _showOnboarding = false;
  bool _showRoleSelector = false;
  bool _showPin = false;
  bool _checkedAuth = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _evaluateFlags());
  }

  Future<void> _evaluateFlags() async {
    final settings = context.read<SettingsViewModel>();
    final auth = context.read<AuthService>();
    final onboardingDone = settings.onboardingCompleted;
    final roleChosen = await auth.hasChosenRole();
    final pinNeeded = auth.hasPin;
    if (!mounted) return;
    setState(() {
      _showOnboarding = !onboardingDone;
      _showRoleSelector = onboardingDone && !roleChosen;
      _showPin = onboardingDone && roleChosen && pinNeeded;
      _checkedAuth = true;
    });
  }

  void _completeOnboarding() {
    final settings = context.read<SettingsViewModel>();
    settings.markOnboardingCompleted();
    setState(() {
      _showOnboarding = false;
      _showRoleSelector = true;
      _checkedAuth = true;
    });
  }

  void _onRoleSelected(AppRole role) {
    final auth = context.read<AuthService>();
    auth.setRole(role);
    setState(() {
      _showRoleSelector = false;
      // Re-evaluar para mostrar PIN si está configurado.
      _showPin = auth.hasPin;
      _checkedAuth = true;
    });
  }

  void _onPinSuccess() {
    if (!mounted) return;
    setState(() => _showPin = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(onCompleted: _completeOnboarding);
    }
    if (_showRoleSelector) {
      return RoleSelectorScreen(onSelected: _onRoleSelected);
    }
    if (_showPin && _checkedAuth) {
      return PinScreen(
        key: const ValueKey('pin_lock'),
        mode: PinMode.lock,
        onSuccess: _onPinSuccess,
      );
    }
    return const MainShell();
  }
}

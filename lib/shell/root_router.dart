import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/ajustes/viewmodels/settings_viewmodel.dart';
import '../features/auth/auth_service.dart';
import '../features/auth/pin_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import 'main_shell.dart';

/// Decide qué pantalla raíz mostrar.
///
/// Flujo:
///   1. Si no se completó onboarding → Onboarding.
///   2. Si hay PIN configurado → PinScreen (lock).
///   3. Caso contrario → MainShell.
class RootRouter extends StatefulWidget {
  const RootRouter({super.key});

  @override
  State<RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<RootRouter> {
  bool _showOnboarding = false;
  bool _showPin = false;
  bool _checkedPin = false;

  @override
  void initState() {
    super.initState();
    // Evaluamos flags una vez montado (los repos son async).
    WidgetsBinding.instance.addPostFrameCallback((_) => _evaluateFlags());
  }

  Future<void> _evaluateFlags() async {
    final settings = context.read<SettingsViewModel>();
    final onboardingDone = settings.onboardingCompleted;
    final hasPin = await AuthService.hasPin();
    if (!mounted) return;
    setState(() {
      _showOnboarding = !onboardingDone;
      _showPin = onboardingDone && hasPin;
      _checkedPin = true;
    });
  }

  void _completeOnboarding() {
    final settings = context.read<SettingsViewModel>();
    settings.markOnboardingCompleted();
    setState(() {
      _showOnboarding = false;
      // Mostrar PIN si existe después de onboarding.
      _showPin = false;
      _evaluateFlags();
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
    if (_showPin && _checkedPin) {
      return PinScreen(
        key: const ValueKey('pin_lock'),
        mode: PinMode.lock,
        onSuccess: _onPinSuccess,
      );
    }
    return const MainShell();
  }
}

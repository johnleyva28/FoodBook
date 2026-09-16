import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/ajustes/viewmodels/settings_viewmodel.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../shell/main_shell.dart';

/// Decide si mostrar onboarding (primera vez) o el shell principal.
class RootRouter extends StatefulWidget {
  const RootRouter({super.key});

  @override
  State<RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<RootRouter> {
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    // Evaluamos el flag de onboarding una vez montado.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<SettingsViewModel>();
      setState(() {
        _showOnboarding = !settings.onboardingCompleted;
      });
    });
  }

  void _completeOnboarding() {
    final settings = context.read<SettingsViewModel>();
    settings.markOnboardingCompleted();
    setState(() => _showOnboarding = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(onCompleted: _completeOnboarding);
    }
    return const MainShell();
  }
}

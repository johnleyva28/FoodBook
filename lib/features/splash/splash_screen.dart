import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/foodbook_colors.dart';
import '../../core/theme/foodbook_spacing.dart';
import '../../core/widgets/foodbook_logo.dart';

/// Pantalla de splash inicial.
///
/// Se muestra brevemente mientras la BD se inicializa y `AuthService.load()`
/// corre. Después navega a la pantalla raíz.
class SplashScreen extends StatefulWidget {
  final Widget child;
  final Duration minDuration;

  const SplashScreen({
    super.key,
    required this.child,
    this.minDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Programamos la salida del splash despues del minDuration.
    Future<void>.delayed(widget.minDuration, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (_, _, _) => widget.child,
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: FoodBookColors.navyDeep,
      ),
      child: Scaffold(
        backgroundColor: FoodBookColors.navyDeep,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                FoodBookColors.navyDeep,
                FoodBookColors.navyVariant,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.85, end: 1.0),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutBack,
                    builder: (_, scale, child) =>
                        Transform.scale(scale: scale, child: child),
                    child: const FoodBookLogo(size: 96),
                  ),
                  const SizedBox(height: FoodBookSpacing.xl),
                  const Text(
                    'FoodBook',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: FoodBookSpacing.xs),
                  Text(
                    'Tu pensión, en un cuaderno',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: FoodBookSpacing.xxl),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FoodBookColors.sky,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

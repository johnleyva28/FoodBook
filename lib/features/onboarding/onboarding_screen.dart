import 'package:flutter/material.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';

class OnboardingPage {
  final IconData icon;
  final String title;
  final String body;
  final Color color;
  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });
}

const _pages = [
  OnboardingPage(
    icon: Icons.restaurant_menu_rounded,
    title: 'Bienvenido a FoodBook',
    body:
        'Tu pensión, en un cuaderno. Registra comidas, snacks y pagos sin conexión y sin cuentas.',
    color: FoodBookColors.sky,
  ),
  OnboardingPage(
    icon: Icons.lunch_dining_rounded,
    title: 'Marca lo que comes',
    body:
        'Activa los switches de desayuno, almuerzo y cena. El gasto del día se calcula solo.',
    color: FoodBookColors.cyanBright,
  ),
  OnboardingPage(
    icon: Icons.account_balance_wallet_rounded,
    title: 'Controla tu deuda',
    body:
        'Ve en tiempo real cuánto le debes a la pensión y configura un presupuesto mensual.',
    color: FoodBookColors.warning,
  ),
  OnboardingPage(
    icon: Icons.store_mall_directory_rounded,
    title: '¿Dueño de pensión?',
    body:
        'FoodBook tiene un modo pensión con datos agregados: comensales servidos, balance diario y pedidos. Elígelo después en Ajustes.',
    color: FoodBookColors.cyanBright,
  ),
  OnboardingPage(
    icon: Icons.shield_outlined,
    title: 'Tus datos son privados',
    body:
        'Todo se guarda localmente en tu dispositivo. Ningún servidor, ninguna cuenta, ningún anuncio. Puedes exportar a CSV o JSON cuando quieras.',
    color: FoodBookColors.success,
  ),
];

/// Pantalla de onboarding. Se muestra la primera vez que se abre la app.
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onCompleted;
  const OnboardingScreen({super.key, required this.onCompleted});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = _currentPage == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(FoodBookSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: page.color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(page.icon, size: 96, color: page.color),
                        ),
                        const SizedBox(height: FoodBookSpacing.xl),
                        Text(
                          page.title,
                          style: theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: FoodBookSpacing.md),
                        Text(
                          page.body,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final active = i == _currentPage;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(FoodBookSpacing.lg),
              child: Row(
                children: [
                  if (!isLast)
                    Expanded(
                      child: TextButton(
                        onPressed: widget.onCompleted,
                        child: const Text('Saltar'),
                      ),
                    ),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: () {
                        if (isLast) {
                          widget.onCompleted();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                      child: Text(isLast ? 'Empezar' : 'Siguiente'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../core/theme/foodbook_spacing.dart';
import '../core/theme/foodbook_text_styles.dart';
import '../features/ajustes/screens/settings_screen.dart';
import '../features/cuentas/screens/accounts_screen.dart';
import '../features/perfil/screens/profile_screen.dart';
import '../features/principal/screens/daily_screen.dart';

/// Shell raíz con la barra de navegación inferior.
///
/// Estructura de 4 destinos centrada en "Hoy":
///   | Cuentas | Hoy | Perfil | Ajustes |
///
/// El Historial y el Calendario se acceden desde el Perfil
/// (sección "Mi actividad").
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 1; // Empieza en "Hoy" (centro-izquierda)

  late final List<_Destination> _destinations = const [
    _Destination(
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet_rounded,
      label: 'Cuentas',
      screen: AccountsScreen(),
    ),
    _Destination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Hoy',
      screen: DailyScreen(),
    ),
    _Destination(
      icon: Icons.person_outline,
      selectedIcon: Icons.person_rounded,
      label: 'Perfil',
      screen: ProfileScreen(),
    ),
    _Destination(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      label: 'Ajustes',
      screen: SettingsScreen(),
    ),
  ];

  void _select(int i) {
    if (_index == i) return;
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: _destinations.map((d) => d.screen).toList(),
      ),
      bottomNavigationBar: _GlassBottomBar(
        destinations: _destinations,
        selectedIndex: _index,
        onSelect: _select,
        theme: theme,
      ),
    );
  }
}

class _Destination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final Widget screen;
  const _Destination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.screen,
  });
}

class _GlassBottomBar extends StatelessWidget {
  final List<_Destination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final ThemeData theme;

  const _GlassBottomBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelect,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          FoodBookSpacing.lg,
          0,
          FoodBookSpacing.lg,
          FoodBookSpacing.md,
        ),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(FoodBookSpacing.radiusXl),
            border: Border.all(color: theme.colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: List.generate(destinations.length, (i) {
              final d = destinations[i];
              final selected = i == selectedIndex;
              return Expanded(
                child: _NavItem(
                  destination: d,
                  selected: selected,
                  onTap: () => onSelect(i),
                  theme: theme,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final _Destination destination;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FoodBookSpacing.radiusXl),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? theme.colorScheme.primary.withValues(alpha: 0.18)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    FoodBookSpacing.radiusFull,
                  ),
                ),
                child: Icon(
                  selected ? destination.selectedIcon : destination.icon,
                  size: 24,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                destination.label,
                style: FoodBookTextStyles.labelSmall.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

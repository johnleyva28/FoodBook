import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../data/app_data_streams.dart';

/// Pantalla de menú del día para el rol pensión.
///
/// Muestra los platillos típicos servidos en cada turno:
///   * Desayuno: agregado de desayunos servidos
///   * Almuerzo: agregado de almuerzos servidos
///   * Cena: agregado de cenas servidas
///
/// Por ahora muestra datos agregados (placeholder); el dueño puede
/// después registrar el menú de cada turno en una versión futura.
class MenuComidaScreen extends StatelessWidget {
  const MenuComidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.restaurant_menu_rounded,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: FoodBookSpacing.sm),
            const Text('Menú del día'),
          ],
        ),
      ),
      body: Consumer<AppDataStreams>(
        builder: (context, streams, _) {
          final today = _todayIso();
          final todayLogs = streams.logs.where((l) => l.date == today).toList();

          final breakfasts = todayLogs.where((l) => l.hadBreakfast).length;
          final lunches = todayLogs.where((l) => l.hadLunch).length;
          final dinners = todayLogs.where((l) => l.hadDinner).length;

          return ListView(
            padding: const EdgeInsets.all(FoodBookSpacing.lg),
            children: [
              Text(
                'Hoy',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: FoodBookSpacing.sm),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: FoodBookSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      _MenuTurno(
                        icon: Icons.free_breakfast_rounded,
                        label: 'Desayunos',
                        detalle: breakfasts == 0
                            ? 'Aún sin pedidos'
                            : '$breakfasts ${breakfasts == 1 ? "servido" : "servidos"}',
                        color: FoodBookColors.warning,
                      ),
                      const Divider(height: 1),
                      _MenuTurno(
                        icon: Icons.lunch_dining_rounded,
                        label: 'Almuerzos',
                        detalle: lunches == 0
                            ? 'Aún sin pedidos'
                            : '$lunches ${lunches == 1 ? "servido" : "servidos"}',
                        color: FoodBookColors.skyLight,
                      ),
                      const Divider(height: 1),
                      _MenuTurno(
                        icon: Icons.dinner_dining_rounded,
                        label: 'Cenas',
                        detalle: dinners == 0
                            ? 'Aún sin pedidos'
                            : '$dinners ${dinners == 1 ? "servida" : "servidas"}',
                        color: FoodBookColors.cyanBright,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: FoodBookSpacing.xl),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(FoodBookSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.tips_and_updates_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: FoodBookSpacing.sm),
                          Text(
                            'Próximamente',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: FoodBookSpacing.sm),
                      Text(
                        'Editor de menú por turno (desayuno, almuerzo, cena) '
                        'con precio, descripción y foto. Disponible en la '
                        'próxima versión.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _todayIso() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${now.year}-${two(now.month)}-${two(now.day)}';
  }
}

class _MenuTurno extends StatelessWidget {
  final IconData icon;
  final String label;
  final String detalle;
  final Color color;

  const _MenuTurno({
    required this.icon,
    required this.label,
    required this.detalle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FoodBookSpacing.lg,
        vertical: FoodBookSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(FoodBookSpacing.radiusSm),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: FoodBookSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.titleSmall),
                Text(detalle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/widgets/stat_row.dart';
import '../../../data/app_data_streams.dart';

/// Pantalla "Clientes" del rol pensión.
///
/// Lista los días con actividad (logs + snacks + pagos) agrupados por
/// fecha con totales del día. Funciona como un "historial agregado" para
/// que el dueño vea la actividad reciente de la pensión.
class ComensalesScreen extends StatelessWidget {
  const ComensalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.people_alt_rounded,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: FoodBookSpacing.sm),
            const Text('Actividad'),
          ],
        ),
      ),
      body: Consumer<AppDataStreams>(
        builder: (context, streams, _) {
          final byDate = <String, _DayActivity>{};

          for (final l in streams.logs) {
            final a = byDate[l.date] ?? _DayActivity(l.date);
            if (l.hadBreakfast) a.breakfasts++;
            if (l.hadLunch) a.lunches++;
            if (l.hadDinner) a.dinners++;
            a.consumed += l.breakfastPrice;
            byDate[l.date] = a;
          }
          for (final s in streams.snacks) {
            final a = byDate[s.date] ?? _DayActivity(s.date);
            a.snacks++;
            a.consumed += s.price;
            byDate[s.date] = a;
          }
          for (final p in streams.payments) {
            final a = byDate[p.date] ?? _DayActivity(p.date);
            a.payments++;
            a.paid += p.amount;
            byDate[p.date] = a;
          }

          final dates = byDate.keys.toList()..sort((a, b) => b.compareTo(a));

          if (dates.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(FoodBookSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.event_busy_rounded,
                      size: 96,
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: FoodBookSpacing.md),
                    Text(
                      'Sin actividad aún',
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: FoodBookSpacing.xs),
                    Text(
                      'Cuando los comensales registren comidas, snacks o '
                      'pagos, aparecerán aquí.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(FoodBookSpacing.lg),
            itemCount: dates.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: FoodBookSpacing.md),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: FoodBookSpacing.sm,
                      ),
                      child: Column(
                        children: [
                          StatRow(
                            icon: Icons.event_available_rounded,
                            label: 'Días con actividad',
                            value: '${dates.length}',
                            valueColor: FoodBookColors.skyLight,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              final date = dates[i - 1];
              final a = byDate[date]!;
              return Card(
                margin: const EdgeInsets.only(bottom: FoodBookSpacing.sm),
                child: Padding(
                  padding: const EdgeInsets.all(FoodBookSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(date),
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: FoodBookSpacing.sm),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (a.breakfasts > 0)
                            _Chip(
                              icon: Icons.free_breakfast_rounded,
                              text: '${a.breakfasts} desayuno',
                              color: FoodBookColors.warning,
                            ),
                          if (a.lunches > 0)
                            _Chip(
                              icon: Icons.lunch_dining_rounded,
                              text: '${a.lunches} almuerzo',
                              color: FoodBookColors.skyLight,
                            ),
                          if (a.dinners > 0)
                            _Chip(
                              icon: Icons.dinner_dining_rounded,
                              text: '${a.dinners} cena',
                              color: FoodBookColors.cyanBright,
                            ),
                          if (a.snacks > 0)
                            _Chip(
                              icon: Icons.cookie_rounded,
                              text: '${a.snacks} snack',
                              color: FoodBookColors.warning,
                            ),
                          if (a.payments > 0)
                            _Chip(
                              icon: Icons.payments_rounded,
                              text: '${a.payments} pago',
                              color: FoodBookColors.success,
                            ),
                        ],
                      ),
                      const SizedBox(height: FoodBookSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Consumido: S/ ${a.consumed.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            'Cobrado: S/ ${a.paid.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: FoodBookColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final d = DateHelper.parse(iso);
      const months = [
        'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
      ];
      return '${d.day} ${months[d.month - 1]} ${d.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _DayActivity {
  final String date;
  int breakfasts = 0;
  int lunches = 0;
  int dinners = 0;
  int snacks = 0;
  int payments = 0;
  double consumed = 0;
  double paid = 0;
  _DayActivity(this.date);
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _Chip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(FoodBookSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

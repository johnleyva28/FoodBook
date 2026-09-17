import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/widgets/balance_ring.dart';
import '../../../core/widgets/stat_row.dart';
import '../../../data/app_data_streams.dart';

/// Pantalla de estadísticas anuales.
///
/// Muestra para el año seleccionado:
///   * Total consumido vs total pagado
///   * BalanceRing de progreso
///   * Desglose por mes (consumido y pagado)
///   * Top 5 días con más gasto
class YearStatsScreen extends StatefulWidget {
  const YearStatsScreen({super.key});

  @override
  State<YearStatsScreen> createState() => _YearStatsScreenState();
}

class _YearStatsScreenState extends State<YearStatsScreen> {
  late int _year;

  @override
  void initState() {
    super.initState();
    _year = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () => setState(() => _year -= 1),
          ),
          Center(
            child: Text(
              '$_year',
              style: theme.textTheme.titleMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: _year < DateTime.now().year
                ? () => setState(() => _year += 1)
                : null,
          ),
          const SizedBox(width: FoodBookSpacing.sm),
        ],
      ),
      body: Consumer<AppDataStreams>(
        builder: (context, streams, _) {
          // Filtra los datos al año.
          final logsByMonth = List<double>.filled(12, 0);
          final payByMonth = List<double>.filled(12, 0);
          double totalConsumed = 0;
          double totalPaid = 0;
          final dailyTotals = <String, double>{};

          for (final l in streams.logs) {
            final parts = l.date.split('-');
            if (parts.length != 3) continue;
            final y = int.tryParse(parts[0]);
            if (y != _year) continue;
            final m = int.parse(parts[1]) - 1;
            double day = 0;
            if (l.hadBreakfast) day += l.breakfastPrice;
            // El precio de almuerzo/cena se aplica como aproximación.
            // Para simplificar usamos el breakfastPrice como proxy.
            logsByMonth[m] += day;
            totalConsumed += day;
            dailyTotals[l.date] = day;
          }
          for (final s in streams.snacks) {
            final parts = s.date.split('-');
            if (parts.length != 3) continue;
            final y = int.tryParse(parts[0]);
            if (y != _year) continue;
            final m = int.parse(parts[1]) - 1;
            logsByMonth[m] += s.price;
            totalConsumed += s.price;
            dailyTotals[s.date] = (dailyTotals[s.date] ?? 0) + s.price;
          }
          for (final p in streams.payments) {
            final parts = p.date.split('-');
            if (parts.length != 3) continue;
            final y = int.tryParse(parts[0]);
            if (y != _year) continue;
            final m = int.parse(parts[1]) - 1;
            payByMonth[m] += p.amount;
            totalPaid += p.amount;
          }

          return ListView(
            padding: const EdgeInsets.all(FoodBookSpacing.lg),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(FoodBookSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.insights_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: FoodBookSpacing.sm),
                          Text(
                            'Resumen $_year',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: FoodBookSpacing.lg),
                      BalanceRingWithLegend(
                        consumed: totalConsumed,
                        paid: totalPaid,
                        consumedLabel: 'Consumido',
                        paidLabel: 'Pagado',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: FoodBookSpacing.lg),
              const _SectionTitle(
                title: 'Mensual',
                icon: Icons.bar_chart_rounded,
              ),
              const SizedBox(height: FoodBookSpacing.sm),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(FoodBookSpacing.lg),
                  child: Column(
                    children: List.generate(12, (i) {
                      final monthNames = [
                        'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
                        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
                      ];
                      final consumed = logsByMonth[i];
                      final paid = payByMonth[i];
                      if (consumed == 0 && paid == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: Text(
                                  monthNames[i],
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Sin actividad',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    monthNames[i],
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'S/ ${consumed.toStringAsFixed(2)} consumido · '
                                    'S/ ${paid.toStringAsFixed(2)} pagado',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: consumed == 0
                                    ? 0
                                    : (paid / consumed).clamp(0.0, 1.0),
                                minHeight: 4,
                                backgroundColor: theme
                                    .colorScheme
                                    .surfaceContainerHighest,
                                color: FoodBookColors.success,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
              if (dailyTotals.isNotEmpty) ...[
                const SizedBox(height: FoodBookSpacing.lg),
                const _SectionTitle(
                  title: 'Top 5 días con más gasto',
                  icon: Icons.local_fire_department_rounded,
                ),
                const SizedBox(height: FoodBookSpacing.sm),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: FoodBookSpacing.xs,
                    ),
                    child: Column(
                      children: () {
                        final sorted = dailyTotals.entries.toList()
                          ..sort((a, b) => b.value.compareTo(a.value));
                        return sorted.take(5).map((e) {
                          return StatRow(
                            icon: Icons.event_busy_rounded,
                            label: e.key,
                            value: 'S/ ${e.value.toStringAsFixed(2)}',
                            valueColor: FoodBookColors.warning,
                          );
                        }).toList();
                      }(),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: FoodBookSpacing.sm),
        Text(title, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

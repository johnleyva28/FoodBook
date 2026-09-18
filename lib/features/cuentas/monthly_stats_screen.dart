import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/daily_bar_chart.dart';
import '../../../data/app_data_streams.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/snack_repository.dart';

/// Resumen mensual del consumo.
///
/// Muestra:
/// - Total del mes en el centro
/// - Chart de barras con consumo por dia del mes
/// - Lista de los top 5 días con mayor consumo
class MonthlyStatsScreen extends StatefulWidget {
  const MonthlyStatsScreen({super.key, DateTime? initialMonth})
      // ignore: prefer_initializing_formals
      : _initialMonth = initialMonth;

  final DateTime? _initialMonth;
  @override
  State<MonthlyStatsScreen> createState() => _MonthlyStatsScreenState();
}
class _MonthlyStatsScreenState extends State<MonthlyStatsScreen> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = widget._initialMonth ?? DateTime(now.year, now.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _month = DateTime(_month.year, _month.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _month = DateTime(_month.year, _month.month + 1, 1);
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() => _month = DateTime(now.year, now.month, 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final streams = context.watch<AppDataStreams>();
    final formatter = MoneyFormatter.defaultPen;

    final range = DateHelper.monthRange(_month);
    final fromDate = DateHelper.format(range.start);
    final toDate = DateHelper.format(range.end);

    // Calcula totales del mes
    final monthSnacks = streams.snacks.where((s) {
      return s.date.compareTo(fromDate) >= 0 && s.date.compareTo(toDate) <= 0;
    }).toList();
    final monthPayments = streams.payments.where((p) {
      return p.date.compareTo(fromDate) >= 0 && p.date.compareTo(toDate) <= 0;
    }).toList();

    final totalConsumed =
        monthSnacks.fold<double>(0, (sum, s) => sum + s.price);
    final totalPaid =
        monthPayments.fold<double>(0, (sum, p) => sum + p.amount);
    final balance = totalConsumed - totalPaid;

    // Top 5 días con mayor consumo
    final byDate = <String, double>{};
    for (final s in monthSnacks) {
      byDate[s.date] = (byDate[s.date] ?? 0) + s.price;
    }
    final topDays = byDate.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5 = topDays.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen mensual'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(FoodBookSpacing.lg),
        children: [
          // ── Selector de mes ──
          Card(
            child: Padding(
              padding: const EdgeInsets.all(FoodBookSpacing.md),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: _previousMonth,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        DateHelper.monthYear(_month),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: _nextMonth,
                  ),
                  if (!DateHelper.isCurrentMonth(_month))
                    TextButton.icon(
                      onPressed: _goToToday,
                      icon: const Icon(Icons.today_rounded, size: 18),
                      label: const Text('Actual'),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Tarjetas de resumen ──
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Consumido',
                  value: formatter.format(totalConsumed),
                  icon: Icons.lunch_dining_rounded,
                  color: FoodBookColors.success,
                ),
              ),
              const SizedBox(width: FoodBookSpacing.sm),
              Expanded(
                child: _StatTile(
                  label: 'Pagado',
                  value: formatter.format(totalPaid),
                  icon: Icons.payments_rounded,
                  color: FoodBookColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: FoodBookSpacing.sm),
          _BalanceTile(
            consumed: totalConsumed,
            paid: totalPaid,
            balance: balance,
            formatter: formatter,
            theme: theme,
          ),

          const SizedBox(height: FoodBookSpacing.lg),

          // ── Chart de barras ──
          if (monthSnacks.isNotEmpty) ...[
            Text(
              'Consumo por día',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: FoodBookSpacing.sm),
            SizedBox(
              height: 220,
              child: DailyBarChart(
                data: _buildChartData(byDate, range),
                unitPrefix: 'S/ ',
              ),
            ),
            const SizedBox(height: FoodBookSpacing.lg),
          ],

          // ── Top 5 días ──
          if (top5.isNotEmpty) ...[
            Text(
              'Top 5 días con mayor consumo',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: FoodBookSpacing.sm),
            ...top5.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              final day = entry.value.key;
              final amount = entry.value.value;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.18,
                    ),
                    child: Text(
                      '$idx',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    DateHelper.label(DateHelper.parse(day)),
                  ),
                  trailing: Text(
                    formatter.format(amount),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              );
            }),
            const SizedBox(height: FoodBookSpacing.lg),
          ],

          // ── Pie chart por categoria ──
          if (monthSnacks.isNotEmpty) ...[
            Text(
              'Distribución por categoría',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: FoodBookSpacing.sm),
            _MonthPie(snacks: monthSnacks, theme: theme),
          ],

          if (monthSnacks.isEmpty && monthPayments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(FoodBookSpacing.xl),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: FoodBookSpacing.md),
                    Text(
                      'Sin datos para este mes',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(FoodBookSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: FoodBookSpacing.xs),
                Text(label, style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: FoodBookSpacing.sm),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceTile extends StatelessWidget {
  final double consumed;
  final double paid;
  final double balance;
  final MoneyFormatter formatter;
  final ThemeData theme;

  const _BalanceTile({
    required this.consumed,
    required this.paid,
    required this.balance,
    required this.formatter,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final pending = balance > 0 ? balance : 0.0;
    final color = pending > 0
        ? theme.colorScheme.error
        : FoodBookColors.success;
    return Card(
      color: color.withValues(alpha: 0.10),
      child: Padding(
        padding: const EdgeInsets.all(FoodBookSpacing.md),
        child: Row(
          children: [
            Icon(
              pending > 0 ? Icons.warning_rounded : Icons.check_circle_rounded,
              color: color,
            ),
            const SizedBox(width: FoodBookSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pending > 0 ? 'Pendiente del mes' : 'Mes completo',
                    style: theme.textTheme.titleSmall,
                  ),
                  Text(
                    pending > 0
                        ? formatter.format(pending)
                        : 'Todo pagado',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
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

class _MonthPie extends StatelessWidget {
  final List<SnackEntry> snacks;
  final ThemeData theme;

  const _MonthPie({required this.snacks, required this.theme});

  @override
  Widget build(BuildContext context) {
    final byCat = <String, double>{};
    for (final s in snacks) {
      String? cat;
      final desc = s.description;
      if (desc != null && desc.startsWith(SnackRepository.categoryPrefix)) {
        final end = desc.indexOf(']');
        if (end > 0) cat = desc.substring(5, end);
      }
      cat ??= 'Otros';
      byCat[cat] = (byCat[cat] ?? 0) + s.price;
    }
    final entries = byCat.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final formatter = MoneyFormatter.defaultPen;
    final colors = <Color>[
      FoodBookColors.sky,
      FoodBookColors.cyanBright,
      FoodBookColors.success,
      FoodBookColors.warning,
      FoodBookColors.skyMuted,
    ];
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: entries.asMap().entries.map((e) {
                  return PieChartSectionData(
                    value: e.value.value,
                    color: colors[e.key % colors.length],
                    radius: 60,
                    title: '',
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 32,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: entries.take(5).map((e) {
                final idx = entries.indexOf(e) % colors.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors[idx],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: FoodBookSpacing.xs),
                      Expanded(
                        child: Text(
                          '${e.key}: ${formatter.formatCompact(e.value)}',
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

List<DailyChartData> _buildChartData(
  Map<String, double> byDate,
  ({DateTime start, DateTime end}) range,
) {
  final result = <DailyChartData>[];
  var d = range.start;
  final today = DateTime.now();
  while (!d.isAfter(range.end)) {
    final iso = DateHelper.format(d);
    result.add(DailyChartData(
      label: DateHelper.format(d),
      value: byDate[iso] ?? 0,
      isToday: d.year == today.year && d.month == today.month && d.day == today.day,
    ));
    d = d.add(const Duration(days: 1));
  }
  return result;
}

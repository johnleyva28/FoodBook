import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/foodbook_colors.dart';

/// Datos del gráfico: una barra por día con su total.
class DailyChartData {
  final String label;
  final double value;
  final bool isToday;
  const DailyChartData({
    required this.label,
    required this.value,
    this.isToday = false,
  });
}

/// Gráfico de barras para los últimos N días (default 7).
class DailyBarChart extends StatelessWidget {
  final List<DailyChartData> data;
  final String? unitPrefix;

  const DailyBarChart({
    super.key,
    required this.data,
    this.unitPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (data.isEmpty) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Text(
            'Sin datos',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }
    final maxValue = data.fold<double>(0, (m, d) => d.value > m ? d.value : m);
    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue == 0 ? 100 : maxValue * 1.2,
          minY: 0,
          barGroups: List.generate(data.length, (i) {
            final d = data[i];
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: d.value,
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                  color: d.isToday
                      ? theme.colorScheme.primary
                      : FoodBookColors.skyMuted,
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      '${value.toInt()}',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= data.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      data[i].label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        fontWeight: data[i].isToday
                            ? FontWeight.w800
                            : FontWeight.w400,
                        color: data[i].isToday
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue == 0 ? 25 : maxValue / 4,
            getDrawingHorizontalLine: (_) => FlLine(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, gIdx, rod, rIdx) {
                final d = data[group.x];
                return BarTooltipItem(
                  '${unitPrefix ?? ''}${d.value.toStringAsFixed(2)}\n${d.label}',
                  theme.textTheme.bodySmall!.copyWith(color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/foodbook_colors.dart';
import '../theme/foodbook_spacing.dart';

/// Gráfico de torta (PieChart) con leyenda interactiva.
///
/// Cada sección tiene su color y muestra el porcentaje al centro.
/// Al tocar una sección se resalta (focusIndex).
class FoodBookPieChart extends StatefulWidget {
  final Map<String, double> data; // categoria -> valor
  final double size;
  final String? emptyLabel;

  const FoodBookPieChart({
    super.key,
    required this.data,
    this.size = 180,
    this.emptyLabel,
  });

  @override
  State<FoodBookPieChart> createState() => _FoodBookPieChartState();
}

class _FoodBookPieChartState extends State<FoodBookPieChart> {
  int _focused = -1;

  static const _palette = <Color>[
    FoodBookColors.sky,
    FoodBookColors.warning,
    FoodBookColors.success,
    FoodBookColors.danger,
    FoodBookColors.cyanBright,
    FoodBookColors.skyLight,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = widget.data.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold<double>(0, (s, e) => s + e.value);

    if (entries.isEmpty) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: Center(
          child: Text(
            widget.emptyLabel ?? 'Sin datos',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: PieChart(
            PieChartData(
              sections: [
                for (var i = 0; i < entries.length; i++)
                  PieChartSectionData(
                    color: _palette[i % _palette.length],
                    value: entries[i].value,
                    title: total == 0
                        ? ''
                        : '${(entries[i].value / total * 100).round()}%',
                    radius: i == _focused
                        ? widget.size * 0.18
                        : widget.size * 0.14,
                    titleStyle: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
              centerSpaceRadius: widget.size * 0.18,
              sectionsSpace: 2,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.touchedSection == null) {
                    setState(() => _focused = -1);
                    return;
                  }
                  setState(() {
                    _focused =
                        response.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: FoodBookSpacing.md),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < entries.length; i++)
                GestureDetector(
                  onTap: () => setState(() {
                    _focused = i == _focused ? -1 : i;
                  }),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _palette[i % _palette.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            entries[i].key,
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(entries[i].value / total * 100).round()}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

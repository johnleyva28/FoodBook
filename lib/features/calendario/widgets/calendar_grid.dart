import 'package:flutter/material.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/theme/foodbook_text_styles.dart';

/// Día visible en el grid del calendario.
class CalendarDay {
  final DateTime date;
  final bool inCurrentMonth;
  final bool isToday;
  final bool hasActivity;
  final double total;

  const CalendarDay({
    required this.date,
    required this.inCurrentMonth,
    required this.isToday,
    required this.hasActivity,
    required this.total,
  });
}

/// Grid mensual 7xN con marcadores para días con actividad.
///
/// `onDayTap` recibe un `CalendarDay` cuando el usuario toca una celda.
class CalendarGrid extends StatelessWidget {
  final DateTime viewedMonth;
  final Set<String> datesWithActivity;
  final Map<String, double> totalsByDate;
  final ValueChanged<CalendarDay> onDayTap;
  final VoidCallback? onPrevMonth;
  final VoidCallback? onNextMonth;
  final VoidCallback? onToday;
  final String monthLabel;
  final bool canGoNext;

  const CalendarGrid({
    super.key,
    required this.viewedMonth,
    required this.datesWithActivity,
    required this.totalsByDate,
    required this.onDayTap,
    required this.monthLabel,
    this.onPrevMonth,
    this.onNextMonth,
    this.onToday,
    this.canGoNext = true,
  });

  String _key(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();

    final firstOfMonth = DateTime(viewedMonth.year, viewedMonth.month, 1);
    final daysInMonth = DateTime(
      viewedMonth.year,
      viewedMonth.month + 1,
      0,
    ).day;

    // El grid empieza en lunes (1) — locale es_PE.
    // weekday: 1=lunes ... 7=domingo
    final firstWeekday = firstOfMonth.weekday;
    final leadingBlanks = firstWeekday - 1;

    final cells = <CalendarDay>[];
    // Días del mes anterior
    final prevMonthLastDay = DateTime(
      viewedMonth.year,
      viewedMonth.month,
      0,
    ).day;
    for (int i = leadingBlanks - 1; i >= 0; i--) {
      final d = DateTime(
        viewedMonth.year,
        viewedMonth.month - 1,
        prevMonthLastDay - i,
      );
      final k = _key(d);
      cells.add(
        CalendarDay(
          date: d,
          inCurrentMonth: false,
          isToday: false,
          hasActivity: datesWithActivity.contains(k),
          total: totalsByDate[k] ?? 0,
        ),
      );
    }
    // Días del mes actual
    for (int day = 1; day <= daysInMonth; day++) {
      final d = DateTime(viewedMonth.year, viewedMonth.month, day);
      final k = _key(d);
      cells.add(
        CalendarDay(
          date: d,
          inCurrentMonth: true,
          isToday:
              d.year == today.year &&
              d.month == today.month &&
              d.day == today.day,
          hasActivity: datesWithActivity.contains(k),
          total: totalsByDate[k] ?? 0,
        ),
      );
    }
    // Días del mes siguiente hasta completar la última semana
    while (cells.length % 7 != 0) {
      final last = cells.last.date;
      final next = DateTime(last.year, last.month, last.day + 1);
      final k = _key(next);
      cells.add(
        CalendarDay(
          date: next,
          inCurrentMonth: false,
          isToday: false,
          hasActivity: datesWithActivity.contains(k),
          total: totalsByDate[k] ?? 0,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header del mes ──
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: onPrevMonth,
            ),
            Expanded(
              child: Center(
                child: Text(
                  monthLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: canGoNext ? onNextMonth : null,
            ),
          ],
        ),
        const SizedBox(height: FoodBookSpacing.xs),
        // ── Botón "Hoy" ──
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onToday,
            icon: const Icon(Icons.today_rounded, size: 18),
            label: const Text('Ir a hoy'),
          ),
        ),
        const SizedBox(height: FoodBookSpacing.sm),
        // ── Encabezado L M X J V S D ──
        Row(
          children: const ['L', 'M', 'X', 'J', 'V', 'S', 'D']
              .map(
                (l) => Expanded(
                  child: Center(
                    child: Text(l, style: FoodBookTextStyles.labelSmall),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: FoodBookSpacing.xs),
        // ── Grid 7 columnas ──
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: cells.length,
          itemBuilder: (_, i) =>
              _DayCell(day: cells[i], onTap: () => onDayTap(cells[i])),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final CalendarDay day;
  final VoidCallback onTap;
  const _DayCell({required this.day, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = !day.inCurrentMonth;
    final scheme = theme.colorScheme;

    final bg = day.isToday
        ? scheme.primary.withValues(alpha: 0.18)
        : (day.hasActivity && day.inCurrentMonth
              ? scheme.surfaceContainerHighest
              : Colors.transparent);

    final borderColor = day.isToday
        ? scheme.primary
        : (day.hasActivity && day.inCurrentMonth
              ? scheme.primary.withValues(alpha: 0.5)
              : scheme.outlineVariant);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FoodBookSpacing.radiusSm),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(FoodBookSpacing.radiusSm),
            border: Border.all(color: borderColor, width: 1),
          ),
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${day.date.day}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: day.isToday ? FontWeight.w800 : FontWeight.w500,
                  color: muted
                      ? scheme.onSurfaceVariant.withValues(alpha: 0.4)
                      : (day.isToday ? scheme.primary : scheme.onSurface),
                ),
              ),
              if (day.hasActivity && day.inCurrentMonth) ...[
                const SizedBox(height: 2),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: day.total > 0
                        ? FoodBookColors.warning
                        : FoodBookColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

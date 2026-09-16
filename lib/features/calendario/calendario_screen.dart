import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/widgets/stat_row.dart';
import '../../../core/utils/date_helper.dart';
import '../../../data/repositories/daily_extras_repository.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/snack_repository.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/dia_detalle.dart';
import 'calendario_viewmodel.dart';

/// Pantalla del calendario mensual.
class CalendarioScreen extends StatelessWidget {
  const CalendarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => _CalendarioVMBuilder.build(ctx),
      child: const _CalendarioView(),
    );
  }
}

class _CalendarioVMBuilder {
  static CalendarioViewModel build(BuildContext ctx) {
    final vm = CalendarioViewModel(
      ctx.read<DailyLogRepository>(),
      ctx.read<SnackRepository>(),
      ctx.read<PaymentRepository>(),
      ctx.read<DailyExtrasRepository>(),
    );
    vm.init();
    vm.attachStreams(ctx);
    return vm;
  }
}

class _CalendarioView extends StatelessWidget {
  const _CalendarioView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CalendarioViewModel>();
    final theme = Theme.of(context);
    final now = DateTime.now();
    final canGoNext = !(vm.viewedMonth.year == now.year &&
        vm.viewedMonth.month == now.month);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.calendar_view_month_rounded,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: FoodBookSpacing.sm),
            const Text('Calendario'),
          ],
        ),
      ),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                FoodBookSpacing.lg,
                FoodBookSpacing.lg,
                FoodBookSpacing.lg,
                FoodBookSpacing.xxl,
              ),
              children: [
                // ── Resumen rápido ──
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(FoodBookSpacing.md),
                    child: Column(
                      children: [
                        StatRow(
                          icon: Icons.event_available_rounded,
                          label: 'Días con actividad',
                          sublabel: 'En ${vm.monthLabel}',
                          value: '${vm.monthDaysActive}',
                          valueColor: FoodBookColors.skyLight,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: FoodBookSpacing.lg),

                // ── Grid del calendario ──
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      FoodBookSpacing.sm,
                      FoodBookSpacing.md,
                      FoodBookSpacing.sm,
                      FoodBookSpacing.md,
                    ),
                    child: CalendarGrid(
                      viewedMonth: vm.viewedMonth,
                      datesWithActivity: vm.datesWithActivity,
                      totalsByDate: const {},
                      onDayTap: (day) => _openDay(context, day.date),
                      monthLabel: vm.monthLabel,
                      onPrevMonth: () => vm.changeMonth(-1),
                      onNextMonth:
                          canGoNext ? () => vm.changeMonth(1) : null,
                      onToday: () => vm.goToCurrentMonth(),
                      canGoNext: canGoNext,
                    ),
                  ),
                ),
                const SizedBox(height: FoodBookSpacing.lg),

                // ── Leyenda ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FoodBookSpacing.md,
                  ),
                  child: Wrap(
                    spacing: FoodBookSpacing.lg,
                    runSpacing: FoodBookSpacing.sm,
                    children: [
                      const _Legend(
                        color: FoodBookColors.warning,
                        label: 'Con consumo',
                      ),
                      const _Legend(
                        color: FoodBookColors.success,
                        label: 'Solo pago',
                      ),
                      _Legend(
                        color: theme.colorScheme.primary,
                        label: 'Hoy',
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _openDay(BuildContext context, DateTime date) {
    final iso = DateHelper.format(date);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DiaDetalleScreen(date: iso),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

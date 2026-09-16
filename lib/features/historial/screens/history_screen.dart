import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/theme/foodbook_text_styles.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/widgets/stat_row.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/daily_extras_repository.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/snack_repository.dart';
import '../viewmodels/history_viewmodel.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) {
        final vm = HistoryViewModel(
          ctx.read<DailyLogRepository>(),
          ctx.read<SnackRepository>(),
          ctx.read<PaymentRepository>(),
          ctx.read<DailyExtrasRepository>(),
        );
        vm.init();
        return vm;
      },
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewModel>();
    final theme = Theme.of(context);

    if (vm.loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Historial')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final dates = vm.datesWithActivity;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: FoodBookSpacing.sm),
            const Text('Historial'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(FoodBookSpacing.lg),
        children: [
          // ── Mes selector ──
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FoodBookSpacing.sm,
                vertical: FoodBookSpacing.xs,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () => vm.changeMonth(-1),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        vm.monthLabel,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () => vm.changeMonth(1),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Resumen del mes ──
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
                  ),
                  const Divider(height: 1),
                  StatRow(
                    icon: Icons.bakery_dining_rounded,
                    label: 'Bocadillos del mes',
                    sublabel: '${vm.monthSnacks.length} registros',
                    value: 'S/ ${vm.monthSnacksTotal.toStringAsFixed(2)}',
                    valueColor: FoodBookColors.warning,
                  ),
                  const Divider(height: 1),
                  StatRow(
                    icon: Icons.payments_rounded,
                    label: 'Pagos del mes',
                    sublabel: '${vm.monthPayments.length} abonos',
                    value: 'S/ ${vm.monthPaymentsTotal.toStringAsFixed(2)}',
                    valueColor: FoodBookColors.success,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Lista de días con actividad ──
          Text(
            'Días con registros',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: FoodBookSpacing.sm),
          if (dates.isEmpty)
            const Card(
              child: EmptyState(
                icon: Icons.history_rounded,
                title: 'Sin registros este mes',
                message: 'Cuando registres comidas o pagos aparecerán aquí.',
              ),
            )
          else
            ...dates.map((date) {
              final daySnacks =
                  vm.snacks.where((s) => s.date == date).toList();
              final dayPayments =
                  vm.payments.where((p) => p.date == date).toList();
              final dayLog = _findLog(vm, date);
              final dayTotal = _computeDayTotal(
                dayLog,
                daySnacks,
              );
              return Card(
                margin: const EdgeInsets.only(bottom: FoodBookSpacing.sm),
                child: ExpansionTile(
                  shape: const Border(),
                  collapsedShape: const Border(),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius:
                          BorderRadius.circular(FoodBookSpacing.radiusMd),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      date.substring(8, 10),
                      style: FoodBookTextStyles.titleSmall.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  title: Text(
                    _humanDate(date),
                    style: theme.textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    [
                      if (dayLog?.hadBreakfast == true) 'desayuno',
                      if (dayLog?.hadLunch == true) 'almuerzo',
                      if (dayLog?.hadDinner == true) 'cena',
                      if (daySnacks.isNotEmpty)
                        '${daySnacks.length} bocadillo(s)',
                      if (dayPayments.isNotEmpty)
                        '${dayPayments.length} pago(s)',
                    ].join(' · '),
                    style: theme.textTheme.bodySmall,
                  ),
                  trailing: Text(
                    'S/ ${dayTotal.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        FoodBookSpacing.lg,
                        0,
                        FoodBookSpacing.lg,
                        FoodBookSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (dayLog != null) ...[
                            if (dayLog.hadBreakfast)
                              _DetailRow(
                                icon: Icons.free_breakfast_rounded,
                                label: 'Desayuno',
                                detail: dayLog.breakfastDesc,
                                amount: dayLog.breakfastPrice,
                              ),
                            if (dayLog.hadLunch)
                              const _DetailRow(
                                icon: Icons.lunch_dining_rounded,
                                label: 'Almuerzo',
                                amount: 9.0,
                              ),
                            if (dayLog.hadDinner)
                              const _DetailRow(
                                icon: Icons.dinner_dining_rounded,
                                label: 'Cena',
                                amount: 9.0,
                              ),
                          ],
                          ...daySnacks.map((s) {
                            final decoded = SnackRepository.decode(s.description);
                            return _DetailRow(
                              icon: Icons.cookie_rounded,
                              label: decoded.$2 ?? 'Bocadillo',
                              detail: decoded.$1,
                              amount: s.price,
                            );
                          }),
                          ...dayPayments.map((p) {
                            final decoded =
                                PaymentRepository.decode(p.note);
                            return _DetailRow(
                              icon: Icons.payments_rounded,
                              label: 'Pago',
                              detail:
                                  [if (decoded.$1 != null) decoded.$1, decoded.$2]
                                      .where((x) => x != null && x.isNotEmpty)
                                      .join(' · '),
                              amount: p.amount,
                              isPayment: true,
                            );
                          }),
                          if (dayLog == null && daySnacks.isEmpty && dayPayments.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: FoodBookSpacing.sm,
                              ),
                              child: Text(
                                'Sin actividad registrada',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  String _humanDate(String iso) {
    try {
      final d = DateHelper.parse(iso);
      return DateFormat("EEEE d 'de' MMMM", 'es_PE').format(d);
    } catch (_) {
      return iso;
    }
  }

  double _computeDayTotal(
    DailyLog? log,
    List<SnackEntry> snacks,
  ) {
    double t = 0;
    if (log != null) {
      if (log.hadBreakfast) t += log.breakfastPrice;
      if (log.hadLunch) t += 9.0;
      if (log.hadDinner) t += 9.0;
    }
    for (final s in snacks) {
      t += s.price;
    }
    return t;
  }

  DailyLog? _findLog(HistoryViewModel vm, String date) {
    for (final l in vm.logs) {
      if (l.date == date) return l;
    }
    return null;
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? detail;
  final double amount;
  final bool isPayment;

  const _DetailRow({
    required this.icon,
    required this.label,
    this.detail,
    required this.amount,
    this.isPayment = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: FoodBookSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodyLarge),
                if (detail != null && detail!.isNotEmpty)
                  Text(
                    detail!,
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Text(
            '${isPayment ? '-' : '+'}S/ ${amount.toStringAsFixed(2)}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: isPayment
                  ? FoodBookColors.success
                  : theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

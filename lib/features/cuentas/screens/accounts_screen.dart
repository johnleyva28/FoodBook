import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/theme/foodbook_text_styles.dart';
import '../../../core/widgets/daily_bar_chart.dart';
import '../../../core/widgets/hero_card.dart';
import '../../../core/widgets/stat_row.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';
import '../../../data/app_data_streams.dart';
import '../../busqueda/search_screen.dart';
import '../../busqueda/search_viewmodel.dart';
import '../viewmodels/accounts_viewmodel.dart';
import '../widgets/payment_history.dart';
import '../widgets/summary_card.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = AccountsViewModel(
          context.read<AppDataStreams>(),
          context.read<PaymentRepository>(),
          context.read<SettingsRepository>(),
        );
        vm.init();
        return vm;
      },
      child: const _AccountsView(),
    );
  }
}

class _AccountsView extends StatelessWidget {
  const _AccountsView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AccountsViewModel>();
    final theme = Theme.of(context);

    if (vm.loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cuentas')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.account_balance_wallet_rounded,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: FoodBookSpacing.sm),
            const Text('Cuentas'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Buscar',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ChangeNotifierProvider(
                    create: (ctx) => SearchViewModel(
                      ctx.read<AppDataStreams>(),
                      ctx.read<SnackRepository>(),
                      ctx.read<PaymentRepository>(),
                    ),
                    child: const SearchScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(FoodBookSpacing.lg),
        children: [
          // ── Deuda con la pensión ──
          HeroCard(
            label: vm.debt > 0 ? 'DEUDAS CON LA PENSIÓN' : 'AL DÍA 🎉',
            amount: 'S/ ${vm.debt.abs().toStringAsFixed(2)}',
            subtitle: vm.debt > 0
                ? 'Consumido menos lo que has pagado'
                : 'No le debes nada a la pensión',
            icon: vm.debt > 0
                ? Icons.trending_up_rounded
                : Icons.check_circle_rounded,
            variant: vm.debt > 0
                ? HeroCardVariant.danger
                : HeroCardVariant.success,
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Presupuesto del mes ──
          if (vm.monthlyBudget > 0) ...[
            _BudgetCard(
              consumed: vm.monthConsumed,
              budget: vm.monthlyBudget,
              usage: vm.monthBudgetUsage,
              projection: vm.monthProjection,
            ),
            const SizedBox(height: FoodBookSpacing.lg),
          ],

          // ── Gráfico últimos 7 días ──
          _WeeklyChartCard(breakdown: vm.last7DaysBreakdown),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Desglose histórico ──
          const _SectionTitle('Consumo total (histórico)'),
          const SizedBox(height: FoodBookSpacing.sm),
          SummaryCard(
            icon: Icons.lunch_dining_rounded,
            label: 'Almuerzos',
            detail:
                '${vm.totalLunches} veces × S/ ${vm.lunchPrice.toStringAsFixed(2)}',
            amount: vm.totalLunches * vm.lunchPrice,
            kind: SummaryCardKind.accent,
          ),
          SummaryCard(
            icon: Icons.dinner_dining_rounded,
            label: 'Cenas',
            detail:
                '${vm.totalDinners} veces × S/ ${vm.dinnerPrice.toStringAsFixed(2)}',
            amount: vm.totalDinners * vm.dinnerPrice,
            kind: SummaryCardKind.accent,
          ),
          SummaryCard(
            icon: Icons.free_breakfast_rounded,
            label: 'Desayunos',
            detail: '${vm.totalBreakfasts} desayunos (precio manual acumulado)',
            amount: vm.breakfastTotal,
            kind: SummaryCardKind.warning,
          ),
          SummaryCard(
            icon: Icons.bakery_dining_rounded,
            label: 'Bocadillos',
            detail: 'Acumulado histórico',
            amount: vm.snacksTotal,
            kind: SummaryCardKind.warning,
          ),
          SummaryCard(
            icon: Icons.calculate_rounded,
            label: 'Total consumido',
            detail: 'Suma de todo lo consumido',
            amount: vm.consumedTotal,
            kind: SummaryCardKind.danger,
          ),
          SummaryCard(
            icon: Icons.payments_rounded,
            label: 'Total pagado',
            detail: '${vm.payments.length} pago(s) registrado(s)',
            amount: vm.paymentsTotal,
            kind: SummaryCardKind.success,
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Este mes ──
          const _SectionTitle('Este mes'),
          const SizedBox(height: FoodBookSpacing.sm),
          SummaryCard(
            icon: Icons.event_available_rounded,
            label: 'Consumido en el mes',
            detail:
                '${vm.monthLunches} almuerzos · ${vm.monthDinners} cenas · ${vm.monthBreakfasts} desayunos',
            amount: vm.monthConsumed,
            kind: SummaryCardKind.default_,
          ),
          SummaryCard(
            icon: Icons.send_rounded,
            label: 'Pagado en el mes',
            detail: 'Abonos registrados',
            amount: vm.monthPaymentsTotal,
            kind: SummaryCardKind.success,
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Pagos ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _SectionTitle('Mis pagos'),
              FilledButton.icon(
                onPressed: () => _showPaymentDialog(context, vm),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Registrar pago'),
              ),
            ],
          ),
          const SizedBox(height: FoodBookSpacing.sm),
          PaymentHistory(
            payments: vm.payments,
            onDelete: vm.deletePayment,
            onEdit: (Payment p) async {
              final decoded = PaymentRepository.decode(p.note);
              await _showPaymentDialog(
                context,
                vm,
                editingId: p.id,
                initialAmount: p.amount,
                initialNote: decoded.$2,
                initialMethod: decoded.$1,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showPaymentDialog(
    BuildContext context,
    AccountsViewModel vm, {
    int? editingId,
    double? initialAmount,
    String? initialNote,
    String? initialMethod,
  }) async {
    final methods = await context
        .read<CatalogRepository>()
        .getAllPaymentMethods();
    if (!context.mounted) return;
    final result = await _PaymentDialog.show(
      context,
      methodNames: methods.map((m) => m.name).toList(),
      initialAmount: initialAmount,
      initialNote: initialNote,
      initialMethod: initialMethod,
      isEditing: editingId != null,
    );
    if (result == null) return;
    if (editingId == null) {
      await vm.addPayment(
        amount: result.amount,
        note: result.note,
        methodName: result.methodName,
      );
    } else {
      await vm.updatePayment(
        id: editingId,
        amount: result.amount,
        note: result.note,
        methodName: result.methodName,
      );
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final double consumed;
  final double budget;
  final double usage;
  final double projection;

  const _BudgetCard({
    required this.consumed,
    required this.budget,
    required this.usage,
    required this.projection,
  });

  Color get _statusColor {
    if (usage >= 1.0) return FoodBookColors.danger;
    if (usage >= 0.8) return FoodBookColors.warning;
    return FoodBookColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clampedUsage = usage.clamp(0.0, 1.5);
    final isOver = usage > 1.0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(FoodBookSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.savings_rounded, color: _statusColor, size: 22),
                const SizedBox(width: FoodBookSpacing.sm),
                Text('Presupuesto mensual', style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: FoodBookSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Consumido', style: theme.textTheme.bodySmall),
                    Text(
                      'S/ ${consumed.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: _statusColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'de S/ ${budget.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      '${(usage * 100).toStringAsFixed(0)}%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: FoodBookSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(FoodBookSpacing.radiusFull),
              child: LinearProgressIndicator(
                value: clampedUsage.toDouble(),
                minHeight: 10,
                color: _statusColor,
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
              ),
            ),
            const SizedBox(height: FoodBookSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Proyección fin de mes',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        'S/ ${projection.toStringAsFixed(2)}',
                        style: FoodBookTextStyles.titleSmall.copyWith(
                          color: projection > budget
                              ? FoodBookColors.danger
                              : FoodBookColors.skyLight,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isOver)
                  const StatusBadge(
                    label: 'Excedido',
                    color: FoodBookColors.danger,
                    icon: Icons.warning_amber_rounded,
                  )
                else if (usage >= 0.8)
                  const StatusBadge(
                    label: 'Cerca',
                    color: FoodBookColors.warning,
                    icon: Icons.info_outline_rounded,
                  )
                else
                  const StatusBadge(
                    label: 'En rango',
                    color: FoodBookColors.success,
                    icon: Icons.check_circle_outline_rounded,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyChartCard extends StatelessWidget {
  final Map<String, double> breakdown;
  const _WeeklyChartCard({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = breakdown.entries.toList();
    final today = DateTime.now().toString().substring(0, 10);
    final data = entries
        .map(
          (e) => DailyChartData(
            label: e.key.substring(8, 10),
            value: e.value,
            isToday: e.key == today,
          ),
        )
        .toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(FoodBookSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: FoodBookSpacing.sm),
                Text('Últimos 7 días', style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: FoodBookSpacing.lg),
            DailyBarChart(data: data, unitPrefix: 'S/ '),
            const SizedBox(height: FoodBookSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(
                  color: theme.colorScheme.primary,
                  label: 'Hoy',
                ),
                const SizedBox(width: FoodBookSpacing.lg),
                const _LegendDot(
                  color: FoodBookColors.skyMuted,
                  label: 'Anterior',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

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

class _PaymentResult {
  final double amount;
  final String? note;
  final String? methodName;
  _PaymentResult(this.amount, this.note, this.methodName);
}

class _PaymentDialog extends StatelessWidget {
  static Future<_PaymentResult?> show(
    BuildContext context, {
    required List<String> methodNames,
    double? initialAmount,
    String? initialNote,
    String? initialMethod,
    bool isEditing = false,
  }) {
    final amountController = TextEditingController(
      text: initialAmount != null ? initialAmount.toString() : '',
    );
    final noteController = TextEditingController(text: initialNote ?? '');
    final selectedMethod = ValueNotifier<String?>(initialMethod);
    final formKey = GlobalKey<FormState>();

    return showDialog<_PaymentResult>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar pago' : 'Registrar pago'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: amountController,
                      autofocus: true,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Monto (S/)',
                        prefixIcon: Icon(Icons.attach_money_rounded),
                      ),
                      validator: (v) {
                        final amount = double.tryParse(
                          v?.replaceAll(',', '.') ?? '',
                        );
                        if (amount == null || amount <= 0) {
                          return 'Ingresa un monto válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: FoodBookSpacing.md),
                    if (methodNames.isNotEmpty) ...[
                      Text(
                        'Método de pago',
                        style: Theme.of(dialogContext).textTheme.bodySmall,
                      ),
                      const SizedBox(height: FoodBookSpacing.xs),
                      ValueListenableBuilder<String?>(
                        valueListenable: selectedMethod,
                        builder: (_, current, _) {
                          return Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: methodNames.map((m) {
                              final selected = current == m;
                              return ChoiceChip(
                                label: Text(m),
                                selected: selected,
                                onSelected: (sel) {
                                  selectedMethod.value = sel ? m : null;
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: FoodBookSpacing.md),
                    ],
                    TextFormField(
                      controller: noteController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Nota (opcional)',
                        prefixIcon: Icon(Icons.notes_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final amount = double.parse(
                    amountController.text.replaceAll(',', '.'),
                  );
                  Navigator.pop<_PaymentResult>(
                    dialogContext,
                    _PaymentResult(
                      amount,
                      noteController.text.trim().isEmpty
                          ? null
                          : noteController.text.trim(),
                      selectedMethod.value,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.check_rounded, size: 18),
              label: Text(isEditing ? 'Guardar' : 'Registrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

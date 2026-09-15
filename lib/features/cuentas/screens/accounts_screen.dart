import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';
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
          context.read<DailyLogRepository>(),
          context.read<SnackRepository>(),
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
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cuentas 💰')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Deuda total con la pensión ──
          Card(
            color: vm.debt > 0
                ? theme.colorScheme.errorContainer
                : theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    vm.debt > 0 ? 'Debes a la pensión' : 'Al día 🎉',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'S/ ${vm.debt.abs().toStringAsFixed(2)}',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Desglose histórico ──
          Text('Consumo total (histórico)', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          SummaryCard(
            icon: Icons.lunch_dining,
            label: 'Almuerzos',
            detail:
                '${vm.totalLunches} veces × S/ ${vm.lunchPrice.toStringAsFixed(2)}',
            amount: vm.totalLunches * vm.lunchPrice,
          ),
          SummaryCard(
            icon: Icons.dinner_dining,
            label: 'Cenas',
            detail:
                '${vm.totalDinners} veces × S/ ${vm.dinnerPrice.toStringAsFixed(2)}',
            amount: vm.totalDinners * vm.dinnerPrice,
          ),
          SummaryCard(
            icon: Icons.free_breakfast,
            label: 'Desayunos',
            detail: 'Precio manual (acumulado)',
            amount: vm.breakfastTotal,
          ),
          SummaryCard(
            icon: Icons.bakery_dining,
            label: 'Bocadillos',
            detail: 'Acumulado',
            amount: vm.snacksTotal,
          ),
          SummaryCard(
            icon: Icons.calculate,
            label: 'Total consumido',
            detail: 'Almuerzos + cenas + desayunos + bocadillos',
            amount: vm.consumedTotal,
          ),
          SummaryCard(
            icon: Icons.payments,
            label: 'Total pagado',
            detail: '${vm.payments.length} pago(s) registrado(s)',
            amount: vm.paymentsTotal,
          ),
          const SizedBox(height: 20),

          // ── Este mes ──
          Text('Este mes', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Consumido en el mes'),
                  Text(
                    'S/ ${vm.monthConsumed.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Pagos ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mis pagos', style: theme.textTheme.titleLarge),
              FilledButton.icon(
                onPressed: () => _showPaymentDialog(context, vm),
                icon: const Icon(Icons.add),
                label: const Text('Registrar pago'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          PaymentHistory(payments: vm.payments, onDelete: vm.deletePayment),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, AccountsViewModel vm) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar pago 💳'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountController,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Monto (S/)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (v) {
                  final amount = double.tryParse(v?.replaceAll(',', '.') ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Ingresa un monto válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: noteController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nota (opcional)',
                  prefixIcon: Icon(Icons.notes),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final amount = double.parse(
                  amountController.text.replaceAll(',', '.'),
                );
                vm.addPayment(amount: amount, note: noteController.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

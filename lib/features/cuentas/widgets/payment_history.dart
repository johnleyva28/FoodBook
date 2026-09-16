import 'package:flutter/material.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/payment_repository.dart';

/// Lista de pagos realizados a la pensión.
///
/// Decodifica método de pago y nota libre usando `PaymentRepository.decode`.
class PaymentHistory extends StatelessWidget {
  final List<Payment> payments;
  final ValueChanged<int> onDelete;
  final Future<void> Function(Payment) onEdit;

  const PaymentHistory({
    super.key,
    required this.payments,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (payments.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(FoodBookSpacing.xl),
          child: Column(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 48,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: FoodBookSpacing.sm),
              Text(
                'Aún no has registrado pagos',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FoodBookSpacing.xs),
              Text(
                'Toca "Registrar pago" para añadir uno.',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: payments.map((p) {
        final decoded = PaymentRepository.decode(p.note);
        final method = decoded.$1;
        final note = decoded.$2;
        return Card(
          margin: const EdgeInsets.only(bottom: FoodBookSpacing.sm),
          child: Dismissible(
            key: ValueKey('payment_${p.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: FoodBookColors.danger.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
              ),
              child: const Icon(Icons.delete_rounded, color: Colors.white),
            ),
            onDismissed: (_) => onDelete(p.id),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.18,
                ),
                child: Icon(
                  method == null
                      ? Icons.payments_rounded
                      : Icons.account_balance_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              title: Text(
                'S/ ${p.amount.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                [
                  p.date,
                  if (method != null) method,
                  if (note != null && note.isNotEmpty) note,
                ].join(' • '),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () => onEdit(p),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

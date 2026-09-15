import 'package:flutter/material.dart';

import '../../../data/database/app_database.dart';

/// Lista de pagos realizados a la pensión.
class PaymentHistory extends StatelessWidget {
  final List<Payment> payments;
  final ValueChanged<int> onDelete;

  const PaymentHistory({
    super.key,
    required this.payments,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text('Aún no has registrado pagos 💳'),
      );
    }

    return Column(
      children: payments
          .map(
            (p) => Card(
              child: ListTile(
                leading: const Icon(Icons.payments),
                title: Text('S/ ${p.amount.toStringAsFixed(2)}'),
                subtitle: Text(
                  (p.note?.isNotEmpty == true)
                      ? '${p.date} · ${p.note}'
                      : p.date,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => onDelete(p.id),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

import 'package:flutter/material.dart';

/// Tarjeta que muestra un concepto, cantidad y monto calculado.
class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String detail;
  final double amount;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.detail,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(label),
        subtitle: Text(detail),
        trailing: Text(
          'S/ ${amount.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

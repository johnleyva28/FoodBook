import 'package:flutter/material.dart';

/// Tarjeta con checkbox para almuerzo o cena (precio fijo).
class LunchDinnerCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final double price;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const LunchDinnerCard({
    super.key,
    required this.label,
    required this.icon,
    required this.price,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        secondary: Icon(icon, size: 32),
        title: Text(label, style: theme.textTheme.titleMedium),
        subtitle: Text('S/ ${price.toStringAsFixed(2)}'),
        value: checked,
        onChanged: onChanged,
      ),
    );
  }
}

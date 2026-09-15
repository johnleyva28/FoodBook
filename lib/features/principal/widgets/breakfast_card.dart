import 'package:flutter/material.dart';

/// Tarjeta del desayuno: toggle + precio manual + descripción.
class BreakfastCard extends StatelessWidget {
  final bool checked;
  final double price;
  final String? description;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;

  const BreakfastCard({
    super.key,
    required this.checked,
    required this.price,
    required this.description,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.free_breakfast, size: 32),
            title: Text('Desayuno', style: theme.textTheme.titleMedium),
            subtitle: Text(
              checked ? 'S/ ${price.toStringAsFixed(2)}' : 'Precio manual',
            ),
            value: checked,
            onChanged: onToggle,
          ),
          if (checked)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      (description == null || description!.isEmpty)
                          ? 'Sin descripción'
                          : description!,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Editar'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

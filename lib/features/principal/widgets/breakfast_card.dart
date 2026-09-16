import 'package:flutter/material.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/theme/foodbook_text_styles.dart';

/// Tarjeta con toggle + precio editable para desayuno.
///
/// Visualmente:
///   • Switch principal (switchListTile en estilo Material 3).
///   • Subtotal en celeste cuando está activo.
///   • Botón "Editar" que abre el diálogo con selector de descripción
///     y monto. Estado vacío neutro cuando está apagado.
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
    final scheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: FoodBookSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
        onTap: () => onToggle(!checked),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FoodBookSpacing.lg,
            vertical: FoodBookSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.free_breakfast_rounded,
                  size: 26,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(width: FoodBookSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Desayuno',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    if (checked) ...[
                      Text(
                        'S/ ${price.toStringAsFixed(2)}',
                        style: FoodBookTextStyles.body.copyWith(
                          color: FoodBookColors.skyLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (description != null && description!.isNotEmpty)
                        Text(
                          description!,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ] else
                      Text(
                        'Toca para registrar',
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              Switch(
                value: checked,
                onChanged: onToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

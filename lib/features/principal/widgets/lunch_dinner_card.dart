import 'package:flutter/material.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/theme/foodbook_text_styles.dart';

/// Tarjeta con switch para almuerzo o cena. El precio es fijo (configurado
/// en Ajustes) y se muestra en celeste cuando el plato está marcado.
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
    final scheme = theme.colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: FoodBookSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
        onTap: () => onChanged(!checked),
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
                  icon,
                  size: 26,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(width: FoodBookSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      'S/ ${price.toStringAsFixed(2)}',
                      style: FoodBookTextStyles.body.copyWith(
                        color: checked
                            ? FoodBookColors.skyLight
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(value: checked, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}

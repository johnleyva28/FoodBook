import 'package:flutter/material.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/theme/foodbook_text_styles.dart';

/// Tarjeta resumen: ícono, etiqueta, detalle y monto.
///
/// Variantes:
///   • `SummaryCardKind.default` — neutro.
///   • `SummaryCardKind.accent` — monto en celeste.
///   • `SummaryCardKind.warning` — monto en ámbar.
///   • `SummaryCardKind.danger` — monto en rojo coral.
///   • `SummaryCardKind.success` — monto en verde.
enum SummaryCardKind { default_, accent, warning, danger, success }

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String detail;
  final double amount;
  final SummaryCardKind kind;
  final VoidCallback? onTap;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.detail,
    required this.amount,
    this.kind = SummaryCardKind.default_,
    this.onTap,
  });

  Color _colorFor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (kind) {
      case SummaryCardKind.accent:
        return FoodBookColors.skyLight;
      case SummaryCardKind.warning:
        return FoodBookColors.warning;
      case SummaryCardKind.danger:
        return FoodBookColors.danger;
      case SummaryCardKind.success:
        return FoodBookColors.success;
      case SummaryCardKind.default_:
        return scheme.onSurface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorFor(context);
    return Card(
      margin: const EdgeInsets.only(bottom: FoodBookSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FoodBookSpacing.lg,
            vertical: FoodBookSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: FoodBookSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      detail,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: FoodBookSpacing.sm),
              Text(
                'S/ ${amount.toStringAsFixed(2)}',
                style: FoodBookTextStyles.titleSmall.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

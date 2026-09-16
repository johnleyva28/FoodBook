import 'package:flutter/material.dart';

import '../theme/foodbook_colors.dart';
import '../theme/foodbook_spacing.dart';

/// Línea de estadística: ícono + label + valor. Usada en perfiles,
/// cards de resumen y desgloses.
class StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final String? sublabel;
  final VoidCallback? onTap;

  const StatRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.sublabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = valueColor ?? theme.colorScheme.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FoodBookSpacing.lg,
            vertical: FoodBookSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(
                    FoodBookSpacing.radiusSm,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: FoodBookSpacing.iconMd,
                  color: effectiveColor,
                ),
              ),
              const SizedBox(width: FoodBookSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (sublabel != null)
                      Text(
                        sublabel!,
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Estado vacío reutilizable para listas.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(FoodBookSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: FoodBookSpacing.iconXl,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),
          Text(
            title,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: FoodBookSpacing.sm),
            Text(
              message!,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: FoodBookSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}

/// Chip de estado (éxito / peligro / info).
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FoodBookSpacing.md,
        vertical: FoodBookSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(FoodBookSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: FoodBookColors.textHigh,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

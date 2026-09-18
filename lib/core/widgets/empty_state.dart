import 'package:flutter/material.dart';

import '../theme/foodbook_spacing.dart';

/// Estado vacío reutilizable.
///
/// Muestra un ícono grande, un título, una descripción opcional y hasta
/// dos acciones (primaria y secundaria). Usar en lugar de `Center(
/// child: Text('Sin datos'))` en listas vacías.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.primaryAction,
    this.secondaryAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.onSurfaceVariant;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FoodBookSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: color.withValues(alpha: 0.7)),
            const SizedBox(height: FoodBookSpacing.md),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: FoodBookSpacing.sm),
              Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (primaryAction != null) ...[
              const SizedBox(height: FoodBookSpacing.lg),
              primaryAction!,
            ],
            if (secondaryAction != null) ...[
              const SizedBox(height: FoodBookSpacing.sm),
              secondaryAction!,
            ],
          ],
        ),
      ),
    );
  }
}

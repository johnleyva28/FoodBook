import 'package:flutter/material.dart';

import '../theme/foodbook_colors.dart';
import '../theme/foodbook_spacing.dart';
import '../theme/foodbook_text_styles.dart';

/// Variantes de la `HeroCard` para usos semánticos.
enum HeroCardVariant {
  /// Gasto del día, balance mensual.
  primary,

  /// Deuda (rojo coral).
  danger,

  /// A favor / al día.
  success,

  /// Información neutral.
  info,
}

/// Tarjeta hero con gradiente. Usada para el gasto del día,
/// la deuda con la pensión y resúmenes principales.
class HeroCard extends StatelessWidget {
  final String label;
  final String amount;
  final String? subtitle;
  final IconData? icon;
  final HeroCardVariant variant;
  final VoidCallback? onTap;

  const HeroCard({
    super.key,
    required this.label,
    required this.amount,
    this.subtitle,
    this.icon,
    this.variant = HeroCardVariant.primary,
    this.onTap,
  });

  LinearGradient get _gradient {
    switch (variant) {
      case HeroCardVariant.danger:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7F1D1D), Color(0xFFDC2626)],
        );
      case HeroCardVariant.success:
        return FoodBookColors.successGradient;
      case HeroCardVariant.info:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A5F), FoodBookColors.navyVariant],
        );
      case HeroCardVariant.primary:
        return FoodBookColors.primaryGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FoodBookSpacing.radiusLg),
        child: Ink(
          decoration: BoxDecoration(
            gradient: _gradient,
            borderRadius: BorderRadius.circular(FoodBookSpacing.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(FoodBookSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: FoodBookSpacing.iconMd,
                        color: FoodBookColors.textHigh.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: FoodBookSpacing.sm),
                    ],
                    Expanded(
                      child: Text(
                        label,
                        style: FoodBookTextStyles.labelSmall.copyWith(
                          color: FoodBookColors.textHigh.withValues(
                            alpha: 0.85,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FoodBookSpacing.md),
                Text(
                  amount,
                  style: FoodBookTextStyles.moneyHero.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: FoodBookSpacing.xs),
                  Text(
                    subtitle!,
                    style: FoodBookTextStyles.caption.copyWith(
                      color: FoodBookColors.textHigh.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

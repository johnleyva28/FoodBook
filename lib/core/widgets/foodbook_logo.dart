import 'package:flutter/material.dart';

import '../theme/foodbook_colors.dart';
import '../theme/foodbook_spacing.dart';
import '../theme/foodbook_text_styles.dart';

/// Logo simple de FoodBook basado en la inicial F + utensilios.
///
/// Se usa en AppBar y como placeholder del logo real. La versión final
/// reemplazará este widget por una imagen.
class FoodBookLogo extends StatelessWidget {
  final double size;
  final bool dark;
  const FoodBookLogo({super.key, this.size = 32, this.dark = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: FoodBookColors.primaryGradient,
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: FoodBookColors.sky.withValues(alpha: 0.3),
            blurRadius: size * 0.4,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.restaurant_menu_rounded,
            color: Colors.white,
            size: size * 0.55,
          ),
          // Pequeña "F" sutil en la esquina inferior derecha.
          Positioned(
            right: size * 0.05,
            bottom: size * 0.05,
            child: Text(
              'B',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w900,
                fontSize: size * 0.18,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header reutilizable que combina logo + nombre + tagline.
class FoodBookHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  const FoodBookHeader({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const FoodBookLogo(size: 36),
        const SizedBox(width: FoodBookSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'FoodBook',
                style: FoodBookTextStyles.title.copyWith(letterSpacing: 0.3),
              ),
              if (subtitle != null)
                Text(subtitle!, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

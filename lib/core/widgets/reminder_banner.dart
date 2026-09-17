import 'package:flutter/material.dart';

import '../theme/foodbook_colors.dart';
import '../theme/foodbook_spacing.dart';

/// Banner in-app que sugiere acciones basadas en la hora del día.
///
/// Aparece en la pantalla Principal cuando:
///   • 11:00–14:00 y no marcó almuerzo.
///   • 18:00–21:00 y no marcó cena.
///
/// Es NO intrusivo: solo se ve si está activado en Ajustes.
class ReminderBanner extends StatelessWidget {
  final bool showLunch;
  final bool showDinner;
  final VoidCallback onTapLunch;
  final VoidCallback onTapDinner;

  const ReminderBanner({
    super.key,
    required this.showLunch,
    required this.showDinner,
    required this.onTapLunch,
    required this.onTapDinner,
  });

  /// Decide qué recordatorio mostrar según la hora.
  factory ReminderBanner.forNow({
    Key? key,
    required VoidCallback onTapLunch,
    required VoidCallback onTapDinner,
  }) {
    final h = DateTime.now().hour;
    final showLunch = h >= 11 && h <= 14;
    final showDinner = h >= 18 && h <= 21;
    return ReminderBanner(
      key: key,
      showLunch: showLunch,
      showDinner: showDinner,
      onTapLunch: onTapLunch,
      onTapDinner: onTapDinner,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!showLunch && !showDinner) return const SizedBox.shrink();

    final icon = showLunch
        ? Icons.lunch_dining_rounded
        : Icons.dinner_dining_rounded;
    final text = showLunch ? '¿Ya almorzaste?' : '¿Ya cenaste?';
    final actionLabel = showLunch ? 'Marcar almuerzo' : 'Marcar cena';
    final action = showLunch ? onTapLunch : onTapDinner;

    return Container(
      margin: const EdgeInsets.only(bottom: FoodBookSpacing.md),
      padding: const EdgeInsets.all(FoodBookSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(FoodBookSpacing.radiusMd),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: FoodBookColors.sky.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(FoodBookSpacing.radiusSm),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: FoodBookColors.sky),
          ),
          const SizedBox(width: FoodBookSpacing.md),
          Expanded(child: Text(text, style: theme.textTheme.titleSmall)),
          TextButton(onPressed: action, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

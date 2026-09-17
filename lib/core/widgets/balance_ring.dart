import 'package:flutter/material.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';

/// Tarjeta que muestra un balance circular (pagado vs consumido)
/// con un porcentaje de cumplimiento.
///
/// Útil para Cuentas y Pension: muestra de un vistazo cuánto se
/// ha pagado del total consumido.
class BalanceRing extends StatelessWidget {
  final double consumed;
  final double paid;
  final double size;
  final String label;

  const BalanceRing({
    super.key,
    required this.consumed,
    required this.paid,
    this.size = 140,
    this.label = 'Pagado',
  });

  double get _ratio {
    if (consumed <= 0) return 0;
    return (paid / consumed).clamp(0.0, 1.0);
  }

  Color get _statusColor {
    final r = _ratio;
    if (r >= 1) return FoodBookColors.success;
    if (r >= 0.5) return FoodBookColors.sky;
    if (r > 0) return FoodBookColors.warning;
    return FoodBookColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (_ratio * 100).round();
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: _ratio,
              strokeWidth: 12,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percent%',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: _statusColor,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Versión con leyenda inferior (más útil en cards de resumen).
class BalanceRingWithLegend extends StatelessWidget {
  final double consumed;
  final double paid;
  final String consumedLabel;
  final String paidLabel;

  const BalanceRingWithLegend({
    super.key,
    required this.consumed,
    required this.paid,
    this.consumedLabel = 'Consumido',
    this.paidLabel = 'Pagado',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ring = BalanceRing(consumed: consumed, paid: paid);
    final pending = (consumed - paid).clamp(0, double.infinity);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ring,
        const SizedBox(width: FoodBookSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendRow(
                color: theme.colorScheme.primary,
                label: consumedLabel,
                value: consumed,
              ),
              const SizedBox(height: 8),
              _LegendRow(
                color: FoodBookColors.success,
                label: paidLabel,
                value: paid,
              ),
              const SizedBox(height: 8),
              _LegendRow(
                color: FoodBookColors.danger,
                label: 'Pendiente',
                value: pending.toDouble(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final double value;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: theme.textTheme.bodySmall),
        ),
        Text(
          'S/ ${value.toStringAsFixed(2)}',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

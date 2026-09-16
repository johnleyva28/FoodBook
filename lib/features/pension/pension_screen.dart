import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/widgets/hero_card.dart';
import '../../../core/widgets/stat_row.dart';
import '../../../data/app_data_streams.dart';
import '../../../data/repositories/snack_repository.dart';

/// Vista del pensionista.
///
/// Muestra datos agregados de la pensión:
///   * Número de comensales que almorzaron / cenaron hoy
///   * Total recaudado vs consumido hoy
///   * Menú del día (desayunos + snacks)
class PensionScreen extends StatelessWidget {
  const PensionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.store_rounded,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: FoodBookSpacing.sm),
            const Text('Mi pensión'),
          ],
        ),
      ),
      body: Consumer<AppDataStreams>(
        builder: (context, streams, _) {
          final today = _todayIso();
          final todayLogs = streams.logs.where((l) => l.date == today).toList();
          final todaySnacks =
              streams.snacks.where((s) => s.date == today).toList();
          final todayPayments =
              streams.payments.where((p) => p.date == today).toList();

          final lunches = todayLogs.where((l) => l.hadLunch).length;
          final dinners = todayLogs.where((l) => l.hadDinner).length;
          final breakfasts = todayLogs.where((l) => l.hadBreakfast).length;

          final snacksTotal = todaySnacks.fold<double>(
            0,
            (s, e) => s + e.price,
          );
          final paymentsTotal = todayPayments.fold<double>(
            0,
            (s, p) => s + p.amount,
          );

          // Precio referencial (lunch + dinner + breakfast promedio)
          final consumed = lunches * 9.0 + dinners * 9.0 + snacksTotal;

          return ListView(
            padding: const EdgeInsets.all(FoodBookSpacing.lg),
            children: [
              // ── Hero: estado del día ──
              HeroCard(
                label: 'INGRESOS HOY',
                amount: 'S/ ${paymentsTotal.toStringAsFixed(2)}',
                subtitle: 'Recaudado de ${todayPayments.length} pago(s)',
                icon: Icons.payments_rounded,
                variant: paymentsTotal > 0
                    ? HeroCardVariant.success
                    : HeroCardVariant.primary,
              ),
              const SizedBox(height: FoodBookSpacing.lg),

              // ── Comensales hoy ──
              const _SectionTitle(
                title: 'Comensales hoy',
                icon: Icons.groups_rounded,
              ),
              const SizedBox(height: FoodBookSpacing.sm),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: FoodBookSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      StatRow(
                        icon: Icons.free_breakfast_rounded,
                        label: 'Desayunos servidos',
                        value: '$breakfasts',
                        valueColor: FoodBookColors.warning,
                      ),
                      const Divider(height: 1),
                      StatRow(
                        icon: Icons.lunch_dining_rounded,
                        label: 'Almuerzos servidos',
                        value: '$lunches',
                        valueColor: FoodBookColors.skyLight,
                      ),
                      const Divider(height: 1),
                      StatRow(
                        icon: Icons.dinner_dining_rounded,
                        label: 'Cenas servidas',
                        value: '$dinners',
                        valueColor: FoodBookColors.cyanBright,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: FoodBookSpacing.lg),

              // ── Balance ──
              const _SectionTitle(
                title: 'Balance del día',
                icon: Icons.account_balance_rounded,
              ),
              const SizedBox(height: FoodBookSpacing.sm),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: FoodBookSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      StatRow(
                        icon: Icons.shopping_cart_rounded,
                        label: 'Consumido (estimado)',
                        sublabel:
                            '${lunches + dinners} comidas + ${todaySnacks.length} snacks',
                        value: 'S/ ${consumed.toStringAsFixed(2)}',
                        valueColor: FoodBookColors.warning,
                      ),
                      const Divider(height: 1),
                      StatRow(
                        icon: Icons.payments_rounded,
                        label: 'Cobrado',
                        sublabel:
                            '${todayPayments.length} pago(s) recibido(s)',
                        value: 'S/ ${paymentsTotal.toStringAsFixed(2)}',
                        valueColor: FoodBookColors.success,
                      ),
                      const Divider(height: 1),
                      StatRow(
                        icon: paymentsTotal - consumed >= 0
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        label: paymentsTotal - consumed >= 0
                            ? 'Margen'
                            : 'Déficit',
                        value:
                            'S/ ${(paymentsTotal - consumed).abs().toStringAsFixed(2)}',
                        valueColor: paymentsTotal - consumed >= 0
                            ? FoodBookColors.success
                            : FoodBookColors.danger,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: FoodBookSpacing.lg),

              // ── Menú del día ──
              const _SectionTitle(
                title: 'Pedidos del día',
                icon: Icons.restaurant_menu_rounded,
              ),
              const SizedBox(height: FoodBookSpacing.sm),
              if (todaySnacks.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(FoodBookSpacing.lg),
                    child: Center(
                      child: Text(
                        'Sin snacks registrados hoy',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(FoodBookSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...todaySnacks.map((s) {
                          final decoded = SnackRepository.decode(s.description);
                          final cat = decoded.$1;
                          final desc = decoded.$2 ?? 'Bocadillo';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cookie_rounded,
                                  size: 18,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: FoodBookSpacing.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(desc),
                                      if (cat != null)
                                        Text(
                                          cat,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                    ],
                                  ),
                                ),
                                Text('S/ ${s.price.toStringAsFixed(2)}'),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _todayIso() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${now.year}-${two(now.month)}-${two(now.day)}';
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: FoodBookSpacing.sm),
        Text(title, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

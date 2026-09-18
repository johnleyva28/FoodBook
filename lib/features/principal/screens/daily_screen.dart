import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/theme/foodbook_text_styles.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/foodbook_logo.dart';
import '../../../core/widgets/hero_card.dart';
import '../../../core/widgets/reminder_banner.dart';
import '../../../core/widgets/stat_row.dart';
import '../../../data/app_data_streams.dart';
import '../../../data/exporters/csv_exporter.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';
import '../../busqueda/search_screen.dart';
import '../../busqueda/search_viewmodel.dart';
import '../viewmodels/daily_viewmodel.dart';
import '../widgets/breakfast_card.dart';
import '../widgets/lunch_dinner_card.dart';
import '../widgets/snack_quick_add.dart';

class DailyScreen extends StatelessWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = DailyViewModel(
          context.read<AppDataStreams>(),
          context.read<DailyLogRepository>(),
          context.read<SnackRepository>(),
          context.read<SettingsRepository>(),
        );
        vm.init();
        return vm;
      },
      child: const _DailyView(),
    );
  }
}

class _DailyView extends StatelessWidget {
  const _DailyView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyViewModel>();
    final theme = Theme.of(context);
    final todayLabel = DateHelper.label(DateTime.now());
    final snacksTotal = vm.todaySnacks.fold<double>(0, (s, e) => s + e.price);

    if (vm.loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('FoodBook')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: FoodBookHeader(subtitle: todayLabel),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Buscar',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ChangeNotifierProvider(
                    create: (ctx) => SearchViewModel(
                      ctx.read<AppDataStreams>(),
                      ctx.read<SnackRepository>(),
                      ctx.read<PaymentRepository>(),
                    ),
                    child: const SearchScreen(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Exportar',
            onPressed: () => _exportCsv(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showSnackDialog(
            context,
            categoryNames: vm.categoryNames,
          );
          if (result != null) {
            await vm.addSnack(
              price: result.price,
              description: result.description,
              categoryName: result.categoryName,
            );
            if (!context.mounted) return;
            AppToast.success(
              context,
              'Bocadillo de S/ ${result.price.toStringAsFixed(2)} agregado',
            );
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Bocadillo'),
      ),
      body: RefreshIndicator(
        color: theme.colorScheme.primary,
        onRefresh: () async => vm.init(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            FoodBookSpacing.lg,
            FoodBookSpacing.lg,
            FoodBookSpacing.lg,
            100, // espacio para el FAB
          ),
          children: [
            // ── Hero card: gasto del día ──
            HeroCard(
              label: 'GASTO DE HOY',
              amount: 'S/ ${vm.dayTotal.toStringAsFixed(2)}',
              subtitle: _subtitleFor(vm),
              icon: Icons.payments_rounded,
              variant: HeroCardVariant.primary,
            ),
            const SizedBox(height: FoodBookSpacing.md),

            // ── Recordatorio in-app por hora ──
            ReminderBanner.forNow(
              onTapLunch: () => vm.toggleLunch(true),
              onTapDinner: () => vm.toggleDinner(true),
            ),

            // ── Comidas de la pensión ──
            const _SectionHeader(
              title: 'Comidas de hoy',
              icon: Icons.lunch_dining_rounded,
            ),
            const SizedBox(height: FoodBookSpacing.sm),
            BreakfastCard(
              checked: vm.log?.hadBreakfast ?? false,
              price: vm.log?.breakfastPrice ?? 0,
              description: vm.log?.breakfastDesc,
              onToggle: (value) async {
                if (value) {
                  final result = await showBreakfastDialog(
                    context,
                    initialPrice: vm.log?.breakfastPrice,
                    initialDesc: vm.log?.breakfastDesc,
                  );
                  if (result != null) {
                    await vm.saveBreakfast(
                      had: true,
                      price: result.$1,
                      description: result.$2,
                    );
                  }
                } else {
                  await vm.saveBreakfast(had: false, price: 0);
                }
              },
              onEdit: () async {
                final result = await showBreakfastDialog(
                  context,
                  initialPrice: vm.log?.breakfastPrice,
                  initialDesc: vm.log?.breakfastDesc,
                );
                if (result != null) {
                  await vm.saveBreakfast(
                    had: true,
                    price: result.$1,
                    description: result.$2,
                  );
                }
              },
            ),
            LunchDinnerCard(
              label: 'Almuerzo',
              icon: Icons.lunch_dining_rounded,
              price: vm.lunchPrice,
              checked: vm.log?.hadLunch ?? false,
              onChanged: vm.toggleLunch,
            ),
            LunchDinnerCard(
              label: 'Cena',
              icon: Icons.dinner_dining_rounded,
              price: vm.dinnerPrice,
              checked: vm.log?.hadDinner ?? false,
              onChanged: vm.toggleDinner,
            ),
            const SizedBox(height: FoodBookSpacing.lg),

            // ── Bocadillos ──
            _SectionHeader(
              title: 'Bocadillos',
              icon: Icons.bakery_dining_rounded,
              trailing: Text(
                'S/ ${snacksTotal.toStringAsFixed(2)}',
                style: FoodBookTextStyles.titleSmall.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: FoodBookSpacing.sm),
            if (vm.todaySnacks.isEmpty)
              const Card(
                child: EmptyState(
                  icon: Icons.cookie_rounded,
                  title: 'Sin bocadillos',
                  message: 'Toca el botón "+ Bocadillo" para registrar una compra fuera del menú.',
                ),
              )
            else
              ...vm.todaySnacks.map((s) {
                final decoded = SnackRepository.decode(s.description);
                final cat = decoded.$1;
                final desc = decoded.$2;
                return Card(
                  margin: const EdgeInsets.only(bottom: FoodBookSpacing.sm),
                  child: Dismissible(
                    key: ValueKey('snack_${s.id}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: FoodBookColors.danger.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(
                          FoodBookSpacing.radiusMd,
                        ),
                      ),
                      child: const Icon(
                        Icons.delete_rounded,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (_) async {
                      await vm.deleteSnack(s.id);
                      if (!context.mounted) return;
                      AppToast.withAction(
                        context,
                        message: 'Eliminado: ${desc ?? "bocadillo"}',
                        actionLabel: 'Deshacer',
                        kind: AppToastKind.warning,
                        onAction: () {
                          vm.addSnack(
                            price: s.price,
                            description: desc,
                            categoryName: cat,
                          );
                        },
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary.withValues(
                          alpha: 0.18,
                        ),
                        child: Icon(
                          _iconForCategory(cat),
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(desc ?? 'Bocadillo'),
                      subtitle: cat == null
                          ? null
                          : Text(
                              cat,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                      trailing: Text(
                        'S/ ${s.price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () async {
                        final result = await showSnackDialog(
                          context,
                          categoryNames: vm.categoryNames,
                          initialDescription: desc,
                          initialCategory: cat,
                          initialPrice: s.price,
                          title: 'Editar bocadillo',
                          actionLabel: 'Guardar',
                        );
                        if (result != null) {
                          await vm.updateSnack(
                            id: s.id,
                            price: result.price,
                            description: result.description,
                            categoryName: result.categoryName,
                          );
                        }
                      },
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  String _subtitleFor(DailyViewModel vm) {
    final log = vm.log;
    if (log == null) return 'Sin registros aún';
    final parts = <String>[];
    if (log.hadBreakfast) parts.add('desayuno');
    if (log.hadLunch) parts.add('almuerzo');
    if (log.hadDinner) parts.add('cena');
    if (vm.todaySnacks.isNotEmpty) {
      parts.add('${vm.todaySnacks.length} bocadillo(s)');
    }
    if (parts.isEmpty) return 'Aún no marcaste ninguna comida';
    return parts.join(' • ');
  }

  IconData _iconForCategory(String? category) {
    switch (category?.toLowerCase()) {
      case 'panadería':
        return Icons.bakery_dining_rounded;
      case 'fruta':
        return Icons.spa_rounded;
      case 'gaseosa':
        return Icons.local_drink_rounded;
      case 'snack':
        return Icons.fastfood_rounded;
      case 'café':
        return Icons.coffee_rounded;
      case 'dulce':
        return Icons.icecream_rounded;
      default:
        return Icons.cookie_rounded;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  const _SectionHeader({
    required this.title,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: FoodBookSpacing.sm),
        Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
        ?trailing,
      ],
    );
  }
}

/// Exporta todos los snacks y pagos a un archivo CSV via share sheet.
Future<void> _exportCsv(BuildContext context) async {
  final streams = context.read<AppDataStreams>();
  AppToast.info(context, 'Generando CSV...');
  final path = await CsvExporter.exportAndShare(
    snacks: streams.snacks,
    payments: streams.payments,
  );
  if (!context.mounted) return;
  if (path != null) {
    AppToast.success(context, 'CSV exportado y compartido');
  } else {
    AppToast.warning(context, 'No se pudo generar el CSV');
  }
}

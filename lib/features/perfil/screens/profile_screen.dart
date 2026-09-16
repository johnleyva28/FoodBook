import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/theme/foodbook_text_styles.dart';
import '../../../core/widgets/stat_row.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) {
        final vm = ProfileViewModel(
          ctx.read<DailyLogRepository>(),
          ctx.read<SnackRepository>(),
          ctx.read<PaymentRepository>(),
          ctx.read<SettingsRepository>(),
        );
        vm.init();
        return vm;
      },
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final theme = Theme.of(context);

    if (vm.loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.person_rounded,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: FoodBookSpacing.sm),
            const Text('Perfil'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(FoodBookSpacing.lg),
        children: [
          // ── Avatar + nombre ──
          Center(
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: FoodBookColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    vm.initials,
                    style: FoodBookTextStyles.displaySmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: FoodBookSpacing.md),
                Text(
                  vm.userName.isEmpty ? 'FoodBooker' : vm.userName,
                  style: theme.textTheme.headlineSmall,
                ),
                Text(
                  'Miembro desde siempre',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: FoodBookSpacing.xl),

          // ── Stats grid ──
          _StatsGrid(vm: vm),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Resumen financiero ──
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: FoodBookSpacing.sm),
              child: Column(
                children: [
                  StatRow(
                    icon: Icons.timeline_rounded,
                    label: 'Días registrados',
                    sublabel: 'Con comidas o snacks',
                    value: '${vm.totalDays}',
                    valueColor: FoodBookColors.skyLight,
                  ),
                  const Divider(height: 1),
                  StatRow(
                    icon: Icons.lunch_dining_rounded,
                    label: 'Almuerzos',
                    value: '${vm.totalLunches}',
                    valueColor: FoodBookColors.skyLight,
                  ),
                  const Divider(height: 1),
                  StatRow(
                    icon: Icons.dinner_dining_rounded,
                    label: 'Cenas',
                    value: '${vm.totalDinners}',
                    valueColor: FoodBookColors.skyLight,
                  ),
                  const Divider(height: 1),
                  StatRow(
                    icon: Icons.free_breakfast_rounded,
                    label: 'Desayunos',
                    value: '${vm.totalBreakfasts}',
                    valueColor: FoodBookColors.skyLight,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Favorito ──
          if (vm.topSnack != null)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: FoodBookColors.warning.withValues(alpha: 0.2),
                  child: Icon(
                    Icons.star_rounded,
                    color: FoodBookColors.warning,
                  ),
                ),
                title: Text('Tu favorito: ${vm.topSnack}'),
                subtitle: const Text(
                  'El bocadillo que más registras',
                ),
              ),
            ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Botón cerrar / cambiar nombre ──
          OutlinedButton.icon(
            onPressed: () => _editName(context, vm),
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Cambiar mi nombre'),
          ),
        ],
      ),
    );
  }

  void _editName(BuildContext context, ProfileViewModel vm) {
    final controller = TextEditingController(text: vm.userName);
    final repo = context.read<SettingsRepository>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tu nombre'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            prefixIcon: Icon(Icons.person_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              await repo.setString('user_name', controller.text.trim());
              vm.userName = controller.text.trim();
              vm.notifyListeners();
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final ProfileViewModel vm;
  const _StatsGrid({required this.vm});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: FoodBookSpacing.md,
      mainAxisSpacing: FoodBookSpacing.md,
      childAspectRatio: 1.4,
      children: [
        _StatTile(
          icon: Icons.payments_rounded,
          label: 'Total consumido',
          value: 'S/ ${vm.totalConsumed.toStringAsFixed(2)}',
          color: FoodBookColors.danger,
        ),
        _StatTile(
          icon: Icons.savings_rounded,
          label: 'Total pagado',
          value: 'S/ ${vm.totalPaid.toStringAsFixed(2)}',
          color: FoodBookColors.success,
        ),
        _StatTile(
          icon: Icons.trending_up_rounded,
          label: 'Promedio diario',
          value: 'S/ ${vm.avgDaily.toStringAsFixed(2)}',
          color: FoodBookColors.sky,
        ),
        _StatTile(
          icon: Icons.cookie_rounded,
          label: 'Bocadillos',
          value: 'S/ ${vm.totalSnacks.toStringAsFixed(2)}',
          color: FoodBookColors.warning,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(FoodBookSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(FoodBookSpacing.radiusSm),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: FoodBookSpacing.sm),
            Text(
              label,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

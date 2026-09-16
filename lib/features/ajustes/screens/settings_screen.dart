import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/repositories/maintenance_repository.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos el VM global provisto en main.dart; aquí solo observamos.
    final vm = context.watch<SettingsViewModel>();
    final theme = Theme.of(context);

    if (vm.loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ajustes')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.settings_rounded,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: FoodBookSpacing.sm),
            const Text('Ajustes'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(FoodBookSpacing.lg),
        children: [
          // ── Perfil ──
          const _SectionTitle('Perfil'),
          const SizedBox(height: FoodBookSpacing.sm),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.18),
                child: Icon(Icons.person_rounded, color: theme.colorScheme.primary),
              ),
              title: Text(
                vm.userName.isEmpty ? 'Sin nombre' : vm.userName,
              ),
              subtitle: const Text('Toca para editar tu nombre'),
              trailing: const Icon(Icons.edit_rounded, size: 18),
              onTap: () => _editUserName(context, vm),
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Tema ──
          const _SectionTitle('Apariencia'),
          const SizedBox(height: FoodBookSpacing.sm),
          Card(
            child: RadioGroup<ThemeMode>(
              groupValue: vm.themeMode,
              onChanged: (v) {
                if (v != null) vm.setThemeMode(v);
              },
              child: const Column(
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    title: Text('Oscuro'),
                    subtitle: Text('Identidad FoodBook (azul marino)'),
                    secondary: Icon(Icons.dark_mode_rounded),
                  ),
                  Divider(height: 1),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    title: Text('Claro'),
                    subtitle: Text('Fondo blanco con acentos celeste'),
                    secondary: Icon(Icons.light_mode_rounded),
                  ),
                  Divider(height: 1),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    title: Text('Sistema'),
                    subtitle: Text('Sigue el modo del dispositivo'),
                    secondary: Icon(Icons.brightness_auto_rounded),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Moneda ──
          const _SectionTitle('Moneda'),
          const SizedBox(height: FoodBookSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(FoodBookSpacing.md),
              child: Wrap(
                spacing: FoodBookSpacing.sm,
                children: AppConstants.supportedCurrencies.map((c) {
                  final selected = vm.currency == c;
                  return ChoiceChip(
                    label: Text(c.trim()),
                    selected: selected,
                    onSelected: (_) => vm.setCurrency(c),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Precios base ──
          const _SectionTitle('Precios base de la pensión'),
          const SizedBox(height: FoodBookSpacing.sm),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lunch_dining_rounded),
                  title: const Text('Precio del almuerzo'),
                  subtitle: const Text(
                    'Se multiplica por cada vez que almuerzas',
                  ),
                  trailing: Text(
                    '${vm.currency} ${vm.lunchPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  onTap: () => _editPrice(
                    context,
                    vm,
                    title: 'Precio del almuerzo',
                    currentValue: vm.lunchPrice,
                    onSave: vm.setLunchPrice,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.dinner_dining_rounded),
                  title: const Text('Precio de la cena'),
                  subtitle: const Text(
                    'Se multiplica por cada vez que cenas',
                  ),
                  trailing: Text(
                    '${vm.currency} ${vm.dinnerPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  onTap: () => _editPrice(
                    context,
                    vm,
                    title: 'Precio de la cena',
                    currentValue: vm.dinnerPrice,
                    onSave: vm.setDinnerPrice,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Presupuesto ──
          const _SectionTitle('Presupuesto mensual'),
          const SizedBox(height: FoodBookSpacing.sm),
          Card(
            child: ListTile(
              leading: const Icon(Icons.savings_rounded),
              title: const Text('Límite mensual'),
              subtitle: const Text(
                'Aparece en Cuentas para controlar tu gasto',
              ),
              trailing: Text(
                '${vm.currency} ${vm.monthlyBudget.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
              onTap: () => _editBudget(context, vm),
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Datos ──
          const _SectionTitle('Datos'),
          const SizedBox(height: FoodBookSpacing.sm),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.file_download_rounded),
                  title: const Text('Exportar datos a CSV'),
                  subtitle: const Text(
                    'Snacks y pagos como archivo CSV',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _exportCsv(context, vm),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever_rounded,
                    color: FoodBookColors.danger,
                  ),
                  title: const Text('Borrar todos los datos'),
                  subtitle: const Text(
                    'Elimina snacks, pagos y registros diarios',
                  ),
                  onTap: () => _confirmDelete(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Acerca de ──
          const _SectionTitle('Acerca de'),
          const SizedBox(height: FoodBookSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(FoodBookSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: FoodBookSpacing.sm),
                      Text(
                        AppConstants.appName,
                        style: theme.textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Text(
                        'v${AppConstants.appVersion}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: FoodBookSpacing.xs),
                  Text(
                    AppConstants.appTagline,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: FoodBookSpacing.sm),
                  Text(
                    'Flutter + Drift (SQLite). Modo offline, sin anuncios, sin cuentas.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editPrice(
    BuildContext context,
    SettingsViewModel vm, {
    required String title,
    required double currentValue,
    required Future<void> Function(double) onSave,
  }) {
    final controller = TextEditingController(text: currentValue.toStringAsFixed(2));
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Precio (${vm.currency.trim()})',
              prefixIcon: const Icon(Icons.attach_money_rounded),
            ),
            validator: (v) {
              final price = double.tryParse(v?.replaceAll(',', '.') ?? '');
              if (price == null || price <= 0) {
                return 'Ingresa un precio válido';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final price = double.parse(
                  controller.text.replaceAll(',', '.'),
                );
                onSave(price);
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _editBudget(BuildContext context, SettingsViewModel vm) {
    final controller =
        TextEditingController(text: vm.monthlyBudget.toStringAsFixed(2));
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Presupuesto mensual'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Presupuesto (${vm.currency.trim()})',
              prefixIcon: const Icon(Icons.savings_rounded),
            ),
            validator: (v) {
              final budget = double.tryParse(v?.replaceAll(',', '.') ?? '');
              if (budget == null || budget < 0) {
                return 'Ingresa un presupuesto válido';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final budget = double.parse(
                  controller.text.replaceAll(',', '.'),
                );
                vm.setMonthlyBudget(budget);
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _editUserName(BuildContext context, SettingsViewModel vm) {
    final controller = TextEditingController(text: vm.userName);

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
            onPressed: () {
              vm.setUserName(controller.text.trim());
              Navigator.pop(dialogContext);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _exportCsv(BuildContext context, SettingsViewModel vm) {
    AppToast.warning(
      context,
      'Exportación CSV en construcción. Estará disponible en la próxima versión.',
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Borrar todos los datos?'),
        content: const Text(
          'Esta acción no se puede deshacer. Se eliminarán todos los registros de comidas, snacks y pagos. Tus ajustes y precios se conservan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: FoodBookColors.danger,
            ),
            onPressed: () async {
              final repo = context.read<MaintenanceRepository>();
              Navigator.pop(dialogContext);
              await repo.wipeAll();
              if (!context.mounted) return;
              AppToast.danger(context, 'Todos los datos fueron eliminados');
            },
            child: const Text('Sí, borrar'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleLarge);
  }
}

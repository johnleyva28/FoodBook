import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';
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
    final todayLabel = DateFormat(
      'EEEE, d \'de\' MMMM',
      'es_PE',
    ).format(DateTime.now());

    if (vm.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('FoodBook 🍽️'),
            Text(
              todayLabel[0].toUpperCase() + todayLabel.substring(1),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Totales de hoy ──
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Gasto de hoy', style: theme.textTheme.titleMedium),
                  Text(
                    'S/ ${vm.dayTotal.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Comidas de la pensión ──
          Text('Comidas de hoy', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),

          BreakfastCard(
            checked: vm.log?.hadBreakfast ?? false,
            price: vm.log?.breakfastPrice ?? 0,
            description: vm.log?.breakfastDesc,
            onToggle: (value) async {
              if (value) {
                // Al activar, pedimos precio y descripción.
                final result = await _showBreakfastDialog(
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
              final result = await _showBreakfastDialog(
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
            icon: Icons.lunch_dining,
            price: vm.lunchPrice,
            checked: vm.log?.hadLunch ?? false,
            onChanged: vm.toggleLunch,
          ),
          LunchDinnerCard(
            label: 'Cena',
            icon: Icons.dinner_dining,
            price: vm.dinnerPrice,
            checked: vm.log?.hadDinner ?? false,
            onChanged: vm.toggleDinner,
          ),
          const SizedBox(height: 16),

          // ── Bocadillos ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bocadillos', style: theme.textTheme.titleLarge),
              FilledButton.icon(
                onPressed: () async {
                  final result = await showSnackDialog(context);
                  if (result != null) {
                    await vm.addSnack(price: result.$1, description: result.$2);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Agregar'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (vm.snacks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('No hay bocadillos registrados hoy 🥐'),
            )
          else
            ...vm.snacks.map(
              (s) => Card(
                child: ListTile(
                  leading: const Icon(Icons.bakery_dining),
                  title: Text(
                    s.description?.isNotEmpty == true
                        ? s.description!
                        : 'Bocadillo',
                  ),
                  subtitle: Text('S/ ${s.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => vm.deleteSnack(s.id),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Diálogo para capturar el precio (y descripción) del desayuno.
  Future<(double, String?)?> _showBreakfastDialog(
    BuildContext context, {
    double? initialPrice,
    String? initialDesc,
  }) {
    final priceController = TextEditingController(
      text: (initialPrice ?? 0) > 0 ? initialPrice.toString() : '',
    );
    final descController = TextEditingController(text: initialDesc ?? '');
    final formKey = GlobalKey<FormState>();

    return showDialog<(double, String?)>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desayuno 🍳'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: priceController,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Precio (S/)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (v) {
                  final price = double.tryParse(v?.replaceAll(',', '.') ?? '');
                  if (price == null || price <= 0) {
                    return 'Ingresa un precio válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: '¿Qué comiste? (opcional)',
                  prefixIcon: Icon(Icons.notes),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final price = double.parse(
                  priceController.text.replaceAll(',', '.'),
                );
                Navigator.pop<(double, String?)>(context, (
                  price,
                  descController.text.trim(),
                ));
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

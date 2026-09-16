import 'package:flutter/material.dart';

import '../../../core/theme/foodbook_spacing.dart';

/// Diálogo para agregar un bocadillo con precio, descripción y categoría.
class SnackFormResult {
  final double price;
  final String? description;
  final String? categoryName;
  SnackFormResult({
    required this.price,
    this.description,
    this.categoryName,
  });
}

/// Muestra el diálogo modal para crear un bocadillo.
///
/// Devuelve `null` si el usuario cancela.
Future<SnackFormResult?> showSnackDialog(
  BuildContext context, {
  List<String> categoryNames = const [],
  String? initialDescription,
  String? initialCategory,
  double? initialPrice,
  String title = 'Agregar bocadillo',
  String actionLabel = 'Agregar',
}) {
  final priceController = TextEditingController(
    text: initialPrice != null ? initialPrice.toString() : '',
  );
  final descController = TextEditingController(text: initialDescription ?? '');
  final selectedCategory = ValueNotifier<String?>(initialCategory);
  final formKey = GlobalKey<FormState>();

  return showDialog<SnackFormResult>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: priceController,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Precio (S/)',
                    prefixIcon: Icon(Icons.attach_money_rounded),
                  ),
                  validator: (v) {
                    final price =
                        double.tryParse(v?.replaceAll(',', '.') ?? '');
                    if (price == null || price <= 0) {
                      return 'Ingresa un precio válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: FoodBookSpacing.md),
                if (categoryNames.isNotEmpty) ...[
                  ValueListenableBuilder<String?>(
                    valueListenable: selectedCategory,
                    builder: (_, current, __) {
                      return Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: categoryNames.map((cat) {
                          final selected = current == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: selected,
                            onSelected: (sel) {
                              selectedCategory.value = sel ? cat : null;
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: FoodBookSpacing.md),
                ],
                TextFormField(
                  controller: descController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final price = double.parse(
                priceController.text.replaceAll(',', '.'),
              );
              Navigator.pop<SnackFormResult>(
                dialogContext,
                SnackFormResult(
                  price: price,
                  description: descController.text.trim().isEmpty
                      ? null
                      : descController.text.trim(),
                  categoryName: selectedCategory.value,
                ),
              );
            }
          },
          icon: const Icon(Icons.check_rounded, size: 18),
          label: Text(actionLabel),
        ),
      ],
    ),
  );
}

/// Diálogo para editar el desayuno (precio manual + descripción).
Future<({double price, String? description})?> showBreakfastDialog(
  BuildContext context, {
  double? initialPrice,
  String? initialDesc,
}) {
  final priceController = TextEditingController(
    text: initialPrice != null && initialPrice > 0
        ? initialPrice.toString()
        : '',
  );
  final descController = TextEditingController(text: initialDesc ?? '');
  final formKey = GlobalKey<FormState>();

  return showDialog<(double, String?)>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Desayuno'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: priceController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Precio (S/)',
                prefixIcon: Icon(Icons.attach_money_rounded),
              ),
              validator: (v) {
                final price = double.tryParse(v?.replaceAll(',', '.') ?? '');
                if (price == null || price <= 0) {
                  return 'Ingresa un precio válido';
                }
                return null;
              },
            ),
            const SizedBox(height: FoodBookSpacing.md),
            TextFormField(
              controller: descController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: '¿Qué comiste? (opcional)',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
            ),
          ],
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
                priceController.text.replaceAll(',', '.'),
              );
              Navigator.pop<(double, String?)>(
                dialogContext,
                (price, descController.text.trim()),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}

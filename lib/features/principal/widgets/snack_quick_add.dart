import 'package:flutter/material.dart';

/// Diálogo para agregar un bocadillo (precio + descripción opcional).
Future<(double price, String? description)?> showSnackDialog(
  BuildContext context,
) {
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showDialog<(double, String?)>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Agregar bocadillo 🥐'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: priceController,
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
                labelText: 'Descripción (opcional)',
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
          child: const Text('Agregar'),
        ),
      ],
    ),
  );
}

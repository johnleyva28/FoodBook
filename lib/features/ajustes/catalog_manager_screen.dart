import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/app_data_streams.dart';
import '../../../data/repositories/catalog_repository.dart';

/// Pantalla de gestión de categorías y métodos de pago.
///
/// Permite agregar y eliminar categorías (de snacks) y métodos
/// de pago. Las categorías/métodos por defecto no se pueden eliminar.
class CatalogManagerScreen extends StatelessWidget {
  const CatalogManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Catálogos'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.cookie_rounded), text: 'Categorías'),
              Tab(icon: Icon(Icons.payments_rounded), text: 'Métodos'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _CategoryList(),
            _PaymentMethodList(),
          ],
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList();

  @override
  Widget build(BuildContext context) {
    final streams = context.watch<AppDataStreams>();
    final repo = context.read<CatalogRepository>();
    final cats = streams.categories;

    return Column(
      children: [
        Expanded(
          child: cats.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(FoodBookSpacing.lg),
                    child: Text('Sin categorías. Agrega la primera.'),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(FoodBookSpacing.md),
                  itemCount: cats.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: FoodBookSpacing.xs),
                  itemBuilder: (_, i) {
                    final c = cats[i];
                    return _CatalogTile(
                      icon: Icons.cookie_rounded,
                      title: c.name,
                      isDefault: c.isDefault,
                      onDelete: c.isDefault
                          ? null
                          : () async {
                              await repo.deleteCategory(c.id);
                              if (!context.mounted) return;
                              AppToast.info(context, 'Categoría eliminada');
                            },
                    );
                  },
                ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(FoodBookSpacing.md),
            child: FilledButton.icon(
              onPressed: () => _showAddDialog(context, isCategory: true),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Agregar categoría'),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodList extends StatelessWidget {
  const _PaymentMethodList();

  // Nombres por defecto (mismos que en el seed del repositorio).
  static const _defaultNames = {'Efectivo', 'Yape', 'Plin', 'Transferencia'};

  @override
  Widget build(BuildContext context) {
    final streams = context.watch<AppDataStreams>();
    final repo = context.read<CatalogRepository>();
    final methods = streams.categories
        .where((c) => _defaultNames.contains(c.name))
        .toList();

    return Column(
      children: [
        Expanded(
          child: methods.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(FoodBookSpacing.lg),
                    child: Text('Sin métodos. Agrega el primero.'),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(FoodBookSpacing.md),
                  itemCount: methods.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: FoodBookSpacing.xs),
                  itemBuilder: (_, i) {
                    final m = methods[i];
                    return _CatalogTile(
                      icon: Icons.payments_rounded,
                      title: m.name,
                      isDefault: m.isDefault,
                      onDelete: m.isDefault
                          ? null
                          : () async {
                              await repo.deletePaymentMethod(m.id);
                              if (!context.mounted) return;
                              AppToast.info(context, 'Método eliminado');
                            },
                    );
                  },
                ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(FoodBookSpacing.md),
            child: FilledButton.icon(
              onPressed: () => _showAddDialog(context, isCategory: false),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Agregar método de pago'),
            ),
          ),
        ),
      ],
    );
  }
}

class _CatalogTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDefault;
  final VoidCallback? onDelete;

  const _CatalogTile({
    required this.icon,
    required this.title,
    required this.isDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.18),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(title),
        subtitle: isDefault ? const Text('Predeterminado') : null,
        trailing: onDelete == null
            ? Icon(
                Icons.lock_outline_rounded,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              )
            : IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: FoodBookColors.danger,
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('¿Eliminar?'),
                      content: Text('Se eliminará "$title".'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) onDelete?.call();
                },
              ),
      ),
    );
  }
}

Future<void> _showAddDialog(
  BuildContext context, {
  required bool isCategory,
}) async {
  final controller = TextEditingController();
  final repo = context.read<CatalogRepository>();
  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(isCategory ? 'Nueva categoría' : 'Nuevo método de pago'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Nombre',
          hintText: isCategory ? 'Ej. Panadería' : 'Ej. Transferencia',
          prefixIcon: Icon(isCategory
              ? Icons.cookie_rounded
              : Icons.payments_rounded),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, controller.text.trim()),
          child: const Text('Agregar'),
        ),
      ],
    ),
  );
  if (result == null || result.isEmpty) return;
  // Capturamos el messenger antes del await para evitar el warning
  // de BuildContext tras async gap.
  // ignore: use_build_context_synchronously
  final messenger = ScaffoldMessenger.maybeOf(context);
  try {
    if (isCategory) {
      await repo.addCategory(name: result);
    } else {
      await repo.addPaymentMethod(name: result);
    }
    messenger?.showSnackBar(
      SnackBar(
        content: Text(
          isCategory
              ? 'Categoría "$result" agregada'
              : 'Método "$result" agregado',
        ),
      ),
    );
  } catch (e) {
    messenger?.showSnackBar(
      const SnackBar(
        content: Text('No se pudo agregar (¿ya existe ese nombre?)'),
      ),
    );
  }
}

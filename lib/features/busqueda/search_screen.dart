import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/theme/foodbook_text_styles.dart';
import '../../../core/widgets/stat_row.dart';
import 'search_viewmodel.dart';

/// Pantalla de búsqueda global de snacks y pagos.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(FoodBookSpacing.lg),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, categoría, fecha, monto...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _controller.clear();
                          vm.setQuery('');
                          setState(() {});
                        },
                      ),
              ),
              onChanged: (v) {
                vm.setQuery(v);
                setState(() {});
              },
            ),
          ),
          if (vm.hits.isEmpty && vm.query.trim().isNotEmpty)
            const Expanded(
              child: EmptyState(
                icon: Icons.search_off_rounded,
                title: 'Sin resultados',
                message: 'Intenta con otro término.',
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: FoodBookSpacing.lg,
                ),
                itemCount: vm.hits.length,
                itemBuilder: (_, i) {
                  final hit = vm.hits[i];
                  return _SearchHitTile(hit: hit);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchHitTile extends StatelessWidget {
  final SearchHit hit;
  const _SearchHitTile({required this.hit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPayment = hit.kind == SearchKind.payment;
    final color = isPayment ? FoodBookColors.success : FoodBookColors.warning;
    final icon = isPayment
        ? Icons.payments_rounded
        : Icons.bakery_dining_rounded;

    return Card(
      margin: const EdgeInsets.only(bottom: FoodBookSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.18),
          child: Icon(icon, color: color),
        ),
        title: Text(hit.title, style: theme.textTheme.titleSmall),
        subtitle: Text(
          [
            hit.date,
            if (hit.subtitle != null && hit.subtitle!.isNotEmpty) hit.subtitle!,
          ].join(' • '),
        ),
        trailing: Text(
          '${isPayment ? '-' : '+'}S/ ${hit.amount.toStringAsFixed(2)}',
          style: FoodBookTextStyles.titleSmall.copyWith(color: color),
        ),
      ),
    );
  }
}

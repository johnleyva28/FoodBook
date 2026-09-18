import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/widgets/highlighted_text.dart';
import '../../../core/widgets/stat_row.dart';
import 'search_viewmodel.dart';

/// Tipo de filtro para reducir la búsqueda.
enum SearchTypeFilter { all, snacks, payments }

extension SearchTypeFilterX on SearchTypeFilter {
  String get label => switch (this) {
        SearchTypeFilter.all => 'Todos',
        SearchTypeFilter.snacks => 'Snacks',
        SearchTypeFilter.payments => 'Pagos',
      };

  SearchKind? get kind => switch (this) {
        SearchTypeFilter.all => null,
        SearchTypeFilter.snacks => SearchKind.snack,
        SearchTypeFilter.payments => SearchKind.payment,
      };
}

/// Orden de los resultados de búsqueda.
enum SearchSortOrder { recent, oldest, amountHigh, amountLow }

extension SearchSortOrderX on SearchSortOrder {
  String get label => switch (this) {
        SearchSortOrder.recent => 'Más reciente',
        SearchSortOrder.oldest => 'Más antiguo',
        SearchSortOrder.amountHigh => 'Mayor monto',
        SearchSortOrder.amountLow => 'Menor monto',
      };
}

/// Pantalla de búsqueda global de snacks y pagos.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  SearchTypeFilter _typeFilter = SearchTypeFilter.all;
  DateTimeRange? _dateRange;
  double? _minAmount;
  SearchSortOrder _sortOrder = SearchSortOrder.recent;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<SearchHit> _applyFilters(List<SearchHit> hits) {
    final filtered = hits.where((h) {
      if (_typeFilter.kind != null && h.kind != _typeFilter.kind) return false;
      if (_dateRange != null) {
        try {
          final d = DateHelper.parse(h.date);
          if (d.isBefore(_dateRange!.start) ||
              d.isAfter(_dateRange!.end)) {
            return false;
          }
        } catch (_) {
          return false;
        }
      }
      if (_minAmount != null && h.amount < _minAmount!) return false;
      return true;
    }).toList();
    // Ordenar
    switch (_sortOrder) {
      case SearchSortOrder.recent:
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SearchSortOrder.oldest:
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SearchSortOrder.amountHigh:
        filtered.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case SearchSortOrder.amountLow:
        filtered.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }
    return filtered;
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange:
          _dateRange ?? DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
    );
    if (picked != null && mounted) {
      setState(() => _dateRange = picked);
    }
  }

  Future<void> _pickMinAmount() async {
    final controller = TextEditingController(
      text: _minAmount?.toStringAsFixed(2) ?? '',
    );
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Monto mínimo'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'S/',
            hintText: 'Ej. 5.00',
            prefixText: 'S/ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (result == null || result.isEmpty) {
      setState(() => _minAmount = null);
    } else {
      final v = double.tryParse(result.replaceAll(',', '.'));
      setState(() => _minAmount = v);
    }
  }

  Future<void> _pickSortOrder() async {
    final picked = await showModalBottomSheet<SearchSortOrder>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Ordenar por',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              for (final order in SearchSortOrder.values)
                ListTile(
                  leading: Icon(
                    order == _sortOrder
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: order == _sortOrder
                        ? theme.colorScheme.primary
                        : null,
                  ),
                  title: Text(order.label),
                  onTap: () => Navigator.pop(ctx, order),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _sortOrder = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    final filtered = _applyFilters(vm.hits);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.search_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: FoodBookSpacing.sm),
            const Text('Buscar'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(FoodBookSpacing.lg),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText:
                        'Buscar por nombre, categoría, fecha, monto...',
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
                const SizedBox(height: FoodBookSpacing.sm),
                // ── Filtros ──
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        children: SearchTypeFilter.values.map((t) {
                          final selected = t == _typeFilter;
                          return ChoiceChip(
                            label: Text(t.label),
                            selected: selected,
                            onSelected: (_) =>
                                setState(() => _typeFilter = t),
                          );
                        }).toList(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.date_range_rounded,
                        color: _dateRange != null
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      tooltip: _dateRange == null
                          ? 'Filtrar por rango'
                          : 'Quitar filtro de fecha',
                      onPressed: () {
                        if (_dateRange != null) {
                          setState(() => _dateRange = null);
                        } else {
                          _pickDateRange();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.payments_outlined,
                        color: _minAmount != null
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      tooltip: _minAmount == null
                          ? 'Filtrar por monto mínimo'
                          : 'Quitar filtro de monto',
                      onPressed: () => _pickMinAmount(),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.sort_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      tooltip: 'Ordenar por',
                      onPressed: () => _pickSortOrder(),
                    ),
                  ],
                ),
                if (_dateRange != null)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: FoodBookSpacing.xs),
                    child: Text(
                      '${DateHelper.format(_dateRange!.start)} → '
                      '${DateHelper.format(_dateRange!.end)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                if (_minAmount != null)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: FoodBookSpacing.xs),
                    child: Text(
                      'Monto ≥ S/ ${_minAmount!.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (filtered.isEmpty && vm.query.trim().isNotEmpty)
            Expanded(
              child: EmptyState(
                icon: Icons.search_off_rounded,
                title: 'Sin resultados',
                message: _dateRange != null || _typeFilter != SearchTypeFilter.all
                    ? 'Prueba a quitar los filtros.'
                    : 'Intenta con otro término.',
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: FoodBookSpacing.lg,
                ),
                itemCount: filtered.length,
                itemBuilder: (_, i) => _SearchHitTile(
                  hit: filtered[i],
                  query: vm.query.trim(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchHitTile extends StatelessWidget {
  final SearchHit hit;
  final String query;
  const _SearchHitTile({required this.hit, required this.query});

  @override
  Widget build(BuildContext context) {
    final isPayment = hit.kind == SearchKind.payment;
    final color = isPayment ? FoodBookColors.success : FoodBookColors.warning;
    final icon =
        isPayment ? Icons.payments_rounded : Icons.bakery_dining_rounded;

    return HighlightedSearchTile(
      icon: icon,
      color: color,
      title: hit.title,
      query: query,
      subtitle: [
        hit.date,
        if (hit.subtitle != null && hit.subtitle!.isNotEmpty) hit.subtitle!,
      ].join(' • '),
      trailing:
          '${isPayment ? '-' : '+'}S/ ${hit.amount.toStringAsFixed(2)}',
    );
  }
}

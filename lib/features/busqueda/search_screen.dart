import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/theme/foodbook_text_styles.dart';
import '../../../core/widgets/stat_row.dart';
import '../../../core/utils/date_helper.dart';
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<SearchHit> _applyFilters(List<SearchHit> hits) {
    return hits.where((h) {
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
      return true;
    }).toList();
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
                itemBuilder: (_, i) => _SearchHitTile(hit: filtered[i]),
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
    final icon =
        isPayment ? Icons.payments_rounded : Icons.bakery_dining_rounded;

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

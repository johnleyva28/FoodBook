import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/stat_row.dart';
import '../../../data/app_data_streams.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../../data/repositories/daily_extras_repository.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';
import '../../principal/widgets/breakfast_card.dart';
import '../../principal/widgets/lunch_dinner_card.dart';
import '../../principal/widgets/snack_quick_add.dart';
import '../calendario_viewmodel.dart';

/// Vista y edición de un día específico.
///
/// Permite modificar desayuno/almuerzo/cena, agregar/editar/borrar
/// snacks, registrar/editar/borrar pagos, y editar notas y rating.
class DiaDetalleScreen extends StatefulWidget {
  final String date; // yyyy-MM-dd
  const DiaDetalleScreen({super.key, required this.date});

  @override
  State<DiaDetalleScreen> createState() => _DiaDetalleScreenState();
}

class _DiaDetalleScreenState extends State<DiaDetalleScreen> {
  late CalendarioViewModel _vm;
  late SettingsRepository _settingsRepo;
  late CatalogRepository _catalogRepo;
  DayDetail? _detail;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // El VM se construye via ChangeNotifierProvider.value para que
    // comparta el bus global AppDataStreams (mismo estado que las
    // demás pantallas: Hoy, Cuentas, Calendario).
    final streams = context.read<AppDataStreams>();
    _vm = CalendarioViewModel(
      streams,
      context.read<DailyLogRepository>(),
      context.read<SnackRepository>(),
      context.read<PaymentRepository>(),
      context.read<DailyExtrasRepository>(),
    );
    _settingsRepo = context.read<SettingsRepository>();
    _catalogRepo = context.read<CatalogRepository>();
    _vm.init();
    _scheduleLoad();
  }

  void _scheduleLoad() {
    // Esperamos el primer ciclo de micro-tareas para que los
    // streams del bus global emitan al menos una vez.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final detail = await _vm.getDayDetail(widget.date);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _loading = false;
      });
    });
  }

  Future<void> _load() async {
    final detail = await _vm.getDayDetail(widget.date);
    if (!mounted) return;
    setState(() {
      _detail = detail;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final humanDate = _humanDate(widget.date);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              humanDate.split(',').first,
              style: theme.textTheme.titleMedium,
            ),
            Text(
              humanDate.contains(',')
                  ? humanDate.split(',').skip(1).join(',').trim()
                  : '',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    final detail = _detail!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        FoodBookSpacing.lg,
        FoodBookSpacing.lg,
        FoodBookSpacing.lg,
        FoodBookSpacing.xxl,
      ),
      children: [
        // ── Resumen ──
        _SummaryRow(detail: detail),
        const SizedBox(height: FoodBookSpacing.lg),

        // ── Comidas ──
        Text(
          'Comidas del día',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: FoodBookSpacing.sm),
        BreakfastCard(
          checked: detail.log?.hadBreakfast ?? false,
          price: detail.log?.breakfastPrice ?? 0,
          description: detail.log?.breakfastDesc,
          onToggle: (value) async {
            if (value) {
              final result = await showBreakfastDialog(
                context,
                initialPrice: detail.log?.breakfastPrice,
                initialDesc: detail.log?.breakfastDesc,
              );
              if (result == null) return;
              await _vm.saveBreakfast(
                widget.date,
                had: true,
                price: result.$1,
                description: result.$2,
              );
            } else {
              await _vm.saveBreakfast(
                widget.date,
                had: false,
                price: 0,
              );
            }
            await _load();
          },
          onEdit: () async {
            final result = await showBreakfastDialog(
              context,
              initialPrice: detail.log?.breakfastPrice,
              initialDesc: detail.log?.breakfastDesc,
            );
            if (result == null) return;
            await _vm.saveBreakfast(
              widget.date,
              had: true,
              price: result.$1,
              description: result.$2,
            );
            await _load();
          },
        ),
        FutureBuilder<double>(
          future: _settingsRepo.getLunchPrice(),
          builder: (_, snap) {
            final price = snap.data ?? 9.0;
            return LunchDinnerCard(
              label: 'Almuerzo',
              icon: Icons.lunch_dining_rounded,
              price: price,
              checked: detail.log?.hadLunch ?? false,
              onChanged: (v) async {
                await _vm.toggleLunch(widget.date, v);
                await _load();
              },
            );
          },
        ),
        FutureBuilder<double>(
          future: _settingsRepo.getDinnerPrice(),
          builder: (_, snap) {
            final price = snap.data ?? 9.0;
            return LunchDinnerCard(
              label: 'Cena',
              icon: Icons.dinner_dining_rounded,
              price: price,
              checked: detail.log?.hadDinner ?? false,
              onChanged: (v) async {
                await _vm.toggleDinner(widget.date, v);
                await _load();
              },
            );
          },
        ),
        const SizedBox(height: FoodBookSpacing.lg),

        // ── Snacks ──
        _SectionTitle(
          title: 'Bocadillos',
          icon: Icons.bakery_dining_rounded,
          actionLabel: 'Agregar',
          onAction: () async {
            final categories = await _catalogRepo.getAllCategories();
            if (!mounted) return;
            final result = await showSnackDialog(
              context,
              categoryNames: categories.map((c) => c.name).toList(),
            );
            if (result != null) {
              await _vm.addSnack(
                widget.date,
                price: result.price,
                description: result.description,
                categoryName: result.categoryName,
              );
              await _load();
            }
          },
        ),
        const SizedBox(height: FoodBookSpacing.sm),
        if (detail.snacks.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(FoodBookSpacing.lg),
              child: Center(
                child: Text(
                  'Sin bocadillos',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          )
        else
          ...detail.snacks.map((s) {
            final decoded = SnackRepository.decode(s.description);
            final cat = decoded.$1;
            final desc = decoded.$2 ?? 'Bocadillo';
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
                    borderRadius:
                        BorderRadius.circular(FoodBookSpacing.radiusMd),
                  ),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await _vm.deleteSnack(s.id);
                  await _load();
                  if (!mounted) return;
                  AppToast.info(context, 'Eliminado: $desc');
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary
                        .withValues(alpha: 0.18),
                    child: Icon(
                      Icons.cookie_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  title: Text(desc),
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
                    final categories = await _catalogRepo.getAllCategories();
                    if (!mounted) return;
                    final result = await showSnackDialog(
                      context,
                      categoryNames: categories.map((c) => c.name).toList(),
                      initialDescription: decoded.$2,
                      initialCategory: decoded.$1,
                      initialPrice: s.price,
                      title: 'Editar bocadillo',
                      actionLabel: 'Guardar',
                    );
                    if (result != null) {
                      await _vm.updateSnack(
                        s.id,
                        price: result.price,
                        description: result.description,
                        categoryName: result.categoryName,
                      );
                      await _load();
                    }
                  },
                ),
              ),
            );
          }),
        const SizedBox(height: FoodBookSpacing.lg),

        // ── Pagos ──
        _SectionTitle(
          title: 'Pagos',
          icon: Icons.payments_rounded,
          actionLabel: 'Agregar',
          onAction: () async {
            final methods = await _catalogRepo.getAllPaymentMethods();
            if (!mounted) return;
            await _showPaymentDialog(methods.map((m) => m.name).toList());
          },
        ),
        const SizedBox(height: FoodBookSpacing.sm),
        if (detail.payments.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(FoodBookSpacing.lg),
              child: Center(
                child: Text(
                  'Sin pagos',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          )
        else
          ...detail.payments.map((p) {
            final decoded = PaymentRepository.decode(p.note);
            return Card(
              margin: const EdgeInsets.only(bottom: FoodBookSpacing.sm),
              child: Dismissible(
                key: ValueKey('payment_${p.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: FoodBookColors.danger.withValues(alpha: 0.9),
                    borderRadius:
                        BorderRadius.circular(FoodBookSpacing.radiusMd),
                  ),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await _vm.deletePayment(p.id);
                  await _load();
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        FoodBookColors.success.withValues(alpha: 0.18),
                    child: const Icon(
                      Icons.payments_rounded,
                      color: FoodBookColors.success,
                    ),
                  ),
                  title: Text(
                    'S/ ${p.amount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    [
                      if (decoded.$1 != null) decoded.$1!,
                      if (decoded.$2 != null && decoded.$2!.isNotEmpty)
                        decoded.$2!,
                    ].join(' • '),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: () async {
                      final methods =
                          await _catalogRepo.getAllPaymentMethods();
                      if (!mounted) return;
                      await _showPaymentDialog(
                        methods.map((m) => m.name).toList(),
                        editingId: p.id,
                        initialAmount: p.amount,
                        initialNote: decoded.$2,
                        initialMethod: decoded.$1,
                      );
                    },
                  ),
                ),
              ),
            );
          }),
        const SizedBox(height: FoodBookSpacing.lg),

        // ── Extras del día (notas, rating, gastos extra) ──
        Text(
          'Notas y extras',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: FoodBookSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(FoodBookSpacing.md),
            child: Column(
              children: [
                _NotesEditor(
                  initialNotes: detail.extras.notes,
                  initialRating: detail.extras.rating,
                  initialExtraExpenses: detail.extras.extraExpenses,
                  onSave: (notes, rating, extras) async {
                    await _vm.saveExtras(
                      widget.date,
                      notes: notes,
                      rating: rating,
                      extraExpenses: extras,
                    );
                    await _load();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _humanDate(String iso) {
    try {
      final d = DateHelper.parse(iso);
      return DateFormat("EEEE, d 'de' MMMM", 'es_PE').format(d);
    } catch (_) {
      return iso;
    }
  }

  Future<void> _showPaymentDialog(
    List<String> methodNames, {
    int? editingId,
    double? initialAmount,
    String? initialNote,
    String? initialMethod,
  }) async {
    final result = await showDialog<_PaymentDialogResult>(
      context: context,
      builder: (dialogContext) => _PaymentDialog(
        methodNames: methodNames,
        initialAmount: initialAmount,
        initialNote: initialNote,
        initialMethod: initialMethod,
        isEditing: editingId != null,
      ),
    );
    if (result == null) return;
    if (editingId == null) {
      await _vm.addPayment(
        widget.date,
        amount: result.amount,
        note: result.note,
        methodName: result.methodName,
      );
    } else {
      await _vm.updatePayment(
        editingId,
        amount: result.amount,
        note: result.note,
        methodName: result.methodName,
      );
    }
    await _load();
  }
}

class _SummaryRow extends StatelessWidget {
  final DayDetail detail;
  const _SummaryRow({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: FoodBookSpacing.sm),
        child: Column(
          children: [
            StatRow(
              icon: Icons.shopping_cart_rounded,
              label: 'Consumido',
              sublabel: 'Desayuno + almuerzo/cena + snacks + extras',
              value: 'S/ ${detail.totalConsumed.toStringAsFixed(2)}',
              valueColor: FoodBookColors.warning,
            ),
            const Divider(height: 1),
            StatRow(
              icon: Icons.payments_rounded,
              label: 'Pagado',
              sublabel: '${detail.payments.length} pago(s)',
              value: 'S/ ${detail.totalPaid.toStringAsFixed(2)}',
              valueColor: FoodBookColors.success,
            ),
            const Divider(height: 1),
            StatRow(
              icon: detail.balance > 0
                  ? Icons.trending_up_rounded
                  : Icons.check_circle_outline_rounded,
              label: detail.balance > 0 ? 'Saldo pendiente' : 'Saldo a favor',
              value: 'S/ ${detail.balance.abs().toStringAsFixed(2)}',
              valueColor: detail.balance > 0
                  ? FoodBookColors.danger
                  : FoodBookColors.success,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final String actionLabel;
  final VoidCallback onAction;
  const _SectionTitle({
    required this.title,
    required this.icon,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: FoodBookSpacing.sm),
        Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
        TextButton.icon(
          onPressed: onAction,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: Text(actionLabel),
        ),
      ],
    );
  }
}

class _PaymentDialogResult {
  final double amount;
  final String? note;
  final String? methodName;
  _PaymentDialogResult(this.amount, this.note, this.methodName);
}

class _PaymentDialog extends StatefulWidget {
  final List<String> methodNames;
  final double? initialAmount;
  final String? initialNote;
  final String? initialMethod;
  final bool isEditing;
  const _PaymentDialog({
    required this.methodNames,
    this.initialAmount,
    this.initialNote,
    this.initialMethod,
    this.isEditing = false,
  });

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  String? _selectedMethod;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialAmount != null ? widget.initialAmount.toString() : '',
    );
    _noteController = TextEditingController(text: widget.initialNote ?? '');
    _selectedMethod = widget.initialMethod;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Editar pago' : 'Registrar pago'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _amountController,
                  autofocus: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Monto (S/)',
                    prefixIcon: Icon(Icons.attach_money_rounded),
                  ),
                  validator: (v) {
                    final amount =
                        double.tryParse(v?.replaceAll(',', '.') ?? '');
                    if (amount == null || amount <= 0) {
                      return 'Ingresa un monto válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: FoodBookSpacing.md),
                if (widget.methodNames.isNotEmpty) ...[
                  Text(
                    'Método de pago',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: FoodBookSpacing.xs),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.methodNames.map((m) {
                      final selected = _selectedMethod == m;
                      return ChoiceChip(
                        label: Text(m),
                        selected: selected,
                        onSelected: (sel) {
                          setState(() {
                            _selectedMethod = sel ? m : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: FoodBookSpacing.md),
                ],
                TextFormField(
                  controller: _noteController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nota (opcional)',
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
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final amount = double.parse(
                _amountController.text.replaceAll(',', '.'),
              );
              Navigator.pop<_PaymentDialogResult>(
                context,
                _PaymentDialogResult(
                  amount,
                  _noteController.text.trim().isEmpty
                      ? null
                      : _noteController.text.trim(),
                  _selectedMethod,
                ),
              );
            }
          },
          icon: const Icon(Icons.check_rounded, size: 18),
          label: Text(widget.isEditing ? 'Guardar' : 'Registrar'),
        ),
      ],
    );
  }
}

class _NotesEditor extends StatefulWidget {
  final String? initialNotes;
  final int? initialRating;
  final double initialExtraExpenses;
  final Future<void> Function(String? notes, int? rating, double extras)
      onSave;

  const _NotesEditor({
    required this.initialNotes,
    required this.initialRating,
    required this.initialExtraExpenses,
    required this.onSave,
  });

  @override
  State<_NotesEditor> createState() => _NotesEditorState();
}

class _NotesEditorState extends State<_NotesEditor> {
  late final TextEditingController _notesController;
  late final TextEditingController _extrasController;
  int? _rating;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
    _extrasController = TextEditingController(
      text: widget.initialExtraExpenses > 0
          ? widget.initialExtraExpenses.toString()
          : '',
    );
    _rating = widget.initialRating;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _extrasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _notesController,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Notas del día',
            hintText: 'Ej: menú especial, malestar, etc.',
            prefixIcon: Icon(Icons.sticky_note_2_rounded),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: FoodBookSpacing.md),
        Text('Calificación', style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
        Row(
          children: List.generate(5, (i) {
            final value = i + 1;
            return IconButton(
              icon: Icon(
                value <= (_rating ?? 0)
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: FoodBookColors.warning,
                size: 28,
              ),
              onPressed: () {
                setState(() {
                  _rating = _rating == value ? null : value;
                });
              },
            );
          }),
        ),
        const SizedBox(height: FoodBookSpacing.sm),
        TextField(
          controller: _extrasController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Gastos extra (S/)',
            hintText: 'Delivery, propinas, etc.',
            prefixIcon: Icon(Icons.add_circle_outline_rounded),
          ),
        ),
        const SizedBox(height: FoodBookSpacing.md),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () async {
              final extras = double.tryParse(
                    _extrasController.text.replaceAll(',', '.'),
                  ) ??
                  0;
              await widget.onSave(
                _notesController.text.trim().isEmpty
                    ? null
                    : _notesController.text.trim(),
                _rating,
                extras,
              );
              if (!context.mounted) return;
              AppToast.success(context, 'Notas guardadas');
            },
            icon: const Icon(Icons.save_rounded, size: 18),
            label: const Text('Guardar notas'),
          ),
        ),
      ],
    );
  }
}

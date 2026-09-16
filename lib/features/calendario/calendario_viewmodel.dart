import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:provider/provider.dart' show ReadContext;

import '../../../core/utils/date_helper.dart';
import '../../../data/database/app_database.dart';
import '../../../data/models/category.dart';
import '../../../data/repositories/daily_extras_repository.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/snack_repository.dart';

/// ViewModel del calendario.
///
/// Permite navegar por meses, ver marcadores por día y editar
/// el detalle de cualquier día (pasado o futuro).
class CalendarioViewModel extends ChangeNotifier {
  final DailyLogRepository _dailyLogRepo;
  final SnackRepository _snackRepo;
  final PaymentRepository _paymentRepo;
  final DailyExtrasRepository _extrasRepo;

  CalendarioViewModel(
    this._dailyLogRepo,
    this._snackRepo,
    this._paymentRepo,
    this._extrasRepo,
  );

  // Streams de datos crudos (alimentados desde la UI).
  final List<DailyLog> logs = [];
  final List<SnackEntry> snacks = [];
  final List<Payment> payments = [];
  bool loading = true;

  late DateTime _viewedMonth;
  DateTime get viewedMonth => _viewedMonth;

  Future<void> init() async {
    final now = DateTime.now();
    _viewedMonth = DateTime(now.year, now.month, 1);
    loading = false;
    notifyListeners();
  }

  /// Adjunta los streams reactivos del DB. Llamar desde la UI justo
  /// después de `init()`.
  void attachStreams(BuildContext context) {
    final db = context.read<AppDatabase>();
    db.select(db.dailyLogs).watch().listen((value) {
      setData(logs: value, snacks: snacks, payments: payments);
    });
    db.select(db.snackEntries).watch().listen((value) {
      setData(logs: logs, snacks: value, payments: payments);
    });
    db.select(db.payments).watch().listen((value) {
      setData(logs: logs, snacks: snacks, payments: value);
    });
  }

  /// Sincroniza los datos crudos con el VM. Llamar desde la UI cuando
  /// los streams emiten.
  void setData({
    required List<DailyLog> logs,
    required List<SnackEntry> snacks,
    required List<Payment> payments,
  }) {
    this.logs
      ..clear()
      ..addAll(logs);
    this.snacks
      ..clear()
      ..addAll(snacks);
    this.payments
      ..clear()
      ..addAll(payments);
    notifyListeners();
  }

  /// Cambia el mes visualizado.
  void changeMonth(int delta) {
    _viewedMonth = DateTime(_viewedMonth.year, _viewedMonth.month + delta, 1);
    notifyListeners();
  }

  /// Va al mes actual.
  void goToCurrentMonth() {
    final now = DateTime.now();
    _viewedMonth = DateTime(now.year, now.month, 1);
    notifyListeners();
  }

  /// Etiqueta humana del mes visualizado.
  String get monthLabel {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];
    return '${months[_viewedMonth.month - 1]} ${_viewedMonth.year}';
  }

  /// Set de fechas (yyyy-MM-dd) del mes visualizado que tienen registros.
  Set<String> get datesWithActivity {
    final first = _viewedMonth;
    final last = DateTime(_viewedMonth.year, _viewedMonth.month + 1, 0);
    final dates = <String>{};
    for (final l in logs) {
      try {
        final d = DateHelper.parse(l.date);
        if (!d.isBefore(first) && !d.isAfter(last)) {
          dates.add(l.date);
        }
      } catch (_) {}
    }
    for (final s in snacks) {
      try {
        final d = DateHelper.parse(s.date);
        if (!d.isBefore(first) && !d.isAfter(last)) {
          dates.add(s.date);
        }
      } catch (_) {}
    }
    for (final p in payments) {
      try {
        final d = DateHelper.parse(p.date);
        if (!d.isBefore(first) && !d.isAfter(last)) {
          dates.add(p.date);
        }
      } catch (_) {}
    }
    return dates;
  }

  /// Total de días con actividad en el mes.
  int get monthDaysActive => datesWithActivity.length;

  /// Detalle completo de un día: log + snacks + pagos + extras.
  Future<DayDetail> getDayDetail(String date) async {
    DailyLog? log;
    for (final l in logs) {
      if (l.date == date) {
        log = l;
        break;
      }
    }
    final daySnacks = snacks.where((s) => s.date == date).toList();
    final dayPayments = payments.where((p) => p.date == date).toList();
    final extras = await _extrasRepo.getOrCreate(date);
    return DayDetail(
      date: date,
      log: log,
      snacks: daySnacks,
      payments: dayPayments,
      extras: extras,
    );
  }

  // ════════════════════════════════════════════════════════════
  // ACCIONES DE EDICIÓN
  // ════════════════════════════════════════════════════════════

  Future<void> toggleLunch(String date, bool value) async {
    await _dailyLogRepo.setLunchForDate(date, value);
    notifyListeners();
  }

  Future<void> toggleDinner(String date, bool value) async {
    await _dailyLogRepo.setDinnerForDate(date, value);
    notifyListeners();
  }

  Future<void> saveBreakfast(
    String date, {
    required bool had,
    required double price,
    String? description,
  }) async {
    await _dailyLogRepo.saveBreakfastForDate(
      date,
      had: had,
      price: price,
      description: description,
    );
    notifyListeners();
  }

  Future<void> addSnack(
    String date, {
    required double price,
    String? description,
    String? categoryName,
  }) async {
    await _snackRepo.add(
      date: date,
      price: price,
      description: description,
      categoryName: categoryName,
    );
    notifyListeners();
  }

  Future<void> updateSnack(
    int id, {
    required double price,
    String? description,
    String? categoryName,
  }) async {
    await _snackRepo.update(
      id: id,
      price: price,
      description: description,
      categoryName: categoryName,
    );
    notifyListeners();
  }

  Future<void> deleteSnack(int id) async {
    await _snackRepo.delete(id);
    notifyListeners();
  }

  Future<void> addPayment(
    String date, {
    required double amount,
    String? note,
    String? methodName,
  }) async {
    await _paymentRepo.add(
      date: date,
      amount: amount,
      note: note,
      methodName: methodName,
    );
    notifyListeners();
  }

  Future<void> updatePayment(
    int id, {
    required double amount,
    String? note,
    String? methodName,
  }) async {
    await _paymentRepo.update(
      id: id,
      amount: amount,
      note: note,
      methodName: methodName,
    );
    notifyListeners();
  }

  Future<void> deletePayment(int id) async {
    await _paymentRepo.delete(id);
    notifyListeners();
  }

  Future<void> saveExtras(
    String date, {
    String? notes,
    int? rating,
    double extraExpenses = 0,
  }) async {
    await _extrasRepo.upsert(DailyExtras(
      date: date,
      notes: notes,
      rating: rating,
      extraExpenses: extraExpenses,
    ));
    notifyListeners();
  }
}

/// Detalle completo de un día para el calendario.
class DayDetail {
  final String date;
  final DailyLog? log;
  final List<SnackEntry> snacks;
  final List<Payment> payments;
  final DailyExtras extras;

  const DayDetail({
    required this.date,
    required this.log,
    required this.snacks,
    required this.payments,
    required this.extras,
  });

  double get totalConsumed {
    double t = 0;
    if (log != null) {
      if (log!.hadBreakfast) t += log!.breakfastPrice;
      // Precio de almuerzo/cena viene de Settings; la UI los conoce.
      // Aquí solo sumamos lo explícito.
    }
    for (final s in snacks) {
      t += s.price;
    }
    t += extras.extraExpenses;
    return t;
  }

  double get totalPaid =>
      payments.fold<double>(0, (sum, p) => sum + p.amount);

  double get balance => totalConsumed - totalPaid;
}

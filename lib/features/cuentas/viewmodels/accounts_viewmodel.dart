import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_helper.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';

/// ViewModel de la pantalla Cuentas (100% reactivo).
/// Escucha los streams de la BD y recalcula todo en memoria.
class AccountsViewModel extends ChangeNotifier {
  final DailyLogRepository _dailyLogRepo;
  final SnackRepository _snackRepo;
  final PaymentRepository _paymentRepo;
  final SettingsRepository _settingsRepo;

  StreamSubscription<List<DailyLog>>? _logsSub;
  StreamSubscription<List<SnackEntry>>? _snacksSub;
  StreamSubscription<List<Payment>>? _paymentsSub;

  List<DailyLog> _logs = [];
  List<SnackEntry> _snacks = [];
  List<Payment> _payments = [];

  double lunchPrice = AppConstants.defaultLunchPrice;
  double dinnerPrice = AppConstants.defaultDinnerPrice;
  double monthlyBudget = AppConstants.defaultMonthlyBudget;
  bool loading = true;

  AccountsViewModel(
    this._dailyLogRepo,
    this._snackRepo,
    this._paymentRepo,
    this._settingsRepo,
  );

  // ════════════════════════════════════════════════════════════
  // HISTÓRICO
  // ════════════════════════════════════════════════════════════

  int get totalLunches => _logs.where((l) => l.hadLunch).length;
  int get totalDinners => _logs.where((l) => l.hadDinner).length;
  int get totalBreakfasts => _logs.where((l) => l.hadBreakfast).length;

  double get breakfastTotal =>
      _logs.fold(0, (sum, l) => sum + l.breakfastPrice);
  double get snacksTotal => _snacks.fold(0, (sum, s) => sum + s.price);
  double get paymentsTotal => _payments.fold(0, (sum, p) => sum + p.amount);
  List<Payment> get payments => _payments;

  double get consumedTotal =>
      totalLunches * lunchPrice +
      totalDinners * dinnerPrice +
      breakfastTotal +
      snacksTotal;

  /// Lo que le debes a la pensión (negativo = a favor).
  double get debt => consumedTotal - paymentsTotal;

  // ════════════════════════════════════════════════════════════
  // MES ACTUAL
  // ════════════════════════════════════════════════════════════

  String get _monthStart {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-01';
  }

  String get _monthEnd {
    final now = DateTime.now();
    final last = DateTime(now.year, now.month + 1, 0);
    return DateHelper.format(last);
  }

  int get monthLunches => _logs
      .where((l) => l.hadLunch && l.date.compareTo(_monthStart) >= 0)
      .length;
  int get monthDinners => _logs
      .where((l) => l.hadDinner && l.date.compareTo(_monthStart) >= 0)
      .length;
  int get monthBreakfasts => _logs
      .where((l) => l.date.compareTo(_monthStart) >= 0)
      .where((l) => l.hadBreakfast)
      .length;

  double get monthBreakfastTotal => _logs
      .where((l) => l.date.compareTo(_monthStart) >= 0)
      .fold(0, (sum, l) => sum + l.breakfastPrice);
  double get monthSnacksTotal => _snacks
      .where((s) => s.date.compareTo(_monthStart) >= 0)
      .fold(0, (sum, s) => sum + s.price);

  double get monthConsumed =>
      monthLunches * lunchPrice +
      monthDinners * dinnerPrice +
      monthBreakfastTotal +
      monthSnacksTotal;

  double get monthPaymentsTotal {
    var total = 0.0;
    for (final p in _payments) {
      if (p.date.compareTo(_monthStart) >= 0 &&
          p.date.compareTo(_monthEnd) <= 0) {
        total += p.amount;
      }
    }
    return total;
  }

  /// Proyección de fin de mes según el promedio diario actual.
  double get monthProjection {
    final today = DateTime.now();
    final daysInMonth = DateTime(today.year, today.month + 1, 0).day;
    if (today.day == 0) return 0;
    final avg = monthConsumed / today.day;
    return avg * daysInMonth;
  }

  /// % del presupuesto consumido este mes (0..1+, puede exceder 1).
  double get monthBudgetUsage {
    if (monthlyBudget <= 0) return 0;
    return monthConsumed / monthlyBudget;
  }

  /// Diferencia restante del presupuesto (positivo = a favor).
  double get monthBudgetRemaining => monthlyBudget - monthConsumed;

  /// Map con gasto diario de los últimos 7 días (date -> total).
  Map<String, double> get last7DaysBreakdown {
    final result = <String, double>{};
    final today = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final d = today.subtract(Duration(days: i));
      result[DateHelper.format(d)] = 0;
    }
    for (final l in _logs) {
      if (result.containsKey(l.date)) {
        double total = 0;
        if (l.hadBreakfast) total += l.breakfastPrice;
        if (l.hadLunch) total += lunchPrice;
        if (l.hadDinner) total += dinnerPrice;
        result[l.date] = (result[l.date] ?? 0) + total;
      }
    }
    for (final s in _snacks) {
      if (result.containsKey(s.date)) {
        result[s.date] = (result[s.date] ?? 0) + s.price;
      }
    }
    return result;
  }

  // ════════════════════════════════════════════════════════════
  // CICLO DE VIDA
  // ════════════════════════════════════════════════════════════

  Future<void> init() async {
    lunchPrice = await _settingsRepo.getLunchPrice();
    dinnerPrice = await _settingsRepo.getDinnerPrice();
    monthlyBudget = await _settingsRepo.getMonthlyBudget();

    _logsSub = _dailyLogRepo.watchAll().listen((logs) {
      _logs = logs;
      notifyListeners();
    });
    _snacksSub = _snackRepo.watchAllOrdered().listen((snacks) {
      _snacks = snacks;
      notifyListeners();
    });
    _paymentsSub = _paymentRepo.watchAll().listen((payments) {
      _payments = payments;
      notifyListeners();
    });

    loading = false;
    notifyListeners();
  }

  // ════════════════════════════════════════════════════════════
  // ACCIONES
  // ════════════════════════════════════════════════════════════

  Future<void> addPayment({
    required double amount,
    String? note,
    String? methodName,
  }) => _paymentRepo.add(amount: amount, note: note, methodName: methodName);

  Future<void> updatePayment({
    required int id,
    required double amount,
    String? note,
    String? methodName,
  }) =>
      _paymentRepo.update(
        id: id,
        amount: amount,
        note: note,
        methodName: methodName,
      );

  Future<void> deletePayment(int id) => _paymentRepo.delete(id);

  @override
  void dispose() {
    _logsSub?.cancel();
    _snacksSub?.cancel();
    _paymentsSub?.cancel();
    super.dispose();
  }
}

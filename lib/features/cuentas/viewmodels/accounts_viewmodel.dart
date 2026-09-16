import 'dart:async';

import 'package:flutter/foundation.dart';

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

  double lunchPrice = 9.00;
  double dinnerPrice = 9.00;
  bool loading = true;

  AccountsViewModel(
    this._dailyLogRepo,
    this._snackRepo,
    this._paymentRepo,
    this._settingsRepo,
  );

  // ═══════════ HISTÓRICO ═══════════

  int get totalLunches => _logs.where((l) => l.hadLunch).length;
  int get totalDinners => _logs.where((l) => l.hadDinner).length;
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

  /// Lo que le debes a la pensión (negativo = al día / a favor).
  double get debt => consumedTotal - paymentsTotal;

  // ═══════════ MES ACTUAL ═══════════

  String get _monthStart {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-01';
  }

  int get monthLunches => _logs
      .where((l) => l.hadLunch && l.date.compareTo(_monthStart) >= 0)
      .length;
  int get monthDinners => _logs
      .where((l) => l.hadDinner && l.date.compareTo(_monthStart) >= 0)
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

  // ═══════════ CICLO DE VIDA ═══════════

  Future<void> init() async {
    lunchPrice = await _settingsRepo.getLunchPrice();
    dinnerPrice = await _settingsRepo.getDinnerPrice();

    // Cada stream recalcula automáticamente ante cualquier cambio.
    _logsSub = _dailyLogRepo.watchAll().listen((logs) {
      _logs = logs;
      notifyListeners();
    });
    _snacksSub = _snackRepo.watchAll().listen((snacks) {
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

  Future<void> addPayment({required double amount, String? note}) =>
      _paymentRepo.add(amount: amount, note: note);

  Future<void> deletePayment(int id) => _paymentRepo.delete(id);

  @override
  void dispose() {
    _logsSub?.cancel();
    _snacksSub?.cancel();
    _paymentsSub?.cancel();
    super.dispose();
  }
}

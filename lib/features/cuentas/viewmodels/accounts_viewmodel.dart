import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';

/// ViewModel de la pantalla Cuentas.
/// Calcula: consumido (almuerzos/cenas × precio base + desayunos +
/// bocadillos) vs. pagado → deuda con la pensión.
class AccountsViewModel extends ChangeNotifier {
  final DailyLogRepository _dailyLogRepo;
  final SnackRepository _snackRepo;
  final PaymentRepository _paymentRepo;
  final SettingsRepository _settingsRepo;

  StreamSubscription<List<Payment>>? _paymentsSub;

  AccountsViewModel(
    this._dailyLogRepo,
    this._snackRepo,
    this._paymentRepo,
    this._settingsRepo,
  );

  // ── Estado ──
  bool loading = true;

  // Totales históricos (todo el tiempo)
  int totalLunches = 0;
  int totalDinners = 0;
  double breakfastTotal = 0;
  double snacksTotal = 0;
  double paymentsTotal = 0;
  List<Payment> payments = [];

  // Totales del mes actual
  int monthLunches = 0;
  int monthDinners = 0;
  double monthBreakfastTotal = 0;
  double monthSnacksTotal = 0;

  double lunchPrice = 9.00;
  double dinnerPrice = 9.00;

  // ── Cálculos ──
  double get consumedTotal =>
      totalLunches * lunchPrice +
      totalDinners * dinnerPrice +
      breakfastTotal +
      snacksTotal;

  double get monthConsumed =>
      monthLunches * lunchPrice +
      monthDinners * dinnerPrice +
      monthBreakfastTotal +
      monthSnacksTotal;

  /// Lo que le debes a la pensión (negativo = te sobra/crédito).
  double get debt => consumedTotal - paymentsTotal;

  String get _monthStart {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-01';
  }

  Future<void> init() async {
    lunchPrice = await _settingsRepo.getLunchPrice();
    dinnerPrice = await _settingsRepo.getDinnerPrice();
    await refresh();

    // Los pagos se actualizan en vivo (stream de drift).
    _paymentsSub = _paymentRepo.watchAll().listen((list) async {
      payments = list;
      paymentsTotal = await _paymentRepo.total();
      notifyListeners();
    });

    loading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    // Histórico
    final (lunches, dinners) = await _dailyLogRepo.countLunchesAndDinners();
    totalLunches = lunches;
    totalDinners = dinners;
    breakfastTotal = await _snackRepo.breakfastTotalBetween();
    snacksTotal = await _snackRepo.totalBetween();
    paymentsTotal = await _paymentRepo.total();

    // Mes actual
    final from = _monthStart;
    final (mLunches, mDinners) = await _dailyLogRepo.countLunchesAndDinners(
      fromDate: from,
    );
    monthLunches = mLunches;
    monthDinners = mDinners;
    monthBreakfastTotal = await _snackRepo.breakfastTotalBetween(
      fromDate: from,
    );
    monthSnacksTotal = await _snackRepo.totalBetween(fromDate: from);

    notifyListeners();
  }

  Future<void> addPayment({required double amount, String? note}) async {
    await _paymentRepo.add(amount: amount, note: note);
    await refresh();
  }

  Future<void> deletePayment(int id) async {
    await _paymentRepo.delete(id);
    await refresh();
  }

  @override
  void dispose() {
    _paymentsSub?.cancel();
    super.dispose();
  }
}

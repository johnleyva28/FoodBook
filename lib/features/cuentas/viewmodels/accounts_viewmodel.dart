import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_helper.dart';
import '../../../data/app_data_streams.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/settings_repository.dart';

/// ViewModel de la pantalla Cuentas (100% reactivo).
///
/// Escucha el bus global `AppDataStreams` para que cualquier
/// edición hecha desde Calendario o la pantalla Hoy se refleje
/// instantáneamente sin recargar.
class AccountsViewModel extends ChangeNotifier {
  final AppDataStreams _streams;
  final PaymentRepository _paymentRepo;
  final SettingsRepository _settingsRepo;

  AccountsViewModel(this._streams, this._paymentRepo, this._settingsRepo);

  double lunchPrice = AppConstants.defaultLunchPrice;
  double dinnerPrice = AppConstants.defaultDinnerPrice;
  double monthlyBudget = AppConstants.defaultMonthlyBudget;
  bool loading = true;

  // ── Streams reactivos (cacheados en AppDataStreams) ──
  List<DailyLog> get logs => _streams.logs;
  List<SnackEntry> get snacks => _streams.snacks;
  List<Payment> get payments => _streams.payments;

  // ════════════════════════════════════════════════════════════
  // HISTÓRICO
  // ════════════════════════════════════════════════════════════

  int get totalLunches => logs.where((l) => l.hadLunch).length;
  int get totalDinners => logs.where((l) => l.hadDinner).length;
  int get totalBreakfasts => logs.where((l) => l.hadBreakfast).length;

  double get breakfastTotal =>
      logs.fold(0, (sum, l) => sum + l.breakfastPrice);
  double get snacksTotal => snacks.fold(0, (sum, s) => sum + s.price);
  double get paymentsTotal =>
      payments.fold(0, (sum, p) => sum + p.amount);

  double get consumedTotal =>
      totalLunches * lunchPrice +
      totalDinners * dinnerPrice +
      breakfastTotal +
      snacksTotal;

  double get debt => consumedTotal - paymentsTotal;

  // ════════════════════════════════════════════════════════════
  // MES ACTUAL
  // ════════════════════════════════════════════════════════════

  String get _monthStart {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${now.year}-${two(now.month)}-01';
  }

  String get _monthEnd => DateHelper.format(
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
      );

  int get monthLunches => logs
      .where((l) => l.hadLunch && l.date.compareTo(_monthStart) >= 0)
      .length;
  int get monthDinners => logs
      .where((l) => l.hadDinner && l.date.compareTo(_monthStart) >= 0)
      .length;
  int get monthBreakfasts => logs
      .where((l) => l.date.compareTo(_monthStart) >= 0)
      .where((l) => l.hadBreakfast)
      .length;

  double get monthBreakfastTotal => logs
      .where((l) => l.date.compareTo(_monthStart) >= 0)
      .fold(0, (sum, l) => sum + l.breakfastPrice);
  double get monthSnacksTotal => snacks
      .where((s) => s.date.compareTo(_monthStart) >= 0)
      .fold(0, (sum, s) => sum + s.price);

  double get monthConsumed =>
      monthLunches * lunchPrice +
      monthDinners * dinnerPrice +
      monthBreakfastTotal +
      monthSnacksTotal;

  double get monthPaymentsTotal {
    var total = 0.0;
    for (final p in payments) {
      if (p.date.compareTo(_monthStart) >= 0 &&
          p.date.compareTo(_monthEnd) <= 0) {
        total += p.amount;
      }
    }
    return total;
  }

  double get monthProjection {
    final today = DateTime.now();
    final daysInMonth = DateTime(today.year, today.month + 1, 0).day;
    if (today.day == 0) return 0;
    final avg = monthConsumed / today.day;
    return avg * daysInMonth;
  }

  double get monthBudgetUsage {
    if (monthlyBudget <= 0) return 0;
    return monthConsumed / monthlyBudget;
  }

  double get monthBudgetRemaining => monthlyBudget - monthConsumed;

  Map<String, double> get last7DaysBreakdown {
    final result = <String, double>{};
    final today = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final d = today.subtract(Duration(days: i));
      result[DateHelper.format(d)] = 0;
    }
    for (final l in logs) {
      if (result.containsKey(l.date)) {
        double total = 0;
        if (l.hadBreakfast) total += l.breakfastPrice;
        if (l.hadLunch) total += lunchPrice;
        if (l.hadDinner) total += dinnerPrice;
        result[l.date] = (result[l.date] ?? 0) + total;
      }
    }
    for (final s in snacks) {
      if (result.containsKey(s.date)) {
        result[s.date] = (result[s.date] ?? 0) + s.price;
      }
    }
    return result;
  }

  Future<void> init() async {
    lunchPrice = await _settingsRepo.getLunchPrice();
    dinnerPrice = await _settingsRepo.getDinnerPrice();
    monthlyBudget = await _settingsRepo.getMonthlyBudget();
    _streams.addListener(_onChange);
    loading = false;
    notifyListeners();
  }

  void _onChange() {
    if (!loading) notifyListeners();
  }

  @override
  void dispose() {
    _streams.removeListener(_onChange);
    super.dispose();
  }

  // ════════════════════════════════════════════════════════════
  // ACCIONES
  // ════════════════════════════════════════════════════════════

  Future<void> addPayment({
    required double amount,
    String? note,
    String? methodName,
    String? date,
  }) => _paymentRepo.add(
        date: date,
        amount: amount,
        note: note,
        methodName: methodName,
      );

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
}

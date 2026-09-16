import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/utils/date_helper.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/daily_extras_repository.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/snack_repository.dart';

/// ViewModel de la pantalla Historial.
///
/// Permite navegar por meses y ver el detalle de cada día:
/// comidas, snacks, extras, pagos.
class HistoryViewModel extends ChangeNotifier {
  final DailyLogRepository _dailyLogRepo;
  final SnackRepository _snackRepo;
  final PaymentRepository _paymentRepo;
  final DailyExtrasRepository _extrasRepo;

  StreamSubscription<List<DailyLog>>? _logsSub;
  StreamSubscription<List<SnackEntry>>? _snacksSub;
  StreamSubscription<List<Payment>>? _paymentsSub;

  HistoryViewModel(
    this._dailyLogRepo,
    this._snackRepo,
    this._paymentRepo,
    this._extrasRepo,
  );

  // ── Estado ──
  List<DailyLog> logs = [];
  List<SnackEntry> snacks = [];
  List<Payment> payments = [];
  bool loading = true;

  // Mes actualmente visualizado.
  late DateTime _viewedMonth;
  DateTime get viewedMonth => _viewedMonth;

  // ── Init ──

  Future<void> init() async {
    final now = DateTime.now();
    _viewedMonth = DateTime(now.year, now.month, 1);

    _logsSub = _dailyLogRepo.watchAll().listen((value) {
      logs = value;
      notifyListeners();
    });
    _snacksSub = _snackRepo.watchAllOrdered().listen((value) {
      snacks = value;
      notifyListeners();
    });
    _paymentsSub = _paymentRepo.watchAll().listen((value) {
      payments = value;
      notifyListeners();
    });

    loading = false;
    notifyListeners();
  }

  void changeMonth(int delta) {
    _viewedMonth = DateTime(_viewedMonth.year, _viewedMonth.month + delta, 1);
    notifyListeners();
  }

  // ── Datos derivados ──

  String get monthLabel {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];
    return '${months[_viewedMonth.month - 1]} ${_viewedMonth.year}';
  }

  /// Lista de fechas del mes visualizado que tienen algún registro.
  List<String> get datesWithActivity {
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
    final list = dates.toList()..sort((a, b) => b.compareTo(a));
    return list;
  }

  /// Detalle de un día específico.
  Future<HistoryDayDetail> getDay(String date) async {
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
    return HistoryDayDetail(
      date: date,
      log: log,
      snacks: daySnacks,
      payments: dayPayments,
      extras: extras,
    );
  }

  /// Resumen del mes actual: total consumido, snacks y pagos.
  double get monthTotal {
    final first = DateHelper.format(_viewedMonth);
    final last = DateHelper.format(
      DateTime(_viewedMonth.year, _viewedMonth.month + 1, 0),
    );
    return logs
        .where((l) => l.date.compareTo(first) >= 0 && l.date.compareTo(last) <= 0)
        .fold<double>(0, (sum, l) {
      double t = 0;
      if (l.hadBreakfast) t += l.breakfastPrice;
      return t;
    });
  }

  int get monthDaysActive {
    return datesWithActivity.length;
  }

  /// Lista de snacks del mes visualizado.
  List<SnackEntry> get monthSnacks {
    final first = DateHelper.format(_viewedMonth);
    final last = DateHelper.format(
      DateTime(_viewedMonth.year, _viewedMonth.month + 1, 0),
    );
    return snacks
        .where((s) =>
            s.date.compareTo(first) >= 0 && s.date.compareTo(last) <= 0)
        .toList();
  }

  /// Lista de pagos del mes visualizado.
  List<Payment> get monthPayments {
    final first = DateHelper.format(_viewedMonth);
    final last = DateHelper.format(
      DateTime(_viewedMonth.year, _viewedMonth.month + 1, 0),
    );
    return payments
        .where((p) =>
            p.date.compareTo(first) >= 0 && p.date.compareTo(last) <= 0)
        .toList();
  }

  /// Suma de snacks del mes.
  double get monthSnacksTotal =>
      monthSnacks.fold<double>(0, (s, e) => s + e.price);

  /// Suma de pagos del mes.
  double get monthPaymentsTotal =>
      monthPayments.fold<double>(0, (s, p) => s + p.amount);

  @override
  void dispose() {
    _logsSub?.cancel();
    _snacksSub?.cancel();
    _paymentsSub?.cancel();
    super.dispose();
  }
}

/// Detalle completo de un día para la vista de historial.
class HistoryDayDetail {
  final String date;
  final DailyLog? log;
  final List<SnackEntry> snacks;
  final List<Payment> payments;
  final dynamic extras;

  const HistoryDayDetail({
    required this.date,
    required this.log,
    required this.snacks,
    required this.payments,
    required this.extras,
  });
}

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';

/// ViewModel de la pantalla Principal.
/// Expone el registro del día, los bocadillos y los precios base.
class DailyViewModel extends ChangeNotifier {
  final DailyLogRepository _dailyLogRepo;
  final SnackRepository _snackRepo;
  final SettingsRepository _settingsRepo;

  StreamSubscription<DailyLog?>? _logSub;
  StreamSubscription<List<SnackEntry>>? _snacksSub;

  DailyViewModel(this._dailyLogRepo, this._snackRepo, this._settingsRepo);

  // ── Estado ──
  DailyLog? log;
  List<SnackEntry> snacks = [];
  double lunchPrice = 9.00;
  double dinnerPrice = 9.00;
  bool loading = true;

  // ── Totales calculados del día ──
  double get dayTotal {
    if (log == null) return 0;
    double total = 0;
    if (log!.hadBreakfast) total += log!.breakfastPrice;
    if (log!.hadLunch) total += lunchPrice;
    if (log!.hadDinner) total += dinnerPrice;
    for (final s in snacks) {
      total += s.price;
    }
    return total;
  }

  /// Inicializa: carga precios y se suscribe a los streams de la BD.
  Future<void> init() async {
    lunchPrice = await _settingsRepo.getLunchPrice();
    dinnerPrice = await _settingsRepo.getDinnerPrice();

    // Nos aseguramos de que exista el registro de hoy.
    log = await _dailyLogRepo.getOrCreateToday();

    _logSub = _dailyLogRepo.watchToday().listen((value) {
      log = value;
      notifyListeners();
    });

    _snacksSub = _snackRepo.watchByDate(_todayDate).listen((value) {
      snacks = value;
      notifyListeners();
    });

    loading = false;
    notifyListeners();
  }

  String get _todayDate {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  // ── Acciones ──

  Future<void> toggleLunch(bool value) async {
    await _dailyLogRepo.toggleLunch(value);
    notifyListeners();
  }

  Future<void> toggleDinner(bool value) async {
    await _dailyLogRepo.toggleDinner(value);
    notifyListeners();
  }

  Future<void> saveBreakfast({
    required bool had,
    required double price,
    String? description,
  }) async {
    await _dailyLogRepo.saveBreakfast(
      had: had,
      price: price,
      description: description,
    );
    notifyListeners();
  }

  Future<void> addSnack({required double price, String? description}) async {
    await _snackRepo.add(price: price, description: description);
    notifyListeners();
  }

  Future<void> deleteSnack(int id) async {
    await _snackRepo.delete(id);
    notifyListeners();
  }

  @override
  void dispose() {
    _logSub?.cancel();
    _snacksSub?.cancel();
    super.dispose();
  }
}

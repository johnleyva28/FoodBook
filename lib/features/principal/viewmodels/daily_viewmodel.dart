import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/database/app_database.dart';
import '../../../data/models/category.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';

/// ViewModel de la pantalla Principal.
/// Expone el registro del día, los bocadillos, los precios base y el
/// catálogo de categorías (para el selector de bocadillos).
class DailyViewModel extends ChangeNotifier {
  final DailyLogRepository _dailyLogRepo;
  final SnackRepository _snackRepo;
  final SettingsRepository _settingsRepo;
  final CatalogRepository _catalogRepo;

  StreamSubscription<DailyLog?>? _logSub;
  StreamSubscription<List<SnackEntry>>? _snacksSub;

  DailyViewModel(
    this._dailyLogRepo,
    this._snackRepo,
    this._settingsRepo,
    this._catalogRepo,
  );

  // ── Estado ──
  DailyLog? log;
  List<SnackEntry> snacks = [];
  List<Category> categories = [];
  double lunchPrice = 9.00;
  double dinnerPrice = 9.00;
  bool loading = true;

  List<String> get categoryNames =>
      categories.map((c) => c.name).toList(growable: false);

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

  Future<void> init() async {
    lunchPrice = await _settingsRepo.getLunchPrice();
    dinnerPrice = await _settingsRepo.getDinnerPrice();
    categories = await _catalogRepo.getAllCategories();

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

  Future<void> addSnack({
    required double price,
    String? description,
    String? categoryName,
  }) async {
    await _snackRepo.add(
      price: price,
      description: description,
      categoryName: categoryName,
    );
    notifyListeners();
  }

  Future<void> updateSnack({
    required int id,
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

  @override
  void dispose() {
    _logSub?.cancel();
    _snacksSub?.cancel();
    super.dispose();
  }
}

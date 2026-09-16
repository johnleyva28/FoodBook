import 'dart:async';

import 'package:flutter/foundation.dart' hide Category;

import '../../../core/utils/date_helper.dart';
import '../../../data/app_data_streams.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';

/// ViewModel de la pantalla Principal.
///
/// Lee del `AppDataStreams` global para reactividad instantánea.
/// Cualquier snack/pago/log editado desde Calendario o Cuentas
/// se refleja al instante aquí.
class DailyViewModel extends ChangeNotifier {
  final AppDataStreams _streams;
  final DailyLogRepository _dailyLogRepo;
  final SnackRepository _snackRepo;
  final SettingsRepository _settingsRepo;

  DailyViewModel(
    this._streams,
    this._dailyLogRepo,
    this._snackRepo,
    this._settingsRepo,
  );

  bool loading = true;
  double lunchPrice = 9.00;
  double dinnerPrice = 9.00;

  List<String> get categoryNames =>
      _streams.categories.map((c) => c.name).toList(growable: false);

  /// Log del día actual. Se actualiza reactivamente.
  DailyLog? get log {
    final today = DateHelper.today();
    for (final l in _streams.logs) {
      if (l.date == today) return l;
    }
    return null;
  }

  /// Snacks de hoy (reactividad automática desde el bus).
  List<SnackEntry> get todaySnacks {
    final today = DateHelper.today();
    return _streams.snacks.where((s) => s.date == today).toList();
  }

  /// Lista de snacks (acceso directo al bus para la UI).
  List<SnackEntry> get snacks => todaySnacks;

  double get dayTotal {
    final l = log;
    if (l == null) return 0;
    double total = 0;
    if (l.hadBreakfast) total += l.breakfastPrice;
    if (l.hadLunch) total += lunchPrice;
    if (l.hadDinner) total += dinnerPrice;
    for (final s in todaySnacks) {
      total += s.price;
    }
    return total;
  }

  Future<void> init() async {
    lunchPrice = await _settingsRepo.getLunchPrice();
    dinnerPrice = await _settingsRepo.getDinnerPrice();

    // Escuchar streams globales para que dayTotal/todaySnacks se recalculen.
    _streams.addListener(_onStreamsChanged);

    loading = false;
    notifyListeners();
  }

  void _onStreamsChanged() {
    if (!loading) notifyListeners();
  }

  @override
  void dispose() {
    _streams.removeListener(_onStreamsChanged);
    super.dispose();
  }

  // ── Acciones ──

  Future<void> toggleLunch(bool value) async {
    // Asegurar registro del día
    await _dailyLogRepo.getOrCreateToday();
    await _dailyLogRepo.toggleLunch(value);
  }

  Future<void> toggleDinner(bool value) async {
    await _dailyLogRepo.getOrCreateToday();
    await _dailyLogRepo.toggleDinner(value);
  }

  Future<void> saveBreakfast({
    required bool had,
    required double price,
    String? description,
  }) async {
    await _dailyLogRepo.getOrCreateToday();
    await _dailyLogRepo.saveBreakfast(
      had: had,
      price: price,
      description: description,
    );
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
  }

  Future<void> deleteSnack(int id) async {
    await _snackRepo.delete(id);
  }
}

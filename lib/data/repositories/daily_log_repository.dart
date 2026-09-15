import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../../core/utils/date_helper.dart';

class DailyLogRepository {
  final AppDatabase _db;
  DailyLogRepository(this._db);

  /// Obtiene (o crea) el registro de hoy.
  Future<DailyLog> getOrCreateToday() => getOrCreateForDate(DateHelper.today());

  /// Obtiene (o crea) el registro de una fecha específica.
  Future<DailyLog> getOrCreateForDate(String date) async {
    final query = _db.select(_db.dailyLogs)..where((t) => t.date.equals(date));
    final existing = await query.getSingleOrNull();
    if (existing != null) return existing;

    await _db
        .into(_db.dailyLogs)
        .insert(
          DailyLogsCompanion.insert(date: date),
          mode: InsertMode.insertOrIgnore,
        );
    return (query..where((t) => t.date.equals(date))).getSingle();
  }

  /// Stream del registro de hoy (null si aún no existe).
  /// El ViewModel decidirá mostrar valores por defecto.
  Stream<DailyLog?> watchToday() {
    final date = DateHelper.today();
    final query = _db.select(_db.dailyLogs)..where((t) => t.date.equals(date));
    return query.watchSingleOrNull();
  }

  /// Marca/desmarca almuerzo.
  Future<void> toggleLunch(bool value) async {
    await getOrCreateToday();
    await (_db.update(_db.dailyLogs)
          ..where((t) => t.date.equals(DateHelper.today())))
        .write(DailyLogsCompanion(hadLunch: Value(value)));
  }

  /// Marca/desmarca cena.
  Future<void> toggleDinner(bool value) async {
    await getOrCreateToday();
    await (_db.update(_db.dailyLogs)
          ..where((t) => t.date.equals(DateHelper.today())))
        .write(DailyLogsCompanion(hadDinner: Value(value)));
  }

  /// Guarda el desayuno (consumido + precio + descripción).
  Future<void> saveBreakfast({
    required bool had,
    required double price,
    String? description,
  }) async {
    await getOrCreateToday();
    await (_db.update(
      _db.dailyLogs,
    )..where((t) => t.date.equals(DateHelper.today()))).write(
      DailyLogsCompanion(
        hadBreakfast: Value(had),
        breakfastPrice: Value(had ? price : 0.0),
        breakfastDesc: Value(description),
      ),
    );
  }

  /// Total de almuerzos y cenas en un rango (para Cuentas).
  Future<(int lunches, int dinners)> countLunchesAndDinners({
    String? fromDate,
    String? toDate,
  }) async {
    final query = _db.selectOnly(_db.dailyLogs)
      ..addColumns([_db.dailyLogs.hadLunch, _db.dailyLogs.hadDinner]);
    if (fromDate != null) {
      query.where(_db.dailyLogs.date.isBiggerOrEqualValue(fromDate));
    }
    if (toDate != null) {
      query.where(_db.dailyLogs.date.isSmallerOrEqualValue(toDate));
    }

    final rows = await query.get();
    int lunches = 0, dinners = 0;
    for (final row in rows) {
      if (row.read(_db.dailyLogs.hadLunch) ?? false) lunches++;
      if (row.read(_db.dailyLogs.hadDinner) ?? false) dinners++;
    }
    return (lunches, dinners);
  }
}

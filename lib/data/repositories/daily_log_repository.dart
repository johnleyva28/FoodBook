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
  Stream<DailyLog?> watchToday() {
    final date = DateHelper.today();
    final query = _db.select(_db.dailyLogs)..where((t) => t.date.equals(date));
    return query.watchSingleOrNull();
  }

  /// Stream de un día específico.
  Stream<DailyLog?> watchDate(String date) {
    final query = _db.select(_db.dailyLogs)..where((t) => t.date.equals(date));
    return query.watchSingleOrNull();
  }

  /// Stream de registros en un rango de fechas (ordenados desc).
  Stream<List<DailyLog>> watchRange(String from, String to) {
    final query = _db.select(_db.dailyLogs)
      ..where(
        (t) => t.date.isBetween(
          Variable.withString(from),
          Variable.withString(to),
        ),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.watch();
  }

  /// Stream del último mes (incluye hoy).
  Stream<List<DailyLog>> watchLastMonth() {
    final today = DateTime.now();
    final first = DateTime(today.year, today.month, 1);
    final last = DateTime(today.year, today.month + 1, 0);
    return watchRange(DateHelper.format(first), DateHelper.format(last));
  }

  /// Stream de TODOS los registros.
  Stream<List<DailyLog>> watchAll() {
    final query = _db.select(_db.dailyLogs)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.watch();
  }

  Future<void> toggleLunch(bool value) async {
    await getOrCreateToday();
    await (_db.update(_db.dailyLogs)
          ..where((t) => t.date.equals(DateHelper.today())))
        .write(DailyLogsCompanion(hadLunch: Value(value)));
  }

  Future<void> toggleDinner(bool value) async {
    await getOrCreateToday();
    await (_db.update(_db.dailyLogs)
          ..where((t) => t.date.equals(DateHelper.today())))
        .write(DailyLogsCompanion(hadDinner: Value(value)));
  }

  /// Marca/desmarca almuerzo en una fecha arbitraria.
  Future<void> setLunchForDate(String date, bool value) async {
    await getOrCreateForDate(date);
    await (_db.update(_db.dailyLogs)..where((t) => t.date.equals(date)))
        .write(DailyLogsCompanion(hadLunch: Value(value)));
  }

  /// Marca/desmarca cena en una fecha arbitraria.
  Future<void> setDinnerForDate(String date, bool value) async {
    await getOrCreateForDate(date);
    await (_db.update(_db.dailyLogs)..where((t) => t.date.equals(date)))
        .write(DailyLogsCompanion(hadDinner: Value(value)));
  }

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

  /// Guarda el desayuno en una fecha arbitraria.
  Future<void> saveBreakfastForDate(
    String date, {
    required bool had,
    required double price,
    String? description,
  }) async {
    await getOrCreateForDate(date);
    await (_db.update(_db.dailyLogs)..where((t) => t.date.equals(date))).write(
      DailyLogsCompanion(
        hadBreakfast: Value(had),
        breakfastPrice: Value(had ? price : 0.0),
        breakfastDesc: Value(description),
      ),
    );
  }

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

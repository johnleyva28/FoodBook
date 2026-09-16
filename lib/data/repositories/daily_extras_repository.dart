import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/category.dart';

/// Repositorio para los datos opcionales por día (`daily_extras`).
///
/// No es un repositorio con streams porque los extras se actualizan con
/// poca frecuencia (el usuario edita manualmente); un read-modify-write
/// es suficiente y más predecible.
class DailyExtrasRepository {
  final AppDatabase _db;
  DailyExtrasRepository(this._db);

  Future<DailyExtras> getOrCreate(String date) async {
    final row = await _db.customSelect(
      'SELECT * FROM daily_extras WHERE date = ?',
      variables: [Variable.withString(date)],
      readsFrom: const {},
    ).getSingleOrNull();
    if (row != null) return DailyExtras.fromRow(row.data);
    return DailyExtras(date: date);
  }

  Future<void> upsert(DailyExtras extras) async {
    final notesValue = extras.notes ?? '';
    await _db.customStatement(
      'INSERT INTO daily_extras (date, notes, rating, extra_expenses) '
      'VALUES (?, ?, ?, ?) '
      'ON CONFLICT(date) DO UPDATE SET '
      '  notes = excluded.notes, '
      '  rating = excluded.rating, '
      '  extra_expenses = excluded.extra_expenses',
      [
        extras.date,
        notesValue,
        extras.rating,
        extras.extraExpenses,
      ],
    );
  }
}

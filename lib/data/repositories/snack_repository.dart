import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../../core/utils/date_helper.dart';

class SnackRepository {
  final AppDatabase _db;
  SnackRepository(this._db);

  Stream<List<SnackEntry>> watchByDate(String date) {
    final query = _db.select(_db.snackEntries)
      ..where((t) => t.date.equals(date));
    return query.watch();
  }

  Future<void> add({required double price, String? description}) {
    return _db
        .into(_db.snackEntries)
        .insert(
          SnackEntriesCompanion.insert(
            date: DateHelper.today(),
            price: price,
            description: Value(description),
          ),
        );
  }

  Future<void> delete(int id) {
    return (_db.delete(_db.snackEntries)..where((t) => t.id.equals(id))).go();
  }

  /// Suma total de bocadillos (opcionalmente en un rango).
  Future<double> totalBetween({String? fromDate, String? toDate}) async {
    final sumExp = _db.snackEntries.price.sum();
    final query = _db.selectOnly(_db.snackEntries)..addColumns([sumExp]);
    if (fromDate != null) {
      query.where(_db.snackEntries.date.isBiggerOrEqualValue(fromDate));
    }
    if (toDate != null) {
      query.where(_db.snackEntries.date.isSmallerOrEqualValue(toDate));
    }
    final result = await query.getSingle();
    return result.read(sumExp) ?? 0.0;
  }

  /// Suma de desayunos registrados en un rango.
  Future<double> breakfastTotalBetween({
    String? fromDate,
    String? toDate,
  }) async {
    final sumExp = _db.dailyLogs.breakfastPrice.sum();
    final query = _db.selectOnly(_db.dailyLogs)..addColumns([sumExp]);
    if (fromDate != null) {
      query.where(_db.dailyLogs.date.isBiggerOrEqualValue(fromDate));
    }
    if (toDate != null) {
      query.where(_db.dailyLogs.date.isSmallerOrEqualValue(toDate));
    }
    final result = await query.getSingle();
    return result.read(sumExp) ?? 0.0;
  }

  /// Stream de TODOS los bocadillos (para Cuentas).
  Stream<List<SnackEntry>> watchAll() => _db.select(_db.snackEntries).watch();
}

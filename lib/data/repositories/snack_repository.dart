import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../../core/utils/date_helper.dart';

/// Repositorio de bocadillos.
///
/// Codificación del campo `description`:
///   `[cat:nombre]nota libre`
/// Para preservar la categoría aunque el `.g.dart` no se regenere.
class SnackRepository {
  static const String categoryPrefix = '[cat:';
  static const String categorySuffix = ']';

  final AppDatabase _db;
  SnackRepository(this._db);

  Stream<List<SnackEntry>> watchByDate(String date) {
    final query = _db.select(_db.snackEntries)
      ..where((t) => t.date.equals(date));
    return query.watch();
  }

  Stream<List<SnackEntry>> watchAll() => _db.select(_db.snackEntries).watch();

  /// Stream de TODOS los snacks, ordenado desc por fecha.
  Stream<List<SnackEntry>> watchAllOrdered() {
    final query = _db.select(_db.snackEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.watch();
  }

  Future<void> add({
    required double price,
    String? description,
    String? categoryName,
  }) {
    final encoded = _encodeDescription(description, categoryName);
    return _db
        .into(_db.snackEntries)
        .insert(
          SnackEntriesCompanion.insert(
            date: DateHelper.today(),
            price: price,
            description: Value(encoded),
          ),
        );
  }

  Future<void> update({
    required int id,
    required double price,
    String? description,
    String? categoryName,
  }) async {
    final encoded = _encodeDescription(description, categoryName);
    await (_db.update(_db.snackEntries)..where((t) => t.id.equals(id))).write(
      SnackEntriesCompanion(
        price: Value(price),
        description: Value(encoded),
      ),
    );
  }

  Future<void> delete(int id) {
    return (_db.delete(_db.snackEntries)..where((t) => t.id.equals(id))).go();
  }

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

  // ════════════════════════════════════════════════════════════
  // Helpers de codificación
  // ════════════════════════════════════════════════════════════

  String? _encodeDescription(String? description, String? categoryName) {
    final buffer = StringBuffer();
    if (categoryName != null && categoryName.isNotEmpty) {
      buffer.write(categoryPrefix);
      buffer.write(categoryName);
      buffer.write(categorySuffix);
    }
    if (description != null && description.isNotEmpty) {
      buffer.write(description);
    }
    return buffer.isEmpty ? null : buffer.toString();
  }

  /// Decodifica el campo `description` en (categoría, nota).
  static (String?, String?) decode(String? raw) {
    if (raw == null || raw.isEmpty) return (null, null);
    if (!raw.startsWith(categoryPrefix)) return (null, raw);
    final end = raw.indexOf(categorySuffix);
    if (end < 0) return (null, raw);
    final cat = raw.substring(categoryPrefix.length, end);
    final rest = raw.substring(end + categorySuffix.length);
    return (cat, rest.isEmpty ? null : rest);
  }
}

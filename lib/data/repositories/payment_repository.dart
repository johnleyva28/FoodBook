import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../../core/utils/date_helper.dart';

/// Repositorio de pagos a la pensión.
///
/// Codificación del campo `note`:
///   `[method:nombre]nota libre`
class PaymentRepository {
  static const String methodPrefix = '[method:';
  static const String methodSuffix = ']';

  final AppDatabase _db;
  PaymentRepository(this._db);

  Stream<List<Payment>> watchAll() {
    final query = _db.select(_db.payments)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.watch();
  }

  Future<void> add({
    required double amount,
    String? note,
    String? methodName,
    String? date,
  }) {
    final encoded = _encodeNote(note, methodName);
    return _db
        .into(_db.payments)
        .insert(
          PaymentsCompanion.insert(
            amount: amount,
            date: date ?? DateHelper.today(),
            note: Value(encoded),
          ),
        );
  }

  Future<void> update({
    required int id,
    required double amount,
    String? note,
    String? methodName,
  }) async {
    final encoded = _encodeNote(note, methodName);
    await (_db.update(_db.payments)..where((t) => t.id.equals(id))).write(
      PaymentsCompanion(amount: Value(amount), note: Value(encoded)),
    );
  }

  Future<void> delete(int id) {
    return (_db.delete(_db.payments)..where((t) => t.id.equals(id))).go();
  }

  Future<double> total() async {
    final sumExp = _db.payments.amount.sum();
    final query = _db.selectOnly(_db.payments)..addColumns([sumExp]);
    final result = await query.getSingle();
    return result.read(sumExp) ?? 0.0;
  }

  Future<double> totalBetween({String? fromDate, String? toDate}) async {
    final sumExp = _db.payments.amount.sum();
    final query = _db.selectOnly(_db.payments)..addColumns([sumExp]);
    if (fromDate != null) {
      query.where(_db.payments.date.isBiggerOrEqualValue(fromDate));
    }
    if (toDate != null) {
      query.where(_db.payments.date.isSmallerOrEqualValue(toDate));
    }
    final result = await query.getSingle();
    return result.read(sumExp) ?? 0.0;
  }

  String? _encodeNote(String? note, String? methodName) {
    final buffer = StringBuffer();
    if (methodName != null && methodName.isNotEmpty) {
      buffer.write(methodPrefix);
      buffer.write(methodName);
      buffer.write(methodSuffix);
    }
    if (note != null && note.isNotEmpty) {
      buffer.write(note);
    }
    return buffer.isEmpty ? null : buffer.toString();
  }

  static (String?, String?) decode(String? raw) {
    if (raw == null || raw.isEmpty) return (null, null);
    if (!raw.startsWith(methodPrefix)) return (null, raw);
    final end = raw.indexOf(methodSuffix);
    if (end < 0) return (null, raw);
    final method = raw.substring(methodPrefix.length, end);
    final rest = raw.substring(end + methodSuffix.length);
    return (method, rest.isEmpty ? null : rest);
  }
}

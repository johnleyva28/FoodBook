import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../../core/utils/date_helper.dart';

class PaymentRepository {
  final AppDatabase _db;
  PaymentRepository(this._db);

  Stream<List<Payment>> watchAll() {
    final query = _db.select(_db.payments)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.watch();
  }

  Future<void> add({required double amount, String? note}) {
    return _db
        .into(_db.payments)
        .insert(
          PaymentsCompanion.insert(
            amount: amount,
            date: DateHelper.today(),
            note: Value(note),
          ),
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
}

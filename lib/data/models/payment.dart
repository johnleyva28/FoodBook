import 'package:drift/drift.dart';

/// Pagos que el usuario le hace a la pensión.
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get date => text()();
  TextColumn get note => text().nullable()();
}

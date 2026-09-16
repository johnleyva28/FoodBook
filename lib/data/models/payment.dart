import 'package:drift/drift.dart';

/// Pagos que el usuario le hace a la pensión.
///
/// Esquema v1. El método de pago se guarda en `note` con prefijo
/// `[method:nombre]` para mantener el esquema estable.
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get date => text()();
  TextColumn get note => text().nullable()();
}

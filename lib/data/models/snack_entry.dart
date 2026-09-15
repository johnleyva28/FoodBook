import 'package:drift/drift.dart';

/// Bocadillos: compras sueltas fuera del menú de la pensión.
class SnackEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get description => text().nullable()();
  RealColumn get price => real()();
}

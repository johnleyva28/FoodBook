import 'package:drift/drift.dart';

/// Configuración clave-valor (precio base de almuerzo/cena, nombre, etc.)
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

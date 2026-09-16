import 'package:drift/drift.dart';

/// Bocadillos: compras sueltas fuera del menú de la pensión.
///
/// Esquema v1. La categoría se guarda como texto (nombre) en `description`
/// con prefijo `[cat:nombre]`; las notas adicionales se guardan como JSON
/// en una segunda parte del campo descripción. Esto evita regenerar el
/// `.g.dart` y mantener el esquema estable.
class SnackEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get description => text().nullable()();
  RealColumn get price => real()();
}

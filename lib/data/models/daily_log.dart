import 'package:drift/drift.dart';

/// Registro diario: qué comió el usuario y precios del desayuno.
class DailyLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Fecha como texto 'yyyy-MM-dd' → única por día, fácil de comparar.
  TextColumn get date => text().unique()();
  BoolColumn get hadBreakfast => boolean().withDefault(const Constant(false))();
  // El desayuno tiene precio manual (varía); lunch y cena son fijos.
  RealColumn get breakfastPrice => real().withDefault(const Constant(0.0))();
  TextColumn get breakfastDesc => text().nullable()();
  BoolColumn get hadLunch => boolean().withDefault(const Constant(false))();
  BoolColumn get hadDinner => boolean().withDefault(const Constant(false))();
}

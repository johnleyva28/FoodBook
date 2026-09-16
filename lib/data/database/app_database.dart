import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/daily_log.dart';
import '../models/payment.dart';
import '../models/setting.dart';
import '../models/snack_entry.dart';

part 'app_database.g.dart';

/// Definición de la base de datos.
///
/// Esquema v1 (estable, generado por build_runner):
///   • DailyLogs    — registro por día (breakfast/lunch/dinner)
///   • SnackEntries — bocadillos sueltos
///   • Payments     — abonos a la pensión
///   • Settings     — preferencias clave-valor
///
/// Para features adicionales (categorías, métodos de pago, notas del día,
/// rating, extras, time stamps) creamos tablas auxiliares con `customStatement`
/// en `onCreate` y `onUpgrade`. Estas viven en la misma base de datos pero
/// se acceden con `customSelect`/`customInsert` para evitar tocar el
/// `.g.dart` generado.
@DriftDatabase(tables: [DailyLogs, SnackEntries, Payments, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createAuxTables();
      await _seedAuxTables();
    },
    onUpgrade: (m, from, to) async {
      // v1 → v2: añadimos tablas auxiliares (no tocamos las existentes).
      if (from < 2) {
        await _createAuxTables();
        await _seedAuxTables();
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // Asegurar que las tablas auxiliares existen (idempotente).
      await _createAuxTables();
      await _seedAuxTables();
    },
  );

  // ════════════════════════════════════════════════════════════
  // TABLAS AUXILIARES (SQL crudo)
  // ════════════════════════════════════════════════════════════

  static const String _createCategories = '''
    CREATE TABLE IF NOT EXISTS categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      icon TEXT NOT NULL DEFAULT 'fastfood',
      color_hex TEXT NOT NULL DEFAULT '#38BDF8',
      is_default INTEGER NOT NULL DEFAULT 0
    )
  ''';

  static const String _createPaymentMethods = '''
    CREATE TABLE IF NOT EXISTS payment_methods (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      icon TEXT NOT NULL DEFAULT 'payments',
      color_hex TEXT NOT NULL DEFAULT '#38BDF8',
      is_default INTEGER NOT NULL DEFAULT 0
    )
  ''';

  /// Tabla `daily_extras` para datos opcionales por fecha (sin tocar
  /// `daily_logs`): notas del día, rating y gastos extra.
  static const String _createDailyExtras = '''
    CREATE TABLE IF NOT EXISTS daily_extras (
      date TEXT PRIMARY KEY,
      notes TEXT,
      rating INTEGER,
      extra_expenses REAL NOT NULL DEFAULT 0
    )
  ''';

  Future<void> _createAuxTables() async {
    await customStatement(_createCategories);
    await customStatement(_createPaymentMethods);
    await customStatement(_createDailyExtras);
  }

  // ════════════════════════════════════════════════════════════
  // SEED INICIAL
  // ════════════════════════════════════════════════════════════

  Future<void> _seedAuxTables() async {
    await _seedCategories();
    await _seedPaymentMethods();
  }

  Future<void> _seedCategories() async {
    final defaults = const [
      _CategorySeed('Panadería', 'bakery_dining', '#FBBF24'),
      _CategorySeed('Fruta', 'spa', '#34D399'),
      _CategorySeed('Gaseosa', 'local_drink', '#22D3EE'),
      _CategorySeed('Snack', 'fastfood', '#F87171'),
      _CategorySeed('Café', 'coffee', '#A5B4FC'),
      _CategorySeed('Dulce', 'icecream', '#F472B6'),
    ];
    for (final c in defaults) {
      final exists = await customSelect(
        'SELECT id FROM categories WHERE name = ?',
        variables: [Variable.withString(c.name)],
        readsFrom: const {},
      ).getSingleOrNull();
      if (exists == null) {
        await customInsert(
          'INSERT INTO categories (name, icon, color_hex, is_default) VALUES (?, ?, ?, 1)',
          variables: [
            Variable.withString(c.name),
            Variable.withString(c.icon),
            Variable.withString(c.colorHex),
          ],
          updates: {_CategoriesTableExcluded},
        );
      }
    }
  }

  Future<void> _seedPaymentMethods() async {
    final defaults = const [
      _PaymentMethodSeed('Efectivo', 'payments', '#34D399'),
      _PaymentMethodSeed('Yape', 'phone_android', '#7DD3FC'),
      _PaymentMethodSeed('Plin', 'phone_iphone', '#38BDF8'),
      _PaymentMethodSeed('Transferencia', 'account_balance', '#A5B4FC'),
    ];
    for (final m in defaults) {
      final exists = await customSelect(
        'SELECT id FROM payment_methods WHERE name = ?',
        variables: [Variable.withString(m.name)],
        readsFrom: const {},
      ).getSingleOrNull();
      if (exists == null) {
        await customInsert(
          'INSERT INTO payment_methods (name, icon, color_hex, is_default) VALUES (?, ?, ?, 1)',
          variables: [
            Variable.withString(m.name),
            Variable.withString(m.icon),
            Variable.withString(m.colorHex),
          ],
          updates: {_PaymentMethodsTableExcluded},
        );
      }
    }
  }
}

const Set<String> _CategoriesTableExcluded = {'id'};
const Set<String> _PaymentMethodsTableExcluded = {'id'};

class _CategorySeed {
  final String name;
  final String icon;
  final String colorHex;
  const _CategorySeed(this.name, this.icon, this.colorHex);
}

class _PaymentMethodSeed {
  final String name;
  final String icon;
  final String colorHex;
  const _PaymentMethodSeed(this.name, this.icon, this.colorHex);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'foodbook.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

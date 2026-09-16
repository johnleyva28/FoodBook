import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/category.dart';

/// Repositorio de categorías y métodos de pago (SQL crudo).
class CatalogRepository {
  final AppDatabase _db;
  CatalogRepository(this._db);

  // ════════════════════════════════════════════════════════
  // CATEGORIES
  // ════════════════════════════════════════════════════════

  Future<List<Category>> getAllCategories() async {
    final rows = await _db.customSelect(
      'SELECT * FROM categories ORDER BY name',
      readsFrom: const {},
    ).get();
    return rows.map((r) => Category.fromRow(r.data)).toList();
  }

  Future<Category?> getCategoryById(int id) async {
    final row = await _db.customSelect(
      'SELECT * FROM categories WHERE id = ?',
      variables: [Variable.withInt(id)],
      readsFrom: const {},
    ).getSingleOrNull();
    return row == null ? null : Category.fromRow(row.data);
  }

  Future<int> addCategory({
    required String name,
    String icon = 'fastfood',
    String colorHex = '#38BDF8',
  }) async {
    return _db.customInsert(
      'INSERT INTO categories (name, icon, color_hex, is_default) VALUES (?, ?, ?, 0)',
      variables: [
        Variable.withString(name),
        Variable.withString(icon),
        Variable.withString(colorHex),
      ],
      updates: const {'categories': const {'id'}},
    );
  }

  Future<void> deleteCategory(int id) async {
    await _db.customStatement(
      'DELETE FROM categories WHERE id = ?',
      [id],
    );
  }

  // ════════════════════════════════════════════════════════
  // PAYMENT METHODS
  // ════════════════════════════════════════════════════════

  Future<List<PaymentMethod>> getAllPaymentMethods() async {
    final rows = await _db.customSelect(
      'SELECT * FROM payment_methods ORDER BY name',
      readsFrom: const {},
    ).get();
    return rows.map((r) => PaymentMethod.fromRow(r.data)).toList();
  }

  Future<int> addPaymentMethod({
    required String name,
    String icon = 'payments',
    String colorHex = '#38BDF8',
  }) async {
    return _db.customInsert(
      'INSERT INTO payment_methods (name, icon, color_hex, is_default) VALUES (?, ?, ?, 0)',
      variables: [
        Variable.withString(name),
        Variable.withString(icon),
        Variable.withString(colorHex),
      ],
      updates: const {'payment_methods': const {'id'}},
    );
  }

  Future<void> deletePaymentMethod(int id) async {
    await _db.customStatement(
      'DELETE FROM payment_methods WHERE id = ?',
      [id],
    );
  }
}

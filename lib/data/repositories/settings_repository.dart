import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../../core/constants/app_constants.dart';

class SettingsRepository {
  final AppDatabase _db;
  SettingsRepository(this._db);

  Future<String?> getString(String key) async {
    final query = _db.select(_db.settings)..where((t) => t.key.equals(key));
    final row = await query.getSingleOrNull();
    return row?.value;
  }

  Future<void> setString(String key, String value) {
    return _db
        .into(_db.settings)
        .insert(
          SettingsCompanion.insert(key: key, value: value),
          mode: InsertMode.insertOrReplace,
        );
  }

  /// Precio del almuerzo (de la BD o el default de 9.00).
  Future<double> getLunchPrice() async {
    final value = await getString(AppConstants.keyLunchPrice);
    return double.tryParse(value ?? '') ?? AppConstants.defaultLunchPrice;
  }

  Future<double> getDinnerPrice() async {
    final value = await getString(AppConstants.keyDinnerPrice);
    return double.tryParse(value ?? '') ?? AppConstants.defaultDinnerPrice;
  }
}

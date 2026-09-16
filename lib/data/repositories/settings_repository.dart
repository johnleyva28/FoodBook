import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../../core/constants/app_constants.dart';

/// Repositorio para la tabla `settings` (clave-valor).
///
/// Guarda preferencias del usuario: precios base, nombre, tema, moneda,
/// presupuesto mensual, etc.
class SettingsRepository {
  final AppDatabase _db;
  SettingsRepository(this._db);

  // ── Lectura / escritura genérica ──

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

  // ── Precios base ──

  Future<double> getLunchPrice() async {
    final value = await getString(AppConstants.keyLunchPrice);
    return double.tryParse(value ?? '') ?? AppConstants.defaultLunchPrice;
  }

  Future<double> getDinnerPrice() async {
    final value = await getString(AppConstants.keyDinnerPrice);
    return double.tryParse(value ?? '') ?? AppConstants.defaultDinnerPrice;
  }

  // ── Otros getters tipados ──

  Future<String> getCurrency() async {
    final value = await getString(AppConstants.keyCurrency);
    if (value == null || !AppConstants.supportedCurrencies.contains(value)) {
      return AppConstants.currencyPEN;
    }
    return value;
  }

  Future<double> getMonthlyBudget() async {
    final value = await getString(AppConstants.keyMonthlyBudget);
    return double.tryParse(value ?? '') ?? AppConstants.defaultMonthlyBudget;
  }

  Future<bool> getNotificationsEnabled() async {
    final value = await getString(AppConstants.keyNotificationsEnabled);
    return value == 'true';
  }

  Future<int> getNotificationLunchHour() async {
    final value = await getString(AppConstants.keyNotificationLunchHour);
    return int.tryParse(value ?? '') ??
        AppConstants.defaultLunchNotificationHour;
  }

  Future<int> getNotificationDinnerHour() async {
    final value = await getString(AppConstants.keyNotificationDinnerHour);
    return int.tryParse(value ?? '') ??
        AppConstants.defaultDinnerNotificationHour;
  }

  Future<bool> getOnboardingCompleted() async {
    final value = await getString(AppConstants.keyOnboardingCompleted);
    return value == 'true';
  }
}

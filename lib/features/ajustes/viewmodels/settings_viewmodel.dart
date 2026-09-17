import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/repositories/settings_repository.dart';

/// ViewModel global de ajustes.
///
/// Se expone a nivel de `MaterialApp` para que cambios como el `themeMode`
/// o la `currency` se propaguen a toda la app sin tener que reiniciar
/// manualmente ninguna pantalla.
class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepo;

  SettingsViewModel(this._settingsRepo);

  bool loading = true;

  // ── Perfil ──
  String userName = '';

  // ── Precios base ──
  double lunchPrice = AppConstants.defaultLunchPrice;
  double dinnerPrice = AppConstants.defaultDinnerPrice;

  // ── Tema ──
  ThemeMode themeMode = ThemeMode.dark;

  // ── Moneda ──
  String currency = AppConstants.currencyPEN;

  // ── Presupuesto ──
  double monthlyBudget = AppConstants.defaultMonthlyBudget;

  // ── Notificaciones ──
  bool notificationsEnabled = false;
  int notificationLunchHour = AppConstants.defaultLunchNotificationHour;
  int notificationDinnerHour = AppConstants.defaultDinnerNotificationHour;

  // ── Onboarding ──
  bool onboardingCompleted = false;

  // ════════════════════════════════════════════════════════════
  // CICLO DE VIDA
  // ════════════════════════════════════════════════════════════

  Future<void> init() async {
    lunchPrice = await _settingsRepo.getLunchPrice();
    dinnerPrice = await _settingsRepo.getDinnerPrice();
    userName = await _settingsRepo.getString(AppConstants.keyUserName) ?? '';
    currency = await _settingsRepo.getCurrency();
    monthlyBudget = await _settingsRepo.getMonthlyBudget();
    notificationsEnabled = await _settingsRepo.getNotificationsEnabled();
    notificationLunchHour = await _settingsRepo.getNotificationLunchHour();
    notificationDinnerHour = await _settingsRepo.getNotificationDinnerHour();
    onboardingCompleted = await _settingsRepo.getOnboardingCompleted();
    themeMode = await _readThemeMode();
    loading = false;
    notifyListeners();
  }

  Future<ThemeMode> _readThemeMode() async {
    final raw = await _settingsRepo.getString(AppConstants.keyThemeMode);
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      case 'dark':
      default:
        return ThemeMode.dark;
    }
  }

  // ════════════════════════════════════════════════════════════
  // SETTERS
  // ════════════════════════════════════════════════════════════

  Future<void> setLunchPrice(double value) async {
    if (value <= 0) return;
    await _settingsRepo.setString(AppConstants.keyLunchPrice, value.toString());
    lunchPrice = value;
    notifyListeners();
  }

  Future<void> setDinnerPrice(double value) async {
    if (value <= 0) return;
    await _settingsRepo.setString(
      AppConstants.keyDinnerPrice,
      value.toString(),
    );
    dinnerPrice = value;
    notifyListeners();
  }

  Future<void> setUserName(String value) async {
    await _settingsRepo.setString(AppConstants.keyUserName, value);
    userName = value;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final key = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
      ThemeMode.dark => 'dark',
    };
    await _settingsRepo.setString(AppConstants.keyThemeMode, key);
    themeMode = mode;
    notifyListeners();
  }

  Future<void> setCurrency(String value) async {
    if (!AppConstants.supportedCurrencies.contains(value)) return;
    await _settingsRepo.setString(AppConstants.keyCurrency, value);
    currency = value;
    notifyListeners();
  }

  Future<void> setMonthlyBudget(double value) async {
    if (value < 0) return;
    await _settingsRepo.setString(
      AppConstants.keyMonthlyBudget,
      value.toString(),
    );
    monthlyBudget = value;
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _settingsRepo.setString(
      AppConstants.keyNotificationsEnabled,
      value.toString(),
    );
    notificationsEnabled = value;
    notifyListeners();
  }

  Future<void> setNotificationLunchHour(int hour) async {
    final clamped = hour.clamp(0, 23);
    await _settingsRepo.setString(
      AppConstants.keyNotificationLunchHour,
      clamped.toString(),
    );
    notificationLunchHour = clamped;
    notifyListeners();
  }

  Future<void> setNotificationDinnerHour(int hour) async {
    final clamped = hour.clamp(0, 23);
    await _settingsRepo.setString(
      AppConstants.keyNotificationDinnerHour,
      clamped.toString(),
    );
    notificationDinnerHour = clamped;
    notifyListeners();
  }

  Future<void> markOnboardingCompleted() async {
    await _settingsRepo.setString(AppConstants.keyOnboardingCompleted, 'true');
    onboardingCompleted = true;
    notifyListeners();
  }
}

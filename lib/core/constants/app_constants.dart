/// Constantes globales de FoodBook.
class AppConstants {
  AppConstants._();

  // ── Identidad ──
  static const String appName = 'FoodBook';
  static const String appVersion = '2.7.0';
  static const String appTagline = 'Tu pensión, en un cuaderno';

  // ── Precios por defecto (soles) ──
  static const double defaultLunchPrice = 9.00;
  static const double defaultDinnerPrice = 9.00;
  static const double defaultBreakfastPrice = 5.00;

  // ── Moneda ──
  static const String currencyPEN = 'S/';
  static const String currencyUSD = r'$';
  static const List<String> supportedCurrencies = [currencyPEN, currencyUSD];

  // ── Claves de la tabla settings ──
  static const String keyLunchPrice = 'lunch_price';
  static const String keyDinnerPrice = 'dinner_price';
  static const String keyUserName = 'user_name';
  static const String keyThemeMode = 'theme_mode';
  static const String keyCurrency = 'currency';
  static const String keyMonthlyBudget = 'monthly_budget';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyNotificationLunchHour = 'notification_lunch_hour';
  static const String keyNotificationDinnerHour = 'notification_dinner_hour';
  static const String keyOnboardingCompleted = 'onboarding_completed';

  // ── Formato de fecha ──
  static const String dateFormat = 'yyyy-MM-dd';

  // ── Defaults varios ──
  static const double defaultMonthlyBudget = 600.0; // S/ 600 mensuales
  static const int defaultLunchNotificationHour = 11; // 11:00 AM
  static const int defaultDinnerNotificationHour = 18; // 6:00 PM
}

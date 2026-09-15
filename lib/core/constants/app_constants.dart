/// Constantes globales de FoodBook.
class AppConstants {
  AppConstants._(); // No instanciable

  // ── Precios base (en soles) ──
  static const double defaultLunchPrice = 9.00;
  static const double defaultDinnerPrice = 9.00;

  // ── Claves para la tabla settings ──
  static const String keyLunchPrice = 'lunch_price';
  static const String keyDinnerPrice = 'dinner_price';
  static const String keyUserName = 'user_name';

  // ── Formato de fecha (clave única por día) ──
  // Usamos 'yyyy-MM-dd' para guardar fechas como texto/fecha
  // de forma consistente en la BD.
  static const String dateFormat = 'yyyy-MM-dd';
}

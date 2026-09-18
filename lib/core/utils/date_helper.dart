import 'package:intl/intl.dart';

/// Utilidades para manejar fechas en formato 'yyyy-MM-dd'.
class DateHelper {
  DateHelper._();

  static final DateFormat _format = DateFormat('yyyy-MM-dd');
  static final DateFormat _humanShort = DateFormat('d MMM yyyy', 'es_PE');
  static final DateFormat _weekDay = DateFormat('EEE', 'es_PE');
  static final DateFormat _month = DateFormat('MMMM yyyy', 'es_PE');

  /// Hoy en formato 'yyyy-MM-dd'.
  static String today() => format(DateTime.now());

  /// Convierte DateTime → 'yyyy-MM-dd'.
  static String format(DateTime date) => _format.format(date);

  /// Convierte 'yyyy-MM-dd' → DateTime.
  static DateTime parse(String date) => _format.parse(date);

  /// Etiqueta legible: "lunes, 15 de septiembre".
  static String label(DateTime date) =>
      DateFormat('EEEE, d \'de\' MMMM', 'es_PE').format(date);

  /// Etiqueta corta: "15 sep 2026".
  static String short(DateTime date) => _humanShort.format(date);

  /// Día de la semana corto: "lun", "mar", ...
  static String weekday(DateTime date) => _weekDay.format(date);

  /// Mes y año: "septiembre 2026".
  static String monthYear(DateTime date) => _month.format(date);

  /// Devuelve true si la fecha es hoy.
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Devuelve true si la fecha es del mes actual.
  static bool isCurrentMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Devuelve el primer día del mes de la fecha dada.
  static DateTime firstDayOfMonth(DateTime date) =>
      DateTime(date.year, date.month, 1);

  /// Devuelve el último día del mes de la fecha dada.
  static DateTime lastDayOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0);

  /// Diferencia en días entre dos fechas (sin contar la hora).
  static int daysBetween(DateTime a, DateTime b) {
    final aa = DateTime(a.year, a.month, a.day);
    final bb = DateTime(b.year, b.month, b.day);
    return bb.difference(aa).inDays;
  }

  /// Lista de los últimos [n] días terminando en hoy (inclusive).
  /// Ej: n=7 → [hace 6, ..., hace 1, hoy]
  static List<DateTime> lastNDays(int n) {
    final today = DateTime.now();
    final base = DateTime(today.year, today.month, today.day);
    return List<DateTime>.generate(n, (i) => base.subtract(Duration(days: n - 1 - i)));
  }

  /// Devuelve el rango de fechas de un mes completo (1 al último día).
  static ({DateTime start, DateTime end}) monthRange(DateTime date) =>
      (start: firstDayOfMonth(date), end: lastDayOfMonth(date));
}

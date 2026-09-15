import 'package:intl/intl.dart';

/// Utilidades para manejar fechas en formato 'yyyy-MM-dd'.
class DateHelper {
  DateHelper._();

  static final DateFormat _format = DateFormat('yyyy-MM-dd');

  /// Hoy en formato 'yyyy-MM-dd'.
  static String today() => format(DateTime.now());

  /// Convierte DateTime → 'yyyy-MM-dd'.
  static String format(DateTime date) => _format.format(date);

  /// Convierte 'yyyy-MM-dd' → DateTime.
  static DateTime parse(String date) => _format.parse(date);

  /// Etiqueta legible: "lunes, 15 de septiembre".
  static String label(DateTime date) =>
      DateFormat('EEEE, d \'de\' MMMM', 'es_PE').format(date);
}

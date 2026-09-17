import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'foodbook_log.dart';

/// Formateador centralizado de dinero.
///
/// Usa el símbolo de la moneda activa (S/ o $) y formatea siempre
/// con 2 decimales. Para "modo compacto" (1.2K, 850) usar [compact].
@immutable
class MoneyFormatter {
  final String symbol;
  final String _locale;

  const MoneyFormatter({required this.symbol, this._locale = 'es_PE'});

  /// Crea el formateador a partir de un código (PEN, USD, S/, $).
  factory MoneyFormatter.fromCode(String? code, {String locale = 'es_PE'}) {
    return MoneyFormatter(symbol: _symbolFor(code), locale: locale);
  }

  /// Resuelve el símbolo a partir de un código de moneda persistido
  /// (PEN, USD, S/, $). Si no se reconoce, devuelve S/.
  static String _symbolFor(String? code) {
    switch (code) {
      case r'$':
      case 'USD':
        return r'$';
      case 'S/':
      case 'PEN':
      default:
        return 'S/';
    }
  }

  /// Devuelve la instancia por defecto con `S/` (compatibilidad).
  static final MoneyFormatter defaultPen =
      MoneyFormatter.fromCode('PEN');

  /// Formato estándar: `S/ 12.50`.
  String format(double amount) {
    try {
      final n = NumberFormat.currency(
        symbol: '$symbol ',
        decimalDigits: 2,
        locale: _locale,
      );
      return n.format(amount);
    } catch (e) {
      FoodBookLog.w('Error formateando moneda', error: e);
      return '$symbol ${amount.toStringAsFixed(2)}';
    }
  }

  /// Formato compacto: `S/ 1.2K` o `S/ 12.50` si es menor a 1000.
  String formatCompact(double amount) {
    if (amount.abs() < 1000) return format(amount);
    try {
      final n = NumberFormat.compactCurrency(
        symbol: '$symbol ',
        decimalDigits: 1,
        locale: _locale,
      );
      return n.format(amount);
    } catch (e) {
      FoodBookLog.w('Error formateando moneda compacta', error: e);
      return format(amount);
    }
  }

  /// Solo el número con 2 decimales, sin símbolo.
  String number(double amount) =>
      NumberFormat('0.00', _locale).format(amount);

  /// Firma + número para indicar gastos (prefijo -).
  String signed(double amount, {bool isNegative = false}) =>
      '${isNegative ? '-' : ''}${format(amount.abs())}';
}

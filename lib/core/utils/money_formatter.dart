import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Formateador centralizado de dinero.
///
/// Usa el símbolo de la moneda activa (S/ o $) y formatea siempre
/// con 2 decimales. Para "modo compacto" (1.2K, 850) usar [compact].
@immutable
class MoneyFormatter {
  final String symbol;
  final String _locale;

  MoneyFormatter({required this.symbol, String locale = 'es_PE'})
    : _locale = locale;

  /// Formato estándar: `S/ 12.50`.
  String format(double amount) {
    final n = NumberFormat.currency(
      symbol: '$symbol ',
      decimalDigits: 2,
      locale: _locale,
    );
    return n.format(amount);
  }

  /// Formato compacto: `S/ 1.2K`.
  String compact(double amount) {
    if (amount.abs() < 1000) return format(amount);
    final n = NumberFormat.compactCurrency(
      symbol: '$symbol ',
      decimalDigits: 1,
      locale: _locale,
    );
    return n.format(amount);
  }

  /// Solo el número con 2 decimales, sin símbolo.
  String number(double amount) =>
      NumberFormat('0.00', _locale).format(amount);
}

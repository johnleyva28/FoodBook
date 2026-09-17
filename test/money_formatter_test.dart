import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:foodbook/core/utils/money_formatter.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es_PE', null);
  });

  group('MoneyFormatter', () {
    test('S/ es el simbolo por defecto', () {
      const f = MoneyFormatter(symbol: 'S/');
      final out = f.format(12.5);
      // es_PE: 12,50 S/
      expect(out, contains('12,50'));
      expect(out, contains('S/'));
    });

    test('format siempre usa 2 decimales', () {
      const f = MoneyFormatter(symbol: 'S/');
      expect(f.format(0), contains('0,00'));
      expect(f.format(1000), contains('1.000,00'));
      expect(f.format(99.999), contains('100,00')); // rounding
    });

    test('compact usa notacion corta para >= 1000', () {
      const f = MoneyFormatter(symbol: 'S/');
      expect(f.compact(500), contains('500,00'));
      expect(f.compact(1500), anyOf(contains('1,5'), contains('1K')));
      expect(f.compact(1500000), anyOf(contains('1,5'), contains('2')));
    });

    test('number devuelve solo el numero', () {
      const f = MoneyFormatter(symbol: 'S/');
      expect(f.number(12.5), '12,50');
      expect(f.number(0), '0,00');
      // No incluye simbolo de moneda
      expect(f.number(12.5), isNot(contains('S/')));
    });
  });

  group('MoneyFormatter.fromCode', () {
    test('PEN -> S/', () {
      expect(MoneyFormatter.fromCode('PEN').symbol, 'S/');
    });

    test('USD -> \$', () {
      expect(MoneyFormatter.fromCode('USD').symbol, r'$');
    });

    test('S/ literal -> S/', () {
      expect(MoneyFormatter.fromCode('S/').symbol, 'S/');
    });

    test('\$ literal -> \$', () {
      expect(MoneyFormatter.fromCode(r'$').symbol, r'$');
    });

    test('null o desconocido -> S/ (fallback)', () {
      expect(MoneyFormatter.fromCode(null).symbol, 'S/');
      expect(MoneyFormatter.fromCode('XYZ').symbol, 'S/');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:foodbook/core/utils/money_formatter.dart';

/// Tests de borde adicionales para MoneyFormatter.
///
/// Complementan los tests basicos con edge cases del formato
/// compact, signed, e inmutabilidad.
void main() {
  setUpAll(() async {
    await initializeDateFormatting('es_PE', null);
  });

  group('MoneyFormatter - formatCompact edge cases', () {
    const m = MoneyFormatter(symbol: 'S/');

    test('compact en exactamente 1000 usa notacion corta', () {
      final out = m.formatCompact(1000);
      // NumberFormat.compactCurrency usa K para >= 1000
      expect(out, isNot(equals(m.format(1000))));
    });

    test('compact en 999 usa formato completo', () {
      expect(m.formatCompact(999), m.format(999));
    });

    test('compact con numero negativo', () {
      // Negativos < -1000 tambien se compactan
      final out = m.formatCompact(-1500);
      expect(out, isNotEmpty);
      expect(out, contains('-'));
    });

    test('compact con cero', () {
      expect(m.formatCompact(0), m.format(0));
    });

    test('compact con 1500 da algo con K o 1.5K', () {
      final out = m.formatCompact(1500);
      // NumberFormat.compactCurrency en es_PE produce 'S/ 1,5K' aprox
      expect(out.toUpperCase(), anyOf(contains('K'), contains('MIL')));
    });

    test('compact en millones usa M', () {
      final out = m.formatCompact(1500000).toUpperCase();
      expect(out, anyOf(contains('M'), contains('MILL')));
    });

    test('compact con 500000 da 500K', () {
      final out = m.formatCompact(500000).toUpperCase();
      expect(out, anyOf(contains('K'), contains('MIL')));
    });
  });

  group('MoneyFormatter - signed', () {
    const m = MoneyFormatter(symbol: 'S/');

    test('signed con isNegative=true agrega - al inicio', () {
      final out = m.signed(12.50, isNegative: true);
      expect(out, startsWith('-'));
      expect(out, contains('S/'));
      // es_PE usa coma decimal: '12,50'
      expect(out, anyOf(contains('12,50'), contains('12.50')));
    });

    test('signed con isNegative=false es positivo', () {
      final out = m.signed(12.50);
      expect(out, isNot(startsWith('-')));
      expect(out, anyOf(contains('12,50'), contains('12.50')));
    });

    test('signed usa valor absoluto', () {
      // signed(-5) con isNegative=false produce 'S/ 5,00' (sin guion)
      final out = m.signed(-5);
      expect(out, anyOf(contains('5,00'), contains('5.00')));
      expect(out, isNot(startsWith('-')));
    });
  });

  group('MoneyFormatter - number edge cases', () {
    const m = MoneyFormatter(symbol: 'S/');

    test('number con cero da 0,00', () {
      expect(m.number(0), anyOf(equals('0,00'), equals('0.00')));
    });

    test('number siempre tiene 2 decimales', () {
      expect(m.number(5), anyOf(equals('5,00'), equals('5.00')));
      expect(m.number(5.5), anyOf(equals('5,50'), equals('5.50')));
      // 5.555 formateado a 2 decimales (redondeo bancario o tradicional)
      final r = m.number(5.555);
      expect(r, anyOf(equals('5,55'), equals('5.55'), equals('5,56'), equals('5.56')));
    });

    test('number con negativo mantiene el guion', () {
      final out = m.number(-12.50);
      expect(out, startsWith('-'));
      expect(out, anyOf(contains('12,50'), contains('12.50')));
    });

    test('number es solo numero, sin simbolo', () {
      final out = m.number(99);
      expect(out.contains('S/'), isFalse);
      expect(out.contains(r'$'), isFalse);
    });
  });

  group('MoneyFormatter - inmutabilidad', () {
    test('MoneyFormatter es @immutable', () {
      // Compilacion: const-constructor funciona
      const a = MoneyFormatter(symbol: 'S/');
      const b = MoneyFormatter(symbol: 'S/');
      // Dos instancias const son iguales en comparacion ==
      expect(a, equals(b));
    });

    test('symbol se mantiene a traves de format', () {
      const pen = MoneyFormatter(symbol: 'S/');
      const usd = MoneyFormatter(symbol: r'$');
      expect(pen.format(100).contains('S/'), isTrue);
      expect(usd.format(100).contains(r'$'), isTrue);
    });
  });

  group('MoneyFormatter - defaultPen', () {
    test('defaultPen es MoneyFormatter con S/', () {
      expect(MoneyFormatter.defaultPen.symbol, 'S/');
    });

    test('defaultPen.format produce S/', () {
      expect(MoneyFormatter.defaultPen.format(100), contains('S/'));
    });
  });

  group('MoneyFormatter - locales', () {
    test('locale es_PE por defecto', () {
      const m = MoneyFormatter(symbol: 'S/');
      // _locale es privado, pero format() debe funcionar sin error
      expect(m.format(1234.56), isNotEmpty);
    });

    test('locale custom funciona', () {
      const m = MoneyFormatter(symbol: r'$', locale: 'en_US');
      final out = m.format(1234.56);
      expect(out, contains(r'$'));
    });
  });
}

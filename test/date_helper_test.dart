import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:foodbook/core/utils/date_helper.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es_PE', null);
  });

  group('DateHelper (calendario)', () {
    test('format y parse son simétricos', () {
      final now = DateTime(2026, 9, 15);
      final iso = DateHelper.format(now);
      expect(iso, '2026-09-15');
      final back = DateHelper.parse(iso);
      expect(back.year, 2026);
      expect(back.month, 9);
      expect(back.day, 15);
    });

    test('primer día del mes siguiente es correcto', () {
      final last = DateTime(2026, 2, 28);
      final next = DateTime(last.year, last.month + 1, 0);
      expect(next.day, 28);
      expect(next.month, 2);
    });

    test('format incluye padding de ceros', () {
      expect(DateHelper.format(DateTime(2026, 3, 5)), '2026-03-05');
      expect(DateHelper.format(DateTime(2026, 12, 31)), '2026-12-31');
    });

    test('parse lanza FormatException con fecha malformada', () {
      expect(() => DateHelper.parse('no-es-fecha'), throwsFormatException);
      expect(() => DateHelper.parse('2026/09/15'), throwsFormatException);
    });

    test('roundtrip format + parse preserva día/mes/año', () {
      final samples = [
        DateTime(2024, 1, 1),
        DateTime(2025, 6, 15),
        DateTime(2026, 12, 31),
        DateTime(2027, 2, 29), // año bisiesto
      ];
      for (final d in samples) {
        final parsed = DateHelper.parse(DateHelper.format(d));
        expect(parsed.year, d.year);
        expect(parsed.month, d.month);
        expect(parsed.day, d.day);
      }
    });
  });

  group('DateHelper nuevas utilidades', () {
    test('short formatea corto', () {
      final d = DateTime(2026, 9, 15);
      final out = DateHelper.short(d);
      expect(out, contains('15'));
      expect(out, contains('2026'));
    });

    test('weekday devuelve dia corto', () {
      // lunes 14 sep 2026
      final d = DateTime(2026, 9, 14);
      final wd = DateHelper.weekday(d);
      expect(wd.toLowerCase(), contains('lun'));
    });

    test('monthYear formatea mes + anio', () {
      final d = DateTime(2026, 9, 1);
      final out = DateHelper.monthYear(d);
      expect(out, contains('2026'));
    });

    test('isToday detecta correctamente', () {
      expect(DateHelper.isToday(DateTime.now()), isTrue);
      expect(DateHelper.isToday(DateTime(2000, 1, 1)), isFalse);
    });

    test('isCurrentMonth detecta el mes actual', () {
      expect(DateHelper.isCurrentMonth(DateTime.now()), isTrue);
      expect(DateHelper.isCurrentMonth(DateTime(2000, 1, 1)), isFalse);
    });

    test('firstDayOfMonth siempre es dia 1', () {
      final d = DateTime(2026, 9, 17);
      expect(DateHelper.firstDayOfMonth(d), DateTime(2026, 9, 1));
    });

    test('lastDayOfMonth retorna 30/31 segun mes', () {
      expect(DateHelper.lastDayOfMonth(DateTime(2026, 9, 1)).day, 30);
      expect(DateHelper.lastDayOfMonth(DateTime(2026, 2, 1)).day, 28);
      // 2026 no es bisiesto
    });

    test('daysBetween calcula diferencia', () {
      final a = DateTime(2026, 9, 1);
      final b = DateTime(2026, 9, 10);
      expect(DateHelper.daysBetween(a, b), 9);
      expect(DateHelper.daysBetween(b, a), -9);
    });

    test('lastNDays retorna n fechas terminando en hoy', () {
      final days = DateHelper.lastNDays(7);
      expect(days.length, 7);
      // El ultimo es hoy
      expect(DateHelper.isToday(days.last), isTrue);
      // El primero es hace 6 dias (valor positivo si restamos hoy - primero)
      expect(DateHelper.daysBetween(days.first, DateTime.now()), 6);
    });

    test('monthRange devuelve inicio y fin del mes', () {
      final range = DateHelper.monthRange(DateTime(2026, 9, 17));
      expect(range.start, DateTime(2026, 9, 1));
      expect(range.end, DateTime(2026, 9, 30));
    });
  });

}

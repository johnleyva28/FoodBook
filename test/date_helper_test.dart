import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/utils/date_helper.dart';

void main() {
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
}

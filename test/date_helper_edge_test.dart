import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:foodbook/core/utils/date_helper.dart';

/// Tests adicionales para DateHelper.
///
/// Cubre casos extremos de los metodos de fechas: anio bisiesto,
/// cambio de mes, anio nuevo, dias exactos entre fechas, etc.
void main() {
  setUpAll(() async {
    await initializeDateFormatting('es_PE', null);
  });

  group('DateHelper - isToday', () {
    test('true para hoy', () {
      expect(DateHelper.isToday(DateTime.now()), isTrue);
    });

    test('false para ayer', () {
      expect(DateHelper.isToday(DateTime.now().subtract(const Duration(days: 1))), isFalse);
    });

    test('false para manana', () {
      expect(DateHelper.isToday(DateTime.now().add(const Duration(days: 1))), isFalse);
    });
  });

  group('DateHelper - isCurrentMonth', () {
    test('true para una fecha de este mes', () {
      expect(DateHelper.isCurrentMonth(DateTime.now()), isTrue);
    });

    test('false para el mes pasado', () {
      final lastMonth = DateTime(DateTime.now().year, DateTime.now().month - 1, 15);
      expect(DateHelper.isCurrentMonth(lastMonth), isFalse);
    });
  });

  group('DateHelper - firstDayOfMonth / lastDayOfMonth', () {
    test('primer dia de enero 2026 = 2026-01-01', () {
      final d = DateHelper.firstDayOfMonth(DateTime(2026, 1, 15));
      expect(d, DateTime(2026, 1, 1));
    });

    test('ultimo dia de enero 2026 = 2026-01-31', () {
      final d = DateHelper.lastDayOfMonth(DateTime(2026, 1, 15));
      expect(d, DateTime(2026, 1, 31));
    });

    test('febrero 2026 (no bisiesto) tiene 28 dias', () {
      final d = DateHelper.lastDayOfMonth(DateTime(2026, 2, 15));
      expect(d, DateTime(2026, 2, 28));
    });

    test('febrero 2024 (bisiesto) tiene 29 dias', () {
      final d = DateHelper.lastDayOfMonth(DateTime(2024, 2, 15));
      expect(d, DateTime(2024, 2, 29));
    });

    test('febrero 2000 (bisiesto, siglo divisible por 400)', () {
      final d = DateHelper.lastDayOfMonth(DateTime(2000, 2, 15));
      expect(d, DateTime(2000, 2, 29));
    });

    test('febrero 1900 (NO bisiesto, siglo divisible por 100 pero no por 400)', () {
      final d = DateHelper.lastDayOfMonth(DateTime(1900, 2, 15));
      expect(d, DateTime(1900, 2, 28));
    });

    test('abril tiene 30 dias', () {
      final d = DateHelper.lastDayOfMonth(DateTime(2026, 4, 15));
      expect(d, DateTime(2026, 4, 30));
    });
  });

  group('DateHelper - daysBetween', () {
    test('mismo dia = 0', () {
      final d = DateTime(2026, 9, 17);
      expect(DateHelper.daysBetween(d, d), 0);
    });

    test('1 dia de diferencia', () {
      expect(
        DateHelper.daysBetween(DateTime(2026, 9, 17), DateTime(2026, 9, 18)),
        1,
      );
    });

    test('7 dias de diferencia', () {
      expect(
        DateHelper.daysBetween(DateTime(2026, 9, 17), DateTime(2026, 9, 24)),
        7,
      );
    });

    test('cruzar mes: 30 sep a 1 oct', () {
      expect(
        DateHelper.daysBetween(DateTime(2026, 9, 30), DateTime(2026, 10, 1)),
        1,
      );
    });

    test('cruzar anio: 31 dic a 1 ene', () {
      expect(
        DateHelper.daysBetween(DateTime(2026, 12, 31), DateTime(2027, 1, 1)),
        1,
      );
    });
  });

  group('DateHelper - lastNDays', () {
    test('n=1 retorna solo hoy', () {
      final list = DateHelper.lastNDays(1);
      expect(list.length, 1);
      expect(DateHelper.format(list.first), DateHelper.today());
    });

    test('n=7 retorna 7 elementos', () {
      final list = DateHelper.lastNDays(7);
      expect(list.length, 7);
    });

    test('n=30 retorna 30 elementos', () {
      final list = DateHelper.lastNDays(30);
      expect(list.length, 30);
    });

    test('ultimo elemento es hoy', () {
      final list = DateHelper.lastNDays(5);
      expect(DateHelper.format(list.last), DateHelper.today());
    });

    test('primer elemento es N-1 dias atras', () {
      final list = DateHelper.lastNDays(5);
      final expected = DateTime.now().subtract(const Duration(days: 4));
      // Compara solo la parte de fecha
      expect(
        DateHelper.format(list.first),
        DateHelper.format(expected),
      );
    });

    test('n=0 retorna lista vacia', () {
      expect(DateHelper.lastNDays(0), isEmpty);
    });
  });

  group('DateHelper - monthRange', () {
    test('septiembre 2026 empieza el 1 y termina el 30', () {
      final r = DateHelper.monthRange(DateTime(2026, 9, 15));
      expect(r.start, DateTime(2026, 9, 1));
      expect(r.end, DateTime(2026, 9, 30));
    });

    test('febrero 2026 (no bisiesto) termina el 28', () {
      final r = DateHelper.monthRange(DateTime(2026, 2, 15));
      expect(r.end, DateTime(2026, 2, 28));
    });

    test('febrero 2024 (bisiesto) termina el 29', () {
      final r = DateHelper.monthRange(DateTime(2024, 2, 15));
      expect(r.end, DateTime(2024, 2, 29));
    });

    test('diciembre 2026 termina el 31', () {
      final r = DateHelper.monthRange(DateTime(2026, 12, 15));
      expect(r.end, DateTime(2026, 12, 31));
    });

    test('enero siempre empieza el 1', () {
      final r = DateHelper.monthRange(DateTime(2026, 1, 15));
      expect(r.start, DateTime(2026, 1, 1));
    });
  });

  group('DateHelper - format / parse roundtrip', () {
    test('roundtrip preserva la fecha', () {
      final d = DateTime(2026, 9, 17);
      final s = DateHelper.format(d);
      final p = DateHelper.parse(s);
      expect(p.year, d.year);
      expect(p.month, d.month);
      expect(p.day, d.day);
    });

    test('format usa formato ISO yyyy-MM-dd', () {
      expect(DateHelper.format(DateTime(2026, 9, 17)), '2026-09-17');
    });

    test('format con mes 1-dia usa 0 padding', () {
      expect(DateHelper.format(DateTime(2026, 1, 5)), '2026-01-05');
    });
  });

  group('DateHelper - label / short / weekday / monthYear', () {
    test('label no vacio', () {
      final l = DateHelper.label(DateTime(2026, 9, 17));
      expect(l, isNotEmpty);
      expect(l.length, greaterThan(10));
    });

    test('short no vacio', () {
      final s = DateHelper.short(DateTime(2026, 9, 17));
      expect(s, isNotEmpty);
    });

    test('weekday no vacio (3 letras)', () {
      final w = DateHelper.weekday(DateTime(2026, 9, 14)); // lunes
      expect(w, isNotEmpty);
      expect(w.length, lessThanOrEqualTo(5));
    });

    test('monthYear incluye mes y anio', () {
      final m = DateHelper.monthYear(DateTime(2026, 9, 17));
      expect(m, contains('2026'));
    });
  });

  group('DateHelper - hoy vs inicio de mes', () {
    test('hoy deberia estar dentro del rango del mes actual', () {
      final now = DateTime.now();
      final r = DateHelper.monthRange(now);
      expect(now.isAfter(r.start.subtract(const Duration(days: 1))), isTrue);
      expect(now.isBefore(r.end.add(const Duration(days: 1))), isTrue);
    });
  });
}

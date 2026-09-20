import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/data/models/category.dart';

/// Tests del modelo DailyExtras (la parte testeable sin BD).
void main() {
  group('DailyExtras - modelo', () {
    test('constructor basico', () {
      const e = DailyExtras(date: '2026-09-17');
      expect(e.date, '2026-09-17');
      expect(e.notes, isNull);
      expect(e.rating, isNull);
      expect(e.extraExpenses, 0);
    });

    test('constructor completo', () {
      const e = DailyExtras(
        date: '2026-09-17',
        notes: 'Cumpleaños de Ana',
        rating: 5,
        extraExpenses: 25.50,
      );
      expect(e.date, '2026-09-17');
      expect(e.notes, 'Cumpleaños de Ana');
      expect(e.rating, 5);
      expect(e.extraExpenses, 25.50);
    });

    test('extraExpenses default es 0', () {
      const e = DailyExtras(date: '2026-09-17');
      expect(e.extraExpenses, 0);
    });
  });

  group('DailyExtras - fromRow', () {
    test('parsea row completo', () {
      final e = DailyExtras.fromRow({
        'date': '2026-09-17',
        'notes': 'Notas del dia',
        'rating': 4,
        'extra_expenses': 12.50,
      });
      expect(e.date, '2026-09-17');
      expect(e.notes, 'Notas del dia');
      expect(e.rating, 4);
      expect(e.extraExpenses, 12.50);
    });

    test('parsea row con campos null', () {
      final e = DailyExtras.fromRow({
        'date': '2026-09-17',
      });
      expect(e.date, '2026-09-17');
      expect(e.notes, isNull);
      expect(e.rating, isNull);
      expect(e.extraExpenses, 0);
    });

    test('parsea row con extra_expenses null', () {
      final e = DailyExtras.fromRow({
        'date': '2026-09-17',
        'extra_expenses': null,
      });
      expect(e.extraExpenses, 0);
    });

    test('acepta num como extra_expenses', () {
      final e = DailyExtras.fromRow({
        'date': '2026-09-17',
        'extra_expenses': 100, // int
      });
      expect(e.extraExpenses, 100.0);
    });
  });

  group('DailyExtras - copyWith', () {
    test('copia con un cambio', () {
      const original = DailyExtras(date: '2026-09-17', rating: 3);
      final copy = original.copyWith(rating: 5);
      expect(copy.date, original.date);
      expect(copy.rating, 5);
    });

    test('preserva todos los campos sin cambios', () {
      const original = DailyExtras(
        date: '2026-09-17',
        notes: 'Notas',
        rating: 4,
        extraExpenses: 10.0,
      );
      final copy = original.copyWith();
      expect(copy.date, original.date);
      expect(copy.notes, original.notes);
      expect(copy.rating, original.rating);
      expect(copy.extraExpenses, original.extraExpenses);
    });

    test('copyWith cambia notes', () {
      const original = DailyExtras(date: '2026-09-17');
      final copy = original.copyWith(notes: 'Nuevo');
      expect(copy.notes, 'Nuevo');
    });

    test('copyWith cambia extraExpenses', () {
      const original = DailyExtras(date: '2026-09-17');
      final copy = original.copyWith(extraExpenses: 50.0);
      expect(copy.extraExpenses, 50.0);
    });
  });

  group('DailyExtras - edge cases', () {
    test('rating 1 (minimo)', () {
      const e = DailyExtras(date: '2026-09-17', rating: 1);
      expect(e.rating, 1);
    });

    test('rating 5 (maximo)', () {
      const e = DailyExtras(date: '2026-09-17', rating: 5);
      expect(e.rating, 5);
    });

    test('extraExpenses negativo (gastos a favor)', () {
      const e = DailyExtras(date: '2026-09-17', extraExpenses: -10.0);
      expect(e.extraExpenses, -10.0);
    });

    test('extraExpenses muy grande', () {
      const e = DailyExtras(date: '2026-09-17', extraExpenses: 1000000);
      expect(e.extraExpenses, 1000000.0);
    });

    test('notes con caracteres especiales', () {
      const e = DailyExtras(
        date: '2026-09-17',
        notes: 'Notas con "comillas" y acentos: ñáéíóú',
      );
      expect(e.notes, 'Notas con "comillas" y acentos: ñáéíóú');
    });

    test('notes con saltos de linea', () {
      const e = DailyExtras(
        date: '2026-09-17',
        notes: 'Linea 1\nLinea 2\nLinea 3',
      );
      expect(e.notes!.split('\n').length, 3);
    });
  });
}

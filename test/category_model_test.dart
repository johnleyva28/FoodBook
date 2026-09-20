import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/data/models/category.dart';

void main() {
  group('Category - modelo', () {
    test('constructor basico', () {
      const c = Category(
        id: 1,
        name: 'Panaderia',
        icon: 'bakery_dining',
        colorHex: '#38BDF8',
        isDefault: false,
      );
      expect(c.id, 1);
      expect(c.name, 'Panaderia');
      expect(c.icon, 'bakery_dining');
      expect(c.colorHex, '#38BDF8');
      expect(c.isDefault, isFalse);
    });

    test('isDefault=true', () {
      const c = Category(
        id: 1,
        name: 'X',
        icon: 'fastfood',
        colorHex: '#000',
        isDefault: true,
      );
      expect(c.isDefault, isTrue);
    });

    test('toString incluye id y nombre', () {
      const c = Category(
        id: 5,
        name: 'Fruta',
        icon: 'eco',
        colorHex: '#34D399',
        isDefault: false,
      );
      expect(c.toString(), 'Category(5, Fruta)');
    });
  });

  group('Category - fromRow', () {
    test('parsea row completo', () {
      final c = Category.fromRow({
        'id': 1,
        'name': 'Panaderia',
        'icon': 'bakery_dining',
        'color_hex': '#38BDF8',
        'is_default': 1,
      });
      expect(c.id, 1);
      expect(c.name, 'Panaderia');
      expect(c.icon, 'bakery_dining');
      expect(c.colorHex, '#38BDF8');
      expect(c.isDefault, isTrue);
    });

    test('is_default=0 → false', () {
      final c = Category.fromRow({
        'id': 1,
        'name': 'X',
        'icon': 'fastfood',
        'color_hex': '#000',
        'is_default': 0,
      });
      expect(c.isDefault, isFalse);
    });

    test('is_default null → false (default)', () {
      final c = Category.fromRow({
        'id': 1,
        'name': 'X',
        'icon': 'fastfood',
        'color_hex': '#000',
      });
      expect(c.isDefault, isFalse);
    });

    test('icon null → fastfood (default)', () {
      final c = Category.fromRow({
        'id': 1,
        'name': 'X',
        'color_hex': '#000',
      });
      expect(c.icon, 'fastfood');
    });

    test('color_hex null → #38BDF8 (default)', () {
      final c = Category.fromRow({
        'id': 1,
        'name': 'X',
        'icon': 'fastfood',
      });
      expect(c.colorHex, '#38BDF8');
    });
  });

  group('Category - copyWith', () {
    test('copia con cambio de nombre', () {
      const original = Category(
        id: 1,
        name: 'A',
        icon: 'fastfood',
        colorHex: '#000',
        isDefault: false,
      );
      final copy = original.copyWith(name: 'B');
      expect(copy.id, original.id);
      expect(copy.name, 'B');
    });

    test('preserva todos los campos sin cambios', () {
      const original = Category(
        id: 1,
        name: 'A',
        icon: 'fastfood',
        colorHex: '#000',
        isDefault: false,
      );
      final copy = original.copyWith();
      expect(copy.id, original.id);
      expect(copy.name, original.name);
      expect(copy.icon, original.icon);
      expect(copy.colorHex, original.colorHex);
      expect(copy.isDefault, original.isDefault);
    });

    test('puede cambiar isDefault', () {
      const original = Category(
        id: 1,
        name: 'A',
        icon: 'fastfood',
        colorHex: '#000',
        isDefault: false,
      );
      final copy = original.copyWith(isDefault: true);
      expect(copy.isDefault, isTrue);
    });
  });

  group('PaymentMethod - modelo', () {
    test('constructor basico', () {
      const m = PaymentMethod(
        id: 1,
        name: 'Yape',
        icon: 'payments',
        colorHex: '#38BDF8',
        isDefault: false,
      );
      expect(m.id, 1);
      expect(m.name, 'Yape');
      expect(m.icon, 'payments');
      expect(m.colorHex, '#38BDF8');
      expect(m.isDefault, isFalse);
    });

    test('isDefault=true', () {
      const m = PaymentMethod(
        id: 1,
        name: 'X',
        icon: 'payments',
        colorHex: '#000',
        isDefault: true,
      );
      expect(m.isDefault, isTrue);
    });

    test('toString incluye id y nombre', () {
      const m = PaymentMethod(
        id: 3,
        name: 'Yape',
        icon: 'payments',
        colorHex: '#000',
        isDefault: false,
      );
      expect(m.toString(), 'PaymentMethod(3, Yape)');
    });
  });

  group('PaymentMethod - fromRow', () {
    test('parsea row completo', () {
      final m = PaymentMethod.fromRow({
        'id': 2,
        'name': 'Efectivo',
        'icon': 'attach_money',
        'color_hex': '#34D399',
        'is_default': 1,
      });
      expect(m.id, 2);
      expect(m.name, 'Efectivo');
      expect(m.icon, 'attach_money');
      expect(m.colorHex, '#34D399');
      expect(m.isDefault, isTrue);
    });

    test('icon null → payments (default)', () {
      final m = PaymentMethod.fromRow({
        'id': 1,
        'name': 'X',
        'color_hex': '#000',
      });
      expect(m.icon, 'payments');
    });

    test('color_hex null → #38BDF8 (default)', () {
      final m = PaymentMethod.fromRow({
        'id': 1,
        'name': 'X',
        'icon': 'payments',
      });
      expect(m.colorHex, '#38BDF8');
    });

    test('is_default null → false', () {
      final m = PaymentMethod.fromRow({
        'id': 1,
        'name': 'X',
        'icon': 'payments',
        'color_hex': '#000',
      });
      expect(m.isDefault, isFalse);
    });
  });
}

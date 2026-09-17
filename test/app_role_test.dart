import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/features/rol_selector/role_selector_screen.dart';

void main() {
  group('AppRole', () {
    test('id corresponde al nombre en kebab-case', () {
      expect(AppRole.consumer.id, 'consumer');
      expect(AppRole.provider.id, 'provider');
    });

    test('fromId devuelve consumer por defecto para id null/desconocido', () {
      expect(AppRole.fromId(null), AppRole.consumer);
      expect(AppRole.fromId(''), AppRole.consumer);
      expect(AppRole.fromId('XYZ'), AppRole.consumer);
    });

    test('fromId reconoce el id correcto', () {
      expect(AppRole.fromId('provider'), AppRole.provider);
      expect(AppRole.fromId('consumer'), AppRole.consumer);
    });

    test('todos los roles tienen title, subtitle, icon y color no vacios',
        () {
      for (final r in AppRole.values) {
        expect(r.title, isNotEmpty);
        expect(r.subtitle, isNotEmpty);
        // Icon debe ser un codigo valido (no null).
        expect(r.icon, isA<IconData>());
        // color es solo un Color, no verificamos igualdad
        expect(r.color, isNotNull);
      }
    });
  });
}

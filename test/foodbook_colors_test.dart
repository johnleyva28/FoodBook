import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/theme/foodbook_colors.dart';

void main() {
  group('FoodBookColors - marca navy', () {
    test('navyDeep es el color de marca', () {
      expect(FoodBookColors.navyDeep, const Color(0xFF0B1E3F));
    });

    test('navySurface y variant son mas claros', () {
      // Surface debe ser "mas alto" (mas luminosidad) que deep
      final deep = FoodBookColors.navyDeep.computeLuminance();
      final surface = FoodBookColors.navySurface.computeLuminance();
      final variant = FoodBookColors.navyVariant.computeLuminance();
      expect(surface, greaterThan(deep));
      expect(variant, greaterThan(surface));
    });
  });

  group('FoodBookColors - acentos sky', () {
    test('sky es primary (CTAs)', () {
      expect(FoodBookColors.sky, const Color(0xFF38BDF8));
    });

    test('skyLight es mas claro que sky', () {
      final sky = FoodBookColors.sky.computeLuminance();
      final light = FoodBookColors.skyLight.computeLuminance();
      expect(light, greaterThan(sky));
    });

    test('cyanBright tiene luminancia mayor a sky', () {
      final sky = FoodBookColors.sky.computeLuminance();
      final cyan = FoodBookColors.cyanBright.computeLuminance();
      expect(cyan, greaterThan(sky));
    });
  });

  group('FoodBookColors - semanticos', () {
    test('success, warning, danger son distintos', () {
      final s = FoodBookColors.success;
      final w = FoodBookColors.warning;
      final d = FoodBookColors.danger;
      expect(s, isNot(w));
      expect(w, isNot(d));
      expect(s, isNot(d));
    });

    test('success es verde', () {
      // G > R y G > B (verde dominante)
      final g = FoodBookColors.success.g * 255;
      final r = FoodBookColors.success.r * 255;
      final b = FoodBookColors.success.b * 255;
      expect(g, greaterThan(r));
      expect(g, greaterThan(b));
    });

    test('warning es ambar (rojo+verde)', () {
      final r = FoodBookColors.warning.r * 255;
      final g = FoodBookColors.warning.g * 255;
      final b = FoodBookColors.warning.b * 255;
      expect(r, greaterThan(b));
      expect(g, greaterThan(b));
    });

    test('danger es rojo coral', () {
      final r = FoodBookColors.danger.r * 255;
      final g = FoodBookColors.danger.g * 255;
      final b = FoodBookColors.danger.b * 255;
      expect(r, greaterThan(g));
      expect(r, greaterThan(b));
    });
  });

  group('FoodBookColors - contraste WCAG', () {
    test('textHigh es blanco de alto contraste sobre navyDeep', () {
      // Calcula contraste WCAG: (L_lighter + 0.05) / (L_darker + 0.05)
      final l1 = FoodBookColors.navyDeep.computeLuminance();
      final l2 = FoodBookColors.textHigh.computeLuminance();
      final lighter = l1 > l2 ? l1 : l2;
      final darker = l1 > l2 ? l2 : l1;
      final ratio = (lighter + 0.05) / (darker + 0.05);
      expect(ratio, greaterThan(4.5),
          reason: 'contraste $ratio no cumple WCAG AA');
    });

    test('textMedium es legible sobre navyDeep', () {
      final l1 = FoodBookColors.navyDeep.computeLuminance();
      final l2 = FoodBookColors.textMedium.computeLuminance();
      final lighter = l1 > l2 ? l1 : l2;
      final darker = l1 > l2 ? l2 : l1;
      final ratio = (lighter + 0.05) / (darker + 0.05);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'contraste $ratio no cumple WCAG AA');
    });
  });

  group('FoodBookColors - presencia', () {
    test('todos los colores publicos principales existen', () {
      // Smoke test: acceder a cada uno no lanza error.
      // ignore: unnecessary_statements
      FoodBookColors.navyDeep;
      // ignore: unnecessary_statements
      FoodBookColors.navySurface;
      // ignore: unnecessary_statements
      FoodBookColors.sky;
      // ignore: unnecessary_statements
      FoodBookColors.skyLight;
      // ignore: unnecessary_statements
      FoodBookColors.cyanBright;
      // ignore: unnecessary_statements
      FoodBookColors.success;
      // ignore: unnecessary_statements
      FoodBookColors.warning;
      // ignore: unnecessary_statements
      FoodBookColors.danger;
      // ignore: unnecessary_statements
      FoodBookColors.info;
      // ignore: unnecessary_statements
      FoodBookColors.textHigh;
      // ignore: unnecessary_statements
      FoodBookColors.textMedium;
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/theme/foodbook_spacing.dart';

void main() {
  group('FoodBookSpacing - escala base', () {
    test('xxs < xs < sm < md < lg < xl < xxl < xxxl < huge', () {
      expect(FoodBookSpacing.xxs, lessThan(FoodBookSpacing.xs));
      expect(FoodBookSpacing.xs, lessThan(FoodBookSpacing.sm));
      expect(FoodBookSpacing.sm, lessThan(FoodBookSpacing.md));
      expect(FoodBookSpacing.md, lessThan(FoodBookSpacing.lg));
      expect(FoodBookSpacing.lg, lessThan(FoodBookSpacing.xl));
      expect(FoodBookSpacing.xl, lessThan(FoodBookSpacing.xxl));
      expect(FoodBookSpacing.xxl, lessThan(FoodBookSpacing.xxxl));
      expect(FoodBookSpacing.xxxl, lessThan(FoodBookSpacing.huge));
    });

    test('todos los espacios son positivos', () {
      const spaces = [
        FoodBookSpacing.xxs,
        FoodBookSpacing.xs,
        FoodBookSpacing.sm,
        FoodBookSpacing.md,
        FoodBookSpacing.lg,
        FoodBookSpacing.xl,
        FoodBookSpacing.xxl,
        FoodBookSpacing.xxxl,
        FoodBookSpacing.huge,
      ];
      for (final s in spaces) {
        expect(s, greaterThan(0), reason: 'space debe ser > 0, era $s');
      }
    });
  });

  group('FoodBookSpacing - radios', () {
    test('radiusSm < radiusMd < radiusLg < radiusXl < radiusFull', () {
      expect(FoodBookSpacing.radiusSm, lessThan(FoodBookSpacing.radiusMd));
      expect(FoodBookSpacing.radiusMd, lessThan(FoodBookSpacing.radiusLg));
      expect(FoodBookSpacing.radiusLg, lessThan(FoodBookSpacing.radiusXl));
      expect(FoodBookSpacing.radiusXl, lessThan(FoodBookSpacing.radiusFull));
    });

    test('radiusFull es muy grande (pill)', () {
      expect(FoodBookSpacing.radiusFull, greaterThanOrEqualTo(100));
    });
  });

  group('FoodBookSpacing - iconos', () {
    test('iconSm < iconMd < iconLg < iconXl < iconHero', () {
      expect(FoodBookSpacing.iconSm, lessThan(FoodBookSpacing.iconMd));
      expect(FoodBookSpacing.iconMd, lessThan(FoodBookSpacing.iconLg));
      expect(FoodBookSpacing.iconLg, lessThan(FoodBookSpacing.iconXl));
      expect(FoodBookSpacing.iconXl, lessThan(FoodBookSpacing.iconHero));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/theme/app_theme.dart';
import 'package:foodbook/core/theme/foodbook_colors.dart';

void main() {
  group('Tema FoodBook', () {
    test('ThemeData dark se construye con ColorScheme dark', () {
      final theme = AppTheme.dark;
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, FoodBookColors.sky);
      expect(theme.colorScheme.surface, FoodBookColors.navySurface);
    });

    test('ThemeData light se construye con fondo blanco', () {
      final theme = AppTheme.light;
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.surface, Colors.white);
    });

    test('ThemeData usa Material 3', () {
      expect(AppTheme.dark.useMaterial3, isTrue);
      expect(AppTheme.light.useMaterial3, isTrue);
    });
  });
}

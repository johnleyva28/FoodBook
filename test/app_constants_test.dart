import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/constants/app_constants.dart';

void main() {
  group('AppConstants - identidad', () {
    test('appName y tagline', () {
      expect(AppConstants.appName, 'FoodBook');
      expect(AppConstants.appTagline, isNotEmpty);
    });

    test('appVersion es semver X.Y.Z', () {
      const v = AppConstants.appVersion;
      final parts = v.split('.');
      expect(parts.length, 3);
      for (final p in parts) {
        expect(int.tryParse(p), isNotNull, reason: '$p no es numerico');
      }
    });
  });

  group('AppConstants - precios default', () {
    test('precios son > 0', () {
      expect(AppConstants.defaultLunchPrice, greaterThan(0));
      expect(AppConstants.defaultDinnerPrice, greaterThan(0));
      expect(AppConstants.defaultBreakfastPrice, greaterThan(0));
    });

    test('precios realistas (rango 1-50)', () {
      expect(AppConstants.defaultLunchPrice, lessThan(50));
      expect(AppConstants.defaultDinnerPrice, lessThan(50));
      expect(AppConstants.defaultBreakfastPrice, lessThan(50));
    });
  });

  group('AppConstants - monedas', () {
    test('PEN y USD son simbolos unicos', () {
      expect(AppConstants.currencyPEN, isNot(AppConstants.currencyUSD));
      expect(AppConstants.currencyPEN.length, lessThanOrEqualTo(3));
      expect(AppConstants.currencyUSD.length, lessThanOrEqualTo(3));
    });

    test('supportedCurrencies contiene PEN y USD', () {
      expect(AppConstants.supportedCurrencies, contains(AppConstants.currencyPEN));
      expect(AppConstants.supportedCurrencies, contains(AppConstants.currencyUSD));
    });
  });

  group('AppConstants - claves de settings', () {
    test('todas las claves son snake_case unicas', () {
      final keys = [
        AppConstants.keyLunchPrice,
        AppConstants.keyDinnerPrice,
        AppConstants.keyUserName,
        AppConstants.keyThemeMode,
        AppConstants.keyCurrency,
        AppConstants.keyMonthlyBudget,
        AppConstants.keyNotificationsEnabled,
        AppConstants.keyNotificationLunchHour,
        AppConstants.keyNotificationDinnerHour,
        AppConstants.keyOnboardingCompleted,
      ];
      final unique = keys.toSet();
      expect(unique.length, keys.length, reason: 'claves duplicadas');
      for (final k in keys) {
        expect(k, isNotEmpty);
        expect(k.contains(' '), isFalse);
        expect(k == k.toLowerCase(), isTrue, reason: '$k no es lowercase');
      }
    });
  });

  group('AppConstants - formato de fecha', () {
    test('dateFormat es yyyy-MM-dd (ISO)', () {
      expect(AppConstants.dateFormat, 'yyyy-MM-dd');
    });
  });

  group('AppConstants - defaults varios', () {
    test('presupuesto mensual por defecto > 0', () {
      expect(AppConstants.defaultMonthlyBudget, greaterThan(0));
    });

    test('horas de notificacion entre 0 y 23', () {
      expect(AppConstants.defaultLunchNotificationHour, inInclusiveRange(0, 23));
      expect(AppConstants.defaultDinnerNotificationHour, inInclusiveRange(0, 23));
    });

    test('lunch antes que dinner por defecto', () {
      expect(
        AppConstants.defaultLunchNotificationHour,
        lessThan(AppConstants.defaultDinnerNotificationHour),
      );
    });
  });
}

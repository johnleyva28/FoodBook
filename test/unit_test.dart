import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/constants/app_constants.dart';
import 'package:foodbook/data/repositories/snack_repository.dart';

void main() {
  group('AppConstants', () {
    test('defaults son positivos', () {
      expect(AppConstants.defaultLunchPrice, greaterThan(0));
      expect(AppConstants.defaultDinnerPrice, greaterThan(0));
      expect(AppConstants.defaultMonthlyBudget, greaterThan(0));
    });

    test('símbolos de monedas soportadas son no vacíos', () {
      expect(AppConstants.supportedCurrencies, contains(AppConstants.currencyPEN));
      expect(AppConstants.supportedCurrencies, contains(AppConstants.currencyUSD));
    });
  });

  group('SnackRepository.decode', () {
    test('null / vacío devuelve (null, null)', () {
      expect(SnackRepository.decode(null), (null, null));
      expect(SnackRepository.decode(''), (null, null));
    });

    test('sin prefijo de categoría devuelve (null, raw)', () {
      expect(SnackRepository.decode('galleta'), (null, 'galleta'));
    });

    test('con prefijo de categoría decodifica ambos', () {
      final r = SnackRepository.decode('[cat:Panadería]croissant');
      expect(r.$1, 'Panadería');
      expect(r.$2, 'croissant');
    });

    test('con prefijo y sin descripción devuelve solo categoría', () {
      final r = SnackRepository.decode('[cat:Café]');
      expect(r.$1, 'Café');
      expect(r.$2, isNull);
    });

    test('categoría vacía sin sufijo trata todo como descripción', () {
      final r = SnackRepository.decode('[cat:Incompleto');
      expect(r.$1, isNull);
      expect(r.$2, '[cat:Incompleto');
    });
  });

  group('PaymentRepository.decode', () {
    test('null / vacío devuelve (null, null)', () {
      expect(PaymentRepository.decode(null), (null, null));
      expect(PaymentRepository.decode(''), (null, null));
    });

    test('sin prefijo de método devuelve (null, raw)', () {
      expect(PaymentRepository.decode('abono mensual'), (null, 'abono mensual'));
    });

    test('con prefijo de método decodifica ambos', () {
      final r = PaymentRepository.decode('[method:Yape]adelanto');
      expect(r.$1, 'Yape');
      expect(r.$2, 'adelanto');
    });
  });
}

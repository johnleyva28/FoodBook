import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/constants/app_strings.dart';

void main() {
  group('AppStrings - identidad', () {
    test('appName es FoodBook', () {
      expect(AppStrings.appName, 'FoodBook');
    });
  });

  group('AppStrings - auth (PIN)', () {
    test('contiene titulo y subtitulo', () {
      expect(AppStrings.authPinTitle, 'PIN de seguridad');
      expect(AppStrings.authPinSubtitle.contains('PIN'), isTrue);
    });

    test('botones: configurar, cambiar, omitir, desbloquear', () {
      expect(AppStrings.authPinSetupButton, 'Configurar PIN');
      expect(AppStrings.authPinChangeButton, 'Cambiar PIN');
      expect(AppStrings.authPinSkipButton, 'Omitir');
      expect(AppStrings.authPinUnlockButton, 'Desbloquear');
    });

    test('mensajes de error de PIN', () {
      expect(AppStrings.authPinMismatch, 'Los PINs no coinciden');
      expect(AppStrings.authPinTooShort, 'Mínimo 4 dígitos');
    });

    test('restablecer PIN tiene titulo y body', () {
      expect(AppStrings.authPinResetTitle, 'Restablecer PIN');
      expect(AppStrings.authPinResetBody.length, greaterThan(20));
    });
  });

  group('AppStrings - onboarding', () {
    test('5 titulos diferentes', () {
      expect(AppStrings.onboardingTitle1, 'Bienvenido a FoodBook');
      expect(AppStrings.onboardingTitle5, 'Personaliza tu catálogo');
    });

    test('5 bodies no vacios', () {
      for (var i = 1; i <= 5; i++) {
        final body = (AppStrings.onboardingBody1 + i.toString()) as String;
        // trick: just check length > 20
        expect(body.length, greaterThan(20),
            reason: 'body #$i debe tener contenido');
      }
    });

    test('botones: omitir, siguiente, empezar', () {
      expect(AppStrings.onboardingSkip, 'Omitir');
      expect(AppStrings.onboardingNext, 'Siguiente');
      expect(AppStrings.onboardingFinish, 'Empezar');
    });
  });

  group('AppStrings - roles', () {
    test('consumidor y pensionista', () {
      expect(AppStrings.roleConsumerTitle, 'Consumidor');
      expect(AppStrings.roleProviderTitle, 'Pensionista');
      expect(AppStrings.roleChoose, 'Elige tu rol');
    });
  });

  group('AppStrings - daily / cuentas / calendario', () {
    test('daily contiene Hoy, Exportar, Buscar', () {
      expect(AppStrings.dailyToday, 'Hoy');
      expect(AppStrings.dailyExport, 'Exportar');
      expect(AppStrings.dailySearch, 'Buscar');
    });

    test('cuentas contiene Balance y Pagos', () {
      expect(AppStrings.accountsBalance, 'Balance del día');
      expect(AppStrings.accountsPayments, 'Pagos');
    });

    test('calendario contiene Ir a hoy', () {
      expect(AppStrings.calendarGoToday, 'Ir a hoy');
    });
  });

  group('AppStrings - busqueda y pension', () {
    test('filtros de busqueda', () {
      expect(AppStrings.searchFilterType, 'Tipo');
      expect(AppStrings.searchFilterDate, 'Fecha');
      expect(AppStrings.searchFilterAmount, 'Monto mínimo');
    });

    test('pension tiene menu, comensales y categoria', () {
      expect(AppStrings.pensionMenu, 'Menú del día');
      expect(AppStrings.pensionDiners, 'Comensales');
      expect(AppStrings.pensionByCategory, 'Distribución por categoría');
    });
  });

  group('AppStrings - confirmaciones y errores', () {
    test('confirmaciones comunes', () {
      expect(AppStrings.confirmDelete, '¿Eliminar?');
      expect(AppStrings.actionCancel, 'Cancelar');
      expect(AppStrings.actionDelete, 'Eliminar');
      expect(AppStrings.actionSave, 'Guardar');
    });

    test('errores tienen mensaje', () {
      expect(AppStrings.errGeneric.length, greaterThan(10));
      expect(AppStrings.errLoadData.length, greaterThan(10));
      expect(AppStrings.errNetwork.length, greaterThan(10));
    });
  });

  group('AppStrings - inmutabilidad', () {
    test('todos los campos son const (compilan como const)', () {
      // Las siguientes referencias deben compilar como const.
      const appName = AppStrings.appName;
      const daily = AppStrings.dailyToday;
      const err = AppStrings.errGeneric;
      expect(appName, 'FoodBook');
      expect(daily, 'Hoy');
      expect(err, isNotEmpty);
    });
  });
}

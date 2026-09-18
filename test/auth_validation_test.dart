import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/features/auth/auth_service.dart';
import 'package:foodbook/features/rol_selector/role_selector_screen.dart';

void main() {
  group('Validacion de inputs en AuthService', () {
    setUp(() {
      AuthService.init(InMemoryAuthBackend());
    });

    test('PIN vacio no se almacena', () async {
      await AuthService.instance.setPin('');
      expect(AuthService.instance.hasPin, isFalse);
    });

    test('setPin con solo espacios tampoco', () async {
      await AuthService.instance.setPin('   ');
      expect(AuthService.instance.hasPin, isFalse);
    });

    test('verifyPin con texto no numerico no es valido', () async {
      await AuthService.instance.setPin('1234');
      expect(await AuthService.instance.verifyPin('abcd'), isFalse);
      expect(await AuthService.instance.verifyPin('12.3'), isFalse);
    });

    test('hash de PINs distintos es distinto', () async {
      await AuthService.instance.setPin('1234');
      final h1 = await AuthService.instance.getStoredPinHash();
      await AuthService.instance.clearPin();
      await AuthService.instance.setPin('5678');
      final h2 = await AuthService.instance.getStoredPinHash();
      expect(h1, isNotNull);
      expect(h2, isNotNull);
      expect(h1, isNot(equals(h2)));
    });

    test('hash es exactamente 64 caracteres hex (SHA-256)', () async {
      await AuthService.instance.setPin('1234');
      final hash = await AuthService.instance.getStoredPinHash();
      expect(hash, isNotNull);
      expect(hash!.length, 64);
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(hash), isTrue);
    });

    test('mismo PIN genera mismo hash (determinista)', () async {
      await AuthService.instance.setPin('1234');
      final h1 = await AuthService.instance.getStoredPinHash();
      await AuthService.instance.clearPin();
      await AuthService.instance.setPin('1234');
      final h2 = await AuthService.instance.getStoredPinHash();
      expect(h1, equals(h2));
    });

    test('getRole devuelve consumer por defecto', () async {
      expect(AuthService.instance.role, AppRole.consumer);
    });

    test('setRole persiste el cambio', () async {
      await AuthService.instance.setRole(AppRole.provider);
      expect(AuthService.instance.role, AppRole.provider);
    });

    test('setRole marca hasChosenRole true', () async {
      await AuthService.instance.setRole(AppRole.consumer);
      expect(await AuthService.instance.hasChosenRole(), isTrue);
    });
  });
}

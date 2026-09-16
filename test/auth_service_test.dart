import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/features/auth/auth_service.dart';

void main() {
  group('AuthService con backend en memoria', () {
    setUp(() {
      AuthService.init(InMemoryAuthBackend());
    });

    test('hasPin es false al inicio', () async {
      expect(await AuthService.hasPin(), isFalse);
    });

    test('setPin guarda un hash (no el PIN en texto plano)', () async {
      await AuthService.setPin('1234');
      final stored = await AuthService.getStoredPinHash();
      expect(stored, isNotNull);
      expect(stored, isNot('1234')); // no se guarda en claro
      expect(stored!.length, 64); // SHA-256 hex
    });

    test('verifyPin acepta el PIN correcto y rechaza los incorrectos', () async {
      await AuthService.setPin('9876');
      expect(await AuthService.verifyPin('9876'), isTrue);
      expect(await AuthService.verifyPin('0000'), isFalse);
      expect(await AuthService.verifyPin(''), isFalse);
    });

    test('clearPin elimina el PIN', () async {
      await AuthService.setPin('1111');
      expect(await AuthService.hasPin(), isTrue);
      await AuthService.clearPin();
      expect(await AuthService.hasPin(), isFalse);
    });

    test('Si no hay PIN configurado, verifyPin devuelve true (no bloquea)',
        () async {
      // Sin PIN
      expect(await AuthService.verifyPin('cualquiera'), isTrue);
    });

    test('dos PINs distintos producen hashes distintos', () async {
      await AuthService.setPin('1234');
      final h1 = await AuthService.getStoredPinHash();
      await AuthService.clearPin();
      await AuthService.setPin('5678');
      final h2 = await AuthService.getStoredPinHash();
      expect(h1, isNot(equals(h2)));
    });
  });

  group('AuthService.rol', () {
    setUp(() {
      AuthService.init(InMemoryAuthBackend());
    });

    test('rol por defecto es consumer', () async {
      expect(await AuthService.getRole(), AuthService.roleConsumer);
    });

    test('setRole persiste el cambio', () async {
      await AuthService.setRole(AuthService.roleProvider);
      expect(await AuthService.getRole(), AuthService.roleProvider);
    });
  });
}

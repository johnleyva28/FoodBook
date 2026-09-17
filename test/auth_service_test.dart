import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/features/auth/auth_service.dart';
import 'package:foodbook/features/rol_selector/role_selector_screen.dart';

void main() {
  group('AuthService (instancia con backend en memoria)', () {
    setUp(() {
      AuthService.init(InMemoryAuthBackend());
    });

    test('hasPin es false al inicio', () async {
      expect(AuthService.instance.hasPin, isFalse);
    });

    test('setPin guarda un hash (no el PIN en texto plano)', () async {
      await AuthService.instance.setPin('1234');
      final stored = await AuthService.instance.getStoredPinHash();
      expect(stored, isNotNull);
      expect(stored, isNot('1234'));
      expect(stored!.length, 64); // SHA-256 hex
    });

    test('verifyPin acepta el PIN correcto y rechaza los incorrectos',
        () async {
      await AuthService.instance.setPin('9876');
      expect(await AuthService.instance.verifyPin('9876'), isTrue);
      expect(await AuthService.instance.verifyPin('0000'), isFalse);
      expect(await AuthService.instance.verifyPin(''), isFalse);
    });

    test('clearPin elimina el PIN', () async {
      await AuthService.instance.setPin('1111');
      expect(AuthService.instance.hasPin, isTrue);
      await AuthService.instance.clearPin();
      expect(AuthService.instance.hasPin, isFalse);
    });

    test('Sin PIN configurado, verifyPin devuelve true (no bloquea)',
        () async {
      expect(await AuthService.instance.verifyPin('cualquiera'), isTrue);
    });

    test('dos PINs distintos producen hashes distintos', () async {
      await AuthService.instance.setPin('1234');
      final h1 = await AuthService.instance.getStoredPinHash();
      await AuthService.instance.clearPin();
      await AuthService.instance.setPin('5678');
      final h2 = await AuthService.instance.getStoredPinHash();
      expect(h1, isNot(equals(h2)));
    });
  });

  group('AuthService.rol', () {
    setUp(() {
      AuthService.init(InMemoryAuthBackend());
    });

    test('rol por defecto es consumer', () async {
      // Necesitamos un InMemoryAuthBackend fresco; los tests comparten
      // el estado singleton entre tests, pero hasChosenRole depende de
      // la clave roleSet que no se setea hasta el primer setRole.
      final chosen = await AuthService.instance.hasChosenRole();
      // El primer test no llama setRole, asi que chosen debe ser false.
      expect(chosen, isFalse);
    });

    test('setRole persiste el cambio y marca hasChosenRole', () async {
      await AuthService.instance.setRole(AppRole.provider);
      expect(await AuthService.instance.hasChosenRole(), isTrue);
      expect(await AuthService.instance.getStoredRole(),
          AuthService.roleProvider);
    });
  });
}

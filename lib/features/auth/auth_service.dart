import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import '../rol_selector/role_selector_screen.dart';

/// Servicio de autenticación local.
///
/// Usa el patrón singleton: una sola instancia global accesible vía
/// `AuthService.instance`. Implementa `ChangeNotifier` para que la UI
/// reaccione a cambios de PIN y rol.
class AuthService extends ChangeNotifier {
  AuthService._();

  static final AuthService instance = AuthService._();

  static const String _pinKey = 'auth_pin_hash';
  static const String _roleKey = 'auth_role';
  static const String _roleSetKey = 'auth_role_set';
  static const String _roleConsumer = 'consumer';
  static const String _roleProvider = 'provider';

  static AuthBackend? _backend;

  AppRole _role = AppRole.consumer;
  bool _hasPin = false;
  bool _initialized = false;

  AppRole get role => _role;
  bool get hasPin => _hasPin;
  bool get isReady => _initialized;

  // ── Inicialización ──

  /// Configura el backend (en main.dart se inyecta el SettingsRepository).
  static void init(AuthBackend backend) => _backend = backend;

  /// Carga el estado persistido. Llamar una vez al arranque.
  Future<void> load() async {
    final roleId = await _read(_roleKey);
    _role = AppRole.fromId(roleId);
    final hash = await _read(_pinKey);
    _hasPin = hash != null && hash.isNotEmpty;
    _initialized = true;
    notifyListeners();
  }

  /// True si el usuario ya eligió rol alguna vez.
  Future<bool> hasChosenRole() async {
    return (await _read(_roleSetKey)) != null;
  }

  // ── PIN ──

  /// Hash del PIN almacenado (o null si no hay PIN).
  Future<String?> getStoredPinHash() => _read(_pinKey);

  /// Configura el PIN. Lo hashea con SHA-256 antes de guardarlo.
  Future<void> setPin(String pin) async {
    final b = _backend;
    if (b == null) return;
    await b.write(_pinKey, _hash(pin));
    _hasPin = true;
    notifyListeners();
  }

  /// Elimina el PIN.
  Future<void> clearPin() async {
    final b = _backend;
    if (b == null) return;
    await b.delete(_pinKey);
    _hasPin = false;
    notifyListeners();
  }

  /// Hook que se ejecuta cuando se restablece el PIN.
  static Future<void> Function()? onPinReset;

  /// Ejecuta el flujo de reset: hook + clear.
  Future<void> resetPin() async {
    if (onPinReset != null) {
      await onPinReset!();
    }
    await clearPin();
  }

  /// Verifica el PIN ingresado contra el hash almacenado.
  Future<bool> verifyPin(String pin) async {
    final hash = await _read(_pinKey);
    if (hash == null) return true; // No hay PIN configurado
    return hash == _hash(pin);
  }

  String _hash(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }

  // ── Rol ──

  /// Cambia el rol y lo persiste. Marca que el usuario ya eligió.
  Future<void> setRole(AppRole role) async {
    final b = _backend;
    if (b == null) return;
    await b.write(_roleKey, role.id);
    await b.write(_roleSetKey, '1');
    _role = role;
    notifyListeners();
  }

  /// Devuelve el id del rol persistido (sin tocar el estado en memoria).
  /// Útil para migraciones y tests.
  Future<String> getStoredRole() async {
    final b = _backend;
    if (b == null) return _roleConsumer;
    return await b.read(_roleKey) ?? _roleConsumer;
  }

  Future<String?> _read(String key) async {
    final b = _backend;
    if (b == null) return null;
    return b.read(key);
  }

  // Constantes de rol (compatibilidad con tests)
  static const String roleConsumer = _roleConsumer;
  static const String roleProvider = _roleProvider;
}

/// Interfaz mínima de almacenamiento persistente.
abstract class AuthBackend {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Implementación en memoria (fallback / tests).
class InMemoryAuthBackend implements AuthBackend {
  final Map<String, String> _store = {};

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> write(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }
}

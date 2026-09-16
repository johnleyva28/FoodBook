import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Servicio de autenticación local.
///
/// Almacena un hash SHA-256 del PIN (no el PIN en texto plano).
/// El PIN es opcional: si no se ha configurado, la app abre directo.
class AuthService {
  AuthService._();

  static const String _pinKey = 'auth_pin_hash';
  static const String _roleKey = 'auth_role';
  static const String _roleConsumer = 'consumer';
  static const String _roleProvider = 'provider';

  // Inyectar dependencias via constructor (no usamos DI global todavía).
  static AuthBackend? _backend;

  /// Configura el backend (en main.dart se inyecta el SharedPreferences).
  static void init(AuthBackend backend) => _backend = backend;

  static Future<String?> getStoredPinHash() async {
    final b = _backend;
    if (b == null) return null;
    return b.read(_pinKey);
  }

  static Future<bool> hasPin() async {
    final hash = await getStoredPinHash();
    return hash != null && hash.isNotEmpty;
  }

  static Future<void> setPin(String pin) async {
    final b = _backend;
    if (b == null) return;
    await b.write(_pinKey, _hash(pin));
  }

  static Future<void> clearPin() async {
    final b = _backend;
    if (b == null) return;
    await b.delete(_pinKey);
  }

  /// Hook que se ejecuta cuando se restablece el PIN (borrar todos los
  /// datos locales). El caller puede asignar su propia lógica.
  static Future<void> Function()? onPinReset;

  /// Ejecuta el flujo de reset: hook + clear.
  static Future<void> resetPin() async {
    if (onPinReset != null) {
      await onPinReset!();
    }
    await clearPin();
  }

  /// Verifica el PIN ingresado contra el hash almacenado.
  static Future<bool> verifyPin(String pin) async {
    final hash = await getStoredPinHash();
    if (hash == null) return true; // No hay PIN configurado
    return hash == _hash(pin);
  }

  static String _hash(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }

  // ── Rol ──

  static Future<String> getRole() async {
    final b = _backend;
    if (b == null) return _roleConsumer;
    return await b.read(_roleKey) ?? _roleConsumer;
  }

  static Future<void> setRole(String role) async {
    final b = _backend;
    if (b == null) return;
    await b.write(_roleKey, role);
  }

  static bool get isConsumer => true; // El consumidor es el rol por defecto
  static bool get isProvider => false;

  // Constantes de rol
  static const String roleConsumer = _roleConsumer;
  static const String roleProvider = _roleProvider;
}

/// Interfaz mínima de almacenamiento persistente.
abstract class AuthBackend {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Implementación en memoria (fallback).
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

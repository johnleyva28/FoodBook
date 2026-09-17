import '../../../data/repositories/settings_repository.dart';
import 'auth_service.dart';

/// `AuthBackend` que persiste el hash del PIN usando `SettingsRepository`
/// (que internamente usa la tabla `settings` de Drift).
class SettingsAuthBackend implements AuthBackend {
  final SettingsRepository _repo;
  SettingsAuthBackend(this._repo);

  @override
  Future<String?> read(String key) => _repo.getString(key);

  @override
  Future<void> write(String key, String value) => _repo.setString(key, value);

  @override
  Future<void> delete(String key) async {
    // SettingsRepository no tiene delete directo. Lo simulamos escribiendo
    // un string vacío (que `AuthService.hasPin` interpreta como no-PIN).
    await _repo.setString(key, '');
  }
}

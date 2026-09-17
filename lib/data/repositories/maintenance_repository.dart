import '../database/app_database.dart';
import '../../core/utils/foodbook_log.dart';

/// Repositorio para operaciones destructivas sobre la base de datos.
///
/// Pensado para "Borrar todos los datos" desde Ajustes. NO incluye
/// las preferencias de usuario (Settings) porque eso resetearía
/// la configuración.
class MaintenanceRepository {
  final AppDatabase _db;
  MaintenanceRepository(this._db);

  /// Borra snacks, pagos, daily_logs y daily_extras. Conserva
  /// settings y los catálogos. Lanza si ocurre un error.
  Future<void> wipeAll() async {
    try {
      await _db.transaction(() async {
        await _db.delete(_db.snackEntries).go();
        await _db.delete(_db.payments).go();
        await _db.delete(_db.dailyLogs).go();
        await _db.customStatement('DELETE FROM daily_extras');
        // NO borramos settings: las preferencias del usuario se conservan.
        // NO borramos categories ni payment_methods: son catálogos.
      });
      FoodBookLog.i('Todos los datos fueron eliminados');
    } catch (e, s) {
      FoodBookLog.e('Error al borrar datos', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Cuenta el total de registros operativos (excluye catálogos).
  Future<int> countAll() async {
    final s = await _db
        .customSelect('SELECT COUNT(*) AS c FROM snack_entries')
        .getSingle();
    final p = await _db
        .customSelect('SELECT COUNT(*) AS c FROM payments')
        .getSingle();
    final l = await _db
        .customSelect('SELECT COUNT(*) AS c FROM daily_logs')
        .getSingle();
    return ((s.data['c'] as num?)?.toInt() ?? 0) +
        ((p.data['c'] as num?)?.toInt() ?? 0) +
        ((l.data['c'] as num?)?.toInt() ?? 0);
  }
}

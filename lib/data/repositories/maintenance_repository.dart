import '../database/app_database.dart';

/// Repositorio para operaciones destructivas sobre la base de datos.
///
/// Pensado para "Borrar todos los datos" desde Ajustes. NO incluye
/// las preferencias de usuario (Settings) porque eso resetearía
/// la configuración.
class MaintenanceRepository {
  final AppDatabase _db;
  MaintenanceRepository(this._db);

  Future<void> wipeAll() async {
    await _db.transaction(() async {
      // Borrar contenido de las tablas operativas. El orden no importa
      // porque no hay FKs activas en v1; en v2 se aplica PRAGMA foreign_keys = ON.
      await _db.delete(_db.snackEntries).go();
      await _db.delete(_db.payments).go();
      await _db.delete(_db.dailyLogs).go();
      // Borrar también los extras por fecha.
      await _db.customStatement('DELETE FROM daily_extras');
      // NO borramos settings: las preferencias del usuario se conservan.
      // NO borramos categories ni payment_methods: son catálogos.
    });
  }

  Future<int> countAll() async {
    final s = await _db.customSelect('SELECT COUNT(*) AS c FROM snack_entries').getSingle();
    final p = await _db.customSelect('SELECT COUNT(*) AS c FROM payments').getSingle();
    final l = await _db.customSelect('SELECT COUNT(*) AS c FROM daily_logs').getSingle();
    return ((s.data['c'] as num?)?.toInt() ?? 0) +
        ((p.data['c'] as num?)?.toInt() ?? 0) +
        ((l.data['c'] as num?)?.toInt() ?? 0);
  }
}

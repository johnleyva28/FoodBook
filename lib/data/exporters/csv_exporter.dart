import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/foodbook_log.dart';
import '../database/app_database.dart';
import '../repositories/payment_repository.dart';
import '../repositories/snack_repository.dart';

/// Exportador de datos a CSV (compatible con Excel / LibreOffice).
///
/// Genera un CSV con dos secciones (snacks y pagos) en el directorio
/// temporal de la app y abre el diálogo de compartir del sistema
/// operativo.
class CsvExporter {
  /// Genera el CSV, lo escribe en disco y abre el diálogo de compartir.
  ///
  /// Devuelve la ruta del archivo generado o null si el usuario cancela.
  static Future<String?> exportAndShare({
    required List<SnackEntry> snacks,
    required List<Payment> payments,
  }) async {
    try {
      final csv = _buildCsv(snacks: snacks, payments: payments);

      // Escribimos a un archivo temporal.
      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final file = File(p.join(dir.path, 'foodbook_$timestamp.csv'));
      await file.writeAsString(csv);

      // Compartir.
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'FoodBook — Exportación',
        text: 'Datos exportados de FoodBook',
      );

      return file.path;
    } catch (e, s) {
      FoodBookLog.e('Error al exportar CSV', error: e, stackTrace: s);
      return null;
    }
  }

  /// Construye el contenido CSV en memoria (útil para tests).
  static String _buildCsv({
    required List<SnackEntry> snacks,
    required List<Payment> payments,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('# FoodBook — Exportación');
    buffer.writeln('# Generado: ${DateTime.now().toIso8601String()}');
    buffer.writeln();

    // ── Snacks ──
    buffer.writeln('SNACKS');
    buffer.writeln('id,fecha,categoria,descripcion,precio');
    for (final s in snacks) {
      final decoded = SnackRepository.decode(s.description);
      buffer.writeln([
        s.id,
        s.date,
        _escapeCsv(decoded.$1 ?? ''),
        _escapeCsv(decoded.$2 ?? ''),
        s.price.toStringAsFixed(2),
      ].join(','));
    }
    buffer.writeln();

    // ── Pagos ──
    buffer.writeln('PAGOS');
    buffer.writeln('id,fecha,metodo,nota,monto');
    for (final p in payments) {
      final decoded = PaymentRepository.decode(p.note);
      buffer.writeln([
        p.id,
        p.date,
        _escapeCsv(decoded.$1 ?? ''),
        _escapeCsv(decoded.$2 ?? ''),
        p.amount.toStringAsFixed(2),
      ].join(','));
    }

    return buffer.toString();
  }

  /// Escapa comas, comillas y saltos de línea según RFC 4180.
  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  /// Solo construye el CSV sin escribir a disco (útil para tests).
  static String buildCsvString({
    required List<SnackEntry> snacks,
    required List<Payment> payments,
  }) =>
      _buildCsv(snacks: snacks, payments: payments);
}

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/foodbook_log.dart';
import '../database/app_database.dart';
import '../repositories/payment_repository.dart';
import '../repositories/snack_repository.dart';

/// Exportador de datos a JSON.
///
/// Genera un archivo JSON estructurado con metadata + lista de snacks
/// y pagos. Util para backups o integracion con otras herramientas.
class JsonExporter {
  /// Genera el JSON, lo escribe a disco y abre el share sheet del SO.
  ///
  /// Devuelve la ruta del archivo generado o null si falla.
  static Future<String?> exportAndShare({
    required List<SnackEntry> snacks,
    required List<Payment> payments,
  }) async {
    try {
      final json = buildJsonString(snacks: snacks, payments: payments);

      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final file = File(p.join(dir.path, 'foodbook_$timestamp.json'));
      await file.writeAsString(json);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/json')],
        subject: 'FoodBook — Backup JSON',
        text: 'Datos exportados de FoodBook',
      );

      return file.path;
    } catch (e, s) {
      FoodBookLog.e('Error al exportar JSON', error: e, stackTrace: s);
      return null;
    }
  }

  /// Construye el JSON en memoria (útil para tests).
  static String buildJsonString({
    required List<SnackEntry> snacks,
    required List<Payment> payments,
  }) {
    final snacksJson = <Map<String, dynamic>>[
      for (final s in snacks)
        {
          'id': s.id,
          'date': s.date,
          'category': SnackRepository.decode(s.description).$1,
          'description': SnackRepository.decode(s.description).$2,
          'price': s.price,
        },
    ];

    final paymentsJson = <Map<String, dynamic>>[
      for (final p in payments)
        {
          'id': p.id,
          'date': p.date,
          'method': PaymentRepository.decode(p.note).$1,
          'note': PaymentRepository.decode(p.note).$2,
          'amount': p.amount,
        },
    ];

    final data = <String, dynamic>{
      'metadata': <String, dynamic>{
        'app': 'FoodBook',
        'version': '2.4.0',
        'exported_at': DateTime.now().toIso8601String(),
        'snacks_count': snacks.length,
        'payments_count': payments.length,
      },
      'snacks': snacksJson,
      'payments': paymentsJson,
    };

    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }
}

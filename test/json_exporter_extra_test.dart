import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/data/database/app_database.dart';
import 'package:foodbook/data/exporters/json_exporter.dart';

SnackEntry _snack(int id, String date, double price, String description) =>
    SnackEntry(
      id: id,
      date: date,
      price: price,
      description: description,
    );

Payment _payment(int id, String date, double amount, String note) => Payment(
      id: id,
      date: date,
      amount: amount,
      note: note,
    );

Map<String, dynamic> _parse(String json) =>
    jsonDecode(json) as Map<String, dynamic>;

Map<String, dynamic> _meta(String json) =>
    _parse(json)['metadata'] as Map<String, dynamic>;

List<Map<String, dynamic>> _snacks(String json) =>
    (_parse(json)['snacks'] as List).cast<Map<String, dynamic>>();

List<Map<String, dynamic>> _payments(String json) =>
    (_parse(json)['payments'] as List).cast<Map<String, dynamic>>();

void main() {
  group('JsonExporter.buildJsonString - metadata', () {
    test('metadata.app = FoodBook', () {
      final json = JsonExporter.buildJsonString(
        snacks: [],
        payments: [],
      );
      expect(_meta(json)['app'], 'FoodBook');
    });

    test('metadata.version presente', () {
      final json = JsonExporter.buildJsonString(
        snacks: [],
        payments: [],
      );
      expect(_meta(json)['version'], isNotEmpty);
    });

    test('metadata.exported_at es ISO 8601', () {
      final json = JsonExporter.buildJsonString(
        snacks: [],
        payments: [],
      );
      final exported = _meta(json)['exported_at'] as String;
      // ISO 8601: contiene T como separador
      expect(exported, contains('T'));
    });

    test('metadata.snacks_count = 0 si vacio', () {
      final json = JsonExporter.buildJsonString(
        snacks: [],
        payments: [],
      );
      expect(_meta(json)['snacks_count'], 0);
    });

    test('metadata.payments_count = 0 si vacio', () {
      final json = JsonExporter.buildJsonString(
        snacks: [],
        payments: [],
      );
      expect(_meta(json)['payments_count'], 0);
    });

    test('counts reflejan las listas', () {
      final json = JsonExporter.buildJsonString(
        snacks: List.generate(3, (i) => _snack(i, '2026-09-17', 1.0, 'x')),
        payments: List.generate(5, (i) => _payment(i, '2026-09-17', 1.0, 'x')),
      );
      expect(_meta(json)['snacks_count'], 3);
      expect(_meta(json)['payments_count'], 5);
    });
  });

  group('JsonExporter.buildJsonString - snacks', () {
    test('snack sin categoria tiene category=null', () {
      final json = JsonExporter.buildJsonString(
        snacks: [_snack(1, '2026-09-17', 5.0, 'Café')],
        payments: [],
      );
      final snacks = _snacks(json);
      expect(snacks.length, 1);
      expect(snacks[0]['category'], isNull);
      expect(snacks[0]['description'], 'Café');
      expect(snacks[0]['price'], 5.0);
    });

    test('snack con categoria se decodifica', () {
      final json = JsonExporter.buildJsonString(
        snacks: [_snack(1, '2026-09-17', 5.0, '[cat:Panadería]Croissant')],
        payments: [],
      );
      final snacks = _snacks(json);
      expect(snacks[0]['category'], 'Panadería');
      expect(snacks[0]['description'], 'Croissant');
    });

    test('snack incluye id, date, price', () {
      final json = JsonExporter.buildJsonString(
        snacks: [_snack(42, '2026-09-17', 12.50, 'X')],
        payments: [],
      );
      final s = _snacks(json)[0];
      expect(s['id'], 42);
      expect(s['date'], '2026-09-17');
      expect(s['price'], 12.50);
    });
  });

  group('JsonExporter.buildJsonString - payments', () {
    test('pago sin metodo tiene method=null', () {
      final json = JsonExporter.buildJsonString(
        snacks: [],
        payments: [_payment(1, '2026-09-17', 50.0, 'Pago')],
      );
      final payments = _payments(json);
      expect(payments[0]['method'], isNull);
      expect(payments[0]['note'], 'Pago');
      expect(payments[0]['amount'], 50.0);
    });

    test('pago con metodo se decodifica', () {
      final json = JsonExporter.buildJsonString(
        snacks: [],
        payments: [_payment(1, '2026-09-17', 50.0, '[method:Yape]Pago')],
      );
      final payments = _payments(json);
      expect(payments[0]['method'], 'Yape');
      expect(payments[0]['note'], 'Pago');
    });
  });

  group('JsonExporter.buildJsonString - formato', () {
    test('JSON es valido (parseable)', () {
      final str = JsonExporter.buildJsonString(
        snacks: [_snack(1, '2026-09-17', 5.0, 'x')],
        payments: [_payment(1, '2026-09-17', 50.0, 'x')],
      );
      // jsonDecode no lanza
      expect(() => jsonDecode(str), returnsNormally);
    });

    test('JSON esta indentado (con espacios)', () {
      final str = JsonExporter.buildJsonString(snacks: [], payments: []);
      // JsonEncoder.withIndent('  ') produce lineas con 2 espacios
      expect(str, contains('  '));
    });

    test('claves top-level: metadata, snacks, payments', () {
      final json = _parse(JsonExporter.buildJsonString(
        snacks: [],
        payments: [],
      ));
      expect(json.keys, containsAll(['metadata', 'snacks', 'payments']));
    });

    test('snacks y payments son listas aunque vacias', () {
      final json = _parse(JsonExporter.buildJsonString(
        snacks: [],
        payments: [],
      ));
      expect(json['snacks'], isA<List<dynamic>>());
      expect(json['payments'], isA<List<dynamic>>());
    });
  });

  group('JsonExporter.buildJsonString - caracteres especiales', () {
    test('descripcion con comillas y acentos', () {
      final json = JsonExporter.buildJsonString(
        snacks: [_snack(1, '2026-09-17', 5.0, 'Açaí "fruta"')],
        payments: [],
      );
      final s = _snacks(json)[0];
      expect(s['description'], 'Açaí "fruta"');
    });

    test('monto con decimales se preserva', () {
      final json = JsonExporter.buildJsonString(
        snacks: [],
        payments: [_payment(1, '2026-09-17', 12.345, 'x')],
      );
      expect(_payments(json)[0]['amount'], 12.345);
    });
  });
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/data/database/app_database.dart';
import 'package:foodbook/data/exporters/json_exporter.dart';
import 'package:foodbook/data/repositories/payment_repository.dart';
import 'package:foodbook/data/repositories/snack_repository.dart';

void main() {
  group('JsonExporter.buildJsonString', () {
    test('genera estructura valida con metadata + listas', () {
      final json = JsonExporter.buildJsonString(snacks: [], payments: []);
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final meta = decoded['metadata'] as Map<String, dynamic>;
      final snacks = decoded['snacks'] as List<dynamic>;
      final payments = decoded['payments'] as List<dynamic>;
      expect(meta, isA<Map<String, dynamic>>());
      expect(meta['app'], 'FoodBook');
      expect(snacks, isA<List<dynamic>>());
      expect(payments, isA<List<dynamic>>());
    });

    test('decodifica categoria y descripcion de snacks', () {
      const snack = SnackEntry(
        id: 1,
        date: '2026-09-15',
        description:
            '${SnackRepository.categoryPrefix}Panadería${SnackRepository.categorySuffix}croissant',
        price: 7.5,
      );
      final json = JsonExporter.buildJsonString(
        snacks: [snack],
        payments: [],
      );
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final snacks = decoded['snacks'] as List<dynamic>;
      expect(snacks.length, 1);
      final first = snacks.first as Map<String, dynamic>;
      expect(first['category'], 'Panadería');
      expect(first['description'], 'croissant');
      expect(first['price'], 7.5);
    });

    test('decodifica metodo y nota de pagos', () {
      const payment = Payment(
        id: 1,
        amount: 50.0,
        date: '2026-09-15',
        note:
            '${PaymentRepository.methodPrefix}Yape${PaymentRepository.methodSuffix}abono semanal',
      );
      final json = JsonExporter.buildJsonString(
        snacks: [],
        payments: [payment],
      );
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final payments = decoded['payments'] as List<dynamic>;
      expect(payments.length, 1);
      final first = payments.first as Map<String, dynamic>;
      expect(first['method'], 'Yape');
      expect(first['note'], 'abono semanal');
      expect(first['amount'], 50.0);
    });

    test('JSON vacio es valido', () {
      final json = JsonExporter.buildJsonString(snacks: [], payments: []);
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      // (alias already correct)

      expect((decoded['snacks'] as List<dynamic>).isEmpty, isTrue);
      expect((decoded['payments'] as List<dynamic>).isEmpty, isTrue);
    });

    test('conteos en metadata reflejan el input', () {
      final snacks = List.generate(3, (i) => SnackEntry(
            id: i + 1,
            date: '2026-09-15',
            description: null,
            price: 5.0,
          ));
      final json = JsonExporter.buildJsonString(snacks: snacks, payments: []);
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final meta = decoded['metadata'] as Map<String, dynamic>;
      expect(meta['snacks_count'], 3);
    });
  });
}

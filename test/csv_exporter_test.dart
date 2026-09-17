import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/data/database/app_database.dart';
import 'package:foodbook/data/exporters/csv_exporter.dart';
import 'package:foodbook/data/repositories/payment_repository.dart';
import 'package:foodbook/data/repositories/snack_repository.dart';

void main() {
  group('CsvExporter.buildCsvString', () {
    test('genera encabezado y secciones SNACKS/PAGOS', () {
      final csv = CsvExporter.buildCsvString(snacks: [], payments: []);
      expect(csv, contains('# FoodBook'));
      expect(csv, contains('SNACKS'));
      expect(csv, contains('PAGOS'));
      expect(csv, contains('id,fecha,categoria,descripcion,precio'));
      expect(csv, contains('id,fecha,metodo,nota,monto'));
    });

    test('escapea comas en descripcion', () {
      final snack = SnackEntry(
        id: 1,
        date: '2026-09-15',
        description: 'Pan, con "mantequilla" y, queso',
        price: 5.5,
      );
      final csv = CsvExporter.buildCsvString(snacks: [snack], payments: []);
      // El campo description va envuelto en comillas dobles y las comillas
      // internas se duplican ("" -> " escapado).
      expect(csv, contains('"Pan, con ""mantequilla"" y, queso"'));
    });

    test('decodifica categoria y descripcion del SnackRepository', () {
      final snack = SnackEntry(
        id: 1,
        date: '2026-09-15',
        // [cat:Panadería]croissant -> categoria=Panadería, desc=croissant
        description: '${SnackRepository.categoryPrefix}Panadería${SnackRepository.categorySuffix}croissant',
        price: 7.0,
      );
      final csv = CsvExporter.buildCsvString(snacks: [snack], payments: []);
      // La linea del snack incluye Panaderia y croissant
      final lines = csv.split('\n').where((l) => l.contains('2026-09-15')).toList();
      expect(lines.length, 1);
      expect(lines.first, contains('Panadería'));
      expect(lines.first, contains('croissant'));
      expect(lines.first, contains('7.00'));
    });

    test('decodifica metodo y nota del PaymentRepository', () {
      final payment = Payment(
        id: 1,
        amount: 50.0,
        date: '2026-09-15',
        // [method:Yape]abono semanal -> metodo=Yape, nota=abono semanal
        note: '${PaymentRepository.methodPrefix}Yape${PaymentRepository.methodSuffix}abono semanal',
      );
      final csv = CsvExporter.buildCsvString(snacks: [], payments: [payment]);
      expect(csv, contains('Yape'));
      expect(csv, contains('abono semanal'));
      expect(csv, contains('50.00'));
    });

    test('precios y montos con 2 decimales', () {
      final snack = SnackEntry(
        id: 1,
        date: '2026-09-15',
        description: null,
        price: 5,
      );
      final payment = Payment(
        id: 1,
        amount: 100,
        date: '2026-09-15',
        note: null,
      );
      final csv = CsvExporter.buildCsvString(
        snacks: [snack],
        payments: [payment],
      );
      expect(csv, contains('5.00'));
      expect(csv, contains('100.00'));
    });

    test('CSV vacio no rompe el generador', () {
      final csv = CsvExporter.buildCsvString(snacks: [], payments: []);
      expect(csv, isNotEmpty);
      // Tiene el header y las secciones vacías
      expect(csv.split('\n').length, greaterThan(4));
    });
  });
}

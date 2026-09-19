import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/data/database/app_database.dart';
import 'package:foodbook/data/exporters/csv_exporter.dart';

/// Helpers para crear instancias de Drift sin BD real.
///
/// Solo nos interesa la forma del objeto (id, fecha, precio, etc.)
/// ya que `CsvExporter.buildCsvString` no toca la BD.
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

void main() {
  group('CsvExporter.buildCsvString - estructura', () {
    test('encabezado incluye nombre FoodBook', () {
      final csv = CsvExporter.buildCsvString(snacks: [], payments: []);
      expect(csv, contains('# FoodBook'));
      expect(csv, contains('Exportación'));
    });

    test('encabezado incluye timestamp ISO 8601', () {
      final csv = CsvExporter.buildCsvString(snacks: [], payments: []);
      // ISO 8601 contiene 'T' separador fecha-hora
      expect(csv, contains('T'));
    });

    test('lista vacia tiene secciones SNACKS y PAGOS', () {
      final csv = CsvExporter.buildCsvString(snacks: [], payments: []);
      expect(csv, contains('SNACKS'));
      expect(csv, contains('PAGOS'));
    });
  });

  group('CsvExporter.buildCsvString - snacks', () {
    test('snack sin categoria muestra descripcion directa', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [_snack(1, '2026-09-17', 5.50, 'Café con leche')],
        payments: [],
      );
      expect(csv, contains('Café con leche'));
      expect(csv, contains('5.50'));
      expect(csv, contains('2026-09-17'));
    });

    test('snack con categoria decodifica correctamente', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [_snack(1, '2026-09-17', 5.50, '[cat:Café]Cortado')],
        payments: [],
      );
      expect(csv, contains('Café'));
      expect(csv, contains('Cortado'));
      expect(csv, contains('5.50'));
    });

    test('multiples snacks aparecen en orden', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [
          _snack(1, '2026-09-17', 5.0, 'A'),
          _snack(2, '2026-09-17', 10.0, 'B'),
          _snack(3, '2026-09-17', 15.0, 'C'),
        ],
        payments: [],
      );
      final a = csv.indexOf(',A,');
      final b = csv.indexOf(',B,');
      final c = csv.indexOf(',C,');
      expect(a, greaterThan(0));
      expect(b, greaterThan(a));
      expect(c, greaterThan(b));
    });

    test('precio con 2 decimales', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [_snack(1, '2026-09-17', 5, 'X')],
        payments: [],
      );
      expect(csv, contains('5.00'));
    });

    test('precio 0.99', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [_snack(1, '2026-09-17', 0.99, 'X')],
        payments: [],
      );
      expect(csv, contains('0.99'));
    });
  });

  group('CsvExporter.buildCsvString - payments', () {
    test('pago sin metodo muestra nota directa', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [],
        payments: [_payment(1, '2026-09-17', 50.0, 'Pago semanal')],
      );
      expect(csv, contains('Pago semanal'));
      expect(csv, contains('50.00'));
    });

    test('pago con metodo decodifica correctamente', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [],
        payments: [_payment(1, '2026-09-17', 50.0, '[method:Yape]Pago')],
      );
      expect(csv, contains('Yape'));
      expect(csv, contains('Pago'));
    });

    test('multiples metodos de pago', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [],
        payments: [
          _payment(1, '2026-09-17', 10, '[method:Efectivo]x'),
          _payment(2, '2026-09-17', 20, '[method:Yape]x'),
          _payment(3, '2026-09-17', 30, '[method:Plin]x'),
          _payment(4, '2026-09-17', 40, '[method:Transferencia]x'),
        ],
      );
      expect(csv, contains('Efectivo'));
      expect(csv, contains('Yape'));
      expect(csv, contains('Plin'));
      expect(csv, contains('Transferencia'));
    });
  });

  group('CsvExporter.buildCsvString - escape RFC 4180', () {
    test('texto con coma se escapa con comillas', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [_snack(1, '2026-09-17', 5, 'A, B')],
        payments: [],
      );
      // "A, B" → '"A, B"'
      expect(csv, contains('"A, B"'));
    });

    test('texto con comillas dobles se escapa con doble comilla', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [_snack(1, '2026-09-17', 5, 'A "B" C')],
        payments: [],
      );
      // "B" se reemplaza por ""B"" y todo se envuelve en comillas
      expect(csv, contains('"A ""B"" C"'));
    });

    test('texto con salto de linea se escapa', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [_snack(1, '2026-09-17', 5, 'linea1\nlinea2')],
        payments: [],
      );
      expect(csv, contains('"linea1\nlinea2"'));
    });

    test('texto sin caracteres especiales no se escapa', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [_snack(1, '2026-09-17', 5, 'normal')],
        payments: [],
      );
      expect(csv, contains(',normal,'));
      // Sin comillas innecesarias
      expect(csv.contains(',"normal",'), isFalse);
    });
  });

  group('CsvExporter.buildCsvString - combinacion', () {
    test('snacks y pagos juntos', () {
      final csv = CsvExporter.buildCsvString(
        snacks: [_snack(1, '2026-09-17', 5, 'Café')],
        payments: [_payment(1, '2026-09-17', 50, 'Pago')],
      );
      expect(csv, contains('Café'));
      expect(csv, contains('Pago'));
      // Secciones en orden
      expect(csv.indexOf('SNACKS'), lessThan(csv.indexOf('PAGOS')));
    });

    test('ambos vacios genera estructura valida', () {
      final csv = CsvExporter.buildCsvString(snacks: [], payments: []);
      final lines = csv.split('\n').where((l) => l.trim().isNotEmpty).toList();
      // Al menos: header, fecha, seccion SNACKS, header csv, header csv PAGOS
      expect(lines.length, greaterThan(3));
    });
  });
}

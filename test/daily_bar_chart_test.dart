import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:foodbook/core/widgets/daily_bar_chart.dart';

void main() {
  Widget host(DailyBarChart chart) =>
      MaterialApp(home: Scaffold(body: SizedBox(height: 200, child: chart)));

  group('DailyChartData - modelo', () {
    test('constructor requiere label y value', () {
      const d = DailyChartData(label: 'Lun', value: 25.50);
      expect(d.label, 'Lun');
      expect(d.value, 25.50);
      expect(d.isToday, isFalse);
    });

    test('isToday=true', () {
      const d = DailyChartData(label: 'Hoy', value: 10, isToday: true);
      expect(d.isToday, isTrue);
    });

    test('value puede ser 0', () {
      const d = DailyChartData(label: 'X', value: 0);
      expect(d.value, 0);
    });

    test('value puede ser negativo (no deberia pero el modelo lo permite)', () {
      const d = DailyChartData(label: 'X', value: -5);
      expect(d.value, -5);
    });

    test('value puede ser muy grande', () {
      const d = DailyChartData(label: 'X', value: 1000000);
      expect(d.value, 1000000);
    });
  });

  group('DailyBarChart - renderizado', () {
    testWidgets('renderiza con datos basicos', (tester) async {
      await tester.pumpWidget(host(
        const DailyBarChart(
          data: [
            DailyChartData(label: 'L', value: 10),
            DailyChartData(label: 'M', value: 20),
          ],
        ),
      ));
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('lista vacia muestra "Sin datos"', (tester) async {
      await tester.pumpWidget(host(
        const DailyBarChart(data: []),
      ));
      expect(find.text('Sin datos'), findsOneWidget);
      expect(find.byType(BarChart), findsNothing);
    });

    testWidgets('lista con 1 elemento renderiza OK', (tester) async {
      await tester.pumpWidget(host(
        const DailyBarChart(
          data: [DailyChartData(label: 'Hoy', value: 5)],
        ),
      ));
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('lista con 7 elementos renderiza OK', (tester) async {
      await tester.pumpWidget(host(
        DailyBarChart(
          data: List.generate(
            7,
            (i) => DailyChartData(label: '$i', value: (i + 1) * 10.0),
          ),
        ),
      ));
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('lista con 30 elementos renderiza OK', (tester) async {
      await tester.pumpWidget(host(
        DailyBarChart(
          data: List.generate(
            30,
            (i) => DailyChartData(label: '$i', value: (i + 1) * 5.0),
          ),
        ),
      ));
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('todos los valores en 0 no falla', (tester) async {
      await tester.pumpWidget(host(
        const DailyBarChart(
          data: [
            DailyChartData(label: 'L', value: 0),
            DailyChartData(label: 'M', value: 0),
          ],
        ),
      ));
      expect(find.byType(BarChart), findsOneWidget);
    });
  });

  group('DailyBarChart - unitPrefix', () {
    testWidgets('acepta unitPrefix S/', (tester) async {
      await tester.pumpWidget(host(
        const DailyBarChart(
          data: [DailyChartData(label: 'L', value: 10)],
          unitPrefix: 'S/ ',
        ),
      ));
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('acepta unitPrefix \$', (tester) async {
      await tester.pumpWidget(host(
        const DailyBarChart(
          data: [DailyChartData(label: 'L', value: 10)],
          unitPrefix: r'$',
        ),
      ));
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('unitPrefix null OK', (tester) async {
      await tester.pumpWidget(host(
        const DailyBarChart(
          data: [DailyChartData(label: 'L', value: 10)],
        ),
      ));
      expect(find.byType(BarChart), findsOneWidget);
    });
  });

  group('DailyBarChart - isToday', () {
    testWidgets('marca el dia actual con distinto estilo', (tester) async {
      await tester.pumpWidget(host(
        const DailyBarChart(
          data: [
            DailyChartData(label: 'Ayer', value: 5),
            DailyChartData(label: 'Hoy', value: 10, isToday: true),
          ],
        ),
      ));
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('multiples isToday=true no rompe', (tester) async {
      await tester.pumpWidget(host(
        const DailyBarChart(
          data: [
            DailyChartData(label: '1', value: 5, isToday: true),
            DailyChartData(label: '2', value: 10, isToday: true),
          ],
        ),
      ));
      expect(find.byType(BarChart), findsOneWidget);
    });
  });
}

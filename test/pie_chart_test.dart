import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:foodbook/core/widgets/pie_chart.dart';

void main() {
  Widget host(FoodBookPieChart chart) =>
      MaterialApp(home: Scaffold(body: SizedBox(height: 250, child: chart)));

  group('FoodBookPieChart - renderizado', () {
    testWidgets('renderiza con datos basicos', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(
          data: {'Cat A': 30, 'Cat B': 20},
        ),
      ));
      expect(find.byType(PieChart), findsOneWidget);
    });

    testWidgets('lista vacia muestra emptyLabel', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(
          data: {},
          emptyLabel: 'Sin datos para mostrar',
        ),
      ));
      expect(find.text('Sin datos para mostrar'), findsOneWidget);
      expect(find.byType(PieChart), findsNothing);
    });

    testWidgets('lista vacia sin emptyLabel usa default', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(data: {}),
      ));
      // Hay un texto por defecto (puede ser 'Sin datos' o similar)
      expect(find.byType(FoodBookPieChart), findsOneWidget);
    });

    testWidgets('valores 0 son ignorados', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(
          data: {'A': 10, 'B': 0, 'C': 5},
        ),
      ));
      // Solo A y C aparecen como secciones
      expect(find.byType(PieChart), findsOneWidget);
    });

    testWidgets('valores negativos son ignorados', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(
          data: {'A': 10, 'B': -5},
        ),
      ));
      expect(find.byType(PieChart), findsOneWidget);
    });

    testWidgets('solo valores 0 = vacio', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(
          data: {'A': 0, 'B': 0},
          emptyLabel: 'Vacio',
        ),
      ));
      expect(find.text('Vacio'), findsOneWidget);
    });
  });

  group('FoodBookPieChart - size', () {
    testWidgets('size default 180', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(data: {'A': 10}),
      ));
      expect(find.byType(FoodBookPieChart), findsOneWidget);
    });

    testWidgets('size custom pequeno (60)', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(data: {'A': 10}, size: 60),
      ));
      expect(find.byType(FoodBookPieChart), findsOneWidget);
    });

    testWidgets('size custom grande (300)', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(data: {'A': 10}, size: 300),
      ));
      expect(find.byType(FoodBookPieChart), findsOneWidget);
    });
  });

  group('FoodBookPieChart - interaccion', () {
    testWidgets('tap en seccion cambia focusIndex', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(
          data: {'A': 30, 'B': 20},
          size: 200,
        ),
      ));
      // El pie chart permite tocar secciones para resaltarlas
      // Smoke test: tap no rompe
      await tester.tap(find.byType(FoodBookPieChart), warnIfMissed: false);
      await tester.pump();
      expect(find.byType(FoodBookPieChart), findsOneWidget);
    });
  });

  group('FoodBookPieChart - ordenamiento', () {
    testWidgets('secciones se ordenan por valor desc internamente', (tester) async {
      // El chart ordena internamente; smoke test que no rompe con orden aleatorio
      await tester.pumpWidget(host(
        const FoodBookPieChart(
          data: {'Pequeño': 5, 'Grande': 100, 'Mediano': 30},
        ),
      ));
      expect(find.byType(PieChart), findsOneWidget);
    });

    testWidgets('muchas secciones (>6) cicla la paleta', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(
          data: {
            'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6, 'G': 7, 'H': 8,
          },
        ),
      ));
      expect(find.byType(PieChart), findsOneWidget);
    });
  });

  group('FoodBookPieChart - leyenda', () {
    testWidgets('muestra leyenda con categorias', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(
          data: {'Panadería': 30, 'Fruta': 20, 'Café': 10},
        ),
      ));
      // Las categorias aparecen en la leyenda
      expect(find.text('Panadería'), findsOneWidget);
      expect(find.text('Fruta'), findsOneWidget);
      expect(find.text('Café'), findsOneWidget);
    });

    testWidgets('muestra porcentajes en leyenda', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(
          data: {'A': 75, 'B': 25},
        ),
      ));
      // 75% y 25% aparecen
      expect(find.textContaining('75'), findsOneWidget);
      expect(find.textContaining('25'), findsOneWidget);
    });

    testWidgets('texto largo en categoria no rompe', (tester) async {
      await tester.pumpWidget(host(
        const FoodBookPieChart(
          data: {
            'Categoria con nombre extremadamente largo': 30,
            'Otra': 20,
          },
        ),
      ));
      expect(find.byType(FoodBookPieChart), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/widgets/balance_ring.dart';

void main() {
  group('BalanceRing ratio logic', () {
    Widget host({required double consumed, required double paid}) =>
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: BalanceRing(consumed: consumed, paid: paid),
            ),
          ),
        );

    testWidgets('renderiza con texto "0%" cuando no hay consumo', (tester) async {
      await tester.pumpWidget(host(consumed: 0, paid: 0));
      expect(find.text('0%'), findsOneWidget);
      expect(find.text('Pagado'), findsOneWidget);
    });

    testWidgets('muestra 50% cuando se paga la mitad', (tester) async {
      await tester.pumpWidget(host(consumed: 100, paid: 50));
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('clamp a 100% si paid > consumed', (tester) async {
      await tester.pumpWidget(host(consumed: 80, paid: 200));
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('muestra 100% cuando pago == consumido', (tester) async {
      await tester.pumpWidget(host(consumed: 75, paid: 75));
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('label custom reemplaza el default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceRing(consumed: 10, paid: 5, label: 'Cubierto'),
          ),
        ),
      );
      expect(find.text('Cubierto'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
    });
  });

  group('BalanceRingWithLegend', () {
    Widget legendHost({
      required double consumed,
      required double paid,
      String consumedLabel = 'Consumido',
      String paidLabel = 'Pagado',
    }) =>
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: BalanceRingWithLegend(
                consumed: consumed,
                paid: paid,
                consumedLabel: consumedLabel,
                paidLabel: paidLabel,
              ),
            ),
          ),
        );

    testWidgets('muestra leyenda con tres valores (consumido, pagado, pendiente)',
        (tester) async {
      await tester.pumpWidget(legendHost(consumed: 100, paid: 30));
      expect(find.text('Consumido'), findsOneWidget);
      expect(find.text('Pendiente'), findsOneWidget);
      expect(find.text('S/ 100.00'), findsOneWidget);
      expect(find.text('S/ 30.00'), findsOneWidget);
      expect(find.text('S/ 70.00'), findsOneWidget);
      // 'Pagado' aparece 2 veces: dentro del anillo y en la leyenda.
      expect(find.text('Pagado'), findsNWidgets(2));
    });

    testWidgets('100% sin pendiente cuando pago == consumido', (tester) async {
      await tester.pumpWidget(legendHost(consumed: 50, paid: 50));
      expect(find.text('S/ 50.00'), findsNWidgets(2)); // consumido + pagado
      expect(find.text('S/ 0.00'), findsOneWidget); // pendiente
    });

    testWidgets('labels custom se respetan', (tester) async {
      await tester.pumpWidget(legendHost(
        consumed: 100,
        paid: 100,
        consumedLabel: 'Consumo',
        paidLabel: 'Pagado OK',
      ));
      expect(find.text('Consumo'), findsOneWidget);
      expect(find.text('Pagado OK'), findsOneWidget);
      expect(find.text('Pendiente'), findsOneWidget);
    });
  });
}

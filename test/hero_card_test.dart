import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/widgets/hero_card.dart';

void main() {
  Widget host(HeroCard card) => MaterialApp(home: Scaffold(body: card));

  group('HeroCard - renderizado basico', () {
    testWidgets('muestra label y amount', (tester) async {
      await tester.pumpWidget(host(
        const HeroCard(label: 'Hoy', amount: 'S/ 25.50'),
      ));
      expect(find.text('Hoy'), findsOneWidget);
      expect(find.text('S/ 25.50'), findsOneWidget);
    });

    testWidgets('muestra subtitle si se da', (tester) async {
      await tester.pumpWidget(host(
        const HeroCard(
          label: 'Hoy',
          amount: 'S/ 25.50',
          subtitle: 'Almuerzo + snack',
        ),
      ));
      expect(find.text('Almuerzo + snack'), findsOneWidget);
    });

    testWidgets('muestra icon si se da', (tester) async {
      await tester.pumpWidget(host(
        const HeroCard(
          label: 'Hoy',
          amount: 'S/ 25.50',
          icon: Icons.restaurant_rounded,
        ),
      ));
      expect(find.byIcon(Icons.restaurant_rounded), findsOneWidget);
    });

    testWidgets('sin subtitle ni icon funciona', (tester) async {
      await tester.pumpWidget(host(
        const HeroCard(label: 'Hoy', amount: 'S/ 25.50'),
      ));
      expect(find.byType(HeroCard), findsOneWidget);
    });
  });

  group('HeroCard - variantes', () {
    testWidgets('variant primary (default)', (tester) async {
      await tester.pumpWidget(host(
        const HeroCard(label: 'A', amount: 'B'),
      ));
      expect(find.byType(HeroCard), findsOneWidget);
    });

    testWidgets('variant danger', (tester) async {
      await tester.pumpWidget(host(
        const HeroCard(
          label: 'Deuda',
          amount: 'S/ 100',
          variant: HeroCardVariant.danger,
        ),
      ));
      expect(find.byType(HeroCard), findsOneWidget);
    });

    testWidgets('variant success', (tester) async {
      await tester.pumpWidget(host(
        const HeroCard(
          label: 'Al dia',
          amount: 'S/ 0',
          variant: HeroCardVariant.success,
        ),
      ));
      expect(find.byType(HeroCard), findsOneWidget);
    });

    testWidgets('variant info', (tester) async {
      await tester.pumpWidget(host(
        const HeroCard(
          label: 'Info',
          amount: 'S/ 0',
          variant: HeroCardVariant.info,
        ),
      ));
      expect(find.byType(HeroCard), findsOneWidget);
    });
  });

  group('HeroCard - interactividad', () {
    testWidgets('tap funciona si onTap dado', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(
        HeroCard(
          label: 'Tap me',
          amount: 'S/ 10',
          onTap: () => taps++,
        ),
      ));
      await tester.tap(find.byType(InkWell).first);
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('sin onTap, no es interactiva', (tester) async {
      await tester.pumpWidget(host(
        const HeroCard(label: 'No tap', amount: 'S/ 0'),
      ));
      // No deberia haber InkWell sin onTap
      expect(find.byType(HeroCard), findsOneWidget);
    });
  });
}

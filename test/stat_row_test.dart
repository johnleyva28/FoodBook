import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/widgets/stat_row.dart';

void main() {
  Widget host(StatRow row) => MaterialApp(home: Scaffold(body: row));

  group('StatRow - renderizado basico', () {
    testWidgets('muestra icono, label y value', (tester) async {
      await tester.pumpWidget(host(
        const StatRow(
          icon: Icons.cookie_rounded,
          label: 'Snacks',
          value: '15',
        ),
      ));
      expect(find.byIcon(Icons.cookie_rounded), findsOneWidget);
      expect(find.text('Snacks'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('muestra sublabel si se da', (tester) async {
      await tester.pumpWidget(host(
        const StatRow(
          icon: Icons.star_rounded,
          label: 'Rating',
          value: '4.5',
          sublabel: 'promedio',
        ),
      ));
      expect(find.text('promedio'), findsOneWidget);
    });

    testWidgets('sin sublabel funciona', (tester) async {
      await tester.pumpWidget(host(
        const StatRow(
          icon: Icons.help_rounded,
          label: 'Help',
          value: '0',
        ),
      ));
      expect(find.byType(StatRow), findsOneWidget);
    });
  });

  group('StatRow - colores', () {
    testWidgets('acepta valueColor custom', (tester) async {
      await tester.pumpWidget(host(
        const StatRow(
          icon: Icons.star_rounded,
          label: 'Positivo',
          value: '100',
          valueColor: Colors.green,
        ),
      ));
      expect(find.byType(StatRow), findsOneWidget);
    });

    testWidgets('usa primary por defecto', (tester) async {
      await tester.pumpWidget(host(
        const StatRow(
          icon: Icons.cookie_rounded,
          label: 'Default',
          value: '0',
        ),
      ));
      // Smoke test: renderiza sin error
      expect(find.byType(StatRow), findsOneWidget);
    });
  });

  group('StatRow - interactividad', () {
    testWidgets('tap funciona si onTap dado', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(
        StatRow(
          icon: Icons.touch_app_rounded,
          label: 'Tap me',
          value: '0',
          onTap: () => taps++,
        ),
      ));
      await tester.tap(find.byType(StatRow));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('sin onTap, no es interactivo', (tester) async {
      await tester.pumpWidget(host(
        const StatRow(
          icon: Icons.lock_rounded,
          label: 'No tap',
          value: '0',
        ),
      ));
      // No deberia lanzar error al tap (InkWell sin onTap lo ignora)
      await tester.tap(find.byType(StatRow));
      await tester.pump();
      expect(find.byType(StatRow), findsOneWidget);
    });
  });

  group('StatRow - textos largos', () {
    testWidgets('label largo se renderiza', (tester) async {
      const longLabel =
          'Este es un label extremadamente largo para verificar render';
      await tester.pumpWidget(host(
        const StatRow(
          icon: Icons.text_fields_rounded,
          label: longLabel,
          value: '0',
        ),
      ));
      expect(find.text(longLabel), findsOneWidget);
    });

    testWidgets('value largo se renderiza', (tester) async {
      const longValue = '09876543210987654321';
      await tester.pumpWidget(host(
        const StatRow(
          icon: Icons.numbers_rounded,
          label: 'Numero',
          value: longValue,
        ),
      ));
      expect(find.text(longValue), findsOneWidget);
    });
  });
}

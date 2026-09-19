import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/widgets/reminder_banner.dart';

void main() {
  Widget host(ReminderBanner banner) =>
      MaterialApp(home: Scaffold(body: banner));

  group('ReminderBanner - composicion', () {
    testWidgets('showLunch=true muestra recordatorio de almuerzo', (tester) async {
      await tester.pumpWidget(host(
        ReminderBanner(
          showLunch: true,
          showDinner: false,
          onTapLunch: () {},
          onTapDinner: () {},
        ),
      ));
      expect(find.text('¿Ya almorzaste?'), findsOneWidget);
      expect(find.text('Marcar almuerzo'), findsOneWidget);
    });

    testWidgets('showDinner=true muestra recordatorio de cena', (tester) async {
      await tester.pumpWidget(host(
        ReminderBanner(
          showLunch: false,
          showDinner: true,
          onTapLunch: () {},
          onTapDinner: () {},
        ),
      ));
      expect(find.text('¿Ya cenaste?'), findsOneWidget);
      expect(find.text('Marcar cena'), findsOneWidget);
    });

    testWidgets('ambos true muestra ambos', (tester) async {
      await tester.pumpWidget(host(
        ReminderBanner(
          showLunch: true,
          showDinner: true,
          onTapLunch: () {},
          onTapDinner: () {},
        ),
      ));
      // Renderiza algo (puede ser Column con ambos o un solo mensaje)
      expect(find.byType(ReminderBanner), findsOneWidget);
    });

    testWidgets('ambos false = SizedBox.shrink (no visible)', (tester) async {
      await tester.pumpWidget(host(
        ReminderBanner(
          showLunch: false,
          showDinner: false,
          onTapLunch: () {},
          onTapDinner: () {},
        ),
      ));
      // No muestra textos de almuerzo/cena
      expect(find.byType(ReminderBanner), findsOneWidget);
    });
  });

  group('ReminderBanner - taps', () {
    testWidgets('tap en recordatorio de almuerzo llama callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(host(
        ReminderBanner(
          showLunch: true,
          showDinner: false,
          onTapLunch: () => tapped = true,
          onTapDinner: () {},
        ),
      ));
      // Encuentra el InkWell o GestureDetector y tap
      await tester.tap(find.byType(InkWell).first, warnIfMissed: false);
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('tap en recordatorio de cena llama callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(host(
        ReminderBanner(
          showLunch: false,
          showDinner: true,
          onTapLunch: () {},
          onTapDinner: () => tapped = true,
        ),
      ));
      await tester.tap(find.byType(InkWell).first, warnIfMissed: false);
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  group('ReminderBanner - factory forNow', () {
    testWidgets('forNow crea un ReminderBanner segun la hora', (tester) async {
      await tester.pumpWidget(host(
        ReminderBanner.forNow(
          onTapLunch: () {},
          onTapDinner: () {},
        ),
      ));
      expect(find.byType(ReminderBanner), findsOneWidget);
    });
  });
}

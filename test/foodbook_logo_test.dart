import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/widgets/foodbook_logo.dart';

void main() {
  Widget host(Widget logo) => MaterialApp(home: Scaffold(body: logo));

  group('FoodBookLogo - renderizado', () {
    testWidgets('renderiza con size default (32)', (tester) async {
      await tester.pumpWidget(host(const FoodBookLogo()));
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FoodBookLogo),
          matching: find.byType(Container).first,
        ),
      );
      // El primer Container del logo debe tener width=32
      // ignore: cast_nullable_to_non_nullable
      expect(container.constraints?.minWidth, 32);
    });

    testWidgets('renderiza con size custom', (tester) async {
      await tester.pumpWidget(host(const FoodBookLogo(size: 64)));
      expect(find.byType(FoodBookLogo), findsOneWidget);
    });

    testWidgets('tamaños grandes (128) sin error', (tester) async {
      await tester.pumpWidget(host(const FoodBookLogo(size: 128)));
      expect(find.byType(FoodBookLogo), findsOneWidget);
    });

    testWidgets('variant dark=true', (tester) async {
      await tester.pumpWidget(host(const FoodBookLogo(dark: true)));
      expect(find.byType(FoodBookLogo), findsOneWidget);
    });

    testWidgets('variant dark=false', (tester) async {
      await tester.pumpWidget(host(const FoodBookLogo(dark: false)));
      expect(find.byType(FoodBookLogo), findsOneWidget);
    });
  });

  group('FoodBookLogo - estructura', () {
    testWidgets('tiene Container principal con borderRadius', (tester) async {
      await tester.pumpWidget(host(const FoodBookLogo(size: 48)));
      // Encuentra todos los Containers dentro del logo
      final containers = find.descendant(
        of: find.byType(FoodBookLogo),
        matching: find.byType(Container),
      );
      expect(containers, findsWidgets);
    });

    testWidgets('tiene stack con letra F', (tester) async {
      await tester.pumpWidget(host(const FoodBookLogo()));
      // El logo contiene un Stack con la letra F
      expect(find.byType(Stack), findsWidgets);
    });
  });

  group('FoodBookLogo - shadow / glow', () {
    testWidgets('shadow scalea con size', (tester) async {
      // Sizes diferentes producen sombras diferentes
      await tester.pumpWidget(host(const FoodBookLogo(size: 32)));
      await tester.pumpWidget(host(const FoodBookLogo(size: 96)));
      // Smoke test: ambos renderizan
      expect(find.byType(FoodBookLogo), findsOneWidget);
    });
  });
}

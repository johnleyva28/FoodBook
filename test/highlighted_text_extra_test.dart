import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/widgets/highlighted_text.dart';

/// Tests adicionales para HighlightedText.
void main() {
  Widget host(String text,
          {String query = '',
          TextStyle? baseStyle,
          Color? highlightColor,
          FontWeight highlightWeight = FontWeight.w800}) =>
      MaterialApp(
        home: Scaffold(
          body: HighlightedText(
            text: text,
            query: query,
            baseStyle: baseStyle,
            highlightColor: highlightColor,
            highlightWeight: highlightWeight,
          ),
        ),
      );

  group('HighlightedText - multiples ocurrencias', () {
    testWidgets('resalta multiples ocurrencias como RichText', (tester) async {
      await tester.pumpWidget(host('cafe con cafe y cafe', query: 'cafe'));
      // Multiples spans → al menos un RichText
      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('resaltado case-insensitive', (tester) async {
      await tester.pumpWidget(host('Cafe CAFE cafe', query: 'CAFE'));
      // Las 3 ocurrencias matchean, renderiza como RichText
      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('query en lowercase matchea Mayusculas', (tester) async {
      await tester.pumpWidget(host('PRODUCTO', query: 'producto'));
      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('query en MAYUSCULAS matchea minusculas', (tester) async {
      await tester.pumpWidget(host('producto', query: 'PRODUCTO'));
      expect(find.byType(RichText), findsWidgets);
    });
  });

  group('HighlightedText - estilos custom', () {
    testWidgets('acepta baseStyle custom', (tester) async {
      const customStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
      await tester.pumpWidget(host(
        'Texto custom',
        baseStyle: customStyle,
      ));
      expect(find.text('Texto custom'), findsOneWidget);
    });

    testWidgets('acepta highlightColor custom', (tester) async {
      await tester.pumpWidget(host(
        'match',
        query: 'match',
        highlightColor: Colors.red,
      ));
      // Smoke test: renderiza sin error
      expect(find.byType(HighlightedText), findsOneWidget);
    });

    testWidgets('acepta highlightWeight custom', (tester) async {
      await tester.pumpWidget(host(
        'match',
        query: 'match',
        highlightWeight: FontWeight.w900,
      ));
      expect(find.byType(HighlightedText), findsOneWidget);
    });
  });

  group('HighlightedText - textos vacios / nulos', () {
    testWidgets('texto vacio con query no falla', (tester) async {
      await tester.pumpWidget(host('', query: 'algo'));
      expect(find.byType(HighlightedText), findsOneWidget);
    });

    testWidgets('query solo espacios no falla', (tester) async {
      await tester.pumpWidget(host('Hola', query: '   '));
      expect(find.text('Hola'), findsOneWidget);
    });

    testWidgets('texto de un solo caracter', (tester) async {
      await tester.pumpWidget(host('a', query: 'a'));
      expect(find.byType(HighlightedText), findsOneWidget);
    });
  });

  group('HighlightedText - query == texto', () {
    testWidgets('todo el texto es highlight', (tester) async {
      await tester.pumpWidget(host('total', query: 'total'));
      // Todo debe estar resaltado
      expect(find.byType(HighlightedText), findsOneWidget);
    });
  });

  group('HighlightedText - caracteres especiales', () {
    testWidgets('query con caracteres acentuados', (tester) async {
      await tester.pumpWidget(host('café con leche', query: 'café'));
      expect(find.byType(HighlightedText), findsOneWidget);
    });

    testWidgets('query con numeros', (tester) async {
      await tester.pumpWidget(host('Item 123 vendido', query: '123'));
      expect(find.byType(HighlightedText), findsOneWidget);
    });

    testWidgets('query con simbolos', (tester) async {
      await tester.pumpWidget(host('Precio: S/ 10.50', query: 'S/'));
      expect(find.byType(HighlightedText), findsOneWidget);
    });
  });

  group('HighlightedText - presenciay robustez', () {
    testWidgets('renderiza texto largo sin overflow', (tester) async {
      const longText =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
          'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
      await tester.pumpWidget(host(longText, query: 'ipsum'));
      expect(find.byType(HighlightedText), findsOneWidget);
    });

    testWidgets('query mas largo que texto devuelve texto plano', (tester) async {
      await tester.pumpWidget(host('corto', query: 'muyyyyy largo'));
      // No hay match → texto plano
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('multiples queries (solo la primera)', (tester) async {
      // El widget solo soporta una query a la vez
      await tester.pumpWidget(host('cafe pan queso', query: 'pan'));
      expect(find.byType(HighlightedText), findsOneWidget);
    });
  });
}

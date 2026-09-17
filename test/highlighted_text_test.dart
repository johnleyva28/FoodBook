import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/widgets/highlighted_text.dart';

void main() {
  group('HighlightedText', () {
    Widget host(String text, {String query = ''}) => MaterialApp(
          home: Scaffold(
            body: HighlightedText(text: text, query: query),
          ),
        );

    testWidgets('texto plano sin query', (tester) async {
      await tester.pumpWidget(host('Hola mundo'));
      expect(find.text('Hola mundo'), findsOneWidget);
    });

    testWidgets('query vacia devuelve texto sin highlighting',
        (tester) async {
      await tester.pumpWidget(host('Hola mundo', query: ''));
      expect(find.text('Hola mundo'), findsOneWidget);
      // Sin highlight: Text plano
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('query que no coincide devuelve texto plano',
        (tester) async {
      await tester.pumpWidget(host('Hola mundo', query: 'xyz'));
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('query matchea: usa RichText con spans',
        (tester) async {
      await tester.pumpWidget(host('Pan con mantequilla', query: 'Pan'));
      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('multiples ocurrencias generan multiples spans',
        (tester) async {
      await tester.pumpWidget(host('aBaBa', query: 'a'));
      final rich = tester.widget<RichText>(find.byType(RichText));
      // Hay 5 chars, los 3 'a' (posiciones 0, 2, 4) se resaltan como TextSpan
      // y los 2 'B' (posiciones 1, 3) quedan normales.
      // total de spans = 5 TextSpan (3 resaltados + 2 normales).
      final spans = (rich.text as TextSpan).children!.toList();
      expect(spans.length, greaterThanOrEqualTo(3));
    });

    testWidgets('case-insensitive match', (tester) async {
      await tester.pumpWidget(host('Hola MUNDO', query: 'mundo'));
      expect(find.byType(RichText), findsOneWidget);
    });
  });
}

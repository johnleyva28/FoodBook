import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/widgets/empty_state.dart';

/// Tests adicionales para EmptyState.
///
/// Complementa empty_state_test.dart con mas combinaciones y
/// verificaciones de estructura.
void main() {
  group('EmptyState - composicion basica', () {
    testWidgets('icono grande (64px por defecto)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.cookie_rounded,
              title: 'Test',
            ),
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.cookie_rounded));
      expect(icon.size, 64);
    });

    testWidgets('icono tiene alpha 0.7 por defecto', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.star_rounded,
              title: 'Test',
            ),
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.star_rounded));
      // Default theme color + withValues(alpha: 0.7)
      expect((icon.color?.a ?? 1.0) < 1.0, isTrue);
    });

    testWidgets('descripcion se centra', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: EmptyState(
                icon: Icons.inbox_rounded,
                title: 'Vacio',
                description: 'Descripcion muy larga que deberia envolver '
                    'en multiples lineas sin problemas de layout.',
              ),
            ),
          ),
        ),
      );
      expect(find.textContaining('Descripcion muy larga'), findsOneWidget);
      // El Text debe estar dentro del Center principal
      final textWidget = tester.widget<Text>(find.textContaining('Descripcion'));
      expect(textWidget.textAlign, TextAlign.center);
    });

    testWidgets('titulo centrado', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.help_rounded,
              title: 'Centro?',
            ),
          ),
        ),
      );
      final titleWidget = tester.widget<Text>(find.text('Centro?'));
      expect(titleWidget.textAlign, TextAlign.center);
    });
  });

  group('EmptyState - acciones', () {
    testWidgets('solo primary, sin secondary', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.add_rounded,
              title: 'Empezar',
              primaryAction: FilledButton(
                onPressed: null,
                child: Text('Agregar'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Agregar'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('primary + secondary juntos', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.warning_rounded,
              title: 'Atencion',
              primaryAction: FilledButton(
                onPressed: null,
                child: Text('Primario'),
              ),
              secondaryAction: TextButton(
                onPressed: null,
                child: Text('Secundario'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Primario'), findsOneWidget);
      expect(find.text('Secundario'), findsOneWidget);
    });

    testWidgets('sin acciones: solo icono + titulo', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.done_rounded,
              title: 'Listo',
            ),
          ),
        ),
      );
      expect(find.byType(FilledButton), findsNothing);
      expect(find.byType(TextButton), findsNothing);
    });
  });

  group('EmptyState - estructura', () {
    testWidgets('usa Center como root', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.star_rounded,
              title: 'Test',
            ),
          ),
        ),
      );
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('usa Column con mainAxisSize.min', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.star_rounded,
              title: 'Test',
            ),
          ),
        ),
      );
      final columns = tester.widgetList<Column>(find.byType(Column));
      final target = columns.firstWhere((c) => c.mainAxisSize == MainAxisSize.min);
      expect(target, isNotNull);
    });

    testWidgets('iconColor custom se aplica (alpha 0.7)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.favorite_rounded,
              title: 'Custom',
              iconColor: Colors.purple,
            ),
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.favorite_rounded));
      // Color base es purple, alpha aplicado 0.7
      expect(icon.color?.toARGB32(), isNotNull);
      expect((icon.color?.a ?? 1.0) < 1.0, isTrue);
    });
  });

  group('EmptyState - padding', () {
    testWidgets('padding interno amplio (xl)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox_rounded,
              title: 'Padding',
            ),
          ),
        ),
      );
      // Busca el Padding principal dentro de EmptyState
      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(EmptyState),
          matching: find.byType(Padding),
        ),
      );
      // FoodBookSpacing.xl = 20
      expect(padding.padding, const EdgeInsets.all(20));
    });
  });

  group('EmptyState - textos largos', () {
    testWidgets('titulo muy largo se renderiza', (tester) async {
      const longTitle =
          'Este es un titulo extremadamente largo para verificar que el widget '
          'maneja correctamente textos de gran longitud sin desbordar el layout';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.text_fields_rounded,
              title: longTitle,
            ),
          ),
        ),
      );
      expect(find.text(longTitle), findsOneWidget);
    });
  });
}

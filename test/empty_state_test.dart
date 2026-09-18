import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/widgets/empty_state.dart';

void main() {
  testWidgets('muestra icono y titulo', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.cookie_rounded,
            title: 'Sin datos',
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.cookie_rounded), findsOneWidget);
    expect(find.text('Sin datos'), findsOneWidget);
  });

  testWidgets('muestra descripcion si se da', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.inbox_rounded,
            title: 'Vacío',
            description: 'Aún no hay nada por aquí',
          ),
        ),
      ),
    );
    expect(find.text('Vacío'), findsOneWidget);
    expect(find.text('Aún no hay nada por aquí'), findsOneWidget);
  });

  testWidgets('muestra primary action', (tester) async {
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
  });

  testWidgets('muestra ambas acciones', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.help_rounded,
            title: '¿Necesitas ayuda?',
            primaryAction: FilledButton(onPressed: null, child: Text('A')),
            secondaryAction: TextButton(onPressed: null, child: Text('B')),
          ),
        ),
      ),
    );
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('acepta iconColor custom (con alpha 0.7 aplicado)', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.warning_rounded,
            title: 'Atención',
            iconColor: Colors.red,
          ),
        ),
      ),
    );
    final iconWidget = tester.widget<Icon>(find.byIcon(Icons.warning_rounded));
    // El color base es Colors.red pero se le aplica withValues(alpha: 0.7).
    expect(iconWidget.color?.toARGB32(), isNotNull);
    expect((iconWidget.color?.a ?? 1.0) < 1.0, isTrue);
  });

  testWidgets('centrado vertical y horizontalmente', (tester) async {
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
    final centerFinder = find.byType(Center);
    expect(centerFinder, findsWidgets);
  });
}

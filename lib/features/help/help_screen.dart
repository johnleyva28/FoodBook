import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/foodbook_spacing.dart';

/// Pantalla de ayuda con preguntas frecuentes y respuestas rápidas.
///
/// Las preguntas se cargan desde una lista interna. Cuando se haga i18n,
/// esta lista pasará a un `.arb` y se cargará según el idioma.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static final List<_FaqItem> _items = [
    const _FaqItem(
      q: '¿Cómo agrego un bocadillo?',
      a:
          'En la pantalla principal pulsa el botón "+ Bocadillo" en la '
          'tarjeta de Bocadillos. Escribe el precio (y una descripción si '
          'quieres). Confirma y aparecerá en la lista del día.',
    ),
    const _FaqItem(
      q: '¿Cómo registro un pago?',
      a:
          'En la pantalla de Cuentas pulsa el botón "+ Pago" en la parte '
          'superior. Ingresa el monto, elige el método y la fecha, y '
          'listo. El balance se actualiza al instante.',
    ),
    const _FaqItem(
      q: '¿Cómo cambio de rol (consumidor ↔ pensión)?',
      a:
          'Ve a Perfil → "Cambiar rol". Elige consumidor si solo quieres '
          'registrar lo que consumes, o pensionista si quieres ver a tus '
          'comensales y gestionar pedidos.',
    ),
    const _FaqItem(
      q: '¿Mis datos salen del dispositivo?',
      a:
          'No. FoodBook es una app local: todos los datos viven en tu '
          'dispositivo. Si quieres conservarlos, exporta a CSV o JSON '
          'desde Configuración.',
    ),
    const _FaqItem(
      q: '¿Qué pasa si olvido el PIN?',
      a:
          'En la pantalla de desbloqueo, pulsa "¿Olvidaste tu PIN?". '
          'Confirma la advertencia. Esto borrará todos los datos locales '
          'para permitirte configurar uno nuevo.',
    ),
    const _FaqItem(
      q: '¿Cómo personalizo las categorías de bocadillos?',
      a:
          'Ve a Configuración → "Administrar catálogos" → "Categorías". '
          'Agrega, edita o elimina categorías. Se aplican al instante.',
    ),
    const _FaqItem(
      q: '¿La app sincroniza con la nube?',
      a:
          'No por ahora. Toda la información está en tu dispositivo. '
          'Si quieres compartir datos entre dispositivos, usa el botón '
          '"Exportar" y comparte el archivo CSV o JSON.',
    ),
    const _FaqItem(
      q: '¿Cómo elimino un bocadillo o un pago?',
      a:
          'Mantén pulsado (long-press) sobre el ítem en su lista. '
          'Aparecerá un diálogo de confirmación.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(FoodBookSpacing.lg),
        children: [
          Text(
            'Preguntas frecuentes',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: FoodBookSpacing.sm),
          Text(
            'Toca cualquier pregunta para ver la respuesta.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),
          ..._items.map((it) => _FaqCard(item: it)),
          const SizedBox(height: FoodBookSpacing.xl),
          Center(
            child: Text(
              '${AppStrings.appName} · ${AppStrings.appName}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem {
  final String q;
  final String a;
  const _FaqItem({required this.q, required this.a});
}

class _FaqCard extends StatelessWidget {
  final _FaqItem item;
  const _FaqCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: FoodBookSpacing.md),
      child: ExpansionTile(
        title: Text(
          item.q,
          style: theme.textTheme.titleMedium,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          FoodBookSpacing.lg,
          0,
          FoodBookSpacing.lg,
          FoodBookSpacing.md,
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.a,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

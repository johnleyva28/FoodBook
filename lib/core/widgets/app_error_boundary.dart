import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';

import '../utils/foodbook_log.dart';

/// Captura errores de construcción de widgets y muestra una pantalla
/// amigable en lugar de una pantalla roja.
///
/// Usar como wrapper raíz en `MaterialApp.builder`:
///
/// ```dart
/// MaterialApp(
///   builder: (ctx, child) => AppErrorBoundary(child: child!),
/// )
/// ```
class AppErrorBoundary extends StatelessWidget {
  final Widget child;
  const AppErrorBoundary({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return _Boundary(child: child);
  }
}

class _Boundary extends StatefulWidget {
  final Widget child;
  const _Boundary({required this.child});

  @override
  State<_Boundary> createState() => _BoundaryState();
}

class _BoundaryState extends State<_Boundary> {
  Object? _error;
  StackTrace? _stack;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _ErrorScreen(
        error: _error!,
        stack: _stack,
        onRetry: () => setState(() {
          _error = null;
          _stack = null;
        }),
      );
    }
    return _ErrorCatcher(
      onError: (e, s) {
        FoodBookLog.e('Error capturado', error: e, stackTrace: s);
        setState(() {
          _error = e;
          _stack = s;
        });
      },
      child: widget.child,
    );
  }
}

class _ErrorCatcher extends StatefulWidget {
  final Widget child;
  final void Function(Object, StackTrace) onError;

  const _ErrorCatcher({required this.child, required this.onError});

  @override
  State<_ErrorCatcher> createState() => _ErrorCatcherState();
}

class _ErrorCatcherState extends State<_ErrorCatcher> {
  @override
  void initState() {
    super.initState();
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      widget.onError(details.exception, details.stack ?? StackTrace.empty);
      original?.call(details);
    };
  }

  @override
  void dispose() {
    FlutterError.onError = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _ErrorScreen extends StatelessWidget {
  final Object error;
  final StackTrace? stack;
  final VoidCallback onRetry;

  const _ErrorScreen({
    required this.error,
    required this.stack,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bug_report_rounded,
                size: 96,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Algo salió mal',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'La app encontró un error inesperado. Puedes reintentar; '
                'si el problema persiste, reinstala la app.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
              const SizedBox(height: 16),
              if (kReleaseMode)
                Text(
                  '$error',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

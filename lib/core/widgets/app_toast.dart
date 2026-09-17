import 'package:flutter/material.dart';

import '../theme/foodbook_colors.dart';

/// Tipos de toast con estilo consistente en toda la app.
enum AppToastKind { info, success, warning, danger }

/// Helper de notificaciones tipo "toast".
///
/// Centraliza el estilo y comportamiento de los SnackBar de FoodBook:
/// duración consistente, colores por tipo, y posición inferior.
class AppToast {
  AppToast._();

  static const Duration _defaultDuration = Duration(seconds: 2);
  static const Duration _longDuration = Duration(seconds: 4);

  /// Muestra un toast informativo.
  static void info(BuildContext context, String message) =>
      _show(context, message, AppToastKind.info);

  /// Muestra un toast de éxito (verde).
  static void success(BuildContext context, String message) =>
      _show(context, message, AppToastKind.success);

  /// Muestra un toast de advertencia (ámbar).
  static void warning(
    BuildContext context,
    String message, {
    Duration duration = _longDuration,
  }) => _show(context, message, AppToastKind.warning, duration: duration);

  /// Muestra un toast de error/peligro (rojo coral).
  static void danger(
    BuildContext context,
    String message, {
    Duration duration = _longDuration,
  }) => _show(context, message, AppToastKind.danger, duration: duration);

  /// Toast con acción (botón).
  static void withAction(
    BuildContext context, {
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    AppToastKind kind = AppToastKind.info,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: _buildContent(message, kind),
        backgroundColor: _bgFor(kind),
        duration: _longDuration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: actionLabel,
          textColor: Colors.white,
          onPressed: onAction,
        ),
      ),
    );
  }

  static void _show(
    BuildContext context,
    String message,
    AppToastKind kind, {
    Duration duration = _defaultDuration,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: _buildContent(message, kind),
        backgroundColor: _bgFor(kind),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static Widget _buildContent(String message, AppToastKind kind) {
    return Row(
      children: [
        Icon(_iconFor(kind), color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }

  static Color _bgFor(AppToastKind kind) {
    switch (kind) {
      case AppToastKind.info:
        return FoodBookColors.navyVariant;
      case AppToastKind.success:
        return FoodBookColors.success;
      case AppToastKind.warning:
        return FoodBookColors.warning;
      case AppToastKind.danger:
        return FoodBookColors.danger;
    }
  }

  static IconData _iconFor(AppToastKind kind) {
    switch (kind) {
      case AppToastKind.info:
        return Icons.info_outline_rounded;
      case AppToastKind.success:
        return Icons.check_circle_outline_rounded;
      case AppToastKind.warning:
        return Icons.warning_amber_rounded;
      case AppToastKind.danger:
        return Icons.error_outline_rounded;
    }
  }
}

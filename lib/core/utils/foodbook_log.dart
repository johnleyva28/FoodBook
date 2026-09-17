import 'package:flutter/foundation.dart';

/// Logger centralizado de FoodBook.
///
/// Usa `debugPrint` en modo debug y silencia en release.
/// Pensado para reemplazar `print` directos en el código.
class FoodBookLog {
  FoodBookLog._();

  static bool get _enabled => kDebugMode;

  static void d(Object? message, {String? tag}) => _log('DEBUG', message, tag);

  static void i(Object? message, {String? tag}) => _log('INFO', message, tag);

  static void w(Object? message, {String? tag, Object? error}) {
    _log('WARN', message, tag);
    if (error != null && _enabled) {
      debugPrint('[FoodBook]   error=$error');
    }
  }

  static void e(
    Object? message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log('ERROR', message, tag);
    if (error != null && _enabled) {
      debugPrint('[FoodBook]   error=$error');
    }
    if (stackTrace != null && _enabled) {
      debugPrint('[FoodBook]   stack=$stackTrace');
    }
  }

  static void _log(String level, Object? message, String? tag) {
    if (!_enabled) return;
    final prefix = tag == null ? '[FoodBook]' : '[FoodBook/$tag]';
    debugPrint('$prefix $level: $message');
  }
}

import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/core/theme/app_theme.dart';

void main() {
  test('app theme dark se inicializa', () {
    final theme = AppTheme.dark;
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.brightness.name, 'dark');
  });
}

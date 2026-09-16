import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/database/app_database.dart';
import 'data/repositories/daily_log_repository.dart';
import 'data/repositories/payment_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/snack_repository.dart';
import 'features/ajustes/viewmodels/settings_viewmodel.dart';
import 'shell/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_PE', null);

  // ✅ Se crea UNA sola vez, antes de runApp.
  final db = AppDatabase();

  runApp(FoodBookApp(db: db));
}

class FoodBookApp extends StatelessWidget {
  final AppDatabase db;

  const FoodBookApp({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        ProxyProvider<AppDatabase, DailyLogRepository>(
          update: (_, db, _) => DailyLogRepository(db),
        ),
        ProxyProvider<AppDatabase, SnackRepository>(
          update: (_, db, _) => SnackRepository(db),
        ),
        ProxyProvider<AppDatabase, PaymentRepository>(
          update: (_, db, _) => PaymentRepository(db),
        ),
        ProxyProvider<AppDatabase, SettingsRepository>(
          update: (_, db, _) => SettingsRepository(db),
        ),
        // VM global de ajustes para que el themeMode sea reactivo desde
        // cualquier punto de la app (settings, splash, etc.).
        ChangeNotifierProvider<SettingsViewModel>(
          create: (ctx) {
            final vm = SettingsViewModel(ctx.read<SettingsRepository>());
            vm.init();
            return vm;
          },
        ),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsVm, _) {
          return MaterialApp(
            title: 'FoodBook',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settingsVm.themeMode,
            home: const MainShell(),
          );
        },
      ),
    );
  }
}

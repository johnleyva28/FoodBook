import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'data/database/app_database.dart';
import 'data/repositories/daily_log_repository.dart';
import 'data/repositories/payment_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/snack_repository.dart';
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
      ],
      child: MaterialApp(
        title: 'FoodBook',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: const MainShell(),
      ),
    );
  }
}

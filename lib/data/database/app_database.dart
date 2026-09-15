import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/daily_log.dart';
import '../models/snack_entry.dart';
import '../models/payment.dart';
import '../models/setting.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [DailyLogs, SnackEntries, Payments, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'foodbook.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

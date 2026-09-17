import 'dart:async';

import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'database/app_database.dart';
import 'models/category.dart' as model;

/// Bus reactivo global de los streams de Drift.
///
/// Mantiene una única subscripción a las tablas `dailyLogs`,
/// `snackEntries` y `payments`. Cualquier parte de la app puede
/// escuchar sus `ChangeNotifier`s internos para reaccionar a
/// cambios en tiempo real.
class AppDataStreams extends ChangeNotifier {
  final AppDatabase _db;

  AppDataStreams(this._db) {
    _attach();
  }

  StreamSubscription<List<DailyLog>>? _logsSub;
  StreamSubscription<List<SnackEntry>>? _snacksSub;
  StreamSubscription<List<Payment>>? _paymentsSub;
  StreamSubscription<List<model.Category>>? _categoriesSub;

  // Estado cacheado (listas inmutables emitidas en cada cambio).
  List<DailyLog> _logs = const [];
  List<SnackEntry> _snacks = const [];
  List<Payment> _payments = const [];
  List<model.Category> _categories = const [];

  List<DailyLog> get logs => _logs;
  List<SnackEntry> get snacks => _snacks;
  List<Payment> get payments => _payments;
  List<model.Category> get categories => _categories;

  bool _ready = false;
  bool get isReady => _ready;

  void _attach() {
    _logsSub = _db.select(_db.dailyLogs).watch().listen((value) {
      _logs = value;
      notifyListeners();
    });
    _snacksSub = _db.select(_db.snackEntries).watch().listen((value) {
      _snacks = value;
      notifyListeners();
    });
    _paymentsSub = _db.select(_db.payments).watch().listen((value) {
      _payments = value;
      notifyListeners();
    });
    // Para la tabla auxiliar `categories` usamos `customSelect` y
    // mapeamos el `Stream<List<QueryRow>>` a `Stream<List<Category>>`
    // con `.map()` para evitar un cast inseguro sobre la subscripción.
    _categoriesSub = _db
        .customSelect(
          'SELECT * FROM categories ORDER BY name',
          readsFrom: const {},
        )
        .watch()
        .map(
          (rows) => rows
              .map((r) => model.Category.fromRow(r.data))
              .toList(growable: false),
        )
        .listen((value) {
          _categories = value;
          notifyListeners();
        });

    // Marcamos como listo después del primer ciclo.
    Future<void>.delayed(const Duration(milliseconds: 50), () {
      _ready = true;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _logsSub?.cancel();
    _snacksSub?.cancel();
    _paymentsSub?.cancel();
    _categoriesSub?.cancel();
    super.dispose();
  }
}

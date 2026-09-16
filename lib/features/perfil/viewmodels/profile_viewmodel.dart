import 'package:flutter/foundation.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';

/// ViewModel de la pantalla Perfil.
///
/// Calcula estadísticas personales del usuario: días registrados,
/// gasto total, gasto promedio, desglose por tipo, etc.
class ProfileViewModel extends ChangeNotifier {
  final DailyLogRepository _dailyLogRepo;
  final SnackRepository _snackRepo;
  final PaymentRepository _paymentRepo;
  final SettingsRepository _settingsRepo;

  ProfileViewModel(
    this._dailyLogRepo,
    this._snackRepo,
    this._paymentRepo,
    this._settingsRepo,
  );

  String userName = '';
  double lunchPrice = 9.0;
  double dinnerPrice = 9.0;
  int totalDays = 0;
  int totalLunches = 0;
  int totalDinners = 0;
  int totalBreakfasts = 0;
  double totalConsumed = 0;
  double totalPaid = 0;
  double totalSnacks = 0;
  double avgDaily = 0;
  String? topSnack;
  bool loading = true;

  Future<void> init() async {
    userName =
        await _settingsRepo.getString('user_name') ?? '';
    lunchPrice = await _settingsRepo.getLunchPrice();
    dinnerPrice = await _settingsRepo.getDinnerPrice();

    final logs = await _dailyLogRepo.watchAll().first;
    final snacks = await _snackRepo.watchAll().first;
    final payments = await _paymentRepo.watchAll().first;

    totalDays = logs.length;
    totalLunches = logs.where((l) => l.hadLunch).length;
    totalDinners = logs.where((l) => l.hadDinner).length;
    totalBreakfasts = logs.where((l) => l.hadBreakfast).length;
    totalConsumed =
        (totalLunches * lunchPrice) + (totalDinners * dinnerPrice) +
        logs.fold<double>(0, (s, l) => s + l.breakfastPrice);
    totalSnacks = snacks.fold<double>(0, (s, e) => s + e.price);
    totalPaid = payments.fold<double>(0, (s, p) => s + p.amount);
    avgDaily = totalDays == 0 ? 0 : totalConsumed / totalDays;
    topSnack = _findTopSnack(snacks);

    loading = false;
    notifyListeners();
  }

  String? _findTopSnack(List<SnackEntry> snacks) {
    if (snacks.isEmpty) return null;
    final counts = <String, int>{};
    for (final s in snacks) {
      final decoded = SnackRepository.decode(s.description);
      final label = decoded.$2 ?? decoded.$1 ?? 'Bocadillo';
      counts[label] = (counts[label] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.isEmpty ? null : sorted.first.key;
  }

  String get initials {
    if (userName.trim().isEmpty) return 'FB';
    final parts = userName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

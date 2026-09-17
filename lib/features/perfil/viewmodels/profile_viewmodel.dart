import 'package:flutter/foundation.dart';

import '../../../data/app_data_streams.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/snack_repository.dart';

/// ViewModel de la pantalla Perfil.
///
/// Lee del `AppDataStreams` global para reactividad en vivo y
/// carga los datos de usuario desde `SettingsRepository`.
class ProfileViewModel extends ChangeNotifier {
  final AppDataStreams _streams;
  final SettingsRepository _settingsRepo;

  ProfileViewModel(this._streams, this._settingsRepo);

  String userName = '';
  double lunchPrice = 9.0;
  double dinnerPrice = 9.0;
  bool loading = true;

  // ── Datos reactivos desde el bus ──
  List<DailyLog> get logs => _streams.logs;
  List<SnackEntry> get snacks => _streams.snacks;
  List<Payment> get payments => _streams.payments;

  // ── Estadísticas ──
  int get totalDays => logs.length;
  int get totalLunches => logs.where((l) => l.hadLunch).length;
  int get totalDinners => logs.where((l) => l.hadDinner).length;
  int get totalBreakfasts => logs.where((l) => l.hadBreakfast).length;

  double get totalConsumed =>
      (totalLunches * lunchPrice) +
      (totalDinners * dinnerPrice) +
      logs.fold<double>(0, (sum, l) => sum + l.breakfastPrice);

  double get totalSnacks => snacks.fold<double>(0, (s, e) => s + e.price);
  double get totalPaid => payments.fold<double>(0, (s, p) => s + p.amount);
  double get avgDaily => totalDays == 0 ? 0 : totalConsumed / totalDays;

  String? get topSnack {
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
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  Future<void> init() async {
    userName = await _settingsRepo.getString('user_name') ?? '';
    lunchPrice = await _settingsRepo.getLunchPrice();
    dinnerPrice = await _settingsRepo.getDinnerPrice();
    _streams.addListener(_onChange);
    loading = false;
    notifyListeners();
  }

  void _onChange() {
    if (!loading) notifyListeners();
  }

  /// Actualiza el nombre del usuario y refresca el estado del VM.
  void updateUserName(String value) {
    userName = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _streams.removeListener(_onChange);
    super.dispose();
  }
}

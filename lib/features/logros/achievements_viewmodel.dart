import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/utils/date_helper.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/snack_repository.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool unlocked;
  final double progress; // 0..1

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.unlocked,
    required this.progress,
  });
}

/// ViewModel de logros / metas del usuario.
class AchievementsViewModel extends ChangeNotifier {
  final DailyLogRepository _dailyLogRepo;
  final SnackRepository _snackRepo;

  StreamSubscription<List<DailyLog>>? _logsSub;
  StreamSubscription<List<SnackEntry>>? _snacksSub;

  List<DailyLog> logs = [];
  List<SnackEntry> snacks = [];

  AchievementsViewModel(this._dailyLogRepo, this._snackRepo);

  Future<void> init() async {
    _logsSub = _dailyLogRepo.watchAll().listen((value) {
      logs = value;
      notifyListeners();
    });
    _snacksSub = _snackRepo.watchAll().listen((value) {
      snacks = value;
      notifyListeners();
    });
  }

  /// Racha actual de días consecutivos con al menos un registro.
  int get currentStreak {
    if (logs.isEmpty && snacks.isEmpty) return 0;
    final dates = <String>{};
    for (final l in logs) {
      dates.add(l.date);
    }
    for (final s in snacks) {
      dates.add(s.date);
    }
    if (dates.isEmpty) return 0;

    int streak = 0;
    var cursor = DateTime.now();
    while (true) {
      final key = DateHelper.format(cursor);
      if (dates.contains(key)) {
        streak++;
        cursor = cursor.subtract(const Duration(days: 1));
      } else if (streak == 0 &&
          key == DateHelper.format(DateTime.now())) {
        // El día de hoy no tiene registro; empezamos desde ayer.
        cursor = cursor.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  /// Mejor racha histórica.
  int get longestStreak {
    if (logs.isEmpty && snacks.isEmpty) return 0;
    final dates = <String>{};
    for (final l in logs) {
      dates.add(l.date);
    }
    for (final s in snacks) {
      dates.add(s.date);
    }
    if (dates.isEmpty) return 0;

    final sorted = dates.map(DateHelper.parse).toList()
      ..sort((a, b) => a.compareTo(b));
    int best = 1;
    int current = 1;
    for (int i = 1; i < sorted.length; i++) {
      final diff = sorted[i].difference(sorted[i - 1]).inDays;
      if (diff == 1) {
        current++;
        if (current > best) best = current;
      } else if (diff > 1) {
        current = 1;
      }
    }
    return best;
  }

  int get totalLunches => logs.where((l) => l.hadLunch).length;
  int get totalDinners => logs.where((l) => l.hadDinner).length;
  int get totalBreakfasts => logs.where((l) => l.hadBreakfast).length;
  int get totalSnacks => snacks.length;
  int get totalDays => logs.length;

  List<Achievement> get achievements {
    return [
      Achievement(
        id: 'first_bite',
        title: 'Primer mordisco',
        description: 'Registra tu primer día.',
        icon: Icons.restaurant_rounded,
        color: const Color(0xFF22D3EE),
        unlocked: totalDays >= 1,
        progress: (totalDays / 1).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'streak_3',
        title: 'Constancia 3',
        description: '3 días seguidos registrando.',
        icon: Icons.local_fire_department_rounded,
        color: const Color(0xFFFB923C),
        unlocked: currentStreak >= 3,
        progress: (currentStreak / 3).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'streak_7',
        title: 'Semana perfecta',
        description: '7 días seguidos registrando.',
        icon: Icons.whatshot_rounded,
        color: const Color(0xFFEF4444),
        unlocked: currentStreak >= 7,
        progress: (currentStreak / 7).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'streak_30',
        title: 'Hábito formado',
        description: '30 días seguidos registrando.',
        icon: Icons.emoji_events_rounded,
        color: const Color(0xFFFBBF24),
        unlocked: currentStreak >= 30,
        progress: (currentStreak / 30).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'lunches_50',
        title: 'Cien almuerzos',
        description: 'Registra 50 almuerzos.',
        icon: Icons.lunch_dining_rounded,
        color: const Color(0xFF7DD3FC),
        unlocked: totalLunches >= 50,
        progress: (totalLunches / 50).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'snacks_20',
        title: 'Snack lover',
        description: 'Registra 20 bocadillos.',
        icon: Icons.cookie_rounded,
        color: const Color(0xFFF472B6),
        unlocked: totalSnacks >= 20,
        progress: (totalSnacks / 20).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'balanced',
        title: 'Equilibrio',
        description: 'Registra desayunos, almuerzos y cenas en un día.',
        icon: Icons.balance_rounded,
        color: const Color(0xFF34D399),
        unlocked: logs.any(
          (l) => l.hadBreakfast && l.hadLunch && l.hadDinner,
        ),
        progress: 1.0,
      ),
    ];
  }

  int get unlockedCount => achievements.where((a) => a.unlocked).length;
  int get totalCount => achievements.length;

  @override
  void dispose() {
    _logsSub?.cancel();
    _snacksSub?.cancel();
    super.dispose();
  }
}

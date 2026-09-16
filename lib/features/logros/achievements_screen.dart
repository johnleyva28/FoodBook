import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';
import '../../../core/theme/foodbook_text_styles.dart';
import '../../../core/widgets/stat_row.dart';
import '../../../data/repositories/daily_log_repository.dart';
import '../../../data/repositories/snack_repository.dart';
import 'achievements_viewmodel.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) {
        final vm = AchievementsViewModel(
          ctx.read<DailyLogRepository>(),
          ctx.read<SnackRepository>(),
        );
        vm.init();
        return vm;
      },
      child: const _AchievementsView(),
    );
  }
}

class _AchievementsView extends StatelessWidget {
  const _AchievementsView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AchievementsViewModel>();
    final theme = Theme.of(context);
    final achievements = vm.achievements;

    return Scaffold(
      appBar: AppBar(title: const Text('Logros')),
      body: ListView(
        padding: const EdgeInsets.all(FoodBookSpacing.lg),
        children: [
          // ── Racha ──
          Card(
            child: Padding(
              padding: const EdgeInsets.all(FoodBookSpacing.lg),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              FoodBookColors.warning.withValues(alpha: 0.7),
                              FoodBookColors.danger,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: FoodBookColors.warning.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: FoodBookSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Racha actual',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              '${vm.currentStreak} ${vm.currentStreak == 1 ? "día" : "días"}',
                              style: theme.textTheme.headlineSmall,
                            ),
                            Text(
                              'Mejor racha: ${vm.longestStreak} días',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: FoodBookSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: StatRow(
                          icon: Icons.restaurant_rounded,
                          label: 'Días registrados',
                          value: '${vm.totalDays}',
                          valueColor: FoodBookColors.sky,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Progreso general ──
          Card(
            child: Padding(
              padding: const EdgeInsets.all(FoodBookSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Logros desbloqueados',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        '${vm.unlockedCount} / ${vm.totalCount}',
                        style: FoodBookTextStyles.titleSmall.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: FoodBookSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      FoodBookSpacing.radiusFull,
                    ),
                    child: LinearProgressIndicator(
                      value: vm.unlockedCount / vm.totalCount,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.surfaceContainerHigh,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: FoodBookSpacing.lg),

          // ── Lista de logros ──
          Text(
            'Todos los logros',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: FoodBookSpacing.sm),
          ...achievements.map((a) {
            return Card(
              margin: const EdgeInsets.only(bottom: FoodBookSpacing.sm),
              child: Padding(
                padding: const EdgeInsets.all(FoodBookSpacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: a.unlocked
                            ? a.color.withValues(alpha: 0.18)
                            : theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(
                          FoodBookSpacing.radiusMd,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        a.icon,
                        color: a.unlocked ? a.color : theme.colorScheme.outline,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: FoodBookSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  a.title,
                                  style: theme.textTheme.titleSmall,
                                ),
                              ),
                              if (a.unlocked)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: FoodBookColors.success,
                                  size: 18,
                                ),
                            ],
                          ),
                          Text(
                            a.description,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              FoodBookSpacing.radiusFull,
                            ),
                            child: LinearProgressIndicator(
                              value: a.progress,
                              minHeight: 4,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHigh,
                              color: a.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

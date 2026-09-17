import 'package:flutter/material.dart';

import '../../../core/theme/foodbook_colors.dart';
import '../../../core/theme/foodbook_spacing.dart';

/// Roles disponibles en FoodBook.
enum AppRole {
  /// Persona que consume en la pensión: registra sus comidas y pagos.
  consumer,

  /// Dueño/admin de la pensión: ve datos agregados (comensales, ingresos).
  provider;

  String get id => switch (this) {
        AppRole.consumer => 'consumer',
        AppRole.provider => 'provider',
      };

  String get title => switch (this) {
        AppRole.consumer => 'Soy comensal',
        AppRole.provider => 'Soy dueño de pensión',
      };

  String get subtitle => switch (this) {
        AppRole.consumer =>
          'Registro mis comidas, snacks y pagos a la pensión.',
        AppRole.provider =>
          'Veo comensales, ingresos y balance diario de mi pensión.',
      };

  IconData get icon => switch (this) {
        AppRole.consumer => Icons.restaurant_rounded,
        AppRole.provider => Icons.store_mall_directory_rounded,
      };

  Color get color => switch (this) {
        AppRole.consumer => FoodBookColors.skyLight,
        AppRole.provider => FoodBookColors.cyanBright,
      };

  /// Parsea un id persistido al enum correspondiente.
  static AppRole fromId(String? id) {
    if (id == AppRole.provider.id) return AppRole.provider;
    return AppRole.consumer;
  }
}

/// Pantalla de selección de rol.
///
/// Se muestra la primera vez (o cuando el usuario quiere cambiar)
/// desde Ajustes. Define la "personalidad" de la app:
///   - **consumer**: ve Hoy / Cuentas / Perfil / Ajustes
///   - **provider**: ve Resumen / Menú / Clientes / Ajustes
class RoleSelectorScreen extends StatelessWidget {
  final ValueChanged<AppRole> onSelected;
  final bool embedded;

  const RoleSelectorScreen({
    super.key,
    required this.onSelected,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: embedded
          ? AppBar(
              title: const Text('Cambiar rol'),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(FoodBookSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!embedded) ...[
                const SizedBox(height: FoodBookSpacing.xl),
                Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: FoodBookColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.4,
                          ),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.people_alt_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: FoodBookSpacing.lg),
                Text(
                  '¿Cómo usarás FoodBook?',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: FoodBookSpacing.xs),
                Text(
                  'Elige tu rol. Podrás cambiarlo cuando quieras desde Ajustes.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: FoodBookSpacing.xxl),
              ],
              _RoleCard(
                role: AppRole.consumer,
                onTap: () => onSelected(AppRole.consumer),
              ),
              const SizedBox(height: FoodBookSpacing.md),
              _RoleCard(
                role: AppRole.provider,
                onTap: () => onSelected(AppRole.provider),
              ),
              const Spacer(),
              if (!embedded)
                Padding(
                  padding: const EdgeInsets.only(top: FoodBookSpacing.lg),
                  child: Text(
                    'Tu elección se guarda localmente. No se comparte con nadie.',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final AppRole role;
  final VoidCallback onTap;

  const _RoleCard({required this.role, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(FoodBookSpacing.radiusLg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FoodBookSpacing.radiusLg),
            border: Border.all(
              color: role.color.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(FoodBookSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: role.color.withValues(alpha: 0.18),
                  borderRadius:
                      BorderRadius.circular(FoodBookSpacing.radiusMd),
                ),
                alignment: Alignment.center,
                child: Icon(role.icon, size: 32, color: role.color),
              ),
              const SizedBox(width: FoodBookSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role.subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

# Changelog — FoodBook

Todos los cambios notables en FoodBook se documentan aquí. El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y la convención de commits es [Conventional Commits](https://www.conventionalcommits.org/es/v1.0.0/).

## [2.0.0] — 2026-09-15

### Added — Sistema visual
- **feat(theme)** — Paleta oficial azul marino + celeste + blanco con tokens (`foodbook_colors.dart`, `foodbook_spacing.dart`, `foodbook_text_styles.dart`).
- **feat(theme)** — `AppTheme.dark` (identidad) y `AppTheme.light` Material 3 con `ColorScheme` completo.
- **feat(theme)** — `ThemeMode` reactivo desde `SettingsViewModel` global.
- **feat(theme)** — Widgets base: `HeroCard` con gradiente, `StatRow`, `EmptyState`, `StatusBadge`.
- **feat(theme)** — `MoneyFormatter` con símbolos configurables (PEN/USD).
- **feat(shell)** — `MainShell` con barra de navegación glass pildora y 5 destinos.

### Added — Datos
- **feat(db)** — `MigrationStrategy` v1→v2 idempotente con seed inicial.
- **feat(db)** — Tablas auxiliares SQL: `categories`, `payment_methods`, `daily_extras`.
- **feat(db)** — 6 categorías y 4 métodos de pago preinstalados.
- **feat(db)** — `CatalogRepository` y `DailyExtrasRepository`.
- **feat(db)** — `SnackRepository` codifica categoría como `[cat:nombre]desc`.
- **feat(db)** — `PaymentRepository` codifica método como `[method:nombre]nota`.
- **feat(db)** — `DailyLogRepository.watchRange`, `watchLastMonth`, `watchAllOrdered`.

### Added — Pantallas rediseñadas
- **feat(principal)** — `DailyScreen` rediseñada con `HeroCard`, FAB extendido, `RefreshIndicator`, cards nuevas, `Dismissible` con undo.
- **feat(principal)** — Diálogo unificado de bocadillos con selector de categoría (`ChoiceChip`) y soporte para edición.
- **feat(cuentas)** — `AccountsScreen` rediseñada con presupuesto, proyección, gráfico semanal de 7 días y `SummaryCard` con variantes semánticas.
- **feat(cuentas)** — `PaymentHistory` con `Dismissible` + edición inline.
- **feat(historial)** — `HistoryScreen` y `HistoryViewModel` con navegación por mes y `ExpansionTile` por día con detalle completo.
- **feat(perfil)** — `ProfileScreen` completa con avatar de iniciales, grid de estadísticas y bocadillo favorito.
- **feat(ajustes)** — `SettingsScreen` rediseñada con selector de tema, moneda, presupuesto y sección de datos.

### Added — Features nuevas
- **feat(busqueda)** — Pantalla de búsqueda global con filtro reactivo por nombre/categoría/fecha/monto.
- **feat(onboarding)** — Pantalla de bienvenida con 4 páginas y `RootRouter`.
- **feat(logros)** — `AchievementsScreen` y `AchievementsViewModel` con rachas y 7 logros.
- **feat(reminder)** — `ReminderBanner` in-app que sugiere acciones según la hora.
- **feat(maintenance)** — `MaintenanceRepository.wipeAll()` borra datos preservando configuración.

### Changed
- **chore(cleanup)** — Eliminados archivos placeholder vacíos.
- **chore(lint)** — `analysis_options.yaml` endurecido con strict-casts, super_params y reglas Material 3.

### Added — Calidad
- **test(coverage)** — Tests unitarios de decode, constantes y tema.
- **docs(readme)** — README completo con características, arquitectura y roadmap.
- **docs(changelog)** — Este archivo.

### Changed — SettingsViewModel
- Expuesto globalmente en `main.dart` para reactividad de tema/moneda/presupuesto.
- Nuevos getters/setters para `themeMode`, `currency`, `monthlyBudget`, `notifications*`, `onboardingCompleted`.

---

## [1.0.0] — 2026-09-15

- **feat(app)** — Primer commit del proyecto FoodBook con las pantallas Principal y Cuentas semi-funcionales.
- **fix(cuentas)** — Solución de errores y configuración de `.gitignore`.
- **fix(cuentas)** — Corrección para usar streams en la data de gastos y cuentas.


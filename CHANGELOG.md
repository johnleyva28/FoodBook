# Changelog — FoodBook

Todos los cambios notables en FoodBook se documentan aquí. El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y la convención de commits es [Conventional Commits](https://www.conventionalcommits.org/es/v1.0.0/).

## Estado del build

- ✅ `flutter analyze` → No issues found
- ✅ `flutter test` → 81/81 tests passed
- ✅ `flutter build windows --debug` → Build successful

## [2.6.4] — 2026-09-17

### Added
- **feat(search)** — Botón "Limpiar todos los filtros" (`clear_all_rounded` en color `error`) que aparece solo cuando hay filtros activos. Resetea `dateRange`, `minAmount` y `typeFilter` a sus defaults con un `AppToast.info` de confirmación.

## [2.6.3] — 2026-09-17

### Added
- **feat(constants)** — `AppStrings` centraliza todos los strings del producto (auth, onboarding, roles, daily, cuentas, calendario, busqueda, pension, ajustes, errores, confirmaciones) como preparación para futura i18n.
- **feat(help)** — Nueva `HelpScreen` (`/profile` → Ayuda) con 8 preguntas frecuentes (agregar bocadillo/pago, cambiar rol, política de datos, recuperación de PIN, catálogos, sincronización, eliminación de ítems).

### Fixed
- **fix(auth)** — `AuthService.setPin('')` o solo-espacios ya no marca `hasPin = true`. Ahora valida con `trim()` antes de hashear.

### Validation
- **feat(validation)** — Límite máximo en formularios de monto: precio de snack ≤ S/ 500, monto de pago ≤ S/ 10000. Protege contra typos sin impedir valores grandes legítimos.

### Tests
- 81/81 tests pasando (+9 nuevos en `test/auth_validation_test.dart`, expandido `money_formatter_test.dart` y `balance_ring_test.dart`).

## [2.6.2] — 2026-09-17

### Added
- **feat(calendario)** — Navegación prev/next en el AppBar de `DiaDetalleScreen` con dos `IconButton` (chevron_left / chevron_right) que avanzan o retroceden un día vía `pushReplacement` con el nuevo `date`. Permite revisar días consecutivos sin volver al calendario.

## [2.6.1] — 2026-09-17

### Added
- **feat(pension)** — `FoodBookPieChart` (torta) integrado en PensionScreen muestra la distribución de snacks del día agrupados por categoría decodificada.
- **feat(search)** — `SearchSortOrder` enum (recent/oldest/amountHigh/amountLow) + `_pickSortOrder` modal bottom sheet con radio buttons. IconButton 'sort_rounded' en la barra de filtros.

## [2.6.0] — 2026-09-17

### Added — UX polish
- **feat(principal)** — Acciones `Buscar` y `Exportar` en el AppBar de Hoy. Un tap en el icono de lupa abre `SearchScreen` con su propio provider; un tap en el icono share genera un CSV con todos los snacks y pagos via `CsvExporter.exportAndShare`, con `AppToast.info` mientras se genera y `success/error` al terminar.
- **feat(calendario)** — `CalendarGrid.onMonthSelected` opcional: cuando se da, el label del mes se vuelve `InkWell` con flecha que abre `showDatePicker` para saltar a otra fecha directamente. `CalendarioViewModel.setViewedMonth(DateTime)` actualiza el mes visualizado.
- **feat(calendario)** — `DiaDetalleScreen` muestra un FAB extendido `Ir a hoy` solo cuando la fecha mostrada no es hoy. Un tap navega via `pushReplacement` a la `DiaDetalleScreen` de hoy.
- **feat(cuentas)** — `YearStatsScreen` accesible desde Cuentas → "Ver estadísticas anuales". Selector de año con flechas prev/next (no permite futuro), `BalanceRingWithLegend` con consumido vs pagado del año, tabla mensual con consumido/pagado/ratio (LinearProgressIndicator), y top 5 días con más gasto del año. Reactividad en vivo via `AppDataStreams`.

## [2.5.0] — 2026-09-17

### Added — Catálogos + búsqueda mejorada + calendario
- **feat(ajustes)** — `CatalogManagerScreen` con TabBar (Categorías / Métodos) para gestionar los items del catálogo. Permite agregar y eliminar categorías de snacks y métodos de pago personalizados. Los predeterminados están protegidos (lock icon). Accesible desde Ajustes → Catálogos.
- **feat(search)** — `HighlightedText` widget con highlighting del término buscado. Resalta la query en color primario + bold + fondo translucido. `HighlightedSearchTile` envuelve `ListTile` con highlighting aplicado a título y subtítulo. El resultado de búsqueda ahora muestra exactamente dónde matchea el término.
- **feat(calendario)** — Tap en el mes del `CalendarGrid` abre un `showDatePicker` para saltar directamente a otra fecha. `CalendarioViewModel.setViewedMonth(DateTime)` actualiza el mes visualizado.
- **feat(widgets)** — `BalanceRing` con `CircularProgressIndicator` muestra el porcentaje Pagado/Consumido. Variante `BalanceRingWithLegend` con leyenda lateral de 3 valores (consumido, pagado, pendiente). Colores por estado: success >=100%, sky >=50%, warning >0, danger 0%. Integrada en Cuentas entre la HeroCard de deuda y el presupuesto.
- **feat(export)** — `JsonExporter` con serialización estructurada (metadata + listas de snacks y pagos), decodificación de categoria/método via `SnackRepository/PaymentRepository.decode`, escritura a temporal y share sheet del SO con mimeType application/json.
- **feat(onboarding)** — Onboarding expandido a 5 slides (Bienvenido / Marca lo que comes / Controla tu deuda / ¿Dueño de pensión? / Tus datos son privados). El nuevo slide 4 introduce el modo pensión multi-rol. El slide 5 destaca privacidad y export.
- **feat(money)** — `MoneyFormatter.formatCompact` (notación K/M para >=1000) + `MoneyFormatter.defaultPen` (instancia por defecto) + try/catch defensivo con `FoodBookLog` como fallback.

### Tests
- **test(auth)** — 8 tests para `AuthService` (hash, verify, clear, role, hasChosenRole).
- **test(money)** — 9 tests para `MoneyFormatter` (format, compact, fromCode).
- **test(csv)** — 6 tests para `CsvExporter`.
- **test(json)** — 5 tests para `JsonExporter`.
- **test(balance)** — 5 tests para `BalanceRing`.
- **test(highlight)** — 6 tests para `HighlightedText`.

### Build
- **chore(deps)** — Agrega `fl_chart ^0.69.2` y `share_plus ^10.0.2`.

## [2.4.0] — 2026-09-16

### Added — Multi-rol
- **feat(rol)** — Sistema multi-rol: el usuario elige entre `consumer` (comensal) o `provider` (dueño de pensión) la primera vez que abre la app. Pantalla `RoleSelectorScreen` con tarjetas grandes para cada rol y opción embebida para cambiarlo desde Ajustes. Persistencia vía `AuthService.hasChosenRole()`.
- **feat(pension)** — `MenuComidaScreen` y `ComensalesScreen` (nuevo bottom nav para el rol provider). Cada una tiene su `Scaffold` + `AppBar` con icono del rol. Reactividad en vivo desde `AppDataStreams`.
- **feat(shell)** — `MainShell` ahora es reactivo al rol: muestra `Cuentas | Hoy | Perfil | Ajustes` para consumer, o `Resumen | Menú | Clientes | Ajustes` para provider. El cambio es instantáneo al cambiar de rol en Ajustes.
- **feat(auth)** — `AuthService` refactorizado a singleton `ChangeNotifier` (`AuthService.instance`) con `load()` async, getters de instancia (`role`, `hasPin`) y `setRole()`, `setPin()`, `clearPin()`, `resetPin()` como métodos de instancia. Compatibilidad con API estática anterior (`AuthService.hasPin()`, `setPin()`).

### Changed
- **feat(settings)** — Nueva sección "Mi rol" con `ListTile` que muestra el rol actual y abre `RoleSelectorScreen` embebido. Al cambiar, muestra `AppToast.success` y reconstruye el `MainShell`.

### Tests
- **test(rol)** — 4 tests para `AppRole` enum: id, fromId con null/desconocido/provider/consumer, defaults, metadata no vacía.

## [2.3.0] — 2026-09-16

### Added — Robustez e infraestructura
- **feat(streams)** — `AppDataStreams` global (bus reactivo único) compartido por todos los VMs. Reemplazó las subscripciones duplicadas a Drift en `ProfileViewModel`, `AchievementsViewModel` y `SearchViewModel`. Cualquier edición ahora se refleja al instante en todas las pantallas sin recargar.
- **feat(auth)** — Sistema de autenticación local con PIN de 4 dígitos. SHA-256 hash vía `crypto`. Pantalla `PinScreen` con teclado numérico y tres modos (lock/setup/confirm). `AuthService` con `AuthBackend` plugin (default: `SettingsAuthBackend` que persiste vía `SettingsRepository`).
- **feat(toast)** — Helper `AppToast` centralizado con 5 métodos (info/success/warning/danger/withAction). Estilo consistente en toda la app (floating, esquinas redondeadas, color por tipo, icono representativo).
- **feat(core)** — `AppErrorBoundary` envuelve `MaterialApp.builder` y captura `FlutterError.onError` para mostrar pantalla amigable en lugar de pantalla roja de debug.
- **feat(core)** — `FoodBookLog` logger centralizado con niveles d/i/w/e, activo solo en modo debug.
- **feat(pension)** — Pantalla `PensionScreen` "Modo pensión" accesible desde Perfil > Mi actividad. Muestra comensales servidos hoy, balance consumido/cobrado, margen/déficit y pedidos de snacks del día.
- **feat(export)** — Export CSV real con `share_plus`. `CsvExporter` genera archivo en directorio temporal con dos secciones (snacks/pagos), escapa RFC 4180, y abre el share sheet del SO.

### Changed
- **feat(settings)** — Nueva sección "Seguridad" en Ajustes con SwitchListTile para activar/desactivar PIN.
- **feat(core)** — `MoneyFormatter.fromCode(code)` factory para mapeo PEN/USD/S-/\$ al símbolo correcto.
- **feat(maintenance)** — `MaintenanceRepository.wipeAll()` envuelve la operación en try/catch y reporta a `FoodBookLog`.

### Fixed
- **fix(streams)** — Cast inseguro `as StreamSubscription<List<Category>>` reemplazado por `.map()` en streams. Era un bug latente en runtime.

### Tests
- **test(auth)** — 8 tests para `AuthService` (hash, verify, clear, role)
- **test(money)** — 9 tests para `MoneyFormatter` (format, compact, fromCode)
- **test(csv)** — 6 tests para `CsvExporter` (escape, decode, formato, vacío)

## [2.2.0] — 2026-09-15

### Changed
- **feat(streams)** — Nuevo `AppDataStreams` global que mantiene una única subscripción a `daily_logs`, `snack_entries`, `payments` y `categories`. Todas las pantallas (Hoy, Cuentas, Calendario, DíaDetalle) lo escuchan vía `addListener`, así cualquier edición se refleja instantáneamente en todas las vistas sin recargar.

### Fixed
- **fix(sync)** — Los cambios hechos desde Calendario/DíaDetalle ya no tardan en propagarse a Hoy/Cuentas. Bug raíz: cada VM creaba su propio cache interno con suscripciones duplicadas a Drift.

## [2.1.0] — 2026-09-15

### Changed
- **refactor(shell)** — Barra de navegación inferior con 4 destinos (Cuentas | Hoy | Perfil | Ajustes). Historial eliminado del bottom nav.
- **refactor(perfil)** — Nueva sección "Mi actividad" con accesos a Calendario, Historial (alias) y Logros.
- **feat(calendario)** — Nueva feature `lib/features/calendario/`: grid mensual editable con vista de detalle por día. Permite editar días pasados o futuros (toggle comidas, agregar/editar/borrar snacks y pagos, notas, rating, gastos extra).
- **feat(repos)** — `DailyLogRepository` ahora expone `setLunchForDate`, `setDinnerForDate`, `saveBreakfastForDate`. `SnackRepository` y `PaymentRepository` aceptan fecha personalizada en `add()`.

### Removed
- **refactor(historial)** — Eliminado `lib/features/historial/` completo. Reemplazado por el Calendario que cubre el mismo caso de uso y mucho más.

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


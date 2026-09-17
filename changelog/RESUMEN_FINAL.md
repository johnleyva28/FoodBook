# Resumen ejecutivo — FoodBook 2.3.0

## Métricas

- **Versión**: 2.3.0
- **Commits**: 47 (3 originales + 44 nuevos)
- **Líneas Dart (lib)**: ~14 000
- **Tests**: 42 pasando (0 fallos)
- **`flutter analyze`**: 0 issues
- **`flutter build windows --debug`**: Build successful

## Arquitectura

```
MVVM con Provider
├── AppDataStreams (bus reactivo global) ← ÚNICA suscripción a Drift
├── Repositorios (cambian DB) → notifican al bus
└── ViewModels (leen del bus) → notifican a la UI

Drift (SQLite) ─── Tablas: daily_logs, snack_entries, payments, settings
                ── Auxiliares SQL: categories, payment_methods, daily_extras
```

## Features por pantalla

### 🏠 Principal (Hoy)
- Toggle desayuno/almuerzo/cena con cálculo en vivo
- Bocadillos con categoría, deslizar para borrar + undo
- Recordatorio in-app por hora (11-14 almuerzo, 18-21 cena)
- HeroCard con gasto del día
- Editor de desayuno con precio + descripción

### 💰 Cuentas
- HeroCard con deuda (variante danger/success)
- **Presupuesto mensual** con barra de progreso y badge de estado
- **Proyección fin de mes** desde promedio diario
- **Gráfico semanal** 7×N
- Desglose histórico (almuerzos, cenas, desayunos, snacks, pagado)
- Agregar / editar / borrar pagos con método
- **Export CSV** (compartir vía share sheet del SO)

### 📅 Calendario
- Grid mensual 7×N con marcadores (amarillo=consumo, verde=solo pago)
- Vista de día editable: comidas, snacks, pagos, notas, rating, gastos extra
- "Ir a hoy" + navegación mes anterior/siguiente

### 🏪 Modo Pensión (vista del dueño)
- Comensales servidos hoy (desayunos/almuerzos/cenas)
- Balance consumido vs cobrado
- Margen o déficit del día
- Pedidos de snacks del día

### 👤 Perfil
- Avatar con iniciales + gradiente
- Stats: días registrados, consumido, pagado, promedio, snacks totales, bocadillo favorito
- "Mi actividad": Calendario / Historial / Modo pensión

### 🔒 Seguridad (opcional)
- PIN de 4 dígitos con hash SHA-256 (no se guarda en claro)
- Teclado numérico custom con haptic feedback
- "¿Olvidaste tu PIN?" → borra datos locales

### 🔍 Búsqueda
- Busca por nombre/categoría/método/fecha/monto en snacks y pagos

### 🏆 Logros
- 7 achievements con rachas y metas

### ⚙️ Ajustes
- Tema (oscuro / claro / sistema)
- Moneda (PEN / USD)
- Precios base (almuerzo, cena, presupuesto mensual)
- **Seguridad** (toggle PIN)
- Datos (exportar CSV, borrar todo)
- Acerca de

## Componentes base

- **AppToast**: helper centralizado para SnackBars (5 tipos, action undo)
- **AppErrorBoundary**: captura errores y muestra pantalla amigable
- **FoodBookLog**: logger debug-only con niveles d/i/w/e
- **MoneyFormatter**: formateo es_PE (S/$, 2 decimales, K/M compacto)
- **FoodBookLogo**: logo con gradiente y sombra
- **HeroCard / StatRow / StatusBadge / EmptyState / ReminderBanner**

## Estructura de archivos

```
lib/
├── core/
│   ├── constants/    AppConstants
│   ├── theme/         AppTheme, foodbook_{colors,spacing,text_styles}
│   ├── utils/         DateHelper, FoodBookLog, MoneyFormatter
│   └── widgets/       HeroCard, StatRow, AppToast, AppErrorBoundary,
│                      ReminderBanner, FoodBookLogo, FoodBookHeader
├── data/
│   ├── database/      AppDatabase + app_database.g.dart (Drift)
│   ├── models/        DailyLog, SnackEntry, Payment, Settings, Category
│   ├── repositories/  DailyLog, Snack, Payment, Settings, Catalog,
│                      DailyExtras, Maintenance
│   ├── app_data_streams.dart  ← bus global
│   └── exporters/     CsvExporter
├── features/
│   ├── ajustes/       Settings screen + VM
│   ├── auth/          AuthService, PinScreen, SettingsAuthBackend
│   ├── busqueda/      Search screen + VM
│   ├── calendario/    Calendario screen + VM, CalendarGrid, DiaDetalle
│   ├── cuentas/       Accounts screen + VM + widgets
│   ├── logros/        Achievements screen + VM
│   ├── onboarding/    Onboarding 4-page
│   ├── pension/       PensionScreen
│   └── principal/     Daily screen + VM + widgets
├── shell/             MainShell (4 destinos), RootRouter (Onboarding + PIN)
└── main.dart          MultiProvider + AppDataStreams init
```

## Convenciones

- **Commits**: Conventional Commits con scope en español
  - `feat(scope): descripción`
  - `fix(scope): descripción`
  - `refactor(scope): ...`
  - `test(scope): ...`
  - `chore(scope): bump / cleanup`
  - `docs(scope): ...`
  - `style(scope): ...`
- No hay hook `commit-msg` (la convención es advisory)
- Mensajes en imperativo, minúsculas, sin punto final

## Roadmap (no implementado)

- [ ] Notificaciones push nativas (requiere `flutter_local_notifications`)
- [ ] Sync en la nube (Firebase / Supabase)
- [ ] Widget para Android home screen
- [ ] Gráfico mensual con `fl_chart`
- [ ] Compartir resumen semanal por WhatsApp

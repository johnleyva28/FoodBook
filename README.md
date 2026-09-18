# 🍽️ FoodBook

> Tu pensión, en un cuaderno — registro diario de comidas y gastos en la pensión.

FoodBook es una app **Flutter offline-first** para Android, iOS y Windows.
Te ayuda a registrar qué comiste en la pensión, controlar cuánto gastas
y saber siempre cuánto le debes a tu pensión (o cuánto te deben tus
comensales, si eres el dueño).

![Estado](https://img.shields.io/badge/estado-activo-38BDF8)
![Versión](https://img.shields.io/badge/versión-2.6.7-38BDF8)
![Flutter](https://img.shields.io/badge/Flutter-3.13%2B-0B1E3F)
![Plataformas](https://img.shields.io/badge/plataformas-Android%20%7C%20iOS%20%7C%20Windows-7DD3FC)
![Tests](https://img.shields.io/badge/tests-97%2F97-38BDF8)
![Issues](https://img.shields.io/badge/analisis-0%20issues-34D399)
![Licencia](https://img.shields.io/badge/licencia-MIT-7DD3FC)

---

## ✨ Por qué FoodBook

- 📴 **Funciona sin internet**: todos los datos viven en tu dispositivo
  (SQLite local vía Drift).
- ⚡ **Sync en vivo**: editas algo y se refleja al instante en todas las
  pantallas, sin recargar.
- 👥 **Multi-rol**: una sola app, dos experiencias (consumidor o
  pensionista).
- 🎨 **Diseño cuidado**: tema oscuro azul marino + celeste + blanco de
  alto contraste, Material 3.
- 📊 **Estadísticas**: anual, mensual, top 5 días, gráficos con
  `fl_chart`.
- 📤 **Exporta cuando quieras**: CSV o JSON con `share_plus`.
- 🔒 **PIN opcional**: SHA-256, sin librerías externas.

---

## 👥 Multi-rol

FoodBook adapta su barra inferior y sus pantallas al rol elegido:

| Consumidor (comensal) | Pensión (dueño) |
|-----------------------|-----------------|
| Cuentas | Resumen |
| Hoy | Menú |
| Perfil | Clientes |
| Ajustes | Ajustes |

Eliges tu rol la primera vez (o desde Perfil → Cambiar rol) y la app
muestra los datos agregados apropiados: turnos servidos, balance,
pedidos en modo pensión.

---

## 🏠 Pantalla principal (Hoy)

- Toggle de **desayuno**, **almuerzo** y **cena** con cálculo automático
  del gasto del día.
- **Bocadillos rápidos** con categorías personalizables (panadería,
  fruta, café, etc.).
- Diálogo unificado para agregar y editar bocadillos con validación
  (precio 0 < x ≤ 500).
- Recordatorio in-app según la hora (11:00–14:00 almuerzo,
  18:00–21:00 cena).
- AppBar con acciones: **Buscar** y **Exportar** (CSV).

## 💰 Cuentas

- Hero card con **deuda con la pensión** en variante danger/success.
- **Presupuesto mensual** con barra de progreso y badge de estado.
- **Proyección fin de mes** basada en tu promedio diario.
- **Gráfico semanal** de los últimos 7 días.
- Registrar / **editar** / borrar pagos con método (Efectivo, Yape,
  Plin, Transferencia).
- **Exportar a CSV** o **JSON** con `share_plus` — abre el share sheet
  del SO.

### 📊 Estadísticas anuales

- Resumen anual: consumido, pagado, balance, racha, mejor día.
- Top 5 días con más gasto.
- **Acceso directo al resumen mensual** (botón
  `calendar_view_month_rounded` en el AppBar).

### 📊 Estadísticas mensuales

- Selector de mes con chevron prev/next + botón "Actual".
- 3 cards de resumen: consumido, pagado, pendiente.
- Chart de barras con consumo por día del mes.
- Top 5 días con mayor consumo.
- Pie chart con distribución por categoría.

## 📅 Calendario

- Vista mensual con grid 7xN y marcadores para días con actividad.
- Tap en cualquier día (pasado o futuro) abre la vista de detalle.
- Día editable: toggle desayuno/almuerzo/cena, agregar/editar/borrar
  snacks y pagos.
- Editor de notas, rating 1-5 y gastos extra por día.
- **Navegación prev/next** con chevron en el AppBar.
- **FAB "Ir a hoy"** cuando estás viendo un día distinto al actual.

## 🏪 Modo pensión (vista del dueño)

- **PensionScreen**: comensales servidos hoy (desayunos / almuerzos /
  cenas), balance del día con anillo de progreso, pedidos del día con
  snacks agrupados.
- **Pie chart** con distribución de snacks por categoría.
- **MenuComidaScreen**: CRUD del menú diario con foto opcional.
- **ComensalesScreen**: lista de comensales recurrentes.

## 👤 Perfil

- Avatar con iniciales y gradiente.
- Grid de estadísticas personales: consumido, pagado, promedio diario,
  snacks.
- Bocadillo **favorito** (el más registrado).
- Sección **Mi actividad** con acceso a Calendario, Historial, Modo
  pensión.
- **Ayuda y preguntas frecuentes** (8 FAQ en `HelpScreen`).

## 🔒 Seguridad (opcional)

- PIN de 4 dígitos con hash **SHA-256** (sin librerías externas, usa
  `crypto`).
- Validación: rechaza PINs vacíos o solo-espacios.
- Actívalo en Ajustes → Seguridad.
- Si lo olvidas, "Restablecer" borra los datos locales (se puede volver
  a empezar).

## 🔍 Búsqueda global

- Busca por nombre, categoría, método, fecha o monto.
- Filtros combinables:
  - Tipo (todos / snacks / pagos).
  - Rango de fechas (date range picker).
  - Monto mínimo.
  - Orden (más reciente, más antiguo, mayor monto, menor monto).
- Botón **"Limpiar todos los filtros"** cuando hay alguno activo.

## 🏆 Logros

- **Racha actual** e histórica.
- 7 achievements: Primer mordisco, Constancia 3/7/30, 50 almuerzos,
  20 snacks, Equilibrio.

## ⚙️ Ajustes

- **Tema** oscuro (identidad), claro o sistema.
- **Moneda** PEN/USD.
- Precios base de almuerzo/cena editables.
- **Presupuesto mensual** editable.
- **Administrar catálogos**: agregar, renombrar y eliminar categorías de
  snacks y métodos de pago.
- **Exportar CSV / JSON** con `share_plus`.
- Borrar todos los datos con doble confirmación.

## 🌱 Onboarding

- 5 pantallas de bienvenida la primera vez que abres la app.
- Indicadores animados y opción "Saltar".
- Cubre: bienvenida, sincronización en vivo, modo pensión, búsqueda,
  catálogos.

---

## 🏗️ Arquitectura

- **MVVM** (Modelo-Vista-ViewModel) con `provider` para inyección y
  reactividad.
- **Drift** como ORM sobre **SQLite** (`path_provider` para localizar
  el archivo).
- **AppDataStreams**: bus reactivo global que emite cuando cambia
  cualquier tabla. Una sola suscripción para toda la app.
- **Tablas auxiliares** (`categories`, `payment_methods`,
  `daily_extras`) creadas con SQL crudo para no requerir regenerar
  `.g.dart`.
- **Codificación de campos opcionales** en campos existentes: ej.
  `[cat:Panadería]croissant` en `description` para preservar la
  categoría aunque el `.g.dart` no se regenere.

```
lib/
├── core/
│   ├── constants/     # AppConstants (claves, defaults, currencies)
│   │                  # AppStrings (textos centralizados para futura i18n)
│   ├── theme/         # AppTheme, colores, tipografía, spacing
│   ├── utils/         # DateHelper (20+ métodos), MoneyFormatter
│   └── widgets/       # HeroCard, StatRow, BalanceRing, DailyBarChart,
│                      # FoodBookPieChart, EmptyState, AppToast, ...
├── data/
│   ├── database/      # AppDatabase + .g.dart (Drift)
│   ├── models/        # DailyLog, SnackEntry, Payment, Settings, ...
│   ├── exporters/     # CsvExporter, JsonExporter
│   └── repositories/  # Snack, Payment, Catalog, DailyExtras, Settings
├── features/
│   ├── ajuste(s)/     # Settings + Catalog manager
│   ├── auth/          # PIN screen + AuthService (singleton)
│   ├── busqueda/      # Search + filter chips
│   ├── calendario/    # Calendar + day detail
│   ├── cuentas/       # Accounts + YearStats + MonthlyStats
│   ├── help/          # FAQ / Help screen
│   ├── historial/     # History screen
│   ├── logros/        # Achievements
│   ├── onboarding/    # Onboarding 5 slides
│   ├── pension/       # PensionScreen, MenuComida, Comensales
│   ├── perfil/        # Profile
│   ├── principal/     # Daily + snack cards
│   ├── rol_selector/  # RoleSelectorScreen
│   └── splash/        # SplashScreen
├── shell/             # MainShell adaptativo por rol
└── main.dart          # Entry, MultiProvider, MaterialApp
```

---

## 🎨 Identidad visual

| Token | Hex | Uso |
|-------|-----|-----|
| `navyDeep` | `#0B1E3F` | Fondo principal (dark) |
| `navySurface` | `#0F2A5C` | Superficie elevada |
| `sky` | `#38BDF8` | Primary / accent |
| `cyanBright` | `#22D3EE` | Highlights |
| `success` | `#34D399` | Estados positivos |
| `warning` | `#FBBF24` | Atención |
| `error` | `#F87171` | Errores |

Tokens centralizados en `lib/core/theme/foodbook_colors.dart`. Material 3
con `ColorScheme` completo. Tema oscuro por defecto (identidad) y
claro/sistema opcionales.

---

## 📦 Instalación

```bash
# 1. Clonar
git clone https://github.com/johnleyva28/FoodBook.git
cd foodbook

# 2. Dependencias
flutter pub get

# 3. Generar código de Drift (solo si cambias tablas)
dart run build_runner build --delete-conflicting-outputs

# 4. Ejecutar
flutter run               # device conectado
flutter run -d windows    # escritorio
flutter run -d android    # emulador / device
flutter run -d ios        # simulador / device
```

### Dependencias principales

| Paquete | Uso |
|---------|-----|
| `drift` + `sqlite3_flutter_libs` | ORM sobre SQLite |
| `provider` | Inyección de dependencias y reactividad |
| `fl_chart` | Gráficos (barras, torta, anillo) |
| `share_plus` | Diálogo de compartir del SO |
| `path_provider` | Directorio temporal para exports |
| `crypto` | SHA-256 para el PIN |
| `intl` | Formato de números y fechas en español |

---

## 🧪 Tests

```bash
flutter test
flutter test --coverage
```

Estado actual (**FoodBook 2.6.7**):

- ✅ `flutter analyze` → **No issues found**
- ✅ `flutter test` → **97/97 tests passed**
- ✅ `flutter build windows --debug` → **Build successful**

Tests cubren:

- `unit_test.dart` — constantes y decodificación de campos opcionales.
- `theme_test.dart` — el tema se construye correctamente en dark/light.
- `widget_test.dart` — smoke test del tema.
- `app_role_test.dart` — enum y serialización del rol.
- `auth_service_test.dart` — AuthService singleton.
- `auth_validation_test.dart` — validación del PIN (vacío, espacios,
  hash SHA-256, determinismo).
- `balance_ring_test.dart` — widget BalanceRing con/sin leyenda.
- `csv_exporter_test.dart` / `json_exporter_test.dart` — exports.
- `date_helper_test.dart` — 20+ métodos de fechas (14 tests).
- `empty_state_test.dart` — widget EmptyState (6 tests).
- `highlighted_text_test.dart` — resaltado case-insensitive.
- `money_formatter_test.dart` — formato currency (15 tests).

---

## 🛣️ Roadmap

- [x] Exportación CSV con `share_plus`.
- [x] Sincronización en vivo con `AppDataStreams`.
- [x] Modo pensión multi-rol.
- [x] Búsqueda con texto, tipo, fecha, monto y orden.
- [x] Estadísticas anuales y mensuales.
- [ ] Notificaciones nativas (`flutter_local_notifications`).
- [ ] Sincronización opcional entre dispositivos (Firebase / Supabase).
- [ ] Modo widget para Android (`home_widget`).
- [ ] Tema claro optimizado (ahora es secundario).
- [ ] Respaldo automático en archivo local.

---

## 📝 Changelog

Ver [`CHANGELOG.md`](./CHANGELOG.md) para el detalle completo por
versión (2.0.0 → 2.6.7).

## 📂 Estructura de cambios

Los cambios se documentan por feature en cada commit (Conventional
Commits) y se resumen en `CHANGELOG.md`. Las decisiones de diseño y
planificación viven en `changelog/`.

---

## 🤝 Contribuir

1. Fork + branch con prefijo `feat/`, `fix/` o `refactor/`.
2. Conventional Commits en español: `feat(area): descripción`.
3. `flutter analyze` + `flutter test` + `flutter build windows` deben
   pasar antes de push.
4. PR con descripción clara.

---

## 📄 Licencia

MIT.

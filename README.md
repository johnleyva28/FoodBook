# 🍽️ FoodBook

> Tu pensión, en un cuaderno — registro diario de comidas y gastos en la pensión.

FoodBook es una app Flutter offline-first para Android, iOS y Windows. Te ayuda a registrar qué comiste en la pensión, controlar cuánto gastas y saber siempre cuánto le debes a tu pensión.

![Estado](https://img.shields.io/badge/estado-activo-38BDF8)
![Versión](https://img.shields.io/badge/versión-2.3.0-38BDF8)
![Flutter](https://img.shields.io/badge/Flutter-3.13%2B-0B1E3F)
![Plataformas](https://img.shields.io/badge/plataformas-Android%20%7C%20iOS%20%7C%20Windows-7DD3FC)

---

## ✨ Características

### 🏠 Principal
- Toggle de **desayuno**, **almuerzo** y **cena** con cálculo automático del gasto del día.
- Bocadillos rápidos con **categorías** (panadería, fruta, café, etc.).
- Diálogo unificado para agregar y editar bocadillos.
- Deslizar para borrar con **snackbar de deshacer**.
- Recordatorio in-app según la hora (11:00–14:00 almuerzo, 18:00–21:00 cena).

### 💰 Cuentas
- **Deuda con la pensión** en hero card con variante danger/success.
- **Presupuesto mensual** con barra de progreso y badge de estado (en rango / cerca / excedido).
- **Proyección fin de mes** basada en tu promedio diario.
- **Gráfico semanal** de los últimos 7 días.
- Desglose histórico de almuerzos, cenas, desayunos, snacks, consumido y pagado.
- Registrar / **editar** / borrar pagos con método (Efectivo, Yape, Plin, Transferencia).
- **Exportar CSV** con `share_plus` — abre el share sheet del SO con el archivo.

### 📅 Calendario
- Vista mensual con grid 7xN y marcadores para días con actividad.
- Tap en cualquier día (pasado o futuro) abre la vista de detalle.
- Día editable: toggle desayuno/almuerzo/cena, agregar/editar/borrar snacks y pagos.
- Editor de notas, rating 1-5 y gastos extra por día.

### 🏪 Modo pensión (vista del dueño)
- Comensales servidos hoy: desayunos / almuerzos / cenas.
- Balance del día: consumido vs cobrado, margen o déficit.
- Pedidos del día con snacks agrupados.

### 👤 Perfil
- Avatar con iniciales y gradiente.
- Grid de estadísticas personales: consumido, pagado, promedio diario, snacks.
- Bocadillo **favorito** (el más registrado).
- Sección **Mi actividad** con acceso a Calendario, Historial (alias) y Modo pensión.

### 🔒 Seguridad (opcional)
- PIN de 4 dígitos con hash **SHA-256**.
- Actívalo en Ajustes → Seguridad.
- Si lo olvidas, "Restablecer" borra los datos locales (se puede volver a empezar).

### 🔍 Búsqueda global
- Busca por nombre, categoría, método, fecha o monto.
- Filtra tanto snacks como pagos.

### 🏆 Logros
- **Racha actual** e histórica.
- 7 achievements: Primer mordisco, Constancia 3/7/30, 50 almuerzos, 20 snacks, Equilibrio.

### ⚙️ Ajustes
- **Tema** oscuro (identidad), claro o sistema.
- **Moneda** PEN/USD.
- Precios base de almuerzo/cena editables.
- **Presupuesto mensual** editable.
- Exportar CSV (pendiente de implementación completa).
- Borrar todos los datos con confirmación.

### 🔍 Búsqueda global
- Busca por nombre, categoría, método, fecha o monto.
- Filtra tanto snacks como pagos.

### 🌱 Onboarding
- 4 pantallas de bienvenida la primera vez que abres la app.
- Indicadores animados y opción "Saltar".

---

## 🏗️ Arquitectura

- **MVVM** (Modelo-Vista-ViewModel) usando `provider` para la inyección y reactividad.
- **Drift** como ORM sobre **SQLite** (`path_provider` para localizar el archivo).
- Streams de Drift expuestos por repositorios para reactividad automática.
- **Tablas auxiliares** (`categories`, `payment_methods`, `daily_extras`) creadas con SQL crudo para no requerir regenerar `.g.dart`.
- Codificación de campos opcionales en campos existentes (ej. `[cat:Panadería]croissant` en `description`).

```
lib/
├── core/
│   ├── constants/      # AppConstants (claves, defaults, currencies)
│   ├── theme/          # AppTheme, colores, tipografía, spacing
│   ├── utils/          # DateHelper, MoneyFormatter
│   └── widgets/        # HeroCard, StatRow, ReminderBanner, ...
├── data/
│   ├── database/       # AppDatabase + .g.dart (Drift)
│   ├── models/         # DailyLog, SnackEntry, Payment, Settings, Category
│   └── repositories/   # Repos por dominio (Snack, Payment, Catalog, etc.)
├── features/
│   ├── ajustes/        # Settings screen + VM
│   ├── busqueda/       # Search screen + VM
│   ├── cuentas/        # Accounts screen + VM + widgets
│   ├── historial/      # History screen + VM
│   ├── logros/         # Achievements screen + VM
│   ├── onboarding/     # Onboarding screen
│   ├── perfil/         # Profile screen + VM
│   └── principal/      # Daily screen + VM + widgets
├── shell/              # MainShell, RootRouter
└── main.dart           # App entry, MultiProvider
```

---

## 🎨 Identidad visual

- **Azul marino** `#0B1E3F` — fondo principal.
- **Celeste sky** `#38BDF8` — accent / primary.
- **Blanco** `#F8FAFC` — texto de alto contraste.

Tokens centralizados en `lib/core/theme/foodbook_colors.dart`. Material 3 con `ColorScheme` completo (primary, secondary, tertiary, error, surface, etc.). Tema oscuro (identidad) y claro opcionales.

---

## 📦 Instalación

```bash
# 1. Clonar
git clone https://github.com/johnleyva28/FoodBook.git
cd foodbook

# 2. Dependencias
flutter pub get

# 3. Generar código de Drift (solo necesario si cambias tablas)
dart run build_runner build --delete-conflicting-outputs

# 4. Ejecutar
flutter run               # device conectado
flutter run -d windows    # escritorio
```

---

## 🧪 Tests

```bash
flutter test
```

Estado actual (FoodBook 2.3.0):
- ✅ `flutter analyze` → **No issues found**
- ✅ `flutter test` → **42/42 tests passed**
- ✅ `flutter build windows --debug` → **Build successful**

Los tests cubren:

- `unit_test.dart` — constantes y decodificación de campos opcionales.
- `theme_test.dart` — el tema se construye correctamente en dark/light.
- `widget_test.dart` — smoke test del tema.

---

## 🛣️ Roadmap

- [ ] Exportación CSV real con `share_plus` o `path_provider` + intent.
- [ ] Notificaciones nativas (`flutter_local_notifications`) en horarios configurables.
- [ ] Sincronización opcional entre dispositivos (Firebase / Supabase).
- [ ] Modo widget para Android (`home_widget`).
- [ ] Gráfico mensual con `fl_chart`.

---

## 📝 Changelog

Ver [`CHANGELOG.md`](./CHANGELOG.md) para el detalle de cada versión.

---

## 📄 Licencia

MIT.

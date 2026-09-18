# 🏛️ Arquitectura de FoodBook

Documento técnico para desarrolladores que quieran entender o extender
FoodBook. Si buscas cómo contribuir, lee primero
[`CONTRIBUTING.md`](./CONTRIBUTING.md).

---

## 🧱 Stack

| Capa | Tecnología |
|------|------------|
| UI | Flutter 3.13+ / Material 3 |
| Estado | `provider` (ChangeNotifier + InheritedProvider) |
| Persistencia | Drift sobre SQLite |
| Reactive bus | `AppDataStreams` (broadcast ChangeNotifier) |
| Gráficos | `fl_chart` |
| Auth | `crypto` (SHA-256) sin servidor |
| Share | `share_plus` |

Sin Firebase, sin backend, sin telemetría. Todo corre offline.

---

## 📦 Modelo de datos

### Tablas (Drift)

| Tabla | Generada | Contenido |
|-------|----------|-----------|
| `daily_logs` | `.g.dart` | Toggle desayuno/almuerzo/cena por fecha |
| `snack_entries` | `.g.dart` | Bocadillos: precio, descripción, fecha |
| `payments` | `.g.dart` | Pagos: monto, método, fecha |
| `categories` | SQL crudo | Categorías de snacks (icono, color, default) |
| `payment_methods` | SQL crudo | Métodos de pago (icono, default) |
| `daily_extras` | SQL crudo | Notas, rating, gastos extra por día |
| `settings` | `.g.dart` | Preferencias (moneda, tema, presupuesto) |

### Codificación de campos opcionales

Para evitar regenerar `.g.dart` al añadir columnas opcionales, usamos
**prefijo en `description`**:

```
'[cat:Panadería]Croissant de mantequilla'
 → category = 'Panadería'
 → desc     = 'Croissant de mantequilla'
```

Helper: `SnackRepository.decode(String?)` retorna `(String?, String?)`.

---

## 🔄 Reactividad: `AppDataStreams`

`AppDataStreams` es un `ChangeNotifier` global que mantiene el último
valor emitido por cada tabla de la DB:

```dart
class AppDataStreams extends ChangeNotifier {
  List<SnackEntry> get snacks => _snacks;
  List<Payment> get payments => _payments;
  // ...
}
```

**Una sola suscripción por tabla.** Cualquier VM que llame a
`streams.addListener(_onChange)` recibe notificaciones cuando esa
tabla cambia.

```
DB change ──► Stream ──► AppDataStreams actualiza listas
                       └► notifica listeners
                          ├► DailyVM rebuilda
                          ├► AccountsVM rebuilda
                          └► PensionVM rebuilda
```

### Por qué no streams directos

Usar `db.watch()` directamente en cada VM multiplicaría las
suscripciones y haría el cambio caro con muchos datos. El bus global
**amortigua** los cambios: solo se notifica "algo cambió", cada VM
filtra lo que le importa.

---

## 🧩 Patrón ViewModel

```dart
class MiViewModel extends ChangeNotifier {
  final AppDataStreams _streams;
  MiViewModel(this._streams) {
    _streams.addListener(_onChange);
  }

  void _onChange() => notifyListeners();

  // Estado público (read-only desde la UI)
  List<MiItem> get items => _items;

  // Acciones (públicas)
  Future<void> update(MiItem item) async {
    await _repo.update(item);
    // _streams se actualiza solo desde el stream
  }

  @override
  void dispose() {
    _streams.removeListener(_onChange);
    super.dispose();
  }
}
```

**Convención:**
- VMs **nunca** reciben `BuildContext`.
- VMs **nunca** hacen `Navigator.push`.
- VMs exponen métodos públicos para mutar estado (`updateX(value)`).
- `notifyListeners()` es `protected`, así que se llama desde dentro de
  `_onX` privados.

---

## 🏗️ Shell adaptativo

`MainShell` muestra 4 destinos según el rol:

```dart
final destinations = isProvider
    ? _providerDestinations()   // Resumen, Menú, Clientes, Ajustes
    : _consumerDestinations();  // Cuentas, Hoy, Perfil, Ajustes
```

`IndexedStack` mantiene los 4 widgets vivos (estado preservado al
cambiar de tab).

---

## 🔐 Auth / PIN

`AuthService` es **singleton**. Se inicializa una vez en `main.dart`:

```dart
AuthService.init(SharedPreferencesAuthBackend());
```

### Hash

```dart
String _hash(String pin) {
  final bytes = utf8.encode(pin);
  return sha256.convert(bytes).toString();
}
```

64 caracteres hex, sin salt (PIN de 4 dígitos no se beneficia de salt).
Para apps reales con contraseñas largas **sí debería llevar salt**.

### Validación

`setPin('')` retorna sin hacer nada (validación con `trim()`). Esto
evita que el flag `_hasPin` quede `true` con un hash vacío.

---

## 📊 Charts

| Widget | Uso | Datos |
|--------|-----|-------|
| `BalanceRing` | Deuda vs pagado del día | Consumido, pagado |
| `BalanceRingWithLegend` | Igual + leyenda | + strings custom |
| `DailyBarChart` | Barras últimos N días | Lista `DailyChartData` |
| `FoodBookPieChart` | Distribución por categoría | Lista de pares (label, value) |

Todos comparten la paleta de `FoodBookColors.sky`, `cyanBright`,
`success`, etc.

---

## 📤 Exports

`CsvExporter` y `JsonExporter`:

1. Construyen el contenido en memoria.
2. Escriben a `getTemporaryDirectory()`.
3. Llaman `Share.shareXFiles([XFile(path)])`.

El usuario decide dónde guardar (correo, Drive, WhatsApp, etc).

---

## 🎨 Theming

`AppTheme.light` / `AppTheme.dark` construyen `ThemeData` Material 3
con tokens de `FoodBookColors`.

- **Dark** es la identidad (azul marino profundo).
- **Light** está implementado pero es secundario.

`SettingsViewModel.themeMode` se inyecta en `MaterialApp.themeMode` y
hace el cambio reactivo.

---

## 🧪 Testing

- **Unit tests**: helpers, modelos, lógica pura.
- **Widget tests**: widgets custom con `pumpWidget` + `find.text`.
- **Sin tests de integración** (todavía): no se ha añadido `integration_test`.

Cobertura por archivo:

| Archivo | Tests |
|---------|-------|
| `auth_validation_test.dart` | 11 |
| `balance_ring_test.dart` | 8 |
| `csv_exporter_test.dart` | 6 |
| `date_helper_test.dart` | 14 |
| `empty_state_test.dart` | 6 |
| `highlighted_text_test.dart` | 5 |
| `json_exporter_test.dart` | 6 |
| `money_formatter_test.dart` | 15 |
| `unit_test.dart` | 7 |
| otros | 19 |
| **Total** | **97** |

---

## 🚧 Limitaciones conocidas

- Sin migración de esquema (estamos en 2.6, los cambios han sido
  aditivos).
- No hay tests de integración con un device real.
- Tema claro es funcional pero no pulido.
- Sin backup automático: si formateas el dispositivo, pierdes datos
  (mitigado por export CSV/JSON).

---

## 🛣️ Próximos pasos sugeridos

1. **Notificaciones nativas** con `flutter_local_notifications`.
2. **Tests de integración** con `integration_test`.
3. **Migraciones Drift** si se añaden columnas nuevas.
4. **i18n real** con `arb` + `flutter gen-l10n` (AppStrings es la base).
5. **Backup automático** cada N días a un directorio configurable.

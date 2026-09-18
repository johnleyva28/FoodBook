# 🤝 Guía para contribuir a FoodBook

Gracias por tu interés en mejorar FoodBook. Esta guía te ayuda a
mantener la calidad y consistencia del proyecto.

---

## 🧭 Convenciones

### Conventional Commits (en español)

Todos los commits siguen el formato:

```
<tipo>(<scope>): <descripción corta en minúsculas, sin punto final>
```

**Tipos permitidos:**

| Tipo | Cuándo usarlo |
|------|---------------|
| `feat` | Nueva funcionalidad visible para el usuario |
| `fix` | Bug fix |
| `refactor` | Cambio interno sin nueva feature ni fix |
| `style` | Formato, comillas, espacios (no cambia lógica) |
| `docs` | Solo documentación (README, CHANGELOG) |
| `test` | Añadir o arreglar tests |
| `chore` | Build, dependencias, herramientas |
| `perf` | Mejora de rendimiento |

**Scopes comunes:** `auth`, `cuentas`, `principal`, `calendario`,
`busqueda`, `pension`, `ajustes`, `perfil`, `logros`, `core`,
`widgets`, `database`, `repositories`, `constants`, `onboarding`,
`help`.

**Ejemplos:**

```
feat(cuentas): nueva MonthlyStatsScreen con resumen mensual
fix(auth): setPin rechaza PIN vacio o solo-espacios
refactor(core): centralizar textos en AppStrings
docs(readme): actualizar documentacion con todas las features
```

---

## ✅ Antes de hacer push

```bash
# 1. Análisis estático
flutter analyze          # debe decir "No issues found"

# 2. Tests
flutter test             # todos deben pasar (97/97 actualmente)

# 3. Build local
flutter build windows --debug   # confirmar que compila
```

Si alguno falla, **no commitees** hasta resolverlo. Si un lint es muy
estricto para tu caso, documéntalo con `// ignore: <rule>` y un
comentario breve de por qué.

---

## 🌳 Branches

- `main` — código estable. Solo recibe PRs.
- `feat/<nombre-corto>` — feature en desarrollo.
- `fix/<nombre-corto>` — bug fix.

**Nunca** commitees directo a `main` sin pasar por un PR (incluso
siendo el único dev — el PR es tu "revisión" formal).

---

## 📁 Estructura del código

Antes de añadir archivos, **revisa si ya existe algo similar**:

- Widget reusable → `lib/core/widgets/`
- Utilidad / helper → `lib/core/utils/`
- Constantes / strings → `lib/core/constants/`
- Modelo de datos → `lib/data/models/` o `lib/data/database/`
- Acceso a datos → `lib/data/repositories/`
- Pantalla + VM → `lib/features/<area>/screens/` + `viewmodels/`

### Patrón de una feature

```
lib/features/mi_feature/
├── screens/
│   └── mi_feature_screen.dart
├── viewmodels/
│   └── mi_feature_viewmodel.dart
├── widgets/        # opcional, widgets específicos de la feature
```

### ViewModel

- Extiende `ChangeNotifier`.
- Constructor recibe `AppDataStreams` (no `BuildContext`).
- Expón `updateX(value)` públicos para escribir desde la UI.
- Escucha `_streams.addListener(_onChange)` si necesita reactividad.
- Implementa `dispose()` para limpiar listeners.

### Repositorio

- Acepta `AppDatabase` por constructor.
- Streams (`watchX()`) retornan `Stream<List<T>>`.
- Métodos de escritura (`add`, `update`, `delete`) retornan `Future`.
- Sin lógica de UI; solo datos.

---

## 🧪 Tests

- Cada helper en `lib/core/utils/` debe tener tests.
- Cada repositorio debe tener al menos 1 test de integración (create +
  read).
- Cada VM debe tener un test que verifique su estado inicial.
- Widgets custom en `lib/core/widgets/` deben tener tests de render.

**Estructura:**

```
test/
├── <archivo>_test.dart
```

Si tu feature no tiene tests, **el PR será rechazado**.

---

## 🎨 Estilo de código

- `prefer_const_constructors`, `prefer_final_locals`, etc. ya están
  activos en `analysis_options.yaml`.
- Imports relativos con `../` (no `package:foodbook/...`) — está
  enforced por `prefer_relative_imports`.
- Sin `print()` en producción — usa `FoodBookLog`.
- Sin `// ignore` sin comentario explicativo.

---

## 📚 Documentación

- Dartdoc en clases y métodos públicos (`///`).
- Actualiza `CHANGELOG.md` si tu cambio es visible para el usuario.
- Si cambias el modelo de datos, regenera Drift con `dart run
  build_runner build`.
- Si añades una pantalla, agrégala al README en la sección
  correspondiente.

---

## 🚫 Lo que NO aceptamos

- Commits con `print()` de debug.
- `// ignore` sin justificación.
- Cambios sin tests.
- Nuevas dependencias sin discutir antes.
- Cambios al esquema de DB sin migración.

---

## 🐛 Reportar bugs

Abre un issue con:

1. Pasos para reproducir.
2. Comportamiento esperado vs observado.
3. Screenshots si aplica.
4. Versión de FoodBook (`app_constants.dart` → `appVersion`).

---

¡Gracias por contribuir! 🎉

/// Strings centralizadas de la aplicación.
///
/// En el futuro, esta clase se reemplazará por un sistema de i18n con
/// arb/arb+. Por ahora centralizamos todos los strings del producto en
/// un solo lugar para facilitar la traducción.
///
/// Las claves siguen la convención `section.action` (ej: `auth.setPin`,
/// `daily.today`) para que sea trivial agruparlas o buscarlas.
abstract class AppStrings {
  AppStrings._();

  // ── App ──
  static const appName = 'FoodBook';

  // ── Auth ──
  static const authPinTitle = 'PIN de seguridad';
  static const authPinSubtitle =
      'Configura un PIN para proteger el acceso a tu información.';
  static const authPinConfirmTitle = 'Confirma tu PIN';
  static const authPinConfirmSubtitle = 'Ingrésalo de nuevo para confirmar.';
  static const authPinUnlockTitle = 'Desbloquear FoodBook';
  static const authPinUnlockSubtitle = 'Ingresa tu PIN para continuar.';
  static const authPinSetupButton = 'Configurar PIN';
  static const authPinChangeButton = 'Cambiar PIN';
  static const authPinSkipButton = 'Omitir';
  static const authPinUnlockButton = 'Desbloquear';
  static const authPinMismatch = 'Los PINs no coinciden';
  static const authPinTooShort = 'Mínimo 4 dígitos';
  static const authPinResetTitle = 'Restablecer PIN';
  static const authPinResetBody =
      '¿Seguro que quieres eliminar el PIN? Cualquiera con acceso al '
      'dispositivo podrá ver la información.';

  // ── Onboarding ──
  static const onboardingTitle1 = 'Bienvenido a FoodBook';
  static const onboardingBody1 =
      'Registra tus bocadillos, almuerzos y cenas. Lleva el control '
      'del consumo diario y los pagos de tu pensión.';
  static const onboardingTitle2 = 'Sincronización en vivo';
  static const onboardingBody2 =
      'Todos tus cambios se reflejan al instante en cada pantalla. '
      'Sin recargar ni esperar.';
  static const onboardingTitle3 = 'Modo Pensión';
  static const onboardingBody3 =
      'Si vendes comida o gestionas una pensión, activa el modo '
      'Pensión para ver tus clientes y balance del día.';
  static const onboardingTitle4 = 'Búsqueda y exportación';
  static const onboardingBody4 =
      'Busca por descripción, fecha o monto. Exporta a CSV cuando '
      'lo necesites.';
  static const onboardingTitle5 = 'Personaliza tu catálogo';
  static const onboardingBody5 =
      'Crea tus propias categorías de snacks y métodos de pago '
      'desde Configuración.';
  static const onboardingSkip = 'Omitir';
  static const onboardingNext = 'Siguiente';
  static const onboardingFinish = 'Empezar';

  // ── Roles ──
  static const roleConsumerTitle = 'Consumidor';
  static const roleConsumerDesc =
      'Quiero registrar lo que consumo y pagar mi pensión.';
  static const roleProviderTitle = 'Pensionista';
  static const roleProviderDesc =
      'Quiero gestionar los pedidos y pagos de mis clientes.';
  static const roleChoose = 'Elige tu rol';

  // ── Daily ──
  static const dailyToday = 'Hoy';
  static const dailyExport = 'Exportar';
  static const dailySearch = 'Buscar';
  static const dailySnacks = 'Bocadillos';
  static const dailyLunch = 'Almuerzo';
  static const dailyDinner = 'Cena';
  static const dailyMarkConsumed = 'Marcar consumido';

  // ── Cuentas ──
  static const accountsBalance = 'Balance del día';
  static const accountsPayments = 'Pagos';
  static const accountsSnacks = 'Bocadillos';
  static const accountsYear = 'Resumen anual';
  static const accountsAddPayment = 'Agregar pago';

  // ── Calendario ──
  static const calendarTitle = 'Calendario';
  static const calendarPickDay = 'Selecciona un día';
  static const calendarGoToday = 'Ir a hoy';

  // ── Búsqueda ──
  static const searchTitle = 'Buscar';
  static const searchEmpty = 'Sin resultados';
  static const searchFilterType = 'Tipo';
  static const searchFilterDate = 'Fecha';
  static const searchFilterAmount = 'Monto mínimo';
  static const searchFilterSort = 'Ordenar';

  // ── Pension ──
  static const pensionTitle = 'Modo Pensión';
  static const pensionMenu = 'Menú del día';
  static const pensionDiners = 'Comensales';
  static const pensionByCategory = 'Distribución por categoría';

  // ── Ajustes ──
  static const settingsTitle = 'Configuración';
  static const settingsExportCsv = 'Exportar a CSV';
  static const settingsExportJson = 'Exportar a JSON';
  static const settingsCatalog = 'Administrar catálogos';
  static const settingsCurrency = 'Moneda';
  static const settingsPin = 'PIN de seguridad';
  static const settingsAbout = 'Acerca de';

  // ── Errores ──
  static const errGeneric = 'Algo salió mal. Inténtalo de nuevo.';
  static const errLoadData = 'No se pudieron cargar los datos.';
  static const errNetwork = 'Sin conexión a internet.';

  // ── Confirmaciones ──
  static const confirmDelete = '¿Eliminar?';
  static const confirmDeleteBody = 'Esta acción no se puede deshacer.';
  static const actionCancel = 'Cancelar';
  static const actionDelete = 'Eliminar';
  static const actionSave = 'Guardar';
}

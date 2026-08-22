// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Gestor de Tienda';

  @override
  String get portalLoginTitle => 'Acceso de la Tienda';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get saveButton => 'Guardar';

  @override
  String get continueButton => 'Continuar';

  @override
  String get closeButton => 'Cerrar';

  @override
  String get createButton => 'Crear';

  @override
  String get editButton => 'Editar';

  @override
  String get skipButton => 'Omitir';

  @override
  String get signInWithPasskeyButton => 'Iniciar sesión con una passkey';

  @override
  String get demoModeLandingButton => 'Probar el modo de demostración';

  @override
  String get demoModeBannerText => 'Modo de demostración';

  @override
  String get exitDemoButton => 'Salir de la demostración';

  @override
  String get passkeySetupTitle => '¿Configurar una passkey?';

  @override
  String get passkeySetupBody =>
      'Inicie sesión más rápido la próxima vez usando la huella, el rostro o el PIN de este dispositivo. Esto solo funciona en este dispositivo y navegador; es una comodidad local, no una forma de acceder a su cuenta desde otro lugar.';

  @override
  String get passkeySetupButton => 'Configurar';

  @override
  String get passkeyManageButton => 'Configurar inicio de sesión con passkey';

  @override
  String passkeyUnsupportedError(String error) {
    return 'El inicio de sesión con passkey no está disponible: $error';
  }

  @override
  String get statusPasskeyEnrolled =>
      'El inicio de sesión con passkey ya está listo en este dispositivo';

  @override
  String get accountEntryTitle => 'Iniciar sesión';

  @override
  String get accountEntryBody =>
      'Introduzca su número de móvil y fecha de nacimiento. Iniciaremos su sesión si este dispositivo ya tiene una cuenta, o crearemos una si no la tiene.';

  @override
  String get accountChoiceTitle => 'Opciones avanzadas';

  @override
  String get accountChoiceBody =>
      'Use estas opciones si configuró una contraseña personalizada, o si necesita restaurar esta cuenta en un dispositivo nuevo.';

  @override
  String get accountUnlockButton => 'Iniciar sesión con contraseña';

  @override
  String get accountHighSecurityButton => 'Configuración de alta seguridad';

  @override
  String get accountRestoreButton => 'Restaurar con frase de respaldo';

  @override
  String get accountAdvancedOptionsLink => 'Opciones avanzadas';

  @override
  String get accountMismatchError =>
      'Ese número de móvil y fecha de nacimiento no coinciden con la cuenta de este dispositivo. Use Opciones avanzadas para iniciar sesión de otra forma.';

  @override
  String get accountSignInButton => 'Iniciar sesión';

  @override
  String get accountSignInTooltip => 'Iniciar sesión';

  @override
  String get createPassphraseTitle => 'Crear cuenta';

  @override
  String get createPassphraseHint =>
      'Cree una contraseña (8+ caracteres). No se puede recuperar.';

  @override
  String get confirmPassphraseTitle => 'Confirmar contraseña';

  @override
  String get confirmPassphraseHint =>
      'Introduzca la misma contraseña de nuevo.';

  @override
  String get passphraseMismatchMessage => 'Las contraseñas no coinciden';

  @override
  String get unlockTitle => 'Iniciar sesión';

  @override
  String get unlockHint => 'Introduzca su contraseña.';

  @override
  String get noAccountFoundMessage =>
      'No se encontró ninguna cuenta en este dispositivo. Cree una primero.';

  @override
  String get restoreTitle => 'Restaurar cuenta';

  @override
  String get restorePhraseFieldLabel => 'Frase de respaldo de 12 palabras';

  @override
  String get setPassphraseTitle => 'Establecer una contraseña';

  @override
  String get setPassphraseHint => 'Cree una contraseña (8+ caracteres).';

  @override
  String get restoreButton => 'Restaurar';

  @override
  String get backupPhraseTitle => 'Guarde su frase de respaldo';

  @override
  String get backupPhraseBody =>
      'Anote estas 12 palabras y guárdelas sin conexión. Cualquiera que las tenga podrá acceder a esta cuenta.';

  @override
  String get backupPhraseConfirmCheckbox => 'He anotado mi frase de respaldo';

  @override
  String get quickSetupWarning =>
      'Esto protege su cuenta para el uso diario en este dispositivo. Para mayor protección, use Opciones avanzadas.';

  @override
  String get quickSetupMobileLabel => 'Número de móvil';

  @override
  String get quickSetupBirthdayLabel => 'Fecha de nacimiento (AAAA-MM-DD)';

  @override
  String get storeNameFieldLabel => 'Nombre de la tienda';

  @override
  String get storeNameDefault => 'Mi tienda';

  @override
  String get preferencesButton => 'Preferencias';

  @override
  String get preferencesTooltip => 'Preferencias';

  @override
  String get preferencesTitle => 'Preferencias';

  @override
  String get preferencesBody =>
      'Opcional. Su número de móvil y fecha de nacimiento se cifran antes de recordarse en este dispositivo.';

  @override
  String get preferencesMobileLabel => 'Número de móvil';

  @override
  String get preferencesBirthdayLabel => 'Fecha de nacimiento (AAAA-MM-DD)';

  @override
  String get preferencesLanguageLabel => 'Idioma';

  @override
  String get preferencesRememberCheckbox => 'Recordar estos datos';

  @override
  String get preferencesSecurityNote =>
      'Mayor seguridad: guarde su frase de respaldo sin conexión y utilícela para restaurar esta cuenta si se pierde el almacenamiento de este dispositivo.';

  @override
  String get accountGateHeadline =>
      'Inicie sesión para abrir el gestor de tienda';

  @override
  String get accountGateBody =>
      'Su cuenta es la llave del gestor de tienda. Las cuentas locales se almacenan como almacenes de claves cifrados protegidos por su contraseña.';

  @override
  String get chatTooltip => 'Chatear con soporte';

  @override
  String get portalTooltip => 'Gestor de tienda';

  @override
  String get chatWithSupportTitle => 'Chat con soporte';

  @override
  String get messageSupportHint => 'Mensaje para soporte';

  @override
  String get clientMenuTitle => 'Menú a la carta';

  @override
  String clientMenuSubtitle(String channel) {
    return 'Canal: $channel · Toque un plato para ver los detalles y añadirlo a su pedido';
  }

  @override
  String get menuFallbackCategory => 'Menú';

  @override
  String get clientOrderLockedTitle => 'Inicie sesión para realizar su pedido';

  @override
  String get clientOrderUnlockedTitle => 'Sus pedidos de este canal';

  @override
  String get clientOrderLockedSubtitle =>
      'Solo los titulares de cuenta pueden crear y ver su propio historial de pedidos.';

  @override
  String clientOrderUnlockedSubtitle(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pedidos cifrados',
      one: '1 pedido cifrado',
    );
    return '$_temp0 · Total NT\$$total';
  }

  @override
  String clientOrderTotalLabel(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '1 artículo',
    );
    return 'Total NT\$$total ($_temp0)';
  }

  @override
  String get clientOrderConfirmButton => 'Confirmar pedido';

  @override
  String get salesWorkspaceTitle => 'Espacio de ventas';

  @override
  String get salesWorkspaceSubtitle => 'Menú';

  @override
  String get offlineTerminalFooter => 'Terminal sin conexión';

  @override
  String get navOverview => 'Resumen';

  @override
  String get navThirdParties => 'Clientes';

  @override
  String get navProducts => 'Productos';

  @override
  String get navOrders => 'Pedidos';

  @override
  String get navConnection => 'Conexión';

  @override
  String get navSupport => 'Soporte';

  @override
  String get createChannelButton => 'Crear enlace de tienda';

  @override
  String get channelNameFieldLabel => 'Nombre del enlace de tienda';

  @override
  String channelReadyTitle(String code) {
    return 'Enlace de tienda $code listo';
  }

  @override
  String get printButton => 'Imprimir';

  @override
  String get metricOrders => 'Pedidos';

  @override
  String get metricThirdParties => 'Clientes';

  @override
  String get metricProducts => 'Productos';

  @override
  String get storageCardTitle => 'Almacenamiento local';

  @override
  String storageCardSubtitle(String channel) {
    return 'El enlace de tienda $channel guarda los pedidos en este dispositivo. Mantenga esta ventana abierta aquí: eso es lo que mantiene su enlace de pago y el chat activos para los clientes.';
  }

  @override
  String get customersSectionTitle => 'Clientes';

  @override
  String get customersSectionSubtitle => 'Directorio de clientes';

  @override
  String get colName => 'Nombre';

  @override
  String get colCustomerCode => 'Código de cliente';

  @override
  String get colEmail => 'Correo electrónico';

  @override
  String get customersEmpty => 'Aún no hay clientes.';

  @override
  String get productsSectionTitle => 'Productos';

  @override
  String get productsSectionSubtitle => 'Catálogo de productos';

  @override
  String get loadSampleMenuButton => 'Cargar menú de ejemplo';

  @override
  String get newProductButton => 'Nuevo producto';

  @override
  String get colReference => 'Referencia';

  @override
  String get colLabel => 'Nombre';

  @override
  String get colPriceHt => 'Precio (sin impuestos)';

  @override
  String get colVat => 'IVA';

  @override
  String get colStock => 'Existencias';

  @override
  String get translationsAction => 'Traducciones';

  @override
  String get productsEmpty =>
      'Aún no hay productos. Añada uno o cargue el menú de ejemplo.';

  @override
  String get newProductTitle => 'Nuevo producto';

  @override
  String get editProductTitle => 'Editar producto';

  @override
  String get fieldReference => 'Referencia';

  @override
  String get fieldLabel => 'Nombre';

  @override
  String get fieldPriceHt => 'Precio (sin impuestos)';

  @override
  String get fieldVat => 'IVA %';

  @override
  String get fieldStock => 'Existencias';

  @override
  String get translationsDialogTitle => 'Traducciones';

  @override
  String get translationsLanguageLabel => 'Idioma';

  @override
  String get translationsLabelField => 'Nombre';

  @override
  String get translationsDescriptionField => 'Descripción';

  @override
  String get ordersSectionTitle => 'Pedidos';

  @override
  String get ordersSectionSubtitle => 'Historial de pedidos';

  @override
  String orderTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transacciones',
      one: '1 transacción',
    );
    return '$_temp0';
  }

  @override
  String get ordersEmptyMock =>
      'Llegan nuevos pedidos automáticamente cada 10 segundos.';

  @override
  String get operateTransactionTooltip => 'Gestionar pedido';

  @override
  String get validateOrderMenuItem => 'Marcar como validado';

  @override
  String get acceptOrderMenuItem => 'Marcar como aceptado';

  @override
  String get processOrderMenuItem => 'Marcar como en proceso';

  @override
  String get deliverOrderMenuItem => 'Marcar como entregado';

  @override
  String get cancelOrderMenuItem => 'Cancelar pedido';

  @override
  String totalHtLabel(String total) {
    return 'Subtotal NT\$$total';
  }

  @override
  String totalTtcLabel(String total) {
    return 'Total NT\$$total';
  }

  @override
  String get orderStatusDraft => 'Borrador';

  @override
  String get orderStatusValidated => 'Validado';

  @override
  String get orderStatusAccepted => 'Aceptado';

  @override
  String get orderStatusProcessing => 'En proceso';

  @override
  String get orderStatusDelivered => 'Entregado';

  @override
  String get orderStatusCanceled => 'Cancelado';

  @override
  String get orderStatusUnknown => 'Desconocido';

  @override
  String get supportSectionTitle => 'Soporte';

  @override
  String supportSectionSubtitle(String channel) {
    return 'Canal $channel';
  }

  @override
  String get joinAsAgentButton => 'Unirse como agente';

  @override
  String get conversationsTab => 'Conversaciones';

  @override
  String get activityLogTab => 'Registro de actividad';

  @override
  String get noActivityYet => 'Aún no hay actividad.';

  @override
  String get noConversationsYet => 'Aún no hay conversaciones.';

  @override
  String get noMessagesYet => 'Sin mensajes';

  @override
  String get selectConversationPrompt => 'Seleccione una conversación';

  @override
  String get replyHint => 'Responder al cliente';

  @override
  String get roleOwnerLabel => 'Propietario';

  @override
  String get roleAgentLabel => 'Agente';

  @override
  String get roleMemberLabel => 'Miembro';

  @override
  String get connectionConnected => 'Conectado';

  @override
  String get connectionReconnectNeeded => 'Es necesario reconectar';

  @override
  String get connectionConnecting => 'Conectando…';

  @override
  String get connectionNotConnected => 'Sin conexión';

  @override
  String get connectionSectionTitle => 'Conexión';

  @override
  String get connectionSectionSubtitle =>
      'Emparejamiento manual para la entrega del chat en vivo';

  @override
  String get portalKeepOpenHint =>
      'Mantenga esta ventana abierta en este dispositivo: eso es lo que mantiene el enlace de pago y el chat de su tienda activos para los clientes.';

  @override
  String get connectionDefaultMessage =>
      'Usando un repetidor público para descubrir rutas';

  @override
  String get generateOfferButton => 'Generar código de emparejamiento';

  @override
  String get acceptOfferButton => 'Introducir código de emparejamiento';

  @override
  String get applyAnswerButton => 'Aplicar respuesta';

  @override
  String get offerFieldLabel => 'Código de emparejamiento';

  @override
  String get answerFieldLabel => 'Código de respuesta';

  @override
  String get connectionOfferGeneratedMessage =>
      'Código de emparejamiento generado. Compártalo con el otro dispositivo y luego introduzca su respuesta.';

  @override
  String get connectionAnswerGeneratedMessage =>
      'Respuesta generada. Envíela de vuelta al dispositivo que creó el código de emparejamiento.';

  @override
  String get connectionAnswerAppliedMessage => 'Conexión establecida.';

  @override
  String connectionOfferErrorMessage(String error) {
    return 'Error de emparejamiento: $error';
  }

  @override
  String connectionAcceptErrorMessage(String error) {
    return 'Error de respuesta: $error';
  }

  @override
  String connectionApplyErrorMessage(String error) {
    return 'Error de conexión: $error';
  }

  @override
  String get connectionFooterNote =>
      'Esto ayuda a descubrir una conexión directa entre dispositivos. No proporciona por sí mismo la entrega de mensajes.';

  @override
  String get statusStartingDb => 'Iniciando base de datos local…';

  @override
  String statusClientStorageError(String error) {
    return 'Error de almacenamiento local: $error';
  }

  @override
  String get statusReadyMessage =>
      'Listo — explore y gestione los datos de la tienda';

  @override
  String statusStartupError(String error) {
    return 'Error de inicio: $error';
  }

  @override
  String statusOrderSynced(String ref, int lineCount, int bytes) {
    return 'Se sincronizó $ref con $lineCount líneas ($bytes bytes)';
  }

  @override
  String statusSyncError(String error) {
    return 'Error de sincronización: $error';
  }

  @override
  String statusOrderStatusChanged(String statusLabel) {
    return 'El estado del pedido cambió a $statusLabel';
  }

  @override
  String statusProductSaved(String ref) {
    return 'Producto $ref guardado localmente';
  }

  @override
  String statusMenuLoaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se cargaron $count productos de menú de ejemplo localmente',
      one: 'Se cargó 1 producto de menú de ejemplo localmente',
    );
    return '$_temp0';
  }

  @override
  String statusAccountCanceled(String error) {
    return 'Inicio de sesión cancelado o fallido: $error';
  }

  @override
  String statusAccountConnected(String address) {
    return 'Cuenta conectada y cifrado inicializado: $address';
  }

  @override
  String get statusProfileDecryptError =>
      'No se pudo descifrar el perfil recordado';

  @override
  String statusProfileSaved(String address) {
    return 'Información de contacto cifrada y recordada para $address';
  }

  @override
  String get statusProfileRemoved =>
      'Se eliminó la información de contacto recordada';

  @override
  String statusTransactionReadFailed(String error) {
    return 'Fallo al leer la transacción cifrada: $error';
  }

  @override
  String statusOrderSaved(String ref) {
    return 'Pedido $ref cifrado para esta cuenta y guardado sin conexión';
  }

  @override
  String get orderSavedSnackbar => 'Pedido guardado sin conexión';

  @override
  String get statusBackupDownloaded => 'Copia de seguridad descargada';

  @override
  String get statusBackupRestored => 'Copia de seguridad restaurada';

  @override
  String statusRestoreFailed(String error) {
    return 'Fallo al restaurar: $error';
  }

  @override
  String get backupTooltip => 'Hacer copia de seguridad';

  @override
  String get restoreTooltip => 'Restaurar datos';

  @override
  String get refreshTooltip => 'Actualizar datos';

  @override
  String get restoreConfirmTitle => '¿Restaurar desde la copia de seguridad?';

  @override
  String get restoreConfirmBody =>
      'Esto reemplazará todos los datos actuales de la tienda y del cliente con el contenido del archivo de copia de seguridad elegido. Esta acción no se puede deshacer.';

  @override
  String orderStatusChangedLog(int orderId, String statusLabel) {
    return 'Pedido n.º $orderId → $statusLabel';
  }

  @override
  String productSavedLog(String ref, String price) {
    return 'Producto $ref guardado (NT\$$price)';
  }

  @override
  String channelCreatedLog(String code, String name) {
    return 'Canal $code creado: \"$name\"';
  }

  @override
  String accountConnectedLog(String address) {
    return 'Cuenta $address conectada';
  }

  @override
  String agentJoinedLog(String address, String channel) {
    return 'El agente $address se unió al canal $channel';
  }

  @override
  String get navContent => 'Contenido del menú';

  @override
  String get contentSectionTitle => 'Contenido del menú';

  @override
  String get contentSectionSubtitle =>
      'Contenido de la tienda orientado al cliente';

  @override
  String get newContentItemButton => 'Nuevo elemento';

  @override
  String get publishButton => 'Publicar a los clientes';

  @override
  String get demoModeButton => 'Modo demo';

  @override
  String get contentEmpty => 'Aún no hay elementos de contenido.';

  @override
  String get colCategory => 'Categoría';

  @override
  String get newContentItemTitle => 'Nuevo elemento';

  @override
  String get editContentItemTitle => 'Editar elemento';

  @override
  String get fieldCategory => 'Categoría';

  @override
  String get fieldDescription => 'Descripción';

  @override
  String get statusContentPublished =>
      'Contenido del menú publicado para los clientes conectados';

  @override
  String get resetDataButton => 'Restablecer datos';

  @override
  String get resetConfirmTitle => '¿Restablecer todos los datos?';

  @override
  String get resetConfirmBody =>
      'Esto elimina permanentemente todos los datos de tienda, chat, contenido del menú y fidelización de este dispositivo. Su cuenta con la sesión iniciada no se ve afectada. Esta acción no se puede deshacer.';

  @override
  String get statusDataReset => 'Todos los datos se han restablecido';

  @override
  String get navLoyalty => 'Fidelización';

  @override
  String get loyaltySectionTitle => 'Fidelización';

  @override
  String get loyaltySectionSubtitle => 'Puntos y niveles de los clientes';

  @override
  String get colWallet => 'Cuenta';

  @override
  String get colPointsBalance => 'Puntos';

  @override
  String get colTier => 'Nivel';

  @override
  String get adjustPointsButton => 'Ajustar puntos';

  @override
  String get adjustPointsTitle => 'Ajustar puntos';

  @override
  String get pointsFieldLabel => 'Puntos (negativo para canjear)';

  @override
  String get reasonFieldLabel => 'Motivo';

  @override
  String get loyaltyEmpty => 'Aún no hay cuentas de fidelización.';

  @override
  String get statusPointsAdjusted => 'Puntos ajustados';

  @override
  String get navBookings => 'Reservas';

  @override
  String get bookingsSectionTitle => 'Reservas';

  @override
  String get bookingsSectionSubtitle => 'Reservas de mesa y estado';

  @override
  String get seedMachinesButton => 'Cargar mesas de ejemplo';

  @override
  String get machinesEmpty =>
      'Aún no hay mesas. Cargue las mesas de ejemplo para empezar.';

  @override
  String get machineStateIdle => 'Libre';

  @override
  String get machineStateOccupied => 'Ocupada';

  @override
  String get machineStateMaintenance => 'Mantenimiento';

  @override
  String get setIdleButton => 'Marcar como libre';

  @override
  String get setMaintenanceButton => 'Marcar como mantenimiento';

  @override
  String get bookingsEmpty => 'Aún no hay reservas.';

  @override
  String get bookingStatusPlanned => 'Planificada';

  @override
  String get bookingStatusReleased => 'Confirmada';

  @override
  String get bookingStatusInProgress => 'En curso';

  @override
  String get bookingStatusCompleted => 'Completada';

  @override
  String get bookingStatusCanceled => 'Cancelada';

  @override
  String get releaseBookingMenuItem => 'Confirmar';

  @override
  String get startBookingMenuItem => 'Iniciar';

  @override
  String get completeBookingMenuItem => 'Completar';

  @override
  String get cancelBookingMenuItem => 'Cancelar';

  @override
  String get clientBookingCardTitle => 'Reservar una mesa';

  @override
  String get clientBookingMachineLabel => 'Mesa';

  @override
  String get clientBookingTimeLabel => 'Hora';

  @override
  String get clientBookingPartySizeLabel => 'Número de personas';

  @override
  String get clientBookingSubmitButton => 'Solicitar reserva';

  @override
  String get statusBookingRequested => 'Solicitud de reserva enviada';
}

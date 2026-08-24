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
  String get chatWithSupportTitle => 'Chat con soporte';

  @override
  String get messageSupportHint => 'Mensaje para soporte';

  @override
  String get memberZoneTooltip => 'Zona de miembros';

  @override
  String get memberZoneTitle => 'Zona de miembros';

  @override
  String get clientMenuTitle => 'Menú a la carta';

  @override
  String clientMenuSubtitle(String channel) {
    return 'Canal: $channel · Toque un plato para ver los detalles y añadirlo a su pedido';
  }

  @override
  String get installAppTitle => 'Install LilyGO ERP';

  @override
  String get installAppBody =>
      'Install this order screen on Android, iOS, Windows, or macOS.';

  @override
  String get installAppHint =>
      'Use Install app, Add to Dock, or on iPhone/iPad Share → Add to Home Screen.';

  @override
  String get enableNotificationsButton => 'Enable notifications';

  @override
  String get notificationsEnabled => 'Notifications enabled';

  @override
  String get notificationsBlocked =>
      'Notifications are blocked in this browser';

  @override
  String get keepAwakeButton => 'Keep screen awake';

  @override
  String get screenAwakeEnabled =>
      'Screen will stay awake while this page is open';

  @override
  String get newOrderNotificationTitle => 'New order';

  @override
  String newOrderNotificationBody(String ref) {
    return 'Order $ref is ready to review.';
  }

  @override
  String get alwaysOnConnectionHint =>
      'Keep this installed app open for live WebRTC orders. If the device suspends it, the connection will show Reconnect needed.';

  @override
  String get iosInstallHint =>
      'On iPhone or iPad: Share → Add to Home Screen, then keep the app open for live orders.';

  @override
  String get backgroundSupportNav => 'Always-on & notifications';

  @override
  String get backgroundSupportTitle => 'Always-on & notifications';

  @override
  String get backgroundSupportSubtitle =>
      'Keep the portal connection visible and receive order alerts.';

  @override
  String get backgroundSupportWebTitle => 'Web app';

  @override
  String get backgroundSupportWebBody =>
      'Works while this page is open. The browser may suspend it when it is in the background.';

  @override
  String get backgroundSupportAndroidTitle => 'Android';

  @override
  String get backgroundSupportAndroidBody =>
      'A native foreground-service app is required for reliable background operation.';

  @override
  String get backgroundSupportIosTitle => 'iPhone & iPad';

  @override
  String get backgroundSupportIosBody =>
      'Install from Safari for quick access. Background alerts require Apple Push Notifications.';

  @override
  String get backgroundSupportChromeTitle => 'Chrome extension';

  @override
  String get backgroundSupportChromeBody =>
      'Install the extension to open the portal in a dedicated Chrome app tab.';

  @override
  String get downloadChromeExtensionButton => 'Download Chrome extension';

  @override
  String get backgroundSupportKeepOpen =>
      'For live WebRTC orders, keep the portal open on the always-on device.';

  @override
  String get deviceConnectionTitle => 'LAN device connection';

  @override
  String get deviceConnectionBody =>
      'The ESP32 is a LAN-only storage and attestation server. It does not serve the web app.';

  @override
  String get deviceUrlLabel => 'ESP32 LAN URL';

  @override
  String get deviceUrlHint => 'http://192.168.1.50:8000';

  @override
  String get saveDeviceUrlButton => 'Save device URL';

  @override
  String get scanDeviceQrButton => 'Scan device QR';

  @override
  String get deviceUrlSaved => 'Device URL saved';

  @override
  String get deviceReachable => 'Device is reachable';

  @override
  String get deviceUnavailable => 'Device is unavailable';

  @override
  String get deviceQrUnsupported =>
      'QR scanning is not supported in this browser. Enter the LAN URL manually.';

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
  String get checkoutInvoiceTitle => 'Invoice preview';

  @override
  String get paymentMethodLabel => 'Payment method';

  @override
  String get cashPaymentLabel => 'Cash';

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
  String get googleDriveBackupTooltip => 'Back up to Google Drive';

  @override
  String get googleDriveRestoreTooltip => 'Restore from Google Drive';

  @override
  String get googleSheetExportTooltip => 'Export to Google Sheet';

  @override
  String get googleSheetImportTooltip => 'Import from Google Sheet';

  @override
  String get googleWorkspaceClientMissing =>
      'Google Workspace is not configured for this deployment';

  @override
  String get googleWorkspaceBackupDone => 'Backup saved to Google Drive';

  @override
  String get googleWorkspaceRestoreDone => 'Backup restored from Google Drive';

  @override
  String googleWorkspaceSheetDone(Object url) {
    return 'Google Sheet exported: $url';
  }

  @override
  String get googleWorkspaceSheetIdLabel => 'Google Sheet ID or URL';

  @override
  String get googleWorkspaceSheetImportDone => 'Google Sheet imported';

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

  @override
  String get navAccessControl => 'Control de acceso';

  @override
  String get membersSectionTitle => 'Miembros';

  @override
  String get membersSectionSubtitle =>
      'Quién puede acceder al portal de esta tienda y qué puede hacer cada uno';

  @override
  String get membersEmpty =>
      'Aún no se han añadido miembros. Solo usted tiene acceso.';

  @override
  String get noRoleLabel => 'Sin rol';

  @override
  String get addMemberButton => 'Añadir miembro';

  @override
  String get walletAddressFieldLabel => 'Dirección de cuenta de la persona';

  @override
  String get roleFieldLabel => 'Rol';

  @override
  String get rolesSectionTitle => 'Roles';

  @override
  String get newRoleButton => 'Nuevo rol';

  @override
  String get roleNameFieldLabel => 'Nombre del rol';

  @override
  String get statusRoleGranted => 'Rol otorgado';

  @override
  String get statusRoleRevoked => 'Rol eliminado';

  @override
  String get navDatabase => 'Base de datos';

  @override
  String get databaseSectionTitle => 'Base de datos';

  @override
  String get databaseSectionSubtitle =>
      'Explore las tablas y ejecute consultas en la base de datos local de este dispositivo';

  @override
  String get sqlQueryLabel => 'Consulta SQL';

  @override
  String get sqlQueryHint => 'SELECT * FROM erp.llx_product';

  @override
  String get runQueryButton => 'Ejecutar';

  @override
  String get queryEmptyResult => 'La consulta no devolvió filas.';

  @override
  String get tablesSectionTitle => 'Tablas';

  @override
  String get clearTableButton => 'Vaciar tabla';

  @override
  String clearTableConfirmTitle(String table) {
    return '¿Vaciar $table?';
  }

  @override
  String get clearTableConfirmBody =>
      'Esto elimina permanentemente todas las filas de esta tabla. Esta acción no se puede deshacer.';

  @override
  String get statusQueryExecuted => 'Consulta ejecutada';

  @override
  String get navRegister => 'Register';

  @override
  String get navRegisterSettlement => 'Till';

  @override
  String get navSalesAnalysis => 'Sales analysis';

  @override
  String get navPosSettings => 'POS settings';

  @override
  String get taxIncludedLabel => 'Tax included in price';

  @override
  String get taxIncludedHint =>
      'Turn off if this product\'s price excludes tax';

  @override
  String get newCategoryTitle => 'New category';

  @override
  String get editCategoryTitle => 'Edit category';

  @override
  String get deleteCategoryConfirmTitle => 'Delete this category?';

  @override
  String get deleteCategoryConfirmBody =>
      'Products in this category will become uncategorized. This cannot be undone.';

  @override
  String get deleteButton => 'Delete';

  @override
  String get productsTabLabel => 'Products';

  @override
  String get categoriesTabLabel => 'Categories';

  @override
  String get newCategoryButton => 'New category';

  @override
  String get categoriesEmpty => 'No categories yet.';

  @override
  String productCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0';
  }

  @override
  String get registerSectionTitle => 'Register';

  @override
  String get registerSectionSubtitle => 'Ring up items and take payment';

  @override
  String get allCategoriesLabel => 'All';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmptyLabel => 'Cart is empty';

  @override
  String get totalLabel => 'Total';

  @override
  String get payButtonLabel => 'Pay';

  @override
  String get registerNotOpenWarning =>
      'Open the register from the Till screen before taking payment';

  @override
  String get saleCompleteTitle => 'Sale complete';

  @override
  String get saleCompleteBody => 'Payment received';

  @override
  String changeDueLabel(String amount) {
    return 'Change due: NT\$$amount';
  }

  @override
  String get okButton => 'OK';

  @override
  String get registerSettlementTitle => 'Till';

  @override
  String get registerSettlementSubtitle =>
      'Open and close the register, and review cash totals';

  @override
  String get colOpenedAt => 'Opened';

  @override
  String get colClosedAt => 'Closed';

  @override
  String get colOpeningFloat => 'Opening float';

  @override
  String get colCountedCash => 'Counted cash';

  @override
  String get registerHistoryTitle => 'History';

  @override
  String get registerHistoryEmpty => 'No register sessions yet.';

  @override
  String get openRegisterCardTitle => 'Open the register';

  @override
  String get openingFloatLabel => 'Opening float';

  @override
  String get openRegisterButton => 'Open register';

  @override
  String activeSessionTitle(String time) {
    return 'Register opened $time';
  }

  @override
  String openingFloatSummary(String amount) {
    return 'Opening float: NT\$$amount';
  }

  @override
  String get closeRegisterButton => 'Close register';

  @override
  String get recentSalesTitle => 'Recent sales';

  @override
  String get recentSalesEmpty => 'No sales yet this session.';

  @override
  String get refundedChipLabel => 'Refunded';

  @override
  String get refundButton => 'Refund';

  @override
  String get closeRegisterTitle => 'Close register';

  @override
  String expectedCashLabel(String amount) {
    return 'Expected cash: NT\$$amount';
  }

  @override
  String get countedCashLabel => 'Counted cash';

  @override
  String varianceLabel(String amount) {
    return 'Variance: NT\$$amount';
  }

  @override
  String get refundConfirmTitle => 'Refund this sale?';

  @override
  String get refundConfirmBody =>
      'This restores stock and records a credit note. This cannot be undone.';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get tenderedAmountLabel => 'Amount tendered';

  @override
  String get completeSaleButton => 'Complete sale';

  @override
  String saleFailedError(String error) {
    return 'Sale could not be completed: $error';
  }

  @override
  String get salesAnalysisSectionTitle => 'Sales analysis';

  @override
  String get salesAnalysisSectionSubtitle =>
      'Daily, category, and product sales breakdowns';

  @override
  String get rangeTodayLabel => 'Today';

  @override
  String get range7dLabel => '7 days';

  @override
  String get range30dLabel => '30 days';

  @override
  String get rangeAllLabel => 'All';

  @override
  String get dailySalesLabel => 'Daily sales';

  @override
  String get exportCsvButton => 'Export CSV';

  @override
  String get salesAnalysisEmpty => 'No sales in this period.';

  @override
  String get salesByCategoryLabel => 'Sales by category';

  @override
  String get salesByProductLabel => 'Sales by product';

  @override
  String get posSettingsSectionTitle => 'POS settings';

  @override
  String get posSettingsSectionSubtitle =>
      'Default tax handling for new products';

  @override
  String get defaultTaxModeLabel => 'Prices include tax by default';

  @override
  String get standardRateLabel => 'Standard tax rate (%)';

  @override
  String get reducedRateLabel => 'Reduced tax rate (%)';

  @override
  String get uncategorizedLabel => 'Uncategorized';

  @override
  String get fieldProductType => 'Type';

  @override
  String get productTypeGoods => 'Goods';

  @override
  String get productTypeService => 'Service';

  @override
  String get fieldBarcode => 'Barcode';

  @override
  String get fieldStockAlert => 'Stock alert threshold';

  @override
  String get imageTooLargeError => 'Image must be smaller than 3 MB';

  @override
  String get productEnabledLabel => 'Available for sale';

  @override
  String get productEnabledHint =>
      'Turn off to hide this product from the register without deleting it';

  @override
  String get colBarcode => 'Barcode';

  @override
  String get productDisabledSuffix => '(hidden)';

  @override
  String get bookingsTabLabel => 'Bookings';

  @override
  String get staffShiftsTabLabel => 'Staff & shifts';

  @override
  String get downtimeTabLabel => 'Downtime';

  @override
  String assignedWorkerLabel(String name) {
    return 'Assigned to $name';
  }

  @override
  String get workersSectionTitle => 'Staff';

  @override
  String get newWorkerButton => 'New staff member';

  @override
  String get editWorkerTitle => 'Edit staff member';

  @override
  String get workersEmpty => 'No staff members yet.';

  @override
  String get shiftsSectionTitle => 'Shifts';

  @override
  String get newShiftButton => 'New shift';

  @override
  String get editShiftTitle => 'Edit shift';

  @override
  String get shiftsEmpty =>
      'No shifts yet — resources are treated as always open.';

  @override
  String get allResourcesLabel => 'All resources';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get activeDowntimesTitle => 'Active downtime';

  @override
  String get activeDowntimesEmpty => 'No resources are currently down.';

  @override
  String get downtimeHistoryTitle => 'History';

  @override
  String get downtimeHistoryEmpty => 'No downtime recorded yet.';

  @override
  String get colResource => 'Resource';

  @override
  String get fieldResource => 'Resource';

  @override
  String get fieldDowntimeReason => 'Reason';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPhone => 'Phone';

  @override
  String get fieldStartTime => 'Start';

  @override
  String get fieldEndTime => 'End';

  @override
  String get startDowntimeButton => 'Start downtime';

  @override
  String get endDowntimeButton => 'End';

  @override
  String get clientBookingWorkerLabel => 'Preferred staff';

  @override
  String get noPreferenceOption => 'No preference';

  @override
  String statusBookingRejected(String reason) {
    return 'Booking request declined: $reason';
  }

  @override
  String get availabilityReasonUnknown => 'Not available';

  @override
  String get availabilityReasonOutOfSchedule => 'Outside operating hours';

  @override
  String get availabilityReasonMachineBusy =>
      'Resource is down for maintenance';

  @override
  String get availabilityReasonResourceBooked => 'Resource is already booked';

  @override
  String get availabilityReasonWorkerBusy => 'Staff member is already booked';

  @override
  String get workerActiveLabel => 'Active';
}

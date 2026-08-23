// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Gestor de Loja';

  @override
  String get portalLoginTitle => 'Acesso da Loja';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get saveButton => 'Guardar';

  @override
  String get continueButton => 'Continuar';

  @override
  String get closeButton => 'Fechar';

  @override
  String get createButton => 'Criar';

  @override
  String get editButton => 'Editar';

  @override
  String get skipButton => 'Ignorar';

  @override
  String get signInWithPasskeyButton => 'Iniciar sessão com uma passkey';

  @override
  String get demoModeLandingButton => 'Experimentar modo de demonstração';

  @override
  String get demoModeBannerText => 'Modo de demonstração';

  @override
  String get exitDemoButton => 'Sair da demonstração';

  @override
  String get passkeySetupTitle => 'Configurar uma passkey?';

  @override
  String get passkeySetupBody =>
      'Inicie sessão mais depressa da próxima vez usando a impressão digital, o rosto ou o PIN deste dispositivo. Isto só funciona neste dispositivo e navegador — é uma conveniência local, não uma forma de aceder à sua conta noutro local.';

  @override
  String get passkeySetupButton => 'Configurar';

  @override
  String get passkeyManageButton => 'Configurar início de sessão com passkey';

  @override
  String passkeyUnsupportedError(String error) {
    return 'O início de sessão com passkey não está disponível: $error';
  }

  @override
  String get statusPasskeyEnrolled =>
      'O início de sessão com passkey está pronto neste dispositivo';

  @override
  String get accountEntryTitle => 'Iniciar sessão';

  @override
  String get accountEntryBody =>
      'Introduza o seu número de telemóvel e data de nascimento. Iniciamos a sua sessão se este dispositivo já tiver uma conta, ou criamos uma nova se não tiver.';

  @override
  String get accountChoiceTitle => 'Opções avançadas';

  @override
  String get accountChoiceBody =>
      'Use estas opções se definiu uma palavra-passe personalizada, ou se precisar de restaurar esta conta noutro dispositivo.';

  @override
  String get accountUnlockButton => 'Iniciar sessão com palavra-passe';

  @override
  String get accountHighSecurityButton => 'Configuração de alta segurança';

  @override
  String get accountRestoreButton => 'Restaurar com frase de segurança';

  @override
  String get accountAdvancedOptionsLink => 'Opções avançadas';

  @override
  String get accountMismatchError =>
      'Esse número de telemóvel e data de nascimento não correspondem à conta deste dispositivo. Use Opções avançadas para iniciar sessão de outra forma.';

  @override
  String get accountSignInButton => 'Iniciar sessão';

  @override
  String get createPassphraseTitle => 'Criar conta';

  @override
  String get createPassphraseHint =>
      'Crie uma palavra-passe (8+ caracteres). Não pode ser recuperada.';

  @override
  String get confirmPassphraseTitle => 'Confirmar palavra-passe';

  @override
  String get confirmPassphraseHint =>
      'Introduza a mesma palavra-passe novamente.';

  @override
  String get passphraseMismatchMessage => 'As palavras-passe não coincidem';

  @override
  String get unlockTitle => 'Iniciar sessão';

  @override
  String get unlockHint => 'Introduza a sua palavra-passe.';

  @override
  String get noAccountFoundMessage =>
      'Nenhuma conta encontrada neste dispositivo. Crie uma primeiro.';

  @override
  String get restoreTitle => 'Restaurar conta';

  @override
  String get restorePhraseFieldLabel => 'Frase de segurança de 12 palavras';

  @override
  String get setPassphraseTitle => 'Definir uma palavra-passe';

  @override
  String get setPassphraseHint => 'Crie uma palavra-passe (8+ caracteres).';

  @override
  String get restoreButton => 'Restaurar';

  @override
  String get backupPhraseTitle => 'Guarde a sua frase de segurança';

  @override
  String get backupPhraseBody =>
      'Anote estas 12 palavras e guarde-as offline. Qualquer pessoa que as tenha pode aceder a esta conta.';

  @override
  String get backupPhraseConfirmCheckbox => 'Anotei a minha frase de segurança';

  @override
  String get quickSetupWarning =>
      'Isto protege a sua conta para uso diário neste dispositivo. Para maior proteção, use Opções avançadas.';

  @override
  String get quickSetupMobileLabel => 'Número de telemóvel';

  @override
  String get quickSetupBirthdayLabel => 'Data de nascimento (AAAA-MM-DD)';

  @override
  String get storeNameFieldLabel => 'Nome da loja';

  @override
  String get storeNameDefault => 'A minha loja';

  @override
  String get preferencesButton => 'Preferências';

  @override
  String get preferencesTooltip => 'Preferências';

  @override
  String get preferencesTitle => 'Preferências';

  @override
  String get preferencesBody =>
      'Opcional. O seu número de telemóvel e data de nascimento são encriptados antes de serem memorizados neste dispositivo.';

  @override
  String get preferencesMobileLabel => 'Número de telemóvel';

  @override
  String get preferencesBirthdayLabel => 'Data de nascimento (AAAA-MM-DD)';

  @override
  String get preferencesLanguageLabel => 'Idioma';

  @override
  String get preferencesRememberCheckbox => 'Memorizar estes dados';

  @override
  String get preferencesSecurityNote =>
      'Maior segurança: mantenha a sua frase de segurança offline e use-a para restaurar esta conta caso o armazenamento deste dispositivo se perca.';

  @override
  String get accountGateHeadline => 'Inicie sessão para abrir o gestor de loja';

  @override
  String get accountGateBody =>
      'A sua conta é a chave do gestor de loja. As contas locais são guardadas como cofres de chaves encriptados, protegidos pela sua palavra-passe.';

  @override
  String get chatTooltip => 'Conversar com o suporte';

  @override
  String get chatWithSupportTitle => 'Conversa com o suporte';

  @override
  String get messageSupportHint => 'Mensagem para o suporte';

  @override
  String get memberZoneTooltip => 'Área de membro';

  @override
  String get memberZoneTitle => 'Área de membro';

  @override
  String get clientMenuTitle => 'Menu à la carte';

  @override
  String clientMenuSubtitle(String channel) {
    return 'Canal: $channel · Toque num prato para ver os detalhes e adicioná-lo ao seu pedido';
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
  String get menuFallbackCategory => 'Menu';

  @override
  String get clientOrderLockedTitle => 'Inicie sessão para fazer o seu pedido';

  @override
  String get clientOrderUnlockedTitle => 'Os seus pedidos deste canal';

  @override
  String get clientOrderLockedSubtitle =>
      'Apenas os titulares de conta podem criar e ver o seu próprio histórico de pedidos.';

  @override
  String clientOrderUnlockedSubtitle(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pedidos encriptados',
      one: '1 pedido encriptado',
    );
    return '$_temp0 · Total NT\$$total';
  }

  @override
  String clientOrderTotalLabel(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
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
  String get salesWorkspaceTitle => 'Espaço de vendas';

  @override
  String get salesWorkspaceSubtitle => 'Menu';

  @override
  String get offlineTerminalFooter => 'Terminal offline';

  @override
  String get navOverview => 'Resumo';

  @override
  String get navThirdParties => 'Clientes';

  @override
  String get navProducts => 'Produtos';

  @override
  String get navOrders => 'Pedidos';

  @override
  String get navConnection => 'Ligação';

  @override
  String get navSupport => 'Suporte';

  @override
  String get createChannelButton => 'Criar link da loja';

  @override
  String get channelNameFieldLabel => 'Nome do link da loja';

  @override
  String channelReadyTitle(String code) {
    return 'Link da loja $code pronto';
  }

  @override
  String get printButton => 'Imprimir';

  @override
  String get metricOrders => 'Pedidos';

  @override
  String get metricThirdParties => 'Clientes';

  @override
  String get metricProducts => 'Produtos';

  @override
  String get storageCardTitle => 'Armazenamento local';

  @override
  String storageCardSubtitle(String channel) {
    return 'O link da loja $channel guarda os pedidos neste dispositivo. Mantenha esta janela aberta aqui — é isso que mantém o seu link de pagamento e o chat ativos para os clientes.';
  }

  @override
  String get customersSectionTitle => 'Clientes';

  @override
  String get customersSectionSubtitle => 'Diretório de clientes';

  @override
  String get colName => 'Nome';

  @override
  String get colCustomerCode => 'Código de cliente';

  @override
  String get colEmail => 'E-mail';

  @override
  String get customersEmpty => 'Ainda não há clientes.';

  @override
  String get productsSectionTitle => 'Produtos';

  @override
  String get productsSectionSubtitle => 'Catálogo de produtos';

  @override
  String get loadSampleMenuButton => 'Carregar menu de exemplo';

  @override
  String get newProductButton => 'Novo produto';

  @override
  String get colReference => 'Referência';

  @override
  String get colLabel => 'Nome';

  @override
  String get colPriceHt => 'Preço (sem impostos)';

  @override
  String get colVat => 'IVA';

  @override
  String get colStock => 'Stock';

  @override
  String get translationsAction => 'Traduções';

  @override
  String get productsEmpty =>
      'Ainda não há produtos. Adicione um ou carregue o menu de exemplo.';

  @override
  String get newProductTitle => 'Novo produto';

  @override
  String get editProductTitle => 'Editar produto';

  @override
  String get fieldReference => 'Referência';

  @override
  String get fieldLabel => 'Nome';

  @override
  String get fieldPriceHt => 'Preço (sem impostos)';

  @override
  String get fieldVat => 'IVA %';

  @override
  String get fieldStock => 'Stock';

  @override
  String get translationsDialogTitle => 'Traduções';

  @override
  String get translationsLanguageLabel => 'Idioma';

  @override
  String get translationsLabelField => 'Nome';

  @override
  String get translationsDescriptionField => 'Descrição';

  @override
  String get ordersSectionTitle => 'Pedidos';

  @override
  String get ordersSectionSubtitle => 'Histórico de pedidos';

  @override
  String orderTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transações',
      one: '1 transação',
    );
    return '$_temp0';
  }

  @override
  String get ordersEmptyMock =>
      'Novos pedidos chegam automaticamente a cada 10 segundos.';

  @override
  String get operateTransactionTooltip => 'Gerir pedido';

  @override
  String get validateOrderMenuItem => 'Marcar como validado';

  @override
  String get acceptOrderMenuItem => 'Marcar como aceite';

  @override
  String get processOrderMenuItem => 'Marcar como em processamento';

  @override
  String get deliverOrderMenuItem => 'Marcar como entregue';

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
  String get orderStatusDraft => 'Rascunho';

  @override
  String get orderStatusValidated => 'Validado';

  @override
  String get orderStatusAccepted => 'Aceite';

  @override
  String get orderStatusProcessing => 'Em processamento';

  @override
  String get orderStatusDelivered => 'Entregue';

  @override
  String get orderStatusCanceled => 'Cancelado';

  @override
  String get orderStatusUnknown => 'Desconhecido';

  @override
  String get supportSectionTitle => 'Suporte';

  @override
  String supportSectionSubtitle(String channel) {
    return 'Canal $channel';
  }

  @override
  String get joinAsAgentButton => 'Juntar-se como agente';

  @override
  String get conversationsTab => 'Conversas';

  @override
  String get activityLogTab => 'Registo de atividade';

  @override
  String get noActivityYet => 'Ainda não há atividade.';

  @override
  String get noConversationsYet => 'Ainda não há conversas.';

  @override
  String get noMessagesYet => 'Sem mensagens';

  @override
  String get selectConversationPrompt => 'Selecione uma conversa';

  @override
  String get replyHint => 'Responder ao cliente';

  @override
  String get roleOwnerLabel => 'Proprietário';

  @override
  String get roleAgentLabel => 'Agente';

  @override
  String get roleMemberLabel => 'Membro';

  @override
  String get connectionConnected => 'Ligado';

  @override
  String get connectionReconnectNeeded => 'É necessário religar';

  @override
  String get connectionConnecting => 'A ligar…';

  @override
  String get connectionNotConnected => 'Sem ligação';

  @override
  String get connectionSectionTitle => 'Ligação';

  @override
  String get connectionSectionSubtitle =>
      'Emparelhamento manual para entrega do chat em direto';

  @override
  String get portalKeepOpenHint =>
      'Mantenha esta janela aberta neste dispositivo — é isso que mantém o link de pagamento e o chat da sua loja ativos para os clientes.';

  @override
  String get connectionDefaultMessage =>
      'A usar um repetidor público para descobrir rotas';

  @override
  String get generateOfferButton => 'Gerar código de emparelhamento';

  @override
  String get acceptOfferButton => 'Introduzir código de emparelhamento';

  @override
  String get applyAnswerButton => 'Aplicar resposta';

  @override
  String get offerFieldLabel => 'Código de emparelhamento';

  @override
  String get answerFieldLabel => 'Código de resposta';

  @override
  String get connectionOfferGeneratedMessage =>
      'Código de emparelhamento gerado. Partilhe-o com o outro dispositivo e depois introduza a resposta dele.';

  @override
  String get connectionAnswerGeneratedMessage =>
      'Resposta gerada. Envie-a de volta ao dispositivo que criou o código de emparelhamento.';

  @override
  String get connectionAnswerAppliedMessage => 'Ligação estabelecida.';

  @override
  String connectionOfferErrorMessage(String error) {
    return 'Erro de emparelhamento: $error';
  }

  @override
  String connectionAcceptErrorMessage(String error) {
    return 'Erro de resposta: $error';
  }

  @override
  String connectionApplyErrorMessage(String error) {
    return 'Erro de ligação: $error';
  }

  @override
  String get connectionFooterNote =>
      'Isto ajuda a descobrir uma ligação direta entre dispositivos. Não fornece, por si só, a entrega de mensagens.';

  @override
  String get statusStartingDb => 'A iniciar a base de dados local…';

  @override
  String statusClientStorageError(String error) {
    return 'Erro de armazenamento local: $error';
  }

  @override
  String get statusReadyMessage =>
      'Pronto — explore e faça a gestão dos dados da loja';

  @override
  String statusStartupError(String error) {
    return 'Erro de arranque: $error';
  }

  @override
  String statusOrderSynced(String ref, int lineCount, int bytes) {
    return '$ref sincronizado com $lineCount linhas ($bytes bytes)';
  }

  @override
  String statusSyncError(String error) {
    return 'Erro de sincronização: $error';
  }

  @override
  String statusOrderStatusChanged(String statusLabel) {
    return 'O estado do pedido foi alterado para $statusLabel';
  }

  @override
  String statusProductSaved(String ref) {
    return 'Produto $ref guardado localmente';
  }

  @override
  String statusMenuLoaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produtos do menu de exemplo carregados localmente',
      one: '1 produto do menu de exemplo carregado localmente',
    );
    return '$_temp0';
  }

  @override
  String statusAccountCanceled(String error) {
    return 'Início de sessão cancelado ou falhado: $error';
  }

  @override
  String statusAccountConnected(String address) {
    return 'Conta ligada e encriptação inicializada: $address';
  }

  @override
  String get statusProfileDecryptError =>
      'Não foi possível desencriptar o perfil memorizado';

  @override
  String statusProfileSaved(String address) {
    return 'Informação de contacto encriptada e memorizada para $address';
  }

  @override
  String get statusProfileRemoved =>
      'Informação de contacto memorizada removida';

  @override
  String statusTransactionReadFailed(String error) {
    return 'Falha ao ler a transação encriptada: $error';
  }

  @override
  String statusOrderSaved(String ref) {
    return 'Pedido $ref encriptado para esta conta e guardado offline';
  }

  @override
  String get orderSavedSnackbar => 'Pedido guardado offline';

  @override
  String get statusBackupDownloaded => 'Cópia de segurança transferida';

  @override
  String get statusBackupRestored => 'Cópia de segurança restaurada';

  @override
  String statusRestoreFailed(String error) {
    return 'Falha ao restaurar: $error';
  }

  @override
  String get backupTooltip => 'Fazer cópia de segurança';

  @override
  String get restoreTooltip => 'Restaurar dados';

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
  String get refreshTooltip => 'Atualizar dados';

  @override
  String get restoreConfirmTitle => 'Restaurar a partir da cópia de segurança?';

  @override
  String get restoreConfirmBody =>
      'Isto substituirá todos os dados atuais da loja e do cliente pelo conteúdo do ficheiro de cópia de segurança escolhido. Esta ação não pode ser desfeita.';

  @override
  String orderStatusChangedLog(int orderId, String statusLabel) {
    return 'Pedido n.º $orderId → $statusLabel';
  }

  @override
  String productSavedLog(String ref, String price) {
    return 'Produto $ref guardado (NT\$$price)';
  }

  @override
  String channelCreatedLog(String code, String name) {
    return 'Canal $code criado: \"$name\"';
  }

  @override
  String accountConnectedLog(String address) {
    return 'Conta $address ligada';
  }

  @override
  String agentJoinedLog(String address, String channel) {
    return 'O agente $address juntou-se ao canal $channel';
  }

  @override
  String get navContent => 'Conteúdo do menu';

  @override
  String get contentSectionTitle => 'Conteúdo do menu';

  @override
  String get contentSectionSubtitle =>
      'Conteúdo da loja voltado para o cliente';

  @override
  String get newContentItemButton => 'Novo item';

  @override
  String get publishButton => 'Publicar para clientes';

  @override
  String get demoModeButton => 'Modo demonstração';

  @override
  String get contentEmpty => 'Ainda não há itens de conteúdo.';

  @override
  String get colCategory => 'Categoria';

  @override
  String get newContentItemTitle => 'Novo item';

  @override
  String get editContentItemTitle => 'Editar item';

  @override
  String get fieldCategory => 'Categoria';

  @override
  String get fieldDescription => 'Descrição';

  @override
  String get statusContentPublished =>
      'Conteúdo do menu publicado para os clientes ligados';

  @override
  String get resetDataButton => 'Repor dados';

  @override
  String get resetConfirmTitle => 'Repor todos os dados?';

  @override
  String get resetConfirmBody =>
      'Isto elimina permanentemente todos os dados de loja, chat, conteúdo do menu e fidelização neste dispositivo. A sua conta com sessão iniciada não é afetada. Esta ação não pode ser desfeita.';

  @override
  String get statusDataReset => 'Todos os dados foram repostos';

  @override
  String get navLoyalty => 'Fidelização';

  @override
  String get loyaltySectionTitle => 'Fidelização';

  @override
  String get loyaltySectionSubtitle => 'Pontos e níveis dos clientes';

  @override
  String get colWallet => 'Conta';

  @override
  String get colPointsBalance => 'Pontos';

  @override
  String get colTier => 'Nível';

  @override
  String get adjustPointsButton => 'Ajustar pontos';

  @override
  String get adjustPointsTitle => 'Ajustar pontos';

  @override
  String get pointsFieldLabel => 'Pontos (negativo para resgatar)';

  @override
  String get reasonFieldLabel => 'Motivo';

  @override
  String get loyaltyEmpty => 'Ainda não há contas de fidelização.';

  @override
  String get statusPointsAdjusted => 'Pontos ajustados';

  @override
  String get navBookings => 'Reservas';

  @override
  String get bookingsSectionTitle => 'Reservas';

  @override
  String get bookingsSectionSubtitle => 'Reservas de mesa e estado';

  @override
  String get seedMachinesButton => 'Carregar mesas de exemplo';

  @override
  String get machinesEmpty =>
      'Ainda não há mesas. Carregue as mesas de exemplo para começar.';

  @override
  String get machineStateIdle => 'Livre';

  @override
  String get machineStateOccupied => 'Ocupada';

  @override
  String get machineStateMaintenance => 'Manutenção';

  @override
  String get setIdleButton => 'Definir como livre';

  @override
  String get setMaintenanceButton => 'Definir como manutenção';

  @override
  String get bookingsEmpty => 'Ainda não há reservas.';

  @override
  String get bookingStatusPlanned => 'Planeada';

  @override
  String get bookingStatusReleased => 'Confirmada';

  @override
  String get bookingStatusInProgress => 'Em curso';

  @override
  String get bookingStatusCompleted => 'Concluída';

  @override
  String get bookingStatusCanceled => 'Cancelada';

  @override
  String get releaseBookingMenuItem => 'Confirmar';

  @override
  String get startBookingMenuItem => 'Iniciar';

  @override
  String get completeBookingMenuItem => 'Concluir';

  @override
  String get cancelBookingMenuItem => 'Cancelar';

  @override
  String get clientBookingCardTitle => 'Reservar uma mesa';

  @override
  String get clientBookingMachineLabel => 'Mesa';

  @override
  String get clientBookingTimeLabel => 'Hora';

  @override
  String get clientBookingPartySizeLabel => 'Número de pessoas';

  @override
  String get clientBookingSubmitButton => 'Pedir reserva';

  @override
  String get statusBookingRequested => 'Pedido de reserva enviado';

  @override
  String get navAccessControl => 'Controlo de acesso';

  @override
  String get membersSectionTitle => 'Membros';

  @override
  String get membersSectionSubtitle =>
      'Quem pode aceder ao portal desta loja, e o que cada um pode fazer';

  @override
  String get membersEmpty =>
      'Ainda não foram adicionados membros. Só você tem acesso.';

  @override
  String get noRoleLabel => 'Sem função';

  @override
  String get addMemberButton => 'Adicionar membro';

  @override
  String get walletAddressFieldLabel => 'Endereço da conta da pessoa';

  @override
  String get roleFieldLabel => 'Função';

  @override
  String get rolesSectionTitle => 'Funções';

  @override
  String get newRoleButton => 'Nova função';

  @override
  String get roleNameFieldLabel => 'Nome da função';

  @override
  String get statusRoleGranted => 'Função atribuída';

  @override
  String get statusRoleRevoked => 'Função removida';

  @override
  String get navDatabase => 'Base de dados';

  @override
  String get databaseSectionTitle => 'Base de dados';

  @override
  String get databaseSectionSubtitle =>
      'Explore as tabelas e execute consultas na base de dados local deste dispositivo';

  @override
  String get sqlQueryLabel => 'Consulta SQL';

  @override
  String get sqlQueryHint => 'SELECT * FROM erp.llx_product';

  @override
  String get runQueryButton => 'Executar';

  @override
  String get queryEmptyResult => 'A consulta não devolveu linhas.';

  @override
  String get tablesSectionTitle => 'Tabelas';

  @override
  String get clearTableButton => 'Limpar tabela';

  @override
  String clearTableConfirmTitle(String table) {
    return 'Limpar $table?';
  }

  @override
  String get clearTableConfirmBody =>
      'Isto elimina permanentemente todas as linhas desta tabela. Esta ação não pode ser desfeita.';

  @override
  String get statusQueryExecuted => 'Consulta executada';

  @override
  String get navRegister => 'Register';

  @override
  String get navRegisterSettlement => 'Till';

  @override
  String get navSalesAnalysis => 'Sales analysis';

  @override
  String get navPosSettings => 'POS settings';

  @override
  String get noCategoryOption => 'No category';

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

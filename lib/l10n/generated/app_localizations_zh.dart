// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '門市管理';

  @override
  String get portalLoginTitle => '門市登入';

  @override
  String get cancelButton => '取消';

  @override
  String get saveButton => '儲存';

  @override
  String get continueButton => '繼續';

  @override
  String get closeButton => '關閉';

  @override
  String get createButton => '建立';

  @override
  String get editButton => '編輯';

  @override
  String get skipButton => '略過';

  @override
  String get signInWithPasskeyButton => '使用密碼金鑰登入';

  @override
  String get demoModeLandingButton => '體驗示範模式';

  @override
  String get demoModeBannerText => '示範模式';

  @override
  String get exitDemoButton => '結束示範';

  @override
  String get passkeySetupTitle => '要設定密碼金鑰嗎？';

  @override
  String get passkeySetupBody =>
      '下次可使用這台裝置的指紋、臉部辨識或 PIN 碼快速登入。這僅在這台裝置與瀏覽器上有效，並非從其他地方存取帳戶的方式。';

  @override
  String get passkeySetupButton => '設定';

  @override
  String get passkeyManageButton => '設定密碼金鑰登入';

  @override
  String passkeyUnsupportedError(String error) {
    return '無法使用密碼金鑰登入：$error';
  }

  @override
  String get statusPasskeyEnrolled => '這台裝置已可使用密碼金鑰登入';

  @override
  String get accountEntryTitle => '登入';

  @override
  String get accountEntryBody => '輸入您的手機號碼與生日。如果這台裝置已有帳戶，我們會為您登入；否則會建立新帳戶。';

  @override
  String get accountChoiceTitle => '進階選項';

  @override
  String get accountChoiceBody => '若您設定了自訂密碼，或需要在新裝置上復原此帳戶，可使用以下選項。';

  @override
  String get accountUnlockButton => '使用密碼登入';

  @override
  String get accountHighSecurityButton => '高安全性設定';

  @override
  String get accountRestoreButton => '使用備份短語復原';

  @override
  String get accountAdvancedOptionsLink => '進階選項';

  @override
  String get accountMismatchError => '此手機號碼與生日和這台裝置上的帳戶不符。請使用「進階選項」以其他方式登入。';

  @override
  String get accountSignInButton => '登入';

  @override
  String get createPassphraseTitle => '建立帳戶';

  @override
  String get createPassphraseHint => '建立密碼（至少 8 個字元）。此密碼無法復原。';

  @override
  String get confirmPassphraseTitle => '確認密碼';

  @override
  String get confirmPassphraseHint => '再次輸入相同的密碼。';

  @override
  String get passphraseMismatchMessage => '兩次輸入的密碼不一致';

  @override
  String get unlockTitle => '登入';

  @override
  String get unlockHint => '請輸入您的密碼。';

  @override
  String get noAccountFoundMessage => '此裝置上找不到帳戶，請先建立一個。';

  @override
  String get restoreTitle => '復原帳戶';

  @override
  String get restorePhraseFieldLabel => '12 個字的備份短語';

  @override
  String get setPassphraseTitle => '設定密碼';

  @override
  String get setPassphraseHint => '建立密碼（至少 8 個字元）。';

  @override
  String get restoreButton => '復原';

  @override
  String get backupPhraseTitle => '儲存您的備份短語';

  @override
  String get backupPhraseBody => '請將這 12 個字寫下並離線保存。任何持有這些字的人都能存取此帳戶。';

  @override
  String get backupPhraseConfirmCheckbox => '我已寫下備份短語';

  @override
  String get quickSetupWarning => '這能保護您在此裝置上的日常使用。如需更高保障，請使用「進階選項」。';

  @override
  String get quickSetupMobileLabel => '手機號碼';

  @override
  String get quickSetupBirthdayLabel => '生日（YYYY-MM-DD）';

  @override
  String get storeNameFieldLabel => '店家名稱';

  @override
  String get storeNameDefault => '我的店家';

  @override
  String get preferencesButton => '偏好設定';

  @override
  String get preferencesTooltip => '偏好設定';

  @override
  String get preferencesTitle => '偏好設定';

  @override
  String get preferencesBody => '選填。您的手機號碼與生日會先加密，再記住於此裝置上。';

  @override
  String get preferencesMobileLabel => '手機號碼';

  @override
  String get preferencesBirthdayLabel => '生日（YYYY-MM-DD）';

  @override
  String get preferencesLanguageLabel => '語言';

  @override
  String get preferencesRememberCheckbox => '記住這些資料';

  @override
  String get preferencesSecurityNote =>
      '更高安全性：請將備份短語離線保存，若此裝置的儲存空間遺失，可用它來復原帳戶。';

  @override
  String get accountGateHeadline => '登入以開啟門市管理';

  @override
  String get accountGateBody => '您的帳戶就是門市管理的存取金鑰。本機帳戶會以加密金鑰庫儲存，並由您的密碼保護。';

  @override
  String get chatTooltip => '與客服聊天';

  @override
  String get chatWithSupportTitle => '與客服聊天';

  @override
  String get messageSupportHint => '傳訊給客服';

  @override
  String get memberZoneTooltip => '會員專區';

  @override
  String get memberZoneTitle => '會員專區';

  @override
  String get clientMenuTitle => '單點菜單';

  @override
  String clientMenuSubtitle(String channel) {
    return '頻道：$channel · 點選菜色查看詳情，加入您的訂單';
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
  String get menuFallbackCategory => '菜單';

  @override
  String get clientOrderLockedTitle => '登入後即可送出訂單';

  @override
  String get clientOrderUnlockedTitle => '此帳戶的頻道交易';

  @override
  String get clientOrderLockedSubtitle => '只有帳戶持有人可以建立與讀取自己的交易紀錄。';

  @override
  String clientOrderUnlockedSubtitle(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已加密 $count 筆',
    );
    return '$_temp0 · 合計 NT\$$total';
  }

  @override
  String clientOrderTotalLabel(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 項',
    );
    return '合計 NT\$$total（$_temp0）';
  }

  @override
  String get clientOrderConfirmButton => '確認點餐';

  @override
  String get checkoutInvoiceTitle => 'Invoice preview';

  @override
  String get paymentMethodLabel => 'Payment method';

  @override
  String get cashPaymentLabel => 'Cash';

  @override
  String get salesWorkspaceTitle => '業務工作區';

  @override
  String get salesWorkspaceSubtitle => '業務選單';

  @override
  String get offlineTerminalFooter => '離線業務端末';

  @override
  String get navOverview => '概要';

  @override
  String get navThirdParties => '客戶';

  @override
  String get navProducts => '商品';

  @override
  String get navOrders => '訂單';

  @override
  String get navConnection => '連線';

  @override
  String get navSupport => '客服';

  @override
  String get createChannelButton => '建立店家連結';

  @override
  String get channelNameFieldLabel => '店家連結名稱';

  @override
  String channelReadyTitle(String code) {
    return '店家連結 $code 已就緒';
  }

  @override
  String get printButton => '列印';

  @override
  String get metricOrders => '訂單';

  @override
  String get metricThirdParties => '客戶';

  @override
  String get metricProducts => '商品';

  @override
  String get storageCardTitle => '本機儲存';

  @override
  String storageCardSubtitle(String channel) {
    return '店家連結 $channel 會將訂單保存在這台裝置上。讓此畫面保持開啟，就能讓顧客持續使用您的結帳連結與聊天功能。';
  }

  @override
  String get customersSectionTitle => '客戶';

  @override
  String get customersSectionSubtitle => '客戶名冊';

  @override
  String get colName => '名稱';

  @override
  String get colCustomerCode => '客戶代碼';

  @override
  String get colEmail => '電子郵件';

  @override
  String get customersEmpty => '尚未收到任何客戶資料。';

  @override
  String get productsSectionTitle => '商品';

  @override
  String get productsSectionSubtitle => '商品目錄';

  @override
  String get loadSampleMenuButton => '載入範例菜單';

  @override
  String get newProductButton => '新增商品';

  @override
  String get colReference => '編號';

  @override
  String get colLabel => '名稱';

  @override
  String get colPriceHt => '未稅價格';

  @override
  String get colVat => '稅率';

  @override
  String get colStock => '庫存';

  @override
  String get translationsAction => '翻譯';

  @override
  String get productsEmpty => '尚無商品，請新增一項或載入範例菜單。';

  @override
  String get newProductTitle => '新增商品';

  @override
  String get editProductTitle => '編輯商品';

  @override
  String get fieldReference => '編號';

  @override
  String get fieldLabel => '名稱';

  @override
  String get fieldPriceHt => '未稅價格';

  @override
  String get fieldVat => '稅率 %';

  @override
  String get fieldStock => '庫存';

  @override
  String get translationsDialogTitle => '翻譯';

  @override
  String get translationsLanguageLabel => '語言';

  @override
  String get translationsLabelField => '名稱';

  @override
  String get translationsDescriptionField => '描述';

  @override
  String get ordersSectionTitle => '訂單';

  @override
  String get ordersSectionSubtitle => '訂單紀錄';

  @override
  String orderTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 筆交易',
    );
    return '$_temp0';
  }

  @override
  String get ordersEmptyMock => '新訂單每 10 秒自動送達一次。';

  @override
  String get operateTransactionTooltip => '管理訂單';

  @override
  String get validateOrderMenuItem => '標示為已確認';

  @override
  String get acceptOrderMenuItem => '標示為已接受';

  @override
  String get processOrderMenuItem => '標示為處理中';

  @override
  String get deliverOrderMenuItem => '標示為已送達';

  @override
  String get cancelOrderMenuItem => '取消訂單';

  @override
  String totalHtLabel(String total) {
    return '未稅合計 NT\$$total';
  }

  @override
  String totalTtcLabel(String total) {
    return '含稅合計 NT\$$total';
  }

  @override
  String get orderStatusDraft => '草稿';

  @override
  String get orderStatusValidated => '已確認';

  @override
  String get orderStatusAccepted => '已接受';

  @override
  String get orderStatusProcessing => '處理中';

  @override
  String get orderStatusDelivered => '已送達';

  @override
  String get orderStatusCanceled => '已取消';

  @override
  String get orderStatusUnknown => '未知';

  @override
  String get supportSectionTitle => '客服';

  @override
  String supportSectionSubtitle(String channel) {
    return '頻道 $channel';
  }

  @override
  String get joinAsAgentButton => '加入為客服人員';

  @override
  String get conversationsTab => '對話';

  @override
  String get activityLogTab => '活動紀錄';

  @override
  String get noActivityYet => '尚無活動紀錄。';

  @override
  String get noConversationsYet => '尚無對話。';

  @override
  String get noMessagesYet => '尚無訊息';

  @override
  String get selectConversationPrompt => '請選擇一則對話';

  @override
  String get replyHint => '回覆客戶';

  @override
  String get roleOwnerLabel => '擁有者';

  @override
  String get roleAgentLabel => '客服人員';

  @override
  String get roleMemberLabel => '成員';

  @override
  String get connectionConnected => '已連線';

  @override
  String get connectionReconnectNeeded => '需要重新連線';

  @override
  String get connectionConnecting => '連線中…';

  @override
  String get connectionNotConnected => '尚未連線';

  @override
  String get connectionSectionTitle => '連線';

  @override
  String get connectionSectionSubtitle => '即時聊天傳送用的手動配對';

  @override
  String get portalKeepOpenHint => '請讓此畫面保持開啟——這是讓您的結帳連結與聊天對顧客保持可用的關鍵。';

  @override
  String get connectionDefaultMessage => '使用公用中繼站探索連線路徑';

  @override
  String get generateOfferButton => '產生配對代碼';

  @override
  String get acceptOfferButton => '輸入配對代碼';

  @override
  String get applyAnswerButton => '套用回應';

  @override
  String get offerFieldLabel => '配對代碼';

  @override
  String get answerFieldLabel => '回應代碼';

  @override
  String get connectionOfferGeneratedMessage => '已產生配對代碼。請分享給對方裝置，並輸入其回應代碼。';

  @override
  String get connectionAnswerGeneratedMessage => '已產生回應代碼，請回傳給建立配對代碼的裝置。';

  @override
  String get connectionAnswerAppliedMessage => '已建立連線。';

  @override
  String connectionOfferErrorMessage(String error) {
    return '配對錯誤：$error';
  }

  @override
  String connectionAcceptErrorMessage(String error) {
    return '回應錯誤：$error';
  }

  @override
  String connectionApplyErrorMessage(String error) {
    return '連線錯誤：$error';
  }

  @override
  String get connectionFooterNote => '此功能協助裝置之間尋找直接連線，本身並不提供訊息傳送功能。';

  @override
  String get statusStartingDb => '正在啟動本機資料庫…';

  @override
  String statusClientStorageError(String error) {
    return '本機儲存發生錯誤：$error';
  }

  @override
  String get statusReadyMessage => '已就緒 — 可瀏覽並管理門市資料';

  @override
  String statusStartupError(String error) {
    return '啟動錯誤：$error';
  }

  @override
  String statusOrderSynced(String ref, int lineCount, int bytes) {
    return '已同步 $ref，共 $lineCount 行（$bytes 位元組）';
  }

  @override
  String statusSyncError(String error) {
    return '同步錯誤：$error';
  }

  @override
  String statusOrderStatusChanged(String statusLabel) {
    return '訂單狀態已變更為 $statusLabel';
  }

  @override
  String statusProductSaved(String ref) {
    return '商品 $ref 已儲存於本機';
  }

  @override
  String statusMenuLoaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已在本機載入 $count 項範例菜單商品',
    );
    return '$_temp0';
  }

  @override
  String statusAccountCanceled(String error) {
    return '登入已取消或失敗：$error';
  }

  @override
  String statusAccountConnected(String address) {
    return '帳戶已連線並完成加密初始化：$address';
  }

  @override
  String get statusProfileDecryptError => '無法解密已記住的資料';

  @override
  String statusProfileSaved(String address) {
    return '已為 $address 加密並記住聯絡資料';
  }

  @override
  String get statusProfileRemoved => '已移除記住的聯絡資料';

  @override
  String statusTransactionReadFailed(String error) {
    return '讀取加密交易失敗：$error';
  }

  @override
  String statusOrderSaved(String ref) {
    return '訂單 $ref 已為此帳戶加密並離線儲存';
  }

  @override
  String get orderSavedSnackbar => '訂單已離線儲存';

  @override
  String get statusBackupDownloaded => '備份已下載';

  @override
  String get statusBackupRestored => '備份已復原';

  @override
  String statusRestoreFailed(String error) {
    return '復原失敗：$error';
  }

  @override
  String get backupTooltip => '備份資料';

  @override
  String get restoreTooltip => '復原資料';

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
  String get refreshTooltip => '重新整理資料';

  @override
  String get restoreConfirmTitle => '要從備份復原嗎？';

  @override
  String get restoreConfirmBody => '這將以所選備份檔案的內容取代目前所有門市與客戶資料，且無法復原。';

  @override
  String orderStatusChangedLog(int orderId, String statusLabel) {
    return '訂單 #$orderId → $statusLabel';
  }

  @override
  String productSavedLog(String ref, String price) {
    return '商品 $ref 已儲存（NT\$$price）';
  }

  @override
  String channelCreatedLog(String code, String name) {
    return '頻道 $code 已建立：「$name」';
  }

  @override
  String accountConnectedLog(String address) {
    return '帳戶 $address 已連線';
  }

  @override
  String agentJoinedLog(String address, String channel) {
    return '客服人員 $address 已加入頻道 $channel';
  }

  @override
  String get navContent => '菜單內容';

  @override
  String get contentSectionTitle => '菜單內容';

  @override
  String get contentSectionSubtitle => '面向顧客的門市內容';

  @override
  String get newContentItemButton => '新增項目';

  @override
  String get publishButton => '發佈給顧客端';

  @override
  String get demoModeButton => '示範模式';

  @override
  String get contentEmpty => '尚無內容項目。';

  @override
  String get colCategory => '分類';

  @override
  String get newContentItemTitle => '新增項目';

  @override
  String get editContentItemTitle => '編輯項目';

  @override
  String get fieldCategory => '分類';

  @override
  String get fieldDescription => '描述';

  @override
  String get statusContentPublished => '菜單內容已發佈給已連線的顧客端';

  @override
  String get resetDataButton => '重設資料';

  @override
  String get resetConfirmTitle => '要重設所有資料嗎？';

  @override
  String get resetConfirmBody =>
      '這將永久刪除此裝置上所有門市、客服、菜單內容與忠誠度資料。您目前登入的帳戶不受影響。此操作無法復原。';

  @override
  String get statusDataReset => '所有資料已重設';

  @override
  String get navLoyalty => '忠誠計畫';

  @override
  String get loyaltySectionTitle => '忠誠計畫';

  @override
  String get loyaltySectionSubtitle => '客戶點數與等級';

  @override
  String get colWallet => '帳戶';

  @override
  String get colPointsBalance => '點數';

  @override
  String get colTier => '等級';

  @override
  String get adjustPointsButton => '調整點數';

  @override
  String get adjustPointsTitle => '調整點數';

  @override
  String get pointsFieldLabel => '點數（兌換請輸入負數）';

  @override
  String get reasonFieldLabel => '原因';

  @override
  String get loyaltyEmpty => '尚無忠誠計畫帳戶。';

  @override
  String get statusPointsAdjusted => '點數已調整';

  @override
  String get navBookings => '訂位';

  @override
  String get bookingsSectionTitle => '訂位';

  @override
  String get bookingsSectionSubtitle => '桌位訂位與狀態';

  @override
  String get seedMachinesButton => '載入範例桌位';

  @override
  String get machinesEmpty => '尚無桌位。請載入範例桌位以開始使用。';

  @override
  String get machineStateIdle => '空桌';

  @override
  String get machineStateOccupied => '使用中';

  @override
  String get machineStateMaintenance => '維護中';

  @override
  String get setIdleButton => '設為空桌';

  @override
  String get setMaintenanceButton => '設為維護中';

  @override
  String get bookingsEmpty => '尚無訂位。';

  @override
  String get bookingStatusPlanned => '已預約';

  @override
  String get bookingStatusReleased => '已受理';

  @override
  String get bookingStatusInProgress => '使用中';

  @override
  String get bookingStatusCompleted => '已完成';

  @override
  String get bookingStatusCanceled => '已取消';

  @override
  String get releaseBookingMenuItem => '受理';

  @override
  String get startBookingMenuItem => '開始使用';

  @override
  String get completeBookingMenuItem => '標記完成';

  @override
  String get cancelBookingMenuItem => '取消訂位';

  @override
  String get clientBookingCardTitle => '預約桌位';

  @override
  String get clientBookingMachineLabel => '桌位';

  @override
  String get clientBookingTimeLabel => '時間';

  @override
  String get clientBookingPartySizeLabel => '人數';

  @override
  String get clientBookingSubmitButton => '送出預約';

  @override
  String get statusBookingRequested => '已送出預約請求';

  @override
  String get navAccessControl => '存取權限';

  @override
  String get membersSectionTitle => '成員';

  @override
  String get membersSectionSubtitle => '誰能存取此門市的後台，以及各自的權限範圍';

  @override
  String get membersEmpty => '尚未新增任何成員，目前只有您能存取。';

  @override
  String get noRoleLabel => '無角色';

  @override
  String get addMemberButton => '新增成員';

  @override
  String get walletAddressFieldLabel => '對方的帳戶地址';

  @override
  String get roleFieldLabel => '角色';

  @override
  String get rolesSectionTitle => '角色';

  @override
  String get newRoleButton => '新增角色';

  @override
  String get roleNameFieldLabel => '角色名稱';

  @override
  String get statusRoleGranted => '已授予角色';

  @override
  String get statusRoleRevoked => '已移除角色';

  @override
  String get navDatabase => '資料庫';

  @override
  String get databaseSectionTitle => '資料庫';

  @override
  String get databaseSectionSubtitle => '瀏覽這台裝置本機資料庫的資料表，並執行查詢';

  @override
  String get sqlQueryLabel => 'SQL 查詢';

  @override
  String get sqlQueryHint => 'SELECT * FROM erp.llx_product';

  @override
  String get runQueryButton => '執行';

  @override
  String get queryEmptyResult => '查詢沒有回傳任何資料。';

  @override
  String get tablesSectionTitle => '資料表';

  @override
  String get clearTableButton => '清空資料表';

  @override
  String clearTableConfirmTitle(String table) {
    return '要清空 $table 嗎？';
  }

  @override
  String get clearTableConfirmBody => '這將永久刪除此資料表中的所有資料。此操作無法復原。';

  @override
  String get statusQueryExecuted => '查詢已執行';

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

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '門市管理';

  @override
  String get portalLoginTitle => '門市登入';

  @override
  String get cancelButton => '取消';

  @override
  String get saveButton => '儲存';

  @override
  String get continueButton => '繼續';

  @override
  String get closeButton => '關閉';

  @override
  String get createButton => '建立';

  @override
  String get editButton => '編輯';

  @override
  String get skipButton => '略過';

  @override
  String get signInWithPasskeyButton => '使用密碼金鑰登入';

  @override
  String get demoModeLandingButton => '體驗示範模式';

  @override
  String get demoModeBannerText => '示範模式';

  @override
  String get exitDemoButton => '結束示範';

  @override
  String get passkeySetupTitle => '要設定密碼金鑰嗎？';

  @override
  String get passkeySetupBody =>
      '下次可使用這台裝置的指紋、臉部辨識或 PIN 碼快速登入。這僅在這台裝置與瀏覽器上有效，並非從其他地方存取帳戶的方式。';

  @override
  String get passkeySetupButton => '設定';

  @override
  String get passkeyManageButton => '設定密碼金鑰登入';

  @override
  String passkeyUnsupportedError(String error) {
    return '無法使用密碼金鑰登入：$error';
  }

  @override
  String get statusPasskeyEnrolled => '這台裝置已可使用密碼金鑰登入';

  @override
  String get accountEntryTitle => '登入';

  @override
  String get accountEntryBody => '輸入您的手機號碼與生日。如果這台裝置已有帳戶，我們會為您登入；否則會建立新帳戶。';

  @override
  String get accountChoiceTitle => '進階選項';

  @override
  String get accountChoiceBody => '若您設定了自訂密碼，或需要在新裝置上復原此帳戶，可使用以下選項。';

  @override
  String get accountUnlockButton => '使用密碼登入';

  @override
  String get accountHighSecurityButton => '高安全性設定';

  @override
  String get accountRestoreButton => '使用備份短語復原';

  @override
  String get accountAdvancedOptionsLink => '進階選項';

  @override
  String get accountMismatchError => '此手機號碼與生日和這台裝置上的帳戶不符。請使用「進階選項」以其他方式登入。';

  @override
  String get accountSignInButton => '登入';

  @override
  String get createPassphraseTitle => '建立帳戶';

  @override
  String get createPassphraseHint => '建立密碼（至少 8 個字元）。此密碼無法復原。';

  @override
  String get confirmPassphraseTitle => '確認密碼';

  @override
  String get confirmPassphraseHint => '再次輸入相同的密碼。';

  @override
  String get passphraseMismatchMessage => '兩次輸入的密碼不一致';

  @override
  String get unlockTitle => '登入';

  @override
  String get unlockHint => '請輸入您的密碼。';

  @override
  String get noAccountFoundMessage => '此裝置上找不到帳戶，請先建立一個。';

  @override
  String get restoreTitle => '復原帳戶';

  @override
  String get restorePhraseFieldLabel => '12 個字的備份短語';

  @override
  String get setPassphraseTitle => '設定密碼';

  @override
  String get setPassphraseHint => '建立密碼（至少 8 個字元）。';

  @override
  String get restoreButton => '復原';

  @override
  String get backupPhraseTitle => '儲存您的備份短語';

  @override
  String get backupPhraseBody => '請將這 12 個字寫下並離線保存。任何持有這些字的人都能存取此帳戶。';

  @override
  String get backupPhraseConfirmCheckbox => '我已寫下備份短語';

  @override
  String get quickSetupWarning => '這能保護您在此裝置上的日常使用。如需更高保障，請使用「進階選項」。';

  @override
  String get quickSetupMobileLabel => '手機號碼';

  @override
  String get quickSetupBirthdayLabel => '生日（YYYY-MM-DD）';

  @override
  String get storeNameFieldLabel => '店家名稱';

  @override
  String get storeNameDefault => '我的店家';

  @override
  String get preferencesButton => '偏好設定';

  @override
  String get preferencesTooltip => '偏好設定';

  @override
  String get preferencesTitle => '偏好設定';

  @override
  String get preferencesBody => '選填。您的手機號碼與生日會先加密，再記住於此裝置上。';

  @override
  String get preferencesMobileLabel => '手機號碼';

  @override
  String get preferencesBirthdayLabel => '生日（YYYY-MM-DD）';

  @override
  String get preferencesLanguageLabel => '語言';

  @override
  String get preferencesRememberCheckbox => '記住這些資料';

  @override
  String get preferencesSecurityNote =>
      '更高安全性：請將備份短語離線保存，若此裝置的儲存空間遺失，可用它來復原帳戶。';

  @override
  String get accountGateHeadline => '登入以開啟門市管理';

  @override
  String get accountGateBody => '您的帳戶就是門市管理的存取金鑰。本機帳戶會以加密金鑰庫儲存，並由您的密碼保護。';

  @override
  String get chatTooltip => '與客服聊天';

  @override
  String get chatWithSupportTitle => '與客服聊天';

  @override
  String get messageSupportHint => '傳訊給客服';

  @override
  String get memberZoneTooltip => '會員專區';

  @override
  String get memberZoneTitle => '會員專區';

  @override
  String get clientMenuTitle => '單點菜單';

  @override
  String clientMenuSubtitle(String channel) {
    return '頻道：$channel · 點選菜色查看詳情，加入您的訂單';
  }

  @override
  String get menuFallbackCategory => '菜單';

  @override
  String get clientOrderLockedTitle => '登入後即可送出訂單';

  @override
  String get clientOrderUnlockedTitle => '此帳戶的頻道交易';

  @override
  String get clientOrderLockedSubtitle => '只有帳戶持有人可以建立與讀取自己的交易紀錄。';

  @override
  String clientOrderUnlockedSubtitle(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已加密 $count 筆',
    );
    return '$_temp0 · 合計 NT\$$total';
  }

  @override
  String clientOrderTotalLabel(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 項',
    );
    return '合計 NT\$$total（$_temp0）';
  }

  @override
  String get clientOrderConfirmButton => '確認點餐';

  @override
  String get salesWorkspaceTitle => '業務工作區';

  @override
  String get salesWorkspaceSubtitle => '業務選單';

  @override
  String get offlineTerminalFooter => '離線業務端末';

  @override
  String get navOverview => '概要';

  @override
  String get navThirdParties => '客戶';

  @override
  String get navProducts => '商品';

  @override
  String get navOrders => '訂單';

  @override
  String get navConnection => '連線';

  @override
  String get navSupport => '客服';

  @override
  String get createChannelButton => '建立店家連結';

  @override
  String get channelNameFieldLabel => '店家連結名稱';

  @override
  String channelReadyTitle(String code) {
    return '店家連結 $code 已就緒';
  }

  @override
  String get printButton => '列印';

  @override
  String get metricOrders => '訂單';

  @override
  String get metricThirdParties => '客戶';

  @override
  String get metricProducts => '商品';

  @override
  String get storageCardTitle => '本機儲存';

  @override
  String storageCardSubtitle(String channel) {
    return '店家連結 $channel 會將訂單保存在這台裝置上。讓此畫面保持開啟，就能讓顧客持續使用您的結帳連結與聊天功能。';
  }

  @override
  String get customersSectionTitle => '客戶';

  @override
  String get customersSectionSubtitle => '客戶名冊';

  @override
  String get colName => '名稱';

  @override
  String get colCustomerCode => '客戶代碼';

  @override
  String get colEmail => '電子郵件';

  @override
  String get customersEmpty => '尚未收到任何客戶資料。';

  @override
  String get productsSectionTitle => '商品';

  @override
  String get productsSectionSubtitle => '商品目錄';

  @override
  String get loadSampleMenuButton => '載入範例菜單';

  @override
  String get newProductButton => '新增商品';

  @override
  String get colReference => '編號';

  @override
  String get colLabel => '名稱';

  @override
  String get colPriceHt => '未稅價格';

  @override
  String get colVat => '稅率';

  @override
  String get colStock => '庫存';

  @override
  String get translationsAction => '翻譯';

  @override
  String get productsEmpty => '尚無商品，請新增一項或載入範例菜單。';

  @override
  String get newProductTitle => '新增商品';

  @override
  String get editProductTitle => '編輯商品';

  @override
  String get fieldReference => '編號';

  @override
  String get fieldLabel => '名稱';

  @override
  String get fieldPriceHt => '未稅價格';

  @override
  String get fieldVat => '稅率 %';

  @override
  String get fieldStock => '庫存';

  @override
  String get translationsDialogTitle => '翻譯';

  @override
  String get translationsLanguageLabel => '語言';

  @override
  String get translationsLabelField => '名稱';

  @override
  String get translationsDescriptionField => '描述';

  @override
  String get ordersSectionTitle => '訂單';

  @override
  String get ordersSectionSubtitle => '訂單紀錄';

  @override
  String orderTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 筆交易',
    );
    return '$_temp0';
  }

  @override
  String get ordersEmptyMock => '新訂單每 10 秒自動送達一次。';

  @override
  String get operateTransactionTooltip => '管理訂單';

  @override
  String get validateOrderMenuItem => '標示為已確認';

  @override
  String get acceptOrderMenuItem => '標示為已接受';

  @override
  String get processOrderMenuItem => '標示為處理中';

  @override
  String get deliverOrderMenuItem => '標示為已送達';

  @override
  String get cancelOrderMenuItem => '取消訂單';

  @override
  String totalHtLabel(String total) {
    return '未稅合計 NT\$$total';
  }

  @override
  String totalTtcLabel(String total) {
    return '含稅合計 NT\$$total';
  }

  @override
  String get orderStatusDraft => '草稿';

  @override
  String get orderStatusValidated => '已確認';

  @override
  String get orderStatusAccepted => '已接受';

  @override
  String get orderStatusProcessing => '處理中';

  @override
  String get orderStatusDelivered => '已送達';

  @override
  String get orderStatusCanceled => '已取消';

  @override
  String get orderStatusUnknown => '未知';

  @override
  String get supportSectionTitle => '客服';

  @override
  String supportSectionSubtitle(String channel) {
    return '頻道 $channel';
  }

  @override
  String get joinAsAgentButton => '加入為客服人員';

  @override
  String get conversationsTab => '對話';

  @override
  String get activityLogTab => '活動紀錄';

  @override
  String get noActivityYet => '尚無活動紀錄。';

  @override
  String get noConversationsYet => '尚無對話。';

  @override
  String get noMessagesYet => '尚無訊息';

  @override
  String get selectConversationPrompt => '請選擇一則對話';

  @override
  String get replyHint => '回覆客戶';

  @override
  String get roleOwnerLabel => '擁有者';

  @override
  String get roleAgentLabel => '客服人員';

  @override
  String get roleMemberLabel => '成員';

  @override
  String get connectionConnected => '已連線';

  @override
  String get connectionReconnectNeeded => '需要重新連線';

  @override
  String get connectionConnecting => '連線中…';

  @override
  String get connectionNotConnected => '尚未連線';

  @override
  String get connectionSectionTitle => '連線';

  @override
  String get connectionSectionSubtitle => '即時聊天傳送用的手動配對';

  @override
  String get portalKeepOpenHint => '請讓此畫面保持開啟——這是讓您的結帳連結與聊天對顧客保持可用的關鍵。';

  @override
  String get connectionDefaultMessage => '使用公用中繼站探索連線路徑';

  @override
  String get generateOfferButton => '產生配對代碼';

  @override
  String get acceptOfferButton => '輸入配對代碼';

  @override
  String get applyAnswerButton => '套用回應';

  @override
  String get offerFieldLabel => '配對代碼';

  @override
  String get answerFieldLabel => '回應代碼';

  @override
  String get connectionOfferGeneratedMessage => '已產生配對代碼。請分享給對方裝置，並輸入其回應代碼。';

  @override
  String get connectionAnswerGeneratedMessage => '已產生回應代碼，請回傳給建立配對代碼的裝置。';

  @override
  String get connectionAnswerAppliedMessage => '已建立連線。';

  @override
  String connectionOfferErrorMessage(String error) {
    return '配對錯誤：$error';
  }

  @override
  String connectionAcceptErrorMessage(String error) {
    return '回應錯誤：$error';
  }

  @override
  String connectionApplyErrorMessage(String error) {
    return '連線錯誤：$error';
  }

  @override
  String get connectionFooterNote => '此功能協助裝置之間尋找直接連線，本身並不提供訊息傳送功能。';

  @override
  String get statusStartingDb => '正在啟動本機資料庫…';

  @override
  String statusClientStorageError(String error) {
    return '本機儲存發生錯誤：$error';
  }

  @override
  String get statusReadyMessage => '已就緒 — 可瀏覽並管理門市資料';

  @override
  String statusStartupError(String error) {
    return '啟動錯誤：$error';
  }

  @override
  String statusOrderSynced(String ref, int lineCount, int bytes) {
    return '已同步 $ref，共 $lineCount 行（$bytes 位元組）';
  }

  @override
  String statusSyncError(String error) {
    return '同步錯誤：$error';
  }

  @override
  String statusOrderStatusChanged(String statusLabel) {
    return '訂單狀態已變更為 $statusLabel';
  }

  @override
  String statusProductSaved(String ref) {
    return '商品 $ref 已儲存於本機';
  }

  @override
  String statusMenuLoaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已在本機載入 $count 項範例菜單商品',
    );
    return '$_temp0';
  }

  @override
  String statusAccountCanceled(String error) {
    return '登入已取消或失敗：$error';
  }

  @override
  String statusAccountConnected(String address) {
    return '帳戶已連線並完成加密初始化：$address';
  }

  @override
  String get statusProfileDecryptError => '無法解密已記住的資料';

  @override
  String statusProfileSaved(String address) {
    return '已為 $address 加密並記住聯絡資料';
  }

  @override
  String get statusProfileRemoved => '已移除記住的聯絡資料';

  @override
  String statusTransactionReadFailed(String error) {
    return '讀取加密交易失敗：$error';
  }

  @override
  String statusOrderSaved(String ref) {
    return '訂單 $ref 已為此帳戶加密並離線儲存';
  }

  @override
  String get orderSavedSnackbar => '訂單已離線儲存';

  @override
  String get statusBackupDownloaded => '備份已下載';

  @override
  String get statusBackupRestored => '備份已復原';

  @override
  String statusRestoreFailed(String error) {
    return '復原失敗：$error';
  }

  @override
  String get backupTooltip => '備份資料';

  @override
  String get restoreTooltip => '復原資料';

  @override
  String get refreshTooltip => '重新整理資料';

  @override
  String get restoreConfirmTitle => '要從備份復原嗎？';

  @override
  String get restoreConfirmBody => '這將以所選備份檔案的內容取代目前所有門市與客戶資料，且無法復原。';

  @override
  String orderStatusChangedLog(int orderId, String statusLabel) {
    return '訂單 #$orderId → $statusLabel';
  }

  @override
  String productSavedLog(String ref, String price) {
    return '商品 $ref 已儲存（NT\$$price）';
  }

  @override
  String channelCreatedLog(String code, String name) {
    return '頻道 $code 已建立：「$name」';
  }

  @override
  String accountConnectedLog(String address) {
    return '帳戶 $address 已連線';
  }

  @override
  String agentJoinedLog(String address, String channel) {
    return '客服人員 $address 已加入頻道 $channel';
  }

  @override
  String get navContent => '菜單內容';

  @override
  String get contentSectionTitle => '菜單內容';

  @override
  String get contentSectionSubtitle => '面向顧客的門市內容';

  @override
  String get newContentItemButton => '新增項目';

  @override
  String get publishButton => '發佈給顧客端';

  @override
  String get demoModeButton => '示範模式';

  @override
  String get contentEmpty => '尚無內容項目。';

  @override
  String get colCategory => '分類';

  @override
  String get newContentItemTitle => '新增項目';

  @override
  String get editContentItemTitle => '編輯項目';

  @override
  String get fieldCategory => '分類';

  @override
  String get fieldDescription => '描述';

  @override
  String get statusContentPublished => '菜單內容已發佈給已連線的顧客端';

  @override
  String get resetDataButton => '重設資料';

  @override
  String get resetConfirmTitle => '要重設所有資料嗎？';

  @override
  String get resetConfirmBody =>
      '這將永久刪除此裝置上所有門市、客服、菜單內容與忠誠度資料。您目前登入的帳戶不受影響。此操作無法復原。';

  @override
  String get statusDataReset => '所有資料已重設';

  @override
  String get navLoyalty => '忠誠計畫';

  @override
  String get loyaltySectionTitle => '忠誠計畫';

  @override
  String get loyaltySectionSubtitle => '客戶點數與等級';

  @override
  String get colWallet => '帳戶';

  @override
  String get colPointsBalance => '點數';

  @override
  String get colTier => '等級';

  @override
  String get adjustPointsButton => '調整點數';

  @override
  String get adjustPointsTitle => '調整點數';

  @override
  String get pointsFieldLabel => '點數（兌換請輸入負數）';

  @override
  String get reasonFieldLabel => '原因';

  @override
  String get loyaltyEmpty => '尚無忠誠計畫帳戶。';

  @override
  String get statusPointsAdjusted => '點數已調整';

  @override
  String get navBookings => '訂位';

  @override
  String get bookingsSectionTitle => '訂位';

  @override
  String get bookingsSectionSubtitle => '桌位訂位與狀態';

  @override
  String get seedMachinesButton => '載入範例桌位';

  @override
  String get machinesEmpty => '尚無桌位。請載入範例桌位以開始使用。';

  @override
  String get machineStateIdle => '空桌';

  @override
  String get machineStateOccupied => '使用中';

  @override
  String get machineStateMaintenance => '維護中';

  @override
  String get setIdleButton => '設為空桌';

  @override
  String get setMaintenanceButton => '設為維護中';

  @override
  String get bookingsEmpty => '尚無訂位。';

  @override
  String get bookingStatusPlanned => '已預約';

  @override
  String get bookingStatusReleased => '已受理';

  @override
  String get bookingStatusInProgress => '使用中';

  @override
  String get bookingStatusCompleted => '已完成';

  @override
  String get bookingStatusCanceled => '已取消';

  @override
  String get releaseBookingMenuItem => '受理';

  @override
  String get startBookingMenuItem => '開始使用';

  @override
  String get completeBookingMenuItem => '標記完成';

  @override
  String get cancelBookingMenuItem => '取消訂位';

  @override
  String get clientBookingCardTitle => '預約桌位';

  @override
  String get clientBookingMachineLabel => '桌位';

  @override
  String get clientBookingTimeLabel => '時間';

  @override
  String get clientBookingPartySizeLabel => '人數';

  @override
  String get clientBookingSubmitButton => '送出預約';

  @override
  String get statusBookingRequested => '已送出預約請求';

  @override
  String get navAccessControl => '存取權限';

  @override
  String get membersSectionTitle => '成員';

  @override
  String get membersSectionSubtitle => '誰能存取此門市的後台，以及各自的權限範圍';

  @override
  String get membersEmpty => '尚未新增任何成員，目前只有您能存取。';

  @override
  String get noRoleLabel => '無角色';

  @override
  String get addMemberButton => '新增成員';

  @override
  String get walletAddressFieldLabel => '對方的帳戶地址';

  @override
  String get roleFieldLabel => '角色';

  @override
  String get rolesSectionTitle => '角色';

  @override
  String get newRoleButton => '新增角色';

  @override
  String get roleNameFieldLabel => '角色名稱';

  @override
  String get statusRoleGranted => '已授予角色';

  @override
  String get statusRoleRevoked => '已移除角色';

  @override
  String get navDatabase => '資料庫';

  @override
  String get databaseSectionTitle => '資料庫';

  @override
  String get databaseSectionSubtitle => '瀏覽這台裝置本機資料庫的資料表，並執行查詢';

  @override
  String get sqlQueryLabel => 'SQL 查詢';

  @override
  String get sqlQueryHint => 'SELECT * FROM erp.llx_product';

  @override
  String get runQueryButton => '執行';

  @override
  String get queryEmptyResult => '查詢沒有回傳任何資料。';

  @override
  String get tablesSectionTitle => '資料表';

  @override
  String get clearTableButton => '清空資料表';

  @override
  String clearTableConfirmTitle(String table) {
    return '要清空 $table 嗎？';
  }

  @override
  String get clearTableConfirmBody => '這將永久刪除此資料表中的所有資料。此操作無法復原。';

  @override
  String get statusQueryExecuted => '查詢已執行';
}

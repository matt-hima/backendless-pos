// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Store Manager';

  @override
  String get portalLoginTitle => 'Store Login';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get continueButton => 'Continue';

  @override
  String get closeButton => 'Close';

  @override
  String get createButton => 'Create';

  @override
  String get editButton => 'Edit';

  @override
  String get skipButton => 'Skip';

  @override
  String get signInWithPasskeyButton => 'Sign in with a passkey';

  @override
  String get demoModeLandingButton => 'Try demo mode';

  @override
  String get demoModeBannerText => 'Demo mode';

  @override
  String get exitDemoButton => 'Exit demo';

  @override
  String get passkeySetupTitle => 'Set up a passkey?';

  @override
  String get passkeySetupBody =>
      'Enable FIDO for quick member access on this device using its fingerprint, face, or PIN. Join the member account again on another computer.';

  @override
  String get passkeySetupButton => 'Set up';

  @override
  String get passkeyManageButton => 'Enable FIDO quick access';

  @override
  String passkeyUnsupportedError(String error) {
    return 'Passkey sign-in isn\'t available: $error';
  }

  @override
  String get statusPasskeyEnrolled => 'Passkey sign-in is ready on this device';

  @override
  String get accountEntryTitle => 'Join member';

  @override
  String get accountEntryBody =>
      'Enter your mobile number to send orders. Birthday is optional for access from another computer. Recovery words are optional for stronger security.';

  @override
  String get accountChoiceTitle => 'Advanced options';

  @override
  String get accountChoiceBody =>
      'Use these if you set a custom passphrase, or need to restore this account on a new device.';

  @override
  String get accountUnlockButton => 'Unlock with passphrase';

  @override
  String get accountHighSecurityButton => 'High security setup';

  @override
  String get accountRestoreButton => 'Restore with backup phrase';

  @override
  String get accountAdvancedOptionsLink => 'Advanced options';

  @override
  String get accountMismatchError =>
      'That mobile number could not unlock this device. Use your passkey, or open Advanced options to use a passphrase or recovery words.';

  @override
  String get accountSignInButton => 'Sign in';

  @override
  String get createPassphraseTitle => 'Create account';

  @override
  String get createPassphraseHint =>
      'Create a passphrase (8+ characters). It cannot be recovered.';

  @override
  String get confirmPassphraseTitle => 'Confirm passphrase';

  @override
  String get confirmPassphraseHint => 'Enter the same passphrase again.';

  @override
  String get passphraseMismatchMessage => 'Passphrases did not match';

  @override
  String get unlockTitle => 'Sign in';

  @override
  String get unlockHint => 'Enter your passphrase.';

  @override
  String get noAccountFoundMessage =>
      'No account found on this device. Create one first.';

  @override
  String get restoreTitle => 'Restore account';

  @override
  String get restorePhraseFieldLabel => '12-word backup phrase';

  @override
  String get setPassphraseTitle => 'Set a passphrase';

  @override
  String get setPassphraseHint => 'Create a passphrase (8+ characters).';

  @override
  String get restoreButton => 'Restore';

  @override
  String get backupPhraseTitle => 'Save your backup phrase';

  @override
  String get backupPhraseBody =>
      'Write these 12 words down and keep them offline. Anyone with them can access this account.';

  @override
  String get backupPhraseConfirmCheckbox => 'I wrote down my backup phrase';

  @override
  String get quickSetupWarning =>
      'Mobile number is required. Birthday is optional for another computer, and recovery words are optional for higher security.';

  @override
  String get quickSetupMobileLabel => 'Mobile number';

  @override
  String get quickSetupBirthdayLabel => 'Birthday (optional · member benefits)';

  @override
  String get storeNameFieldLabel => 'Store name';

  @override
  String get storeNameDefault => 'My store';

  @override
  String get preferencesButton => 'Preferences';

  @override
  String get preferencesTooltip => 'Preferences';

  @override
  String get preferencesTitle => 'Preferences';

  @override
  String get preferencesBody =>
      'Optional. Your mobile number and birthday are encrypted before being remembered on this device.';

  @override
  String get preferencesMobileLabel => 'Mobile number';

  @override
  String get preferencesBirthdayLabel => 'Birthday (YYYY-MM-DD)';

  @override
  String get preferencesLanguageLabel => 'Language';

  @override
  String get preferencesRememberCheckbox => 'Remember these details';

  @override
  String get preferencesSecurityNote =>
      'Higher security: keep your backup phrase offline and use it to restore this account if this device\'s storage is lost.';

  @override
  String get accountGateHeadline => 'Sign in to open the store manager';

  @override
  String get accountGateBody =>
      'Your account is the store manager key. Local accounts are stored as encrypted keystores protected by your passphrase.';

  @override
  String get chatTooltip => 'Chat with support';

  @override
  String get chatWithSupportTitle => 'Chat with support';

  @override
  String get messageSupportHint => 'Message support';

  @override
  String get memberZoneTooltip => 'Member zone';

  @override
  String get memberZoneTitle => 'Member zone';

  @override
  String get clientMenuTitle => 'À la carte menu';

  @override
  String clientMenuSubtitle(String channel) {
    return 'Channel: $channel · Tap a dish to see details and add it to your order';
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
  String get clientOrderLockedTitle => 'Ready to order';

  @override
  String get clientOrderUnlockedTitle => 'Your channel orders';

  @override
  String get clientOrderLockedSubtitle =>
      'Enter your mobile number only when you send the order.';

  @override
  String clientOrderUnlockedSubtitle(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count encrypted orders',
      one: '1 encrypted order',
    );
    return '$_temp0 · Total NT\$$total';
  }

  @override
  String clientOrderTotalLabel(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return 'Total NT\$$total ($_temp0)';
  }

  @override
  String get clientOrderConfirmButton => 'Confirm order';

  @override
  String get checkoutInvoiceTitle => 'Invoice preview';

  @override
  String get paymentMethodLabel => 'Payment method';

  @override
  String get cashPaymentLabel => 'Cash';

  @override
  String get salesWorkspaceTitle => 'SuiteCRM workspace';

  @override
  String get salesWorkspaceSubtitle => 'Accounts, activities, and operations';

  @override
  String get offlineTerminalFooter => 'Offline terminal';

  @override
  String get navOverview => 'Overview';

  @override
  String get navThirdParties => 'Accounts';

  @override
  String get navProducts => 'Products';

  @override
  String get navOrders => 'Orders';

  @override
  String get navConnection => 'Connection';

  @override
  String get navSupport => 'Support';

  @override
  String get createChannelButton => 'Open store link';

  @override
  String get channelNameFieldLabel => 'Store link name';

  @override
  String channelReadyTitle(String code) {
    return 'Store link $code ready';
  }

  @override
  String get printButton => 'Print';

  @override
  String get metricOrders => 'Orders';

  @override
  String get metricThirdParties => 'Accounts';

  @override
  String get metricProducts => 'Products';

  @override
  String get storageCardTitle => 'Local storage';

  @override
  String storageCardSubtitle(String channel) {
    return 'Store link $channel keeps orders on this device. Keep this window open here — it\'s what keeps your checkout link and chat live for customers.';
  }

  @override
  String get customersSectionTitle => 'Accounts & contacts';

  @override
  String get customersSectionSubtitle =>
      'SuiteCRM account and contact directory';

  @override
  String get colName => 'Name';

  @override
  String get colCustomerCode => 'Customer code';

  @override
  String get colEmail => 'Email';

  @override
  String get customersEmpty => 'No customers yet.';

  @override
  String get productsSectionTitle => 'Products';

  @override
  String get productsSectionSubtitle => 'Product catalog';

  @override
  String get loadSampleMenuButton => 'Load sample menu';

  @override
  String get newProductButton => 'New product';

  @override
  String get colReference => 'Reference';

  @override
  String get colLabel => 'Label';

  @override
  String get colPriceHt => 'Price (excl. tax)';

  @override
  String get colVat => 'VAT';

  @override
  String get colStock => 'Stock';

  @override
  String get translationsAction => 'Translations';

  @override
  String get productsEmpty =>
      'No products yet. Add one or load the sample menu.';

  @override
  String get newProductTitle => 'New product';

  @override
  String get editProductTitle => 'Edit product';

  @override
  String get fieldReference => 'Reference';

  @override
  String get fieldLabel => 'Label';

  @override
  String get fieldPriceHt => 'Price (excl. tax)';

  @override
  String get fieldVat => 'VAT %';

  @override
  String get fieldStock => 'Stock';

  @override
  String get translationsDialogTitle => 'Translations';

  @override
  String get translationsLanguageLabel => 'Language';

  @override
  String get translationsLabelField => 'Label';

  @override
  String get translationsDescriptionField => 'Description';

  @override
  String get ordersSectionTitle => 'Orders';

  @override
  String get ordersSectionSubtitle => 'Order history';

  @override
  String orderTransactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return '$_temp0';
  }

  @override
  String get ordersEmptyMock =>
      'New orders arrive automatically every 10 seconds.';

  @override
  String get operateTransactionTooltip => 'Manage order';

  @override
  String get validateOrderMenuItem => 'Mark as validated';

  @override
  String get acceptOrderMenuItem => 'Mark as accepted';

  @override
  String get processOrderMenuItem => 'Mark as processing';

  @override
  String get deliverOrderMenuItem => 'Mark as delivered';

  @override
  String get cancelOrderMenuItem => 'Cancel order';

  @override
  String totalHtLabel(String total) {
    return 'Subtotal NT\$$total';
  }

  @override
  String totalTtcLabel(String total) {
    return 'Total NT\$$total';
  }

  @override
  String get orderStatusDraft => 'Draft';

  @override
  String get orderStatusValidated => 'Validated';

  @override
  String get orderStatusAccepted => 'Accepted';

  @override
  String get orderStatusProcessing => 'Processing';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCanceled => 'Canceled';

  @override
  String get orderStatusUnknown => 'Unknown';

  @override
  String get supportSectionTitle => 'Support';

  @override
  String supportSectionSubtitle(String channel) {
    return 'Channel $channel';
  }

  @override
  String get joinAsAgentButton => 'Join as agent';

  @override
  String get conversationsTab => 'Conversations';

  @override
  String get activityLogTab => 'Activity log';

  @override
  String get noActivityYet => 'No activity yet.';

  @override
  String get noConversationsYet => 'No conversations yet.';

  @override
  String get noMessagesYet => 'No messages';

  @override
  String get selectConversationPrompt => 'Select a conversation';

  @override
  String get replyHint => 'Reply to customer';

  @override
  String get roleOwnerLabel => 'Owner';

  @override
  String get roleAgentLabel => 'Agent';

  @override
  String get roleMemberLabel => 'Member';

  @override
  String get connectionConnected => 'Connected';

  @override
  String get connectionReconnectNeeded => 'Reconnect needed';

  @override
  String get connectionConnecting => 'Connecting…';

  @override
  String get connectionNotConnected => 'Not connected';

  @override
  String get connectionSectionTitle => 'Connection';

  @override
  String get connectionSectionSubtitle =>
      'Manual pairing for live chat delivery';

  @override
  String get portalKeepOpenHint =>
      'Keep this window open on this device — it\'s what keeps your store\'s checkout link and chat live for customers.';

  @override
  String get connectionDefaultMessage =>
      'Using a public relay to discover routes';

  @override
  String get generateOfferButton => 'Generate pairing code';

  @override
  String get acceptOfferButton => 'Enter pairing code';

  @override
  String get applyAnswerButton => 'Apply response';

  @override
  String get offerFieldLabel => 'Pairing code';

  @override
  String get answerFieldLabel => 'Response code';

  @override
  String get connectionOfferGeneratedMessage =>
      'Pairing code generated. Share it with the other device, then enter its response.';

  @override
  String get connectionAnswerGeneratedMessage =>
      'Response generated. Send it back to the device that created the pairing code.';

  @override
  String get connectionAnswerAppliedMessage => 'Connection established.';

  @override
  String connectionOfferErrorMessage(String error) {
    return 'Pairing error: $error';
  }

  @override
  String connectionAcceptErrorMessage(String error) {
    return 'Response error: $error';
  }

  @override
  String connectionApplyErrorMessage(String error) {
    return 'Connection error: $error';
  }

  @override
  String get connectionFooterNote =>
      'This helps discover a direct connection between devices. It does not provide message delivery on its own.';

  @override
  String get statusStartingDb => 'Starting local database…';

  @override
  String statusClientStorageError(String error) {
    return 'Local storage error: $error';
  }

  @override
  String get statusReadyMessage => 'Ready — browse and manage store data';

  @override
  String statusStartupError(String error) {
    return 'Startup error: $error';
  }

  @override
  String statusOrderSynced(String ref, int lineCount, int bytes) {
    return 'Synced $ref with $lineCount lines ($bytes bytes)';
  }

  @override
  String statusSyncError(String error) {
    return 'Sync error: $error';
  }

  @override
  String statusOrderStatusChanged(String statusLabel) {
    return 'Order status changed to $statusLabel';
  }

  @override
  String statusProductSaved(String ref) {
    return 'Product $ref saved locally';
  }

  @override
  String statusMenuLoaded(int count) {
    return 'Loaded $count sample menu products locally';
  }

  @override
  String statusAccountCanceled(String error) {
    return 'Sign-in canceled or failed: $error';
  }

  @override
  String statusAccountConnected(String address) {
    return 'Account connected and encryption initialized: $address';
  }

  @override
  String get statusProfileDecryptError =>
      'Remembered profile could not be decrypted';

  @override
  String statusProfileSaved(String address) {
    return 'Contact information encrypted and remembered for $address';
  }

  @override
  String get statusProfileRemoved => 'Remembered contact information removed';

  @override
  String statusTransactionReadFailed(String error) {
    return 'Encrypted transaction read failed: $error';
  }

  @override
  String statusOrderSaved(String ref) {
    return 'Order $ref encrypted for this account and saved offline';
  }

  @override
  String get orderSavedSnackbar => 'Order saved offline';

  @override
  String get statusBackupDownloaded => 'Backup downloaded';

  @override
  String get statusBackupRestored => 'Backup restored';

  @override
  String statusRestoreFailed(String error) {
    return 'Restore failed: $error';
  }

  @override
  String get backupTooltip => 'Back up data';

  @override
  String get restoreTooltip => 'Restore data';

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
  String get refreshTooltip => 'Refresh data';

  @override
  String get restoreConfirmTitle => 'Restore from backup?';

  @override
  String get restoreConfirmBody =>
      'This replaces all current store and client data with the contents of the chosen backup file. This cannot be undone.';

  @override
  String orderStatusChangedLog(int orderId, String statusLabel) {
    return 'Order #$orderId → $statusLabel';
  }

  @override
  String productSavedLog(String ref, String price) {
    return 'Product $ref saved (NT\$$price)';
  }

  @override
  String channelCreatedLog(String code, String name) {
    return 'Channel $code created: \"$name\"';
  }

  @override
  String accountConnectedLog(String address) {
    return 'Account $address connected';
  }

  @override
  String agentJoinedLog(String address, String channel) {
    return 'Agent $address joined channel $channel';
  }

  @override
  String get navContent => 'Menu content';

  @override
  String get contentSectionTitle => 'Menu content';

  @override
  String get contentSectionSubtitle => 'Customer-facing storefront content';

  @override
  String get newContentItemButton => 'New item';

  @override
  String get publishButton => 'Publish to clients';

  @override
  String get demoModeButton => 'Demo mode';

  @override
  String get contentEmpty => 'No content items yet.';

  @override
  String get colCategory => 'Category';

  @override
  String get newContentItemTitle => 'New item';

  @override
  String get editContentItemTitle => 'Edit item';

  @override
  String get fieldCategory => 'Category';

  @override
  String get fieldDescription => 'Description';

  @override
  String get statusContentPublished =>
      'Menu content published to connected clients';

  @override
  String get resetDataButton => 'Reset data';

  @override
  String get resetConfirmTitle => 'Reset all data?';

  @override
  String get resetConfirmBody =>
      'This permanently deletes all store, chat, menu content, and loyalty data on this device. Your signed-in account is not affected. This cannot be undone.';

  @override
  String get statusDataReset => 'All data has been reset';

  @override
  String get navLoyalty => 'Memberships';

  @override
  String get loyaltySectionTitle => 'Memberships & rewards';

  @override
  String get loyaltySectionSubtitle =>
      'SuiteCRM accounts, contacts, points, and claims';

  @override
  String get colWallet => 'Account';

  @override
  String get colPointsBalance => 'Points';

  @override
  String get colTier => 'Tier';

  @override
  String get adjustPointsButton => 'Adjust points';

  @override
  String get adjustPointsTitle => 'Adjust points';

  @override
  String get pointsFieldLabel => 'Points (negative to redeem)';

  @override
  String get reasonFieldLabel => 'Reason';

  @override
  String get loyaltyEmpty => 'No memberships yet.';

  @override
  String get statusPointsAdjusted => 'Points adjusted';

  @override
  String get navBookings => 'Bookings';

  @override
  String get bookingsSectionTitle => 'Bookings';

  @override
  String get bookingsSectionSubtitle =>
      'SuiteCRM activities, resources, and booking status';

  @override
  String get seedMachinesButton => 'Load sample resources';

  @override
  String get machinesEmpty =>
      'No resources yet. Load sample resources to get started.';

  @override
  String get machineStateIdle => 'Idle';

  @override
  String get machineStateOccupied => 'Occupied';

  @override
  String get machineStateMaintenance => 'Maintenance';

  @override
  String get setIdleButton => 'Set idle';

  @override
  String get setMaintenanceButton => 'Set maintenance';

  @override
  String get bookingsEmpty => 'No bookings yet.';

  @override
  String get bookingStatusPlanned => 'Planned';

  @override
  String get bookingStatusReleased => 'Released';

  @override
  String get bookingStatusInProgress => 'In progress';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusCanceled => 'Canceled';

  @override
  String get releaseBookingMenuItem => 'Release';

  @override
  String get startBookingMenuItem => 'Start';

  @override
  String get completeBookingMenuItem => 'Complete';

  @override
  String get cancelBookingMenuItem => 'Cancel';

  @override
  String get clientBookingCardTitle => 'Request a booking';

  @override
  String get clientBookingMachineLabel => 'Resource';

  @override
  String get clientBookingTimeLabel => 'Time';

  @override
  String get clientBookingPartySizeLabel => 'Party size';

  @override
  String get clientBookingSubmitButton => 'Request booking';

  @override
  String get statusBookingRequested => 'Booking request sent';

  @override
  String get navAccessControl => 'Access control';

  @override
  String get membersSectionTitle => 'Members';

  @override
  String get membersSectionSubtitle =>
      'Who can access this store\'s portal, and what they can do';

  @override
  String get membersEmpty =>
      'No members added yet. You\'re the only one with access.';

  @override
  String get noRoleLabel => 'No role';

  @override
  String get addMemberButton => 'Add member';

  @override
  String get walletAddressFieldLabel => 'Their account address';

  @override
  String get roleFieldLabel => 'Role';

  @override
  String get rolesSectionTitle => 'Roles';

  @override
  String get newRoleButton => 'New role';

  @override
  String get roleNameFieldLabel => 'Role name';

  @override
  String get statusRoleGranted => 'Role granted';

  @override
  String get statusRoleRevoked => 'Role removed';

  @override
  String get navDatabase => 'Database';

  @override
  String get databaseSectionTitle => 'Database';

  @override
  String get databaseSectionSubtitle =>
      'Browse tables and run queries against this device\'s local database';

  @override
  String get sqlQueryLabel => 'SQL query';

  @override
  String get sqlQueryHint => 'SELECT * FROM erp.llx_product';

  @override
  String get runQueryButton => 'Run';

  @override
  String get queryEmptyResult => 'Query returned no rows.';

  @override
  String get tablesSectionTitle => 'Tables';

  @override
  String get clearTableButton => 'Clear table';

  @override
  String clearTableConfirmTitle(String table) {
    return 'Clear $table?';
  }

  @override
  String get clearTableConfirmBody =>
      'This permanently deletes every row in this table. This cannot be undone.';

  @override
  String get statusQueryExecuted => 'Query executed';

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

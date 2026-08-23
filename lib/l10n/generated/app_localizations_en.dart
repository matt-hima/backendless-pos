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
      'Sign in faster next time using this device\'s fingerprint, face, or PIN. This only works on this device and browser — it\'s a local convenience, not a way to access your account elsewhere.';

  @override
  String get passkeySetupButton => 'Set up';

  @override
  String get passkeyManageButton => 'Set up passkey sign-in';

  @override
  String passkeyUnsupportedError(String error) {
    return 'Passkey sign-in isn\'t available: $error';
  }

  @override
  String get statusPasskeyEnrolled => 'Passkey sign-in is ready on this device';

  @override
  String get accountEntryTitle => 'Sign in';

  @override
  String get accountEntryBody =>
      'Enter your mobile number to send orders. Use passkey for quick access on this device; use Advanced options for birthday details or your recovery words on another device.';

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
      'Mobile number is for daily member access. Passkey is the fastest option on this device; keep birthday details or recovery words for access from another device.';

  @override
  String get quickSetupMobileLabel => 'Mobile number';

  @override
  String get quickSetupBirthdayLabel => 'Birthday (YYYY-MM-DD)';

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
  String get menuFallbackCategory => 'Menu';

  @override
  String get clientOrderLockedTitle => 'Sign in to place your order';

  @override
  String get clientOrderUnlockedTitle => 'Your channel orders';

  @override
  String get clientOrderLockedSubtitle =>
      'Only account holders can create and view their own order history.';

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
  String get salesWorkspaceTitle => 'Sales workspace';

  @override
  String get salesWorkspaceSubtitle => 'Menu';

  @override
  String get offlineTerminalFooter => 'Offline terminal';

  @override
  String get navOverview => 'Overview';

  @override
  String get navThirdParties => 'Customers';

  @override
  String get navProducts => 'Products';

  @override
  String get navOrders => 'Orders';

  @override
  String get navConnection => 'Connection';

  @override
  String get navSupport => 'Support';

  @override
  String get createChannelButton => 'Create store link';

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
  String get metricThirdParties => 'Customers';

  @override
  String get metricProducts => 'Products';

  @override
  String get storageCardTitle => 'Local storage';

  @override
  String storageCardSubtitle(String channel) {
    return 'Store link $channel keeps orders on this device. Keep this window open here — it\'s what keeps your checkout link and chat live for customers.';
  }

  @override
  String get customersSectionTitle => 'Customers';

  @override
  String get customersSectionSubtitle => 'Customer directory';

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
  String get navLoyalty => 'Loyalty';

  @override
  String get loyaltySectionTitle => 'Loyalty';

  @override
  String get loyaltySectionSubtitle => 'Customer points and tiers';

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
  String get loyaltyEmpty => 'No loyalty accounts yet.';

  @override
  String get statusPointsAdjusted => 'Points adjusted';

  @override
  String get navBookings => 'Bookings';

  @override
  String get bookingsSectionTitle => 'Bookings';

  @override
  String get bookingsSectionSubtitle => 'Table bookings and status';

  @override
  String get seedMachinesButton => 'Load sample tables';

  @override
  String get machinesEmpty =>
      'No tables yet. Load the sample tables to get started.';

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
  String get clientBookingCardTitle => 'Book a table';

  @override
  String get clientBookingMachineLabel => 'Table';

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
}

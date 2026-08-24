import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('pt'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Store Manager'**
  String get appTitle;

  /// No description provided for @portalLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Store Login'**
  String get portalLoginTitle;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @createButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createButton;

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @skipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipButton;

  /// No description provided for @signInWithPasskeyButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with a passkey'**
  String get signInWithPasskeyButton;

  /// No description provided for @demoModeLandingButton.
  ///
  /// In en, this message translates to:
  /// **'Try demo mode'**
  String get demoModeLandingButton;

  /// No description provided for @demoModeBannerText.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get demoModeBannerText;

  /// No description provided for @exitDemoButton.
  ///
  /// In en, this message translates to:
  /// **'Exit demo'**
  String get exitDemoButton;

  /// No description provided for @passkeySetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up a passkey?'**
  String get passkeySetupTitle;

  /// No description provided for @passkeySetupBody.
  ///
  /// In en, this message translates to:
  /// **'Enable FIDO for quick member access on this device using its fingerprint, face, or PIN. Join the member account again on another computer.'**
  String get passkeySetupBody;

  /// No description provided for @passkeySetupButton.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get passkeySetupButton;

  /// No description provided for @passkeyManageButton.
  ///
  /// In en, this message translates to:
  /// **'Enable FIDO quick access'**
  String get passkeyManageButton;

  /// No description provided for @passkeyUnsupportedError.
  ///
  /// In en, this message translates to:
  /// **'Passkey sign-in isn\'t available: {error}'**
  String passkeyUnsupportedError(String error);

  /// No description provided for @statusPasskeyEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Passkey sign-in is ready on this device'**
  String get statusPasskeyEnrolled;

  /// No description provided for @accountEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Join member'**
  String get accountEntryTitle;

  /// No description provided for @accountEntryBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to send orders. Birthday is optional for access from another computer. Recovery words are optional for stronger security.'**
  String get accountEntryBody;

  /// No description provided for @accountChoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced options'**
  String get accountChoiceTitle;

  /// No description provided for @accountChoiceBody.
  ///
  /// In en, this message translates to:
  /// **'Use these if you set a custom passphrase, or need to restore this account on a new device.'**
  String get accountChoiceBody;

  /// No description provided for @accountUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock with passphrase'**
  String get accountUnlockButton;

  /// No description provided for @accountHighSecurityButton.
  ///
  /// In en, this message translates to:
  /// **'High security setup'**
  String get accountHighSecurityButton;

  /// No description provided for @accountRestoreButton.
  ///
  /// In en, this message translates to:
  /// **'Restore with backup phrase'**
  String get accountRestoreButton;

  /// No description provided for @accountAdvancedOptionsLink.
  ///
  /// In en, this message translates to:
  /// **'Advanced options'**
  String get accountAdvancedOptionsLink;

  /// No description provided for @accountMismatchError.
  ///
  /// In en, this message translates to:
  /// **'That mobile number could not unlock this device. Use your passkey, or open Advanced options to use a passphrase or recovery words.'**
  String get accountMismatchError;

  /// No description provided for @accountSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get accountSignInButton;

  /// No description provided for @createPassphraseTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createPassphraseTitle;

  /// No description provided for @createPassphraseHint.
  ///
  /// In en, this message translates to:
  /// **'Create a passphrase (8+ characters). It cannot be recovered.'**
  String get createPassphraseHint;

  /// No description provided for @confirmPassphraseTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm passphrase'**
  String get confirmPassphraseTitle;

  /// No description provided for @confirmPassphraseHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the same passphrase again.'**
  String get confirmPassphraseHint;

  /// No description provided for @passphraseMismatchMessage.
  ///
  /// In en, this message translates to:
  /// **'Passphrases did not match'**
  String get passphraseMismatchMessage;

  /// No description provided for @unlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get unlockTitle;

  /// No description provided for @unlockHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your passphrase.'**
  String get unlockHint;

  /// No description provided for @noAccountFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No account found on this device. Create one first.'**
  String get noAccountFoundMessage;

  /// No description provided for @restoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore account'**
  String get restoreTitle;

  /// No description provided for @restorePhraseFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'12-word backup phrase'**
  String get restorePhraseFieldLabel;

  /// No description provided for @setPassphraseTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a passphrase'**
  String get setPassphraseTitle;

  /// No description provided for @setPassphraseHint.
  ///
  /// In en, this message translates to:
  /// **'Create a passphrase (8+ characters).'**
  String get setPassphraseHint;

  /// No description provided for @restoreButton.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreButton;

  /// No description provided for @backupPhraseTitle.
  ///
  /// In en, this message translates to:
  /// **'Save your backup phrase'**
  String get backupPhraseTitle;

  /// No description provided for @backupPhraseBody.
  ///
  /// In en, this message translates to:
  /// **'Write these 12 words down and keep them offline. Anyone with them can access this account.'**
  String get backupPhraseBody;

  /// No description provided for @backupPhraseConfirmCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I wrote down my backup phrase'**
  String get backupPhraseConfirmCheckbox;

  /// No description provided for @quickSetupWarning.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required. Birthday is optional for another computer, and recovery words are optional for higher security.'**
  String get quickSetupWarning;

  /// No description provided for @quickSetupMobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get quickSetupMobileLabel;

  /// No description provided for @quickSetupBirthdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday (optional · member benefits)'**
  String get quickSetupBirthdayLabel;

  /// No description provided for @storeNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Store name'**
  String get storeNameFieldLabel;

  /// No description provided for @storeNameDefault.
  ///
  /// In en, this message translates to:
  /// **'My store'**
  String get storeNameDefault;

  /// No description provided for @preferencesButton.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesButton;

  /// No description provided for @preferencesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesTooltip;

  /// No description provided for @preferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesTitle;

  /// No description provided for @preferencesBody.
  ///
  /// In en, this message translates to:
  /// **'Optional. Your mobile number and birthday are encrypted before being remembered on this device.'**
  String get preferencesBody;

  /// No description provided for @preferencesMobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get preferencesMobileLabel;

  /// No description provided for @preferencesBirthdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday (YYYY-MM-DD)'**
  String get preferencesBirthdayLabel;

  /// No description provided for @preferencesLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get preferencesLanguageLabel;

  /// No description provided for @preferencesRememberCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Remember these details'**
  String get preferencesRememberCheckbox;

  /// No description provided for @preferencesSecurityNote.
  ///
  /// In en, this message translates to:
  /// **'Higher security: keep your backup phrase offline and use it to restore this account if this device\'s storage is lost.'**
  String get preferencesSecurityNote;

  /// No description provided for @accountGateHeadline.
  ///
  /// In en, this message translates to:
  /// **'Sign in to open the store manager'**
  String get accountGateHeadline;

  /// No description provided for @accountGateBody.
  ///
  /// In en, this message translates to:
  /// **'Your account is the store manager key. Local accounts are stored as encrypted keystores protected by your passphrase.'**
  String get accountGateBody;

  /// No description provided for @chatTooltip.
  ///
  /// In en, this message translates to:
  /// **'Chat with support'**
  String get chatTooltip;

  /// No description provided for @chatWithSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with support'**
  String get chatWithSupportTitle;

  /// No description provided for @messageSupportHint.
  ///
  /// In en, this message translates to:
  /// **'Message support'**
  String get messageSupportHint;

  /// No description provided for @memberZoneTooltip.
  ///
  /// In en, this message translates to:
  /// **'Member zone'**
  String get memberZoneTooltip;

  /// No description provided for @memberZoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Member zone'**
  String get memberZoneTitle;

  /// No description provided for @clientMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'À la carte menu'**
  String get clientMenuTitle;

  /// No description provided for @clientMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Channel: {channel} · Tap a dish to see details and add it to your order'**
  String clientMenuSubtitle(String channel);

  /// No description provided for @installAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Install LilyGO ERP'**
  String get installAppTitle;

  /// No description provided for @installAppBody.
  ///
  /// In en, this message translates to:
  /// **'Install this order screen on Android, iOS, Windows, or macOS.'**
  String get installAppBody;

  /// No description provided for @installAppHint.
  ///
  /// In en, this message translates to:
  /// **'Use Install app, Add to Dock, or on iPhone/iPad Share → Add to Home Screen.'**
  String get installAppHint;

  /// No description provided for @enableNotificationsButton.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enableNotificationsButton;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked in this browser'**
  String get notificationsBlocked;

  /// No description provided for @keepAwakeButton.
  ///
  /// In en, this message translates to:
  /// **'Keep screen awake'**
  String get keepAwakeButton;

  /// No description provided for @screenAwakeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Screen will stay awake while this page is open'**
  String get screenAwakeEnabled;

  /// No description provided for @newOrderNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'New order'**
  String get newOrderNotificationTitle;

  /// No description provided for @newOrderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Order {ref} is ready to review.'**
  String newOrderNotificationBody(String ref);

  /// No description provided for @alwaysOnConnectionHint.
  ///
  /// In en, this message translates to:
  /// **'Keep this installed app open for live WebRTC orders. If the device suspends it, the connection will show Reconnect needed.'**
  String get alwaysOnConnectionHint;

  /// No description provided for @iosInstallHint.
  ///
  /// In en, this message translates to:
  /// **'On iPhone or iPad: Share → Add to Home Screen, then keep the app open for live orders.'**
  String get iosInstallHint;

  /// No description provided for @backgroundSupportNav.
  ///
  /// In en, this message translates to:
  /// **'Always-on & notifications'**
  String get backgroundSupportNav;

  /// No description provided for @backgroundSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Always-on & notifications'**
  String get backgroundSupportTitle;

  /// No description provided for @backgroundSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the portal connection visible and receive order alerts.'**
  String get backgroundSupportSubtitle;

  /// No description provided for @backgroundSupportWebTitle.
  ///
  /// In en, this message translates to:
  /// **'Web app'**
  String get backgroundSupportWebTitle;

  /// No description provided for @backgroundSupportWebBody.
  ///
  /// In en, this message translates to:
  /// **'Works while this page is open. The browser may suspend it when it is in the background.'**
  String get backgroundSupportWebBody;

  /// No description provided for @backgroundSupportAndroidTitle.
  ///
  /// In en, this message translates to:
  /// **'Android'**
  String get backgroundSupportAndroidTitle;

  /// No description provided for @backgroundSupportAndroidBody.
  ///
  /// In en, this message translates to:
  /// **'A native foreground-service app is required for reliable background operation.'**
  String get backgroundSupportAndroidBody;

  /// No description provided for @backgroundSupportIosTitle.
  ///
  /// In en, this message translates to:
  /// **'iPhone & iPad'**
  String get backgroundSupportIosTitle;

  /// No description provided for @backgroundSupportIosBody.
  ///
  /// In en, this message translates to:
  /// **'Install from Safari for quick access. Background alerts require Apple Push Notifications.'**
  String get backgroundSupportIosBody;

  /// No description provided for @backgroundSupportChromeTitle.
  ///
  /// In en, this message translates to:
  /// **'Chrome extension'**
  String get backgroundSupportChromeTitle;

  /// No description provided for @backgroundSupportChromeBody.
  ///
  /// In en, this message translates to:
  /// **'Install the extension to open the portal in a dedicated Chrome app tab.'**
  String get backgroundSupportChromeBody;

  /// No description provided for @downloadChromeExtensionButton.
  ///
  /// In en, this message translates to:
  /// **'Download Chrome extension'**
  String get downloadChromeExtensionButton;

  /// No description provided for @backgroundSupportKeepOpen.
  ///
  /// In en, this message translates to:
  /// **'For live WebRTC orders, keep the portal open on the always-on device.'**
  String get backgroundSupportKeepOpen;

  /// No description provided for @deviceConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'LAN device connection'**
  String get deviceConnectionTitle;

  /// No description provided for @deviceConnectionBody.
  ///
  /// In en, this message translates to:
  /// **'The ESP32 is a LAN-only storage and attestation server. It does not serve the web app.'**
  String get deviceConnectionBody;

  /// No description provided for @deviceUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'ESP32 LAN URL'**
  String get deviceUrlLabel;

  /// No description provided for @deviceUrlHint.
  ///
  /// In en, this message translates to:
  /// **'http://192.168.1.50:8000'**
  String get deviceUrlHint;

  /// No description provided for @saveDeviceUrlButton.
  ///
  /// In en, this message translates to:
  /// **'Save device URL'**
  String get saveDeviceUrlButton;

  /// No description provided for @scanDeviceQrButton.
  ///
  /// In en, this message translates to:
  /// **'Scan device QR'**
  String get scanDeviceQrButton;

  /// No description provided for @deviceUrlSaved.
  ///
  /// In en, this message translates to:
  /// **'Device URL saved'**
  String get deviceUrlSaved;

  /// No description provided for @deviceReachable.
  ///
  /// In en, this message translates to:
  /// **'Device is reachable'**
  String get deviceReachable;

  /// No description provided for @deviceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Device is unavailable'**
  String get deviceUnavailable;

  /// No description provided for @deviceQrUnsupported.
  ///
  /// In en, this message translates to:
  /// **'QR scanning is not supported in this browser. Enter the LAN URL manually.'**
  String get deviceQrUnsupported;

  /// No description provided for @menuFallbackCategory.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuFallbackCategory;

  /// No description provided for @clientOrderLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to order'**
  String get clientOrderLockedTitle;

  /// No description provided for @clientOrderUnlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your channel orders'**
  String get clientOrderUnlockedTitle;

  /// No description provided for @clientOrderLockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number only when you send the order.'**
  String get clientOrderLockedSubtitle;

  /// No description provided for @clientOrderUnlockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 encrypted order} other{{count} encrypted orders}} · Total NT\${total}'**
  String clientOrderUnlockedSubtitle(int count, String total);

  /// No description provided for @clientOrderTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total NT\${total} ({count, plural, one{1 item} other{{count} items}})'**
  String clientOrderTotalLabel(String total, int count);

  /// No description provided for @clientOrderConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm order'**
  String get clientOrderConfirmButton;

  /// No description provided for @checkoutInvoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice preview'**
  String get checkoutInvoiceTitle;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethodLabel;

  /// No description provided for @cashPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cashPaymentLabel;

  /// No description provided for @salesWorkspaceTitle.
  ///
  /// In en, this message translates to:
  /// **'SuiteCRM workspace'**
  String get salesWorkspaceTitle;

  /// No description provided for @salesWorkspaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts, activities, and operations'**
  String get salesWorkspaceSubtitle;

  /// No description provided for @offlineTerminalFooter.
  ///
  /// In en, this message translates to:
  /// **'Offline terminal'**
  String get offlineTerminalFooter;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navThirdParties.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get navThirdParties;

  /// No description provided for @navProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get navProducts;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get navConnection;

  /// No description provided for @navSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get navSupport;

  /// No description provided for @createChannelButton.
  ///
  /// In en, this message translates to:
  /// **'Open store link'**
  String get createChannelButton;

  /// No description provided for @channelNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Store link name'**
  String get channelNameFieldLabel;

  /// No description provided for @channelReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Store link {code} ready'**
  String channelReadyTitle(String code);

  /// No description provided for @printButton.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get printButton;

  /// No description provided for @metricOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get metricOrders;

  /// No description provided for @metricThirdParties.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get metricThirdParties;

  /// No description provided for @metricProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get metricProducts;

  /// No description provided for @storageCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Local storage'**
  String get storageCardTitle;

  /// No description provided for @storageCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Store link {channel} keeps orders on this device. Keep this window open here — it\'s what keeps your checkout link and chat live for customers.'**
  String storageCardSubtitle(String channel);

  /// No description provided for @customersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts & contacts'**
  String get customersSectionTitle;

  /// No description provided for @customersSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'SuiteCRM account and contact directory'**
  String get customersSectionSubtitle;

  /// No description provided for @colName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get colName;

  /// No description provided for @colCustomerCode.
  ///
  /// In en, this message translates to:
  /// **'Customer code'**
  String get colCustomerCode;

  /// No description provided for @colEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get colEmail;

  /// No description provided for @customersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No customers yet.'**
  String get customersEmpty;

  /// No description provided for @productsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsSectionTitle;

  /// No description provided for @productsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Product catalog'**
  String get productsSectionSubtitle;

  /// No description provided for @loadSampleMenuButton.
  ///
  /// In en, this message translates to:
  /// **'Load sample menu'**
  String get loadSampleMenuButton;

  /// No description provided for @newProductButton.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get newProductButton;

  /// No description provided for @colReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get colReference;

  /// No description provided for @colLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get colLabel;

  /// No description provided for @colPriceHt.
  ///
  /// In en, this message translates to:
  /// **'Price (excl. tax)'**
  String get colPriceHt;

  /// No description provided for @colVat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get colVat;

  /// No description provided for @colStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get colStock;

  /// No description provided for @translationsAction.
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get translationsAction;

  /// No description provided for @productsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products yet. Add one or load the sample menu.'**
  String get productsEmpty;

  /// No description provided for @newProductTitle.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get newProductTitle;

  /// No description provided for @editProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProductTitle;

  /// No description provided for @fieldReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get fieldReference;

  /// No description provided for @fieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get fieldLabel;

  /// No description provided for @fieldPriceHt.
  ///
  /// In en, this message translates to:
  /// **'Price (excl. tax)'**
  String get fieldPriceHt;

  /// No description provided for @fieldVat.
  ///
  /// In en, this message translates to:
  /// **'VAT %'**
  String get fieldVat;

  /// No description provided for @fieldStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get fieldStock;

  /// No description provided for @translationsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get translationsDialogTitle;

  /// No description provided for @translationsLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get translationsLanguageLabel;

  /// No description provided for @translationsLabelField.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get translationsLabelField;

  /// No description provided for @translationsDescriptionField.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get translationsDescriptionField;

  /// No description provided for @ordersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersSectionTitle;

  /// No description provided for @ordersSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Order history'**
  String get ordersSectionSubtitle;

  /// No description provided for @orderTransactionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 transaction} other{{count} transactions}}'**
  String orderTransactionCount(int count);

  /// No description provided for @ordersEmptyMock.
  ///
  /// In en, this message translates to:
  /// **'New orders arrive automatically every 10 seconds.'**
  String get ordersEmptyMock;

  /// No description provided for @operateTransactionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Manage order'**
  String get operateTransactionTooltip;

  /// No description provided for @validateOrderMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Mark as validated'**
  String get validateOrderMenuItem;

  /// No description provided for @acceptOrderMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Mark as accepted'**
  String get acceptOrderMenuItem;

  /// No description provided for @processOrderMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Mark as processing'**
  String get processOrderMenuItem;

  /// No description provided for @deliverOrderMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Mark as delivered'**
  String get deliverOrderMenuItem;

  /// No description provided for @cancelOrderMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get cancelOrderMenuItem;

  /// No description provided for @totalHtLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal NT\${total}'**
  String totalHtLabel(String total);

  /// No description provided for @totalTtcLabel.
  ///
  /// In en, this message translates to:
  /// **'Total NT\${total}'**
  String totalTtcLabel(String total);

  /// No description provided for @orderStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get orderStatusDraft;

  /// No description provided for @orderStatusValidated.
  ///
  /// In en, this message translates to:
  /// **'Validated'**
  String get orderStatusValidated;

  /// No description provided for @orderStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get orderStatusAccepted;

  /// No description provided for @orderStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get orderStatusProcessing;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get orderStatusCanceled;

  /// No description provided for @orderStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get orderStatusUnknown;

  /// No description provided for @supportSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportSectionTitle;

  /// No description provided for @supportSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Channel {channel}'**
  String supportSectionSubtitle(String channel);

  /// No description provided for @joinAsAgentButton.
  ///
  /// In en, this message translates to:
  /// **'Join as agent'**
  String get joinAsAgentButton;

  /// No description provided for @conversationsTab.
  ///
  /// In en, this message translates to:
  /// **'Conversations'**
  String get conversationsTab;

  /// No description provided for @activityLogTab.
  ///
  /// In en, this message translates to:
  /// **'Activity log'**
  String get activityLogTab;

  /// No description provided for @noActivityYet.
  ///
  /// In en, this message translates to:
  /// **'No activity yet.'**
  String get noActivityYet;

  /// No description provided for @noConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet.'**
  String get noConversationsYet;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get noMessagesYet;

  /// No description provided for @selectConversationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Select a conversation'**
  String get selectConversationPrompt;

  /// No description provided for @replyHint.
  ///
  /// In en, this message translates to:
  /// **'Reply to customer'**
  String get replyHint;

  /// No description provided for @roleOwnerLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwnerLabel;

  /// No description provided for @roleAgentLabel.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get roleAgentLabel;

  /// No description provided for @roleMemberLabel.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get roleMemberLabel;

  /// No description provided for @connectionConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connectionConnected;

  /// No description provided for @connectionReconnectNeeded.
  ///
  /// In en, this message translates to:
  /// **'Reconnect needed'**
  String get connectionReconnectNeeded;

  /// No description provided for @connectionConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get connectionConnecting;

  /// No description provided for @connectionNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get connectionNotConnected;

  /// No description provided for @connectionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connectionSectionTitle;

  /// No description provided for @connectionSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manual pairing for live chat delivery'**
  String get connectionSectionSubtitle;

  /// No description provided for @portalKeepOpenHint.
  ///
  /// In en, this message translates to:
  /// **'Keep this window open on this device — it\'s what keeps your store\'s checkout link and chat live for customers.'**
  String get portalKeepOpenHint;

  /// No description provided for @connectionDefaultMessage.
  ///
  /// In en, this message translates to:
  /// **'Using a public relay to discover routes'**
  String get connectionDefaultMessage;

  /// No description provided for @generateOfferButton.
  ///
  /// In en, this message translates to:
  /// **'Generate pairing code'**
  String get generateOfferButton;

  /// No description provided for @acceptOfferButton.
  ///
  /// In en, this message translates to:
  /// **'Enter pairing code'**
  String get acceptOfferButton;

  /// No description provided for @applyAnswerButton.
  ///
  /// In en, this message translates to:
  /// **'Apply response'**
  String get applyAnswerButton;

  /// No description provided for @offerFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Pairing code'**
  String get offerFieldLabel;

  /// No description provided for @answerFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Response code'**
  String get answerFieldLabel;

  /// No description provided for @connectionOfferGeneratedMessage.
  ///
  /// In en, this message translates to:
  /// **'Pairing code generated. Share it with the other device, then enter its response.'**
  String get connectionOfferGeneratedMessage;

  /// No description provided for @connectionAnswerGeneratedMessage.
  ///
  /// In en, this message translates to:
  /// **'Response generated. Send it back to the device that created the pairing code.'**
  String get connectionAnswerGeneratedMessage;

  /// No description provided for @connectionAnswerAppliedMessage.
  ///
  /// In en, this message translates to:
  /// **'Connection established.'**
  String get connectionAnswerAppliedMessage;

  /// No description provided for @connectionOfferErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Pairing error: {error}'**
  String connectionOfferErrorMessage(String error);

  /// No description provided for @connectionAcceptErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Response error: {error}'**
  String connectionAcceptErrorMessage(String error);

  /// No description provided for @connectionApplyErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Connection error: {error}'**
  String connectionApplyErrorMessage(String error);

  /// No description provided for @connectionFooterNote.
  ///
  /// In en, this message translates to:
  /// **'This helps discover a direct connection between devices. It does not provide message delivery on its own.'**
  String get connectionFooterNote;

  /// No description provided for @statusStartingDb.
  ///
  /// In en, this message translates to:
  /// **'Starting local database…'**
  String get statusStartingDb;

  /// No description provided for @statusClientStorageError.
  ///
  /// In en, this message translates to:
  /// **'Local storage error: {error}'**
  String statusClientStorageError(String error);

  /// No description provided for @statusReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'Ready — browse and manage store data'**
  String get statusReadyMessage;

  /// No description provided for @statusStartupError.
  ///
  /// In en, this message translates to:
  /// **'Startup error: {error}'**
  String statusStartupError(String error);

  /// No description provided for @statusOrderSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced {ref} with {lineCount} lines ({bytes} bytes)'**
  String statusOrderSynced(String ref, int lineCount, int bytes);

  /// No description provided for @statusSyncError.
  ///
  /// In en, this message translates to:
  /// **'Sync error: {error}'**
  String statusSyncError(String error);

  /// No description provided for @statusOrderStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'Order status changed to {statusLabel}'**
  String statusOrderStatusChanged(String statusLabel);

  /// No description provided for @statusProductSaved.
  ///
  /// In en, this message translates to:
  /// **'Product {ref} saved locally'**
  String statusProductSaved(String ref);

  /// No description provided for @statusMenuLoaded.
  ///
  /// In en, this message translates to:
  /// **'Loaded {count} sample menu products locally'**
  String statusMenuLoaded(int count);

  /// No description provided for @statusAccountCanceled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in canceled or failed: {error}'**
  String statusAccountCanceled(String error);

  /// No description provided for @statusAccountConnected.
  ///
  /// In en, this message translates to:
  /// **'Account connected and encryption initialized: {address}'**
  String statusAccountConnected(String address);

  /// No description provided for @statusProfileDecryptError.
  ///
  /// In en, this message translates to:
  /// **'Remembered profile could not be decrypted'**
  String get statusProfileDecryptError;

  /// No description provided for @statusProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Contact information encrypted and remembered for {address}'**
  String statusProfileSaved(String address);

  /// No description provided for @statusProfileRemoved.
  ///
  /// In en, this message translates to:
  /// **'Remembered contact information removed'**
  String get statusProfileRemoved;

  /// No description provided for @statusTransactionReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Encrypted transaction read failed: {error}'**
  String statusTransactionReadFailed(String error);

  /// No description provided for @statusOrderSaved.
  ///
  /// In en, this message translates to:
  /// **'Order {ref} encrypted for this account and saved offline'**
  String statusOrderSaved(String ref);

  /// No description provided for @orderSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Order saved offline'**
  String get orderSavedSnackbar;

  /// No description provided for @statusBackupDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Backup downloaded'**
  String get statusBackupDownloaded;

  /// No description provided for @statusBackupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get statusBackupRestored;

  /// No description provided for @statusRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}'**
  String statusRestoreFailed(String error);

  /// No description provided for @backupTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back up data'**
  String get backupTooltip;

  /// No description provided for @restoreTooltip.
  ///
  /// In en, this message translates to:
  /// **'Restore data'**
  String get restoreTooltip;

  /// No description provided for @googleDriveBackupTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back up to Google Drive'**
  String get googleDriveBackupTooltip;

  /// No description provided for @googleDriveRestoreTooltip.
  ///
  /// In en, this message translates to:
  /// **'Restore from Google Drive'**
  String get googleDriveRestoreTooltip;

  /// No description provided for @googleSheetExportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export to Google Sheet'**
  String get googleSheetExportTooltip;

  /// No description provided for @googleSheetImportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Import from Google Sheet'**
  String get googleSheetImportTooltip;

  /// No description provided for @googleWorkspaceClientMissing.
  ///
  /// In en, this message translates to:
  /// **'Google Workspace is not configured for this deployment'**
  String get googleWorkspaceClientMissing;

  /// No description provided for @googleWorkspaceBackupDone.
  ///
  /// In en, this message translates to:
  /// **'Backup saved to Google Drive'**
  String get googleWorkspaceBackupDone;

  /// No description provided for @googleWorkspaceRestoreDone.
  ///
  /// In en, this message translates to:
  /// **'Backup restored from Google Drive'**
  String get googleWorkspaceRestoreDone;

  /// No description provided for @googleWorkspaceSheetDone.
  ///
  /// In en, this message translates to:
  /// **'Google Sheet exported: {url}'**
  String googleWorkspaceSheetDone(Object url);

  /// No description provided for @googleWorkspaceSheetIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Google Sheet ID or URL'**
  String get googleWorkspaceSheetIdLabel;

  /// No description provided for @googleWorkspaceSheetImportDone.
  ///
  /// In en, this message translates to:
  /// **'Google Sheet imported'**
  String get googleWorkspaceSheetImportDone;

  /// No description provided for @refreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh data'**
  String get refreshTooltip;

  /// No description provided for @restoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup?'**
  String get restoreConfirmTitle;

  /// No description provided for @restoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This replaces all current store and client data with the contents of the chosen backup file. This cannot be undone.'**
  String get restoreConfirmBody;

  /// No description provided for @orderStatusChangedLog.
  ///
  /// In en, this message translates to:
  /// **'Order #{orderId} → {statusLabel}'**
  String orderStatusChangedLog(int orderId, String statusLabel);

  /// No description provided for @productSavedLog.
  ///
  /// In en, this message translates to:
  /// **'Product {ref} saved (NT\${price})'**
  String productSavedLog(String ref, String price);

  /// No description provided for @channelCreatedLog.
  ///
  /// In en, this message translates to:
  /// **'Channel {code} created: \"{name}\"'**
  String channelCreatedLog(String code, String name);

  /// No description provided for @accountConnectedLog.
  ///
  /// In en, this message translates to:
  /// **'Account {address} connected'**
  String accountConnectedLog(String address);

  /// No description provided for @agentJoinedLog.
  ///
  /// In en, this message translates to:
  /// **'Agent {address} joined channel {channel}'**
  String agentJoinedLog(String address, String channel);

  /// No description provided for @navContent.
  ///
  /// In en, this message translates to:
  /// **'Menu content'**
  String get navContent;

  /// No description provided for @contentSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu content'**
  String get contentSectionTitle;

  /// No description provided for @contentSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customer-facing storefront content'**
  String get contentSectionSubtitle;

  /// No description provided for @newContentItemButton.
  ///
  /// In en, this message translates to:
  /// **'New item'**
  String get newContentItemButton;

  /// No description provided for @publishButton.
  ///
  /// In en, this message translates to:
  /// **'Publish to clients'**
  String get publishButton;

  /// No description provided for @demoModeButton.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get demoModeButton;

  /// No description provided for @contentEmpty.
  ///
  /// In en, this message translates to:
  /// **'No content items yet.'**
  String get contentEmpty;

  /// No description provided for @colCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get colCategory;

  /// No description provided for @newContentItemTitle.
  ///
  /// In en, this message translates to:
  /// **'New item'**
  String get newContentItemTitle;

  /// No description provided for @editContentItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editContentItemTitle;

  /// No description provided for @fieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get fieldCategory;

  /// No description provided for @fieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fieldDescription;

  /// No description provided for @statusContentPublished.
  ///
  /// In en, this message translates to:
  /// **'Menu content published to connected clients'**
  String get statusContentPublished;

  /// No description provided for @resetDataButton.
  ///
  /// In en, this message translates to:
  /// **'Reset data'**
  String get resetDataButton;

  /// No description provided for @resetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all data?'**
  String get resetConfirmTitle;

  /// No description provided for @resetConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes all store, chat, menu content, and loyalty data on this device. Your signed-in account is not affected. This cannot be undone.'**
  String get resetConfirmBody;

  /// No description provided for @statusDataReset.
  ///
  /// In en, this message translates to:
  /// **'All data has been reset'**
  String get statusDataReset;

  /// No description provided for @navLoyalty.
  ///
  /// In en, this message translates to:
  /// **'Memberships'**
  String get navLoyalty;

  /// No description provided for @loyaltySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Memberships & rewards'**
  String get loyaltySectionTitle;

  /// No description provided for @loyaltySectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'SuiteCRM accounts, contacts, points, and claims'**
  String get loyaltySectionSubtitle;

  /// No description provided for @colWallet.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get colWallet;

  /// No description provided for @colPointsBalance.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get colPointsBalance;

  /// No description provided for @colTier.
  ///
  /// In en, this message translates to:
  /// **'Tier'**
  String get colTier;

  /// No description provided for @adjustPointsButton.
  ///
  /// In en, this message translates to:
  /// **'Adjust points'**
  String get adjustPointsButton;

  /// No description provided for @adjustPointsTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust points'**
  String get adjustPointsTitle;

  /// No description provided for @pointsFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Points (negative to redeem)'**
  String get pointsFieldLabel;

  /// No description provided for @reasonFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reasonFieldLabel;

  /// No description provided for @loyaltyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No memberships yet.'**
  String get loyaltyEmpty;

  /// No description provided for @statusPointsAdjusted.
  ///
  /// In en, this message translates to:
  /// **'Points adjusted'**
  String get statusPointsAdjusted;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @bookingsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookingsSectionTitle;

  /// No description provided for @bookingsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'SuiteCRM activities, resources, and booking status'**
  String get bookingsSectionSubtitle;

  /// No description provided for @seedMachinesButton.
  ///
  /// In en, this message translates to:
  /// **'Load sample resources'**
  String get seedMachinesButton;

  /// No description provided for @machinesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No resources yet. Load sample resources to get started.'**
  String get machinesEmpty;

  /// No description provided for @machineStateIdle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get machineStateIdle;

  /// No description provided for @machineStateOccupied.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get machineStateOccupied;

  /// No description provided for @machineStateMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get machineStateMaintenance;

  /// No description provided for @setIdleButton.
  ///
  /// In en, this message translates to:
  /// **'Set idle'**
  String get setIdleButton;

  /// No description provided for @setMaintenanceButton.
  ///
  /// In en, this message translates to:
  /// **'Set maintenance'**
  String get setMaintenanceButton;

  /// No description provided for @bookingsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet.'**
  String get bookingsEmpty;

  /// No description provided for @bookingStatusPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get bookingStatusPlanned;

  /// No description provided for @bookingStatusReleased.
  ///
  /// In en, this message translates to:
  /// **'Released'**
  String get bookingStatusReleased;

  /// No description provided for @bookingStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get bookingStatusInProgress;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingStatusCompleted;

  /// No description provided for @bookingStatusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get bookingStatusCanceled;

  /// No description provided for @releaseBookingMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get releaseBookingMenuItem;

  /// No description provided for @startBookingMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startBookingMenuItem;

  /// No description provided for @completeBookingMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get completeBookingMenuItem;

  /// No description provided for @cancelBookingMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelBookingMenuItem;

  /// No description provided for @clientBookingCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Request a booking'**
  String get clientBookingCardTitle;

  /// No description provided for @clientBookingMachineLabel.
  ///
  /// In en, this message translates to:
  /// **'Resource'**
  String get clientBookingMachineLabel;

  /// No description provided for @clientBookingTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get clientBookingTimeLabel;

  /// No description provided for @clientBookingPartySizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Party size'**
  String get clientBookingPartySizeLabel;

  /// No description provided for @clientBookingSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Request booking'**
  String get clientBookingSubmitButton;

  /// No description provided for @statusBookingRequested.
  ///
  /// In en, this message translates to:
  /// **'Booking request sent'**
  String get statusBookingRequested;

  /// No description provided for @navAccessControl.
  ///
  /// In en, this message translates to:
  /// **'Access control'**
  String get navAccessControl;

  /// No description provided for @membersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersSectionTitle;

  /// No description provided for @membersSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who can access this store\'s portal, and what they can do'**
  String get membersSectionSubtitle;

  /// No description provided for @membersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No members added yet. You\'re the only one with access.'**
  String get membersEmpty;

  /// No description provided for @noRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'No role'**
  String get noRoleLabel;

  /// No description provided for @addMemberButton.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get addMemberButton;

  /// No description provided for @walletAddressFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Their account address'**
  String get walletAddressFieldLabel;

  /// No description provided for @roleFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleFieldLabel;

  /// No description provided for @rolesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get rolesSectionTitle;

  /// No description provided for @newRoleButton.
  ///
  /// In en, this message translates to:
  /// **'New role'**
  String get newRoleButton;

  /// No description provided for @roleNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Role name'**
  String get roleNameFieldLabel;

  /// No description provided for @statusRoleGranted.
  ///
  /// In en, this message translates to:
  /// **'Role granted'**
  String get statusRoleGranted;

  /// No description provided for @statusRoleRevoked.
  ///
  /// In en, this message translates to:
  /// **'Role removed'**
  String get statusRoleRevoked;

  /// No description provided for @navDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get navDatabase;

  /// No description provided for @databaseSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get databaseSectionTitle;

  /// No description provided for @databaseSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse tables and run queries against this device\'s local database'**
  String get databaseSectionSubtitle;

  /// No description provided for @sqlQueryLabel.
  ///
  /// In en, this message translates to:
  /// **'SQL query'**
  String get sqlQueryLabel;

  /// No description provided for @sqlQueryHint.
  ///
  /// In en, this message translates to:
  /// **'SELECT * FROM erp.llx_product'**
  String get sqlQueryHint;

  /// No description provided for @runQueryButton.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get runQueryButton;

  /// No description provided for @queryEmptyResult.
  ///
  /// In en, this message translates to:
  /// **'Query returned no rows.'**
  String get queryEmptyResult;

  /// No description provided for @tablesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get tablesSectionTitle;

  /// No description provided for @clearTableButton.
  ///
  /// In en, this message translates to:
  /// **'Clear table'**
  String get clearTableButton;

  /// No description provided for @clearTableConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear {table}?'**
  String clearTableConfirmTitle(String table);

  /// No description provided for @clearTableConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes every row in this table. This cannot be undone.'**
  String get clearTableConfirmBody;

  /// No description provided for @statusQueryExecuted.
  ///
  /// In en, this message translates to:
  /// **'Query executed'**
  String get statusQueryExecuted;

  /// No description provided for @navRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get navRegister;

  /// No description provided for @navRegisterSettlement.
  ///
  /// In en, this message translates to:
  /// **'Till'**
  String get navRegisterSettlement;

  /// No description provided for @navSalesAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Sales analysis'**
  String get navSalesAnalysis;

  /// No description provided for @navPosSettings.
  ///
  /// In en, this message translates to:
  /// **'POS settings'**
  String get navPosSettings;

  /// No description provided for @noCategoryOption.
  ///
  /// In en, this message translates to:
  /// **'No category'**
  String get noCategoryOption;

  /// No description provided for @taxIncludedLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax included in price'**
  String get taxIncludedLabel;

  /// No description provided for @taxIncludedHint.
  ///
  /// In en, this message translates to:
  /// **'Turn off if this product\'s price excludes tax'**
  String get taxIncludedHint;

  /// No description provided for @newCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategoryTitle;

  /// No description provided for @editCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategoryTitle;

  /// No description provided for @deleteCategoryConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this category?'**
  String get deleteCategoryConfirmTitle;

  /// No description provided for @deleteCategoryConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Products in this category will become uncategorized. This cannot be undone.'**
  String get deleteCategoryConfirmBody;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @productsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTabLabel;

  /// No description provided for @categoriesTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTabLabel;

  /// No description provided for @newCategoryButton.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategoryButton;

  /// No description provided for @categoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No categories yet.'**
  String get categoriesEmpty;

  /// No description provided for @productCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 product} other{{count} products}}'**
  String productCountLabel(int count);

  /// No description provided for @registerSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerSectionTitle;

  /// No description provided for @registerSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ring up items and take payment'**
  String get registerSectionSubtitle;

  /// No description provided for @allCategoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategoriesLabel;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @cartEmptyLabel.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get cartEmptyLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @payButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get payButtonLabel;

  /// No description provided for @registerNotOpenWarning.
  ///
  /// In en, this message translates to:
  /// **'Open the register from the Till screen before taking payment'**
  String get registerNotOpenWarning;

  /// No description provided for @saleCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Sale complete'**
  String get saleCompleteTitle;

  /// No description provided for @saleCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get saleCompleteBody;

  /// No description provided for @changeDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Change due: NT\${amount}'**
  String changeDueLabel(String amount);

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @registerSettlementTitle.
  ///
  /// In en, this message translates to:
  /// **'Till'**
  String get registerSettlementTitle;

  /// No description provided for @registerSettlementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open and close the register, and review cash totals'**
  String get registerSettlementSubtitle;

  /// No description provided for @colOpenedAt.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get colOpenedAt;

  /// No description provided for @colClosedAt.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get colClosedAt;

  /// No description provided for @colOpeningFloat.
  ///
  /// In en, this message translates to:
  /// **'Opening float'**
  String get colOpeningFloat;

  /// No description provided for @colCountedCash.
  ///
  /// In en, this message translates to:
  /// **'Counted cash'**
  String get colCountedCash;

  /// No description provided for @registerHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get registerHistoryTitle;

  /// No description provided for @registerHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No register sessions yet.'**
  String get registerHistoryEmpty;

  /// No description provided for @openRegisterCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Open the register'**
  String get openRegisterCardTitle;

  /// No description provided for @openingFloatLabel.
  ///
  /// In en, this message translates to:
  /// **'Opening float'**
  String get openingFloatLabel;

  /// No description provided for @openRegisterButton.
  ///
  /// In en, this message translates to:
  /// **'Open register'**
  String get openRegisterButton;

  /// No description provided for @activeSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Register opened {time}'**
  String activeSessionTitle(String time);

  /// No description provided for @openingFloatSummary.
  ///
  /// In en, this message translates to:
  /// **'Opening float: NT\${amount}'**
  String openingFloatSummary(String amount);

  /// No description provided for @closeRegisterButton.
  ///
  /// In en, this message translates to:
  /// **'Close register'**
  String get closeRegisterButton;

  /// No description provided for @recentSalesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent sales'**
  String get recentSalesTitle;

  /// No description provided for @recentSalesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sales yet this session.'**
  String get recentSalesEmpty;

  /// No description provided for @refundedChipLabel.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refundedChipLabel;

  /// No description provided for @refundButton.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refundButton;

  /// No description provided for @closeRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Close register'**
  String get closeRegisterTitle;

  /// No description provided for @expectedCashLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected cash: NT\${amount}'**
  String expectedCashLabel(String amount);

  /// No description provided for @countedCashLabel.
  ///
  /// In en, this message translates to:
  /// **'Counted cash'**
  String get countedCashLabel;

  /// No description provided for @varianceLabel.
  ///
  /// In en, this message translates to:
  /// **'Variance: NT\${amount}'**
  String varianceLabel(String amount);

  /// No description provided for @refundConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Refund this sale?'**
  String get refundConfirmTitle;

  /// No description provided for @refundConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This restores stock and records a credit note. This cannot be undone.'**
  String get refundConfirmBody;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @tenderedAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount tendered'**
  String get tenderedAmountLabel;

  /// No description provided for @completeSaleButton.
  ///
  /// In en, this message translates to:
  /// **'Complete sale'**
  String get completeSaleButton;

  /// No description provided for @salesAnalysisSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales analysis'**
  String get salesAnalysisSectionTitle;

  /// No description provided for @salesAnalysisSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily, category, and product sales breakdowns'**
  String get salesAnalysisSectionSubtitle;

  /// No description provided for @rangeTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get rangeTodayLabel;

  /// No description provided for @range7dLabel.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get range7dLabel;

  /// No description provided for @range30dLabel.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get range30dLabel;

  /// No description provided for @rangeAllLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get rangeAllLabel;

  /// No description provided for @dailySalesLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily sales'**
  String get dailySalesLabel;

  /// No description provided for @exportCsvButton.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsvButton;

  /// No description provided for @salesAnalysisEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sales in this period.'**
  String get salesAnalysisEmpty;

  /// No description provided for @salesByCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Sales by category'**
  String get salesByCategoryLabel;

  /// No description provided for @salesByProductLabel.
  ///
  /// In en, this message translates to:
  /// **'Sales by product'**
  String get salesByProductLabel;

  /// No description provided for @posSettingsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'POS settings'**
  String get posSettingsSectionTitle;

  /// No description provided for @posSettingsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Default tax handling for new products'**
  String get posSettingsSectionSubtitle;

  /// No description provided for @defaultTaxModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Prices include tax by default'**
  String get defaultTaxModeLabel;

  /// No description provided for @standardRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Standard tax rate (%)'**
  String get standardRateLabel;

  /// No description provided for @reducedRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Reduced tax rate (%)'**
  String get reducedRateLabel;

  /// No description provided for @uncategorizedLabel.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get uncategorizedLabel;

  /// No description provided for @fieldProductType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fieldProductType;

  /// No description provided for @productTypeGoods.
  ///
  /// In en, this message translates to:
  /// **'Goods'**
  String get productTypeGoods;

  /// No description provided for @productTypeService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get productTypeService;

  /// No description provided for @fieldBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get fieldBarcode;

  /// No description provided for @fieldStockAlert.
  ///
  /// In en, this message translates to:
  /// **'Stock alert threshold'**
  String get fieldStockAlert;

  /// No description provided for @productEnabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Available for sale'**
  String get productEnabledLabel;

  /// No description provided for @productEnabledHint.
  ///
  /// In en, this message translates to:
  /// **'Turn off to hide this product from the register without deleting it'**
  String get productEnabledHint;

  /// No description provided for @colBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get colBarcode;

  /// No description provided for @productDisabledSuffix.
  ///
  /// In en, this message translates to:
  /// **'(hidden)'**
  String get productDisabledSuffix;

  /// No description provided for @bookingsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookingsTabLabel;

  /// No description provided for @staffShiftsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Staff & shifts'**
  String get staffShiftsTabLabel;

  /// No description provided for @downtimeTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Downtime'**
  String get downtimeTabLabel;

  /// No description provided for @assignedWorkerLabel.
  ///
  /// In en, this message translates to:
  /// **'Assigned to {name}'**
  String assignedWorkerLabel(String name);

  /// No description provided for @workersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get workersSectionTitle;

  /// No description provided for @newWorkerButton.
  ///
  /// In en, this message translates to:
  /// **'New staff member'**
  String get newWorkerButton;

  /// No description provided for @editWorkerTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit staff member'**
  String get editWorkerTitle;

  /// No description provided for @workersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No staff members yet.'**
  String get workersEmpty;

  /// No description provided for @shiftsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Shifts'**
  String get shiftsSectionTitle;

  /// No description provided for @newShiftButton.
  ///
  /// In en, this message translates to:
  /// **'New shift'**
  String get newShiftButton;

  /// No description provided for @editShiftTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit shift'**
  String get editShiftTitle;

  /// No description provided for @shiftsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No shifts yet — resources are treated as always open.'**
  String get shiftsEmpty;

  /// No description provided for @allResourcesLabel.
  ///
  /// In en, this message translates to:
  /// **'All resources'**
  String get allResourcesLabel;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @activeDowntimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Active downtime'**
  String get activeDowntimesTitle;

  /// No description provided for @activeDowntimesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No resources are currently down.'**
  String get activeDowntimesEmpty;

  /// No description provided for @downtimeHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get downtimeHistoryTitle;

  /// No description provided for @downtimeHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No downtime recorded yet.'**
  String get downtimeHistoryEmpty;

  /// No description provided for @colResource.
  ///
  /// In en, this message translates to:
  /// **'Resource'**
  String get colResource;

  /// No description provided for @fieldResource.
  ///
  /// In en, this message translates to:
  /// **'Resource'**
  String get fieldResource;

  /// No description provided for @fieldDowntimeReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get fieldDowntimeReason;

  /// No description provided for @fieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get fieldNotes;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get fieldPhone;

  /// No description provided for @fieldStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get fieldStartTime;

  /// No description provided for @fieldEndTime.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get fieldEndTime;

  /// No description provided for @startDowntimeButton.
  ///
  /// In en, this message translates to:
  /// **'Start downtime'**
  String get startDowntimeButton;

  /// No description provided for @endDowntimeButton.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endDowntimeButton;

  /// No description provided for @clientBookingWorkerLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred staff'**
  String get clientBookingWorkerLabel;

  /// No description provided for @noPreferenceOption.
  ///
  /// In en, this message translates to:
  /// **'No preference'**
  String get noPreferenceOption;

  /// No description provided for @statusBookingRejected.
  ///
  /// In en, this message translates to:
  /// **'Booking request declined: {reason}'**
  String statusBookingRejected(String reason);

  /// No description provided for @availabilityReasonUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get availabilityReasonUnknown;

  /// No description provided for @availabilityReasonOutOfSchedule.
  ///
  /// In en, this message translates to:
  /// **'Outside operating hours'**
  String get availabilityReasonOutOfSchedule;

  /// No description provided for @availabilityReasonMachineBusy.
  ///
  /// In en, this message translates to:
  /// **'Resource is down for maintenance'**
  String get availabilityReasonMachineBusy;

  /// No description provided for @availabilityReasonResourceBooked.
  ///
  /// In en, this message translates to:
  /// **'Resource is already booked'**
  String get availabilityReasonResourceBooked;

  /// No description provided for @availabilityReasonWorkerBusy.
  ///
  /// In en, this message translates to:
  /// **'Staff member is already booked'**
  String get availabilityReasonWorkerBusy;

  /// No description provided for @workerActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get workerActiveLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja', 'pt', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

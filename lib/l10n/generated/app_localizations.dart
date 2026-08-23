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
  /// **'Sign in faster next time using this device\'s fingerprint, face, or PIN. This only works on this device and browser — it\'s a local convenience, not a way to access your account elsewhere.'**
  String get passkeySetupBody;

  /// No description provided for @passkeySetupButton.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get passkeySetupButton;

  /// No description provided for @passkeyManageButton.
  ///
  /// In en, this message translates to:
  /// **'Set up passkey sign-in'**
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
  /// **'Sign in'**
  String get accountEntryTitle;

  /// No description provided for @accountEntryBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to send orders. Use passkey for quick access on this device; use Advanced options for birthday details or your recovery words on another device.'**
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
  /// **'Mobile number is for daily member access. Passkey is the fastest option on this device; keep birthday details or recovery words for access from another device.'**
  String get quickSetupWarning;

  /// No description provided for @quickSetupMobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get quickSetupMobileLabel;

  /// No description provided for @quickSetupBirthdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday (YYYY-MM-DD)'**
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

  /// No description provided for @menuFallbackCategory.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuFallbackCategory;

  /// No description provided for @clientOrderLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to place your order'**
  String get clientOrderLockedTitle;

  /// No description provided for @clientOrderUnlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your channel orders'**
  String get clientOrderUnlockedTitle;

  /// No description provided for @clientOrderLockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only account holders can create and view their own order history.'**
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

  /// No description provided for @salesWorkspaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales workspace'**
  String get salesWorkspaceTitle;

  /// No description provided for @salesWorkspaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
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
  /// **'Customers'**
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
  /// **'Create store link'**
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
  /// **'Customers'**
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
  /// **'Customers'**
  String get customersSectionTitle;

  /// No description provided for @customersSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customer directory'**
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
  /// **'Loyalty'**
  String get navLoyalty;

  /// No description provided for @loyaltySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Loyalty'**
  String get loyaltySectionTitle;

  /// No description provided for @loyaltySectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customer points and tiers'**
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
  /// **'No loyalty accounts yet.'**
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
  /// **'Table bookings and status'**
  String get bookingsSectionSubtitle;

  /// No description provided for @seedMachinesButton.
  ///
  /// In en, this message translates to:
  /// **'Load sample tables'**
  String get seedMachinesButton;

  /// No description provided for @machinesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tables yet. Load the sample tables to get started.'**
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
  /// **'Book a table'**
  String get clientBookingCardTitle;

  /// No description provided for @clientBookingMachineLabel.
  ///
  /// In en, this message translates to:
  /// **'Table'**
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

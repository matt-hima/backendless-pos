import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:js_util' as js_util;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'l10n/generated/app_localizations.dart';
import 'models/order_payload.dart';
import 'data/sample_scenarios.dart';
import 'services/api_service.dart';
import 'services/database_service.dart';
import 'services/webrtc_mock_service.dart';
import 'services/indexed_db_service.dart';
import 'services/wallet_auth_service.dart';
import 'services/wallet_crypto_service.dart';
import 'services/local_wallet_service.dart';
import 'services/merchant_link_service.dart';
import 'services/passkey_service.dart';
import 'services/channel_print_service.dart';
import 'services/backup_service.dart';
import 'services/webrtc_service.dart';
import 'services/notification_service.dart';
import 'services/device_qr_service.dart';
import 'services/google_workspace_service.dart';

void main() => runApp(const LilyGoApp());

final _supportedLocales = {
  Locale('en'): 'English',
  Locale('ja'): '日本語',
  Locale('zh', 'TW'): '繁體中文',
  Locale('pt'): 'Português',
  Locale('es'): 'Español',
};

String _localeCode(Locale locale) => locale.countryCode != null
    ? '${locale.languageCode}_${locale.countryCode}'
    : locale.languageCode;

bool _isPortalRoute() =>
    Uri.base.path == '/portal' || Uri.base.fragment == '/portal';

Locale _parseLocaleCode(String code) {
  final parts = code.split('_');
  return parts.length > 1 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
}

String orderStatusLabel(BuildContext context, int status) {
  final l = AppLocalizations.of(context);
  switch (status) {
    case 0:
      return l.orderStatusDraft;
    case 1:
      return l.orderStatusValidated;
    case 2:
      return l.orderStatusAccepted;
    case 3:
      return l.orderStatusProcessing;
    case 4:
      return l.orderStatusDelivered;
    case -1:
      return l.orderStatusCanceled;
    default:
      return l.orderStatusUnknown;
  }
}

String _roleLabel(BuildContext context, String role) {
  final l = AppLocalizations.of(context);
  switch (role) {
    case 'owner':
      return l.roleOwnerLabel;
    case 'agent':
      return l.roleAgentLabel;
    default:
      return l.roleMemberLabel;
  }
}

class LilyGoApp extends StatefulWidget {
  const LilyGoApp({super.key});
  @override
  State<LilyGoApp> createState() => _LilyGoAppState();
}

class _LilyGoAppState extends State<LilyGoApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final db = DatabaseService();
  final radio = WebRtcMockService();
  final indexedDb = IndexedDbService();
  final walletAuth = WalletAuthService();
  final walletCrypto = WalletCryptoService();
  final localWallet = LocalWalletService();
  final merchantLinks = MerchantLinkService();
  final passkey = PasskeyService();
  final channelPrint = ChannelPrintService();
  final backup = BackupService();
  final googleWorkspace = GoogleWorkspaceService();
  final webRtc = WebRtcService();
  final notifications = NotificationService();
  late final ApiService api;
  StreamSubscription<OrderPayload>? subscription;
  Timer? _rtcPollTimer;
  String status = '';
  List<Map<String, dynamic>> productRows = [];
  List<Map<String, dynamic>> customerRows = [];
  List<Map<String, dynamic>> orderRows = [];
  List<Map<String, dynamic>> clientProducts = [];
  List<Map<String, dynamic>> clientSiteContent = [];
  final Map<int, int> cart = {};
  bool databaseStarted = false;
  // Render the offline menu shell immediately; IndexedDB can hydrate it afterward.
  bool clientReady = true;
  String activeChannel = Uri.base.queryParameters['channel'] ?? 'default';
  String? walletAddress;
  int clientTransactionCount = 0;
  double clientTransactionTotal = 0;
  bool walletInitialized = false;
  int portalSection = 0;
  String walletMobile = '';
  String walletBirthday = '';
  bool rememberWalletInfo = false;
  Locale currentLocale = const Locale('en');
  String rtcStatus = 'disconnected';
  int rtcClientCount = 0;
  List<Map<String, dynamic>> clientChatMessages = [];
  final clientChatController = TextEditingController();
  List<Map<String, dynamic>> channelMembers = [];
  List<Map<String, dynamic>> serviceRooms = [];
  List<Map<String, dynamic>> activityLog = [];
  int? selectedRoomId;
  List<Map<String, dynamic>> serviceMessages = [];
  bool showActivityLog = false;
  final serviceReplyController = TextEditingController();
  List<Map<String, dynamic>> menuContentItems = [];
  List<Map<String, dynamic>> loyaltyAccounts = [];
  List<Map<String, dynamic>> machinesList = [];
  List<Map<String, dynamic>> bookingsList = [];
  List<Map<String, dynamic>> clientBookings = [];
  Set<String> myPermissions = {};
  List<Map<String, dynamic>> iamUsersList = [];
  List<Map<String, dynamic>> iamRolesList = [];
  List<Map<String, dynamic>> dbTableCounts = [];
  List<Map<String, dynamic>>? dbQueryResult;
  String? dbQueryError;
  List<Map<String, dynamic>> categoryRows = [];
  List<Map<String, dynamic>> paymentTypeRows = [];
  Map<String, dynamic>? activeRegisterSession;
  List<Map<String, dynamic>> registerSessionHistory = [];
  List<Map<String, dynamic>> posSaleRows = [];
  Map<String, String> posSettings = {};
  bool productsShowCategories = false;
  final Map<int, int> registerCart = {};
  int? registerCategoryFilter;
  bool salesAnalysisLoaded = false;
  String salesRange = 'today';
  List<Map<String, dynamic>> dailySalesRows = [];
  List<Map<String, dynamic>> salesByCategoryRows = [];
  List<Map<String, dynamic>> salesByProductRows = [];

  AppLocalizations get _l => AppLocalizations.of(navigatorKey.currentContext!);

  @override
  void initState() {
    super.initState();
    api = ApiService();
    _initializeWebRtc();
    _startClient();
    if (_isPortalRoute()) _start();
    _pollRtc();
    _rtcPollTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _pollRtc(),
    );
  }

  Future<void> _initializeWebRtc() async {
    try {
      await webRtc.initialize(portal: _isPortalRoute(), channel: activeChannel);
    } catch (error) {
      if (mounted) setState(() => status = 'Connection unavailable: $error');
    }
  }

  Future<void> _startClient() async {
    if (activeChannel != 'default') {
      merchantLinks.save(
        channel: activeChannel,
        link: '${Uri.base.origin}/?channel=$activeChannel',
      );
    }
    if (mounted)
      setState(() {
        clientProducts = [];
        clientReady = true;
      });
    try {
      await Future.any([
        indexedDb.initialize(),
        Future<void>.delayed(
          const Duration(seconds: 8),
          () => throw Exception(
            'IndexedDB initialization timed out; using local menu fallback',
          ),
        ),
      ]);
      await indexedDb.expireMemberData();
      final siteContent = await indexedDb.cmsItems('site_content');
      final savedProducts = await indexedDb.products();
      if (mounted) setState(() => clientSiteContent = siteContent);
      if (savedProducts.isNotEmpty) {
        if (mounted)
          setState(() {
            clientProducts = savedProducts;
            clientReady = true;
          });
        return;
      }
      final products = await indexedDb.products();
      final normalizedProducts = products
          .map(
            (product) => {
              ...product,
              'rowid': product['rowid'] ?? product['id'],
            },
          )
          .where((product) => product['rowid'] != null)
          .toList();
      if (mounted)
        setState(() {
          clientProducts = normalizedProducts;
          clientReady = true;
        });
    } catch (error) {
      if (mounted)
        setState(() => status = _l.statusClientStorageError(error.toString()));
    }
  }

  int _clientProductId(Map<String, dynamic> product) =>
      (product['rowid'] ?? product['id']) as int;

  String _localizedProductLabel(Map<String, dynamic> product) {
    final labels = product['labels'] as Map?;
    final code = _localeCode(currentLocale);
    return labels?[code]?.toString() ?? product['label']?.toString() ?? '';
  }

  Future<void> _start() async {
    if (databaseStarted) return;
    databaseStarted = true;
    try {
      await db.initialize();
      subscription = radio.orders.listen(_receiveOrder);
      radio.start();
      await _refresh();
      await _refreshCustomerService();
      await _refreshMenuContent();
      await _refreshLoyalty();
      await _refreshBookings();
      await _refreshIam();
      await _refreshDbManagement();
      if (mounted) setState(() => status = _l.statusReadyMessage);
    } catch (error) {
      if (mounted)
        setState(() => status = _l.statusStartupError(error.toString()));
    }
  }

  Future<void> _refresh() async {
    final data = await Future.wait([
      db.rows('''
        SELECT p.rowid, p.ref, p.label, p.price, p.tva_tx, p.stock, p.tax_included, p.updated_at,
               c.rowid AS category_id, c.label AS category_label, c.color AS category_color
        FROM erp.llx_product p
        LEFT JOIN erp.llx_categorie_product cp ON cp.fk_product = p.rowid
        LEFT JOIN erp.llx_categorie c ON c.rowid = cp.fk_categorie
        ORDER BY p.rowid DESC
      '''),
      db.rows(
        'SELECT rowid, nom, code_client, email, updated_at FROM erp.llx_societe WHERE is_merchant = false ORDER BY rowid DESC',
      ),
      db.rows(
        'SELECT c.rowid, c.ref, c.fk_statut, s.nom AS customer, p.label AS product, d.qty, d.subprice, d.total_ht, d.total_ttc FROM erp.llx_commande c JOIN erp.llx_societe s ON s.rowid = c.fk_soc JOIN erp.llx_commandedet d ON d.fk_commande = c.rowid JOIN erp.llx_product p ON p.rowid = d.fk_product ORDER BY c.rowid DESC',
      ),
      db.categories(),
      db.paymentTypes(),
      db.activeRegisterSession(),
      db.registerSessions(),
      db.settingsMap(),
      db.posSales(),
    ]);
    if (!mounted) return;
    setState(() {
      productRows = data[0] as List<Map<String, dynamic>>;
      customerRows = data[1] as List<Map<String, dynamic>>;
      orderRows = data[2] as List<Map<String, dynamic>>;
      categoryRows = data[3] as List<Map<String, dynamic>>;
      paymentTypeRows = data[4] as List<Map<String, dynamic>>;
      activeRegisterSession = data[5] as Map<String, dynamic>?;
      registerSessionHistory = data[6] as List<Map<String, dynamic>>;
      posSettings = data[7] as Map<String, String>;
      posSaleRows = data[8] as List<Map<String, dynamic>>;
    });
  }

  Future<void> _receiveOrder(OrderPayload payload) async {
    try {
      if (_isPortalRoute() && walletAddress != 'demo-mode') {
        await api.deviceAttest(payload.order['ref'].toString());
      }
      await db.upsertOrder(payload);
      final bytes = await db.exportParquet();
      if (walletAddress != 'demo-mode') await api.syncParquet(bytes);
      await _refresh();
      if (mounted)
        setState(
          () => status = _l.statusOrderSynced(
            payload.order['ref'].toString(),
            payload.lines.length,
            bytes.length,
          ),
        );
      if (_isPortalRoute()) {
        await notifications.show(
          _l.newOrderNotificationTitle,
          _l.newOrderNotificationBody(payload.order['ref'].toString()),
        );
      }
    } catch (error) {
      if (mounted)
        setState(() => status = _l.statusSyncError(error.toString()));
    }
  }

  Future<void> _setOrderStatus(int orderId, int nextStatus) async {
    await db.updateOrderStatus(orderId, nextStatus);
    await _refresh();
    final statusLabel = orderStatusLabel(
      navigatorKey.currentContext!,
      nextStatus,
    );
    await _logChannelEvent(_l.orderStatusChangedLog(orderId, statusLabel));
    if (mounted)
      setState(() => status = _l.statusOrderStatusChanged(statusLabel));
  }

  Future<void> _editProduct([Map<String, dynamic>? row]) async {
    final result = await showDialog<_ProductDraft>(
      context: navigatorKey.currentContext!,
      builder: (_) => _ProductDialog(
        row: row,
        categories: categoryRows,
        defaultTaxIncluded:
            posSettings['TAKEPOS_TAX_INCLUDED_DEFAULT'] != 'false',
        defaultTaxRate: posSettings['MAIN_TAX_STANDARD'],
      ),
    );
    if (result == null) return;
    await db.saveProduct(
      id: row?['rowid'] as int?,
      ref: result.ref,
      label: result.label,
      price: result.price,
      tax: result.tax,
      stock: result.stock,
      categoryId: result.categoryId,
      taxIncluded: result.taxIncluded,
    );
    await _logChannelEvent(
      _l.productSavedLog(result.ref, result.price.toStringAsFixed(2)),
    );
    await _refresh();
    if (mounted) setState(() => status = _l.statusProductSaved(result.ref));
  }

  Future<void> _editCategory([Map<String, dynamic>? row]) async {
    final result = await showDialog<_CategoryDraft>(
      context: navigatorKey.currentContext!,
      builder: (_) => _CategoryDialog(row: row),
    );
    if (result == null) return;
    await db.saveCategory(
      id: row?['rowid'] as int?,
      label: result.label,
      color: result.color,
    );
    await _refresh();
  }

  Future<void> _deleteCategory(int id) async {
    final l = _l;
    final confirmed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.deleteCategoryConfirmTitle),
        content: Text(l.deleteCategoryConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.deleteButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await db.deleteCategory(id);
    await _refresh();
  }

  Future<void> _editProductTranslations(Map<String, dynamic> row) async {
    final productId = row['rowid'] as int;
    final existing = await db.productLangs(productId);
    if (!mounted) return;
    await showDialog<void>(
      context: navigatorKey.currentContext!,
      builder: (_) => _ProductLangDialog(
        productId: productId,
        baseLabel: row['label']?.toString() ?? '',
        existing: existing,
      ),
    );
  }

  Future<void> _chooseSampleScenario() async {
    String? selected;
    await showDialog<void>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add sample business data'),
        content: SizedBox(
          width: 460,
          child: ListView(
            shrinkWrap: true,
            children: sampleScenarios.map((scenario) {
              final id = scenario['id'].toString();
              return ListTile(
                leading: const Icon(Icons.storefront_outlined),
                title: Text(scenario['sector'].toString()),
                subtitle: Text(scenario['platform'].toString()),
                onTap: () {
                  selected = id;
                  Navigator.pop(dialogContext);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(_l.cancelButton),
          ),
        ],
      ),
    );
    if (selected == null) return;
    final scenario = sampleScenarios.firstWhere(
      (item) => item['id'] == selected,
    );
    await _loadSampleScenario(scenario);
  }

  Future<void> _loadSampleScenario(Map<String, dynamic> scenario) async {
    final items = (scenario['items'] as List).cast<Map<String, dynamic>>();
    final imageAsset = scenario['image_asset']?.toString();
    final categoryIds = <String, int>{};
    for (final product in items) {
      final categoryLabel = product['category']?.toString();
      final categoryId = categoryLabel == null
          ? null
          : categoryIds[categoryLabel] ??= await db.ensureCategory(
              categoryLabel,
            );
      await db.saveProduct(
        id: product['id'] as int,
        ref: product['ref'] as String,
        label: product['label'] as String,
        price: (product['price'] as num).toDouble(),
        tax: (product['tva_tx'] as num).toDouble(),
        stock: (product['stock'] as num).toDouble(),
        photo: imageAsset,
        photoMime: imageAsset == null ? null : 'image/jpeg',
        categoryId: categoryId,
      );
    }
    await _refresh();
    await _saveSiteContentBatch([
      {
        'ref': 'site.title',
        'label': scenario['platform'],
        'description': scenario['sector'],
      },
      {
        'ref': 'site.welcome',
        'label': 'Online ordering',
        'description': 'Browse the latest menu and place an order online.',
      },
      {
        'ref': 'site.notice',
        'label': 'Store notice',
        'description':
            'Orders are confirmed by the store. Payment is cash on pickup.',
      },
      {
        'ref': 'site.contact',
        'label': 'Contact',
        'description': 'Contact the store for questions about your order.',
      },
      {
        'ref': 'site.hours',
        'label': 'Opening hours',
        'description': 'Mon–Sun · 10:00–20:00',
      },
      {
        'ref': 'site.privacy',
        'label': 'Privacy policy',
        'description':
            'We use your order details only to process and support your order.',
      },
      {
        'ref': 'site.terms',
        'label': 'Terms of service',
        'description': 'Please review your order before confirming checkout.',
      },
      {
        'ref': 'site.refund',
        'label': 'Refund policy',
        'description':
            'Contact the store before pickup if you need to change an order.',
      },
      {
        'ref': 'page.about',
        'label': 'About us',
        'description': 'Learn about this store and the services we provide.',
      },
      {
        'ref': 'page.contact',
        'label': 'Contact',
        'description':
            'Contact the store for order support and general questions.',
      },
      {
        'ref': 'page.privacy',
        'label': 'Privacy policy',
        'description':
            'We use customer information only to process and support orders.',
      },
      {
        'ref': 'page.terms',
        'label': 'Terms of service',
        'description':
            'Please review your order and store terms before checkout.',
      },
      {
        'ref': 'page.refund',
        'label': 'Refund policy',
        'description':
            'Contact the store before pickup if you need to change or cancel an order.',
      },
      {
        'ref': 'catalog.layout',
        'label': 'grid',
        'description': 'Product catalog layout: grid or list.',
      },
      {
        'ref': 'catalog.columns',
        'label': '2',
        'description': 'Product cards per row on wide screens.',
      },
      {
        'ref': 'catalog.sort',
        'label': 'default',
        'description': 'Product sort: default, name, price_low, or price_high.',
      },
      {
        'ref': 'catalog.show_count',
        'label': 'true',
        'description': 'Show the number of products in the catalog.',
      },
    ]);
    await _refreshMenuContent();
    await _publishCmsCollection('site_content');
    if (mounted)
      setState(() => status = 'Loaded ${scenario['sector']} sample data');
  }

  Future<void> _saveSiteContentBatch(List<Map<String, dynamic>> items) async {
    final existing = await db.cmsItems('site_content');
    for (final item in items) {
      final match = existing.cast<Map<String, dynamic>?>().firstWhere(
        (row) => row?['ref']?.toString() == item['ref']?.toString(),
        orElse: () => null,
      );
      final id = match?['rowid'];
      await db.saveCmsItem(
        id: id is num ? id.toInt() : null,
        collection: 'site_content',
        data: item,
      );
    }
  }

  Future<void> _connectWallet() async {
    try {
      // Customer checkout is intentionally mobile-first. The portal keeps
      // the injected-wallet/admin login path, while the client only asks for
      // mobile on the first order and uses FIDO automatically afterward.
      if (!_isPortalRoute()) {
        if (passkey.hasPasskey()) {
          await _signInWithPasskey();
          if (walletAddress != null) return;
        }
        await _accountEntry();
        return;
      }
      // Passkeys are the fastest local membership path. If the browser asks
      // for a different credential or the user cancels, show the normal
      // mobile-number flow instead of blocking sign-in.
      if (passkey.hasPasskey()) {
        try {
          await _signInWithPasskey();
          if (walletAddress != null) {
            await _ensurePortalAccess(walletAddress!, '');
            return;
          }
        } catch (_) {
          // Fall through to wallet or mobile sign-in.
        }
      }
      final address = await walletAuth.connect();
      if (address != null) {
        await _finishWalletLogin(address);
        await _ensurePortalAccess(address, '');
        return;
      }
      await _accountEntry();
    } catch (error) {
      if (mounted)
        setState(() => status = _l.statusAccountCanceled(error.toString()));
    }
  }

  Future<void> _accountEntry() async {
    final l = _l;
    final isPortal = _isPortalRoute();
    final mobileController = TextEditingController();
    final birthdayController = TextEditingController();
    final storeNameController = TextEditingController();
    var advanced = false;
    var enableRecoveryWords = false;
    final proceed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l.accountEntryTitle),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.accountEntryBody),
                const SizedBox(height: 16),
                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l.quickSetupMobileLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: birthdayController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: l.quickSetupBirthdayLabel,
                    helperText: l.preferencesSecurityNote,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 4),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: enableRecoveryWords,
                  onChanged: (value) => setDialogState(
                    () => enableRecoveryWords = value ?? false,
                  ),
                  title: Text(l.backupPhraseTitle),
                  subtitle: Text(l.backupPhraseBody),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                if (isPortal) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: storeNameController,
                    decoration: InputDecoration(
                      labelText: l.storeNameFieldLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(l.quickSetupWarning, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => setDialogState(() => advanced = true),
                    child: Text(l.accountAdvancedOptionsLink),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l.cancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l.continueButton),
            ),
          ],
        ),
      ),
    );
    final mobile = mobileController.text.trim();
    final birthday = birthdayController.text.trim();
    final storeName = storeNameController.text.trim();
    mobileController.dispose();
    birthdayController.dispose();
    storeNameController.dispose();
    if (proceed != true) return;
    if (advanced) {
      final action = await _walletChoice();
      if (action == 'highSecurity') await _createLocalWallet();
      if (action == 'unlock') await _unlockLocalWallet();
      if (action == 'restore') await _restoreLocalWallet();
      return;
    }
    if (mobile.isEmpty) return;
    final passphrase = 'mobile:$mobile';
    if (await localWallet.hasWallet()) {
      try {
        final address = await localWallet.unlock(passphrase);
        if (address != null) {
          await _finishWalletLogin(address, local: true);
          await _ensurePortalAccess(address, storeName);
          return;
        }
      } catch (_) {
        // Older accounts used mobile + birthday. Keep that path compatible
        // when a birthday is supplied through the advanced recovery flow.
      }
      if (mounted) setState(() => status = l.accountMismatchError);
      return;
    }
    final created = await localWallet.create(passphrase);
    final address = created['address']!.toString();
    final mnemonic = created['mnemonic']?.toString();
    if (mnemonic != null && enableRecoveryWords) {
      await _showRecoveryPhrase(mnemonic);
    }
    await _offerPasskeySetup(passphrase);
    final updated = _walletThirdParty(address);
    updated['encrypted_profile'] = await walletCrypto.encrypt({
      'phone_mobile': mobile,
      'birthday': birthday,
      'locale': _localeCode(currentLocale),
    });
    await indexedDb.saveWalletThirdParty(updated);
    if (mounted)
      setState(() {
        walletMobile = mobile;
        walletBirthday = birthday;
        rememberWalletInfo = true;
      });
    await _finishWalletLogin(address, local: true);
    await _ensurePortalAccess(address, '');
    await _ensurePortalAccess(address, storeName);
  }

  Future<void> _ensurePortalAccess(String address, String storeName) async {
    if (!_isPortalRoute()) return;
    final merchantRows = await db.rows(
      'SELECT rowid FROM erp.llx_societe WHERE is_merchant = true LIMIT 1',
    );
    final createdMerchant = merchantRows.isEmpty;
    final resolvedStoreName = storeName.trim().isEmpty
        ? _l.storeNameDefault
        : storeName.trim();
    if (createdMerchant) await db.registerMerchant(resolvedStoreName);
    await db.grantRole(address, 'owner');
    await _refreshMyPermissions();
    await _refreshIam();
    await _refresh();
    if (createdMerchant) await _autoProvisionChannel(resolvedStoreName);
  }

  Future<void> _finishWalletLogin(String address, {bool local = false}) async {
    if (!local) await walletCrypto.initialize(address);
    final thirdparty = _walletThirdParty(address);
    await indexedDb.saveWalletThirdParty(thirdparty);
    await indexedDb.saveMemberSession(
      wallet: address,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
    if (mounted)
      setState(() {
        walletAddress = address;
        walletInitialized = true;
        status = _l.statusAccountConnected(_shortWallet(address));
        if (_isPortalRoute()) {
          myPermissions = DatabaseService.permissionCatalog.toSet();
        }
      });
    await _loadClientStats();
    await _loadWalletProfile(address);
    if (_isPortalRoute()) {
      await _start();
      await _refreshMyPermissions();
      await _logChannelEvent(_l.accountConnectedLog(_shortWallet(address)));
      await _refreshCustomerService();
    }
  }

  Future<void> _refreshMyPermissions() async {
    var permissions = walletAddress == 'demo-mode'
        ? DatabaseService.permissionCatalog.toSet()
        : await db.permissionsForWallet(walletAddress!);
    // A wallet can outlive a partially initialized DuckDB session. Recover
    // the portal owner mapping before rendering an empty workspace.
    if (_isPortalRoute() &&
        walletAddress != null &&
        walletAddress != 'demo-mode' &&
        permissions.isEmpty) {
      await db.grantRole(walletAddress!, 'owner');
      permissions = await db.permissionsForWallet(walletAddress!);
      if (permissions.isEmpty) {
        // Keep a valid authenticated owner usable even when an older local
        // DuckDB snapshot has no IAM rows yet; the next refresh repairs it.
        permissions = DatabaseService.permissionCatalog.toSet();
      }
    }
    if (mounted) setState(() => myPermissions = permissions);
  }

  Future<void> _loadWalletProfile(String address) async {
    final thirdparty = await indexedDb.walletThirdParty(address.toLowerCase());
    final envelope = thirdparty?['encrypted_profile']?.toString();
    if (envelope == null || envelope == 'null' || envelope.isEmpty) return;
    try {
      final profile = await walletCrypto.decrypt(envelope);
      final localeCode = profile['locale']?.toString();
      if (mounted)
        setState(() {
          walletMobile =
              profile['phone_mobile']?.toString() ??
              profile['phone']?.toString() ??
              '';
          walletBirthday = profile['birthday']?.toString() ?? '';
          rememberWalletInfo = true;
          if (localeCode != null && localeCode.isNotEmpty)
            currentLocale = _parseLocaleCode(localeCode);
        });
    } catch (_) {
      if (mounted) setState(() => status = _l.statusProfileDecryptError);
    }
  }

  Future<void> _editPreferences() async {
    if (walletAddress == null) return;
    final l = _l;
    final mobile = TextEditingController(text: walletMobile);
    final birthday = TextEditingController(text: walletBirthday);
    var remember = rememberWalletInfo;
    var selectedLocale = currentLocale;
    final result = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l.preferencesTitle),
          content: SizedBox(
            width: 430,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.preferencesBody),
                const SizedBox(height: 16),
                TextField(
                  controller: mobile,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l.preferencesMobileLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: birthday,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: l.preferencesBirthdayLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Locale>(
                  initialValue: selectedLocale,
                  decoration: InputDecoration(
                    labelText: l.preferencesLanguageLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: _supportedLocales.entries
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                  onChanged: (locale) => setDialogState(
                    () => selectedLocale = locale ?? selectedLocale,
                  ),
                ),
                CheckboxListTile(
                  value: remember,
                  onChanged: (value) =>
                      setDialogState(() => remember = value ?? false),
                  title: Text(l.preferencesRememberCheckbox),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                Text(
                  l.preferencesSecurityNote,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _managePasskey,
                    icon: const Icon(Icons.fingerprint),
                    label: Text(l.passkeyManageButton),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l.cancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l.saveButton),
            ),
          ],
        ),
      ),
    );
    if (result != true) {
      mobile.dispose();
      birthday.dispose();
      return;
    }
    final address = walletAddress!.toLowerCase();
    final mobileValue = mobile.text.trim();
    final birthdayValue = birthday.text.trim();
    final updated = _walletThirdParty(walletAddress!);
    if (remember) {
      updated['encrypted_profile'] = await walletCrypto.encrypt({
        'phone_mobile': mobileValue,
        'birthday': birthdayValue,
        'locale': _localeCode(selectedLocale),
      });
    } else {
      updated['encrypted_profile'] = null;
    }
    await indexedDb.saveWalletThirdParty(updated);
    mobile.dispose();
    birthday.dispose();
    if (mounted)
      setState(() {
        walletMobile = remember ? mobileValue : '';
        walletBirthday = remember ? birthdayValue : '';
        rememberWalletInfo = remember;
        currentLocale = selectedLocale;
        status = remember
            ? l.statusProfileSaved(_shortWallet(address))
            : l.statusProfileRemoved;
      });
  }

  Future<String?> _walletChoice() {
    final l = _l;
    return showDialog<String>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.accountChoiceTitle),
        content: Text(l.accountChoiceBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, 'unlock'),
            child: Text(l.accountUnlockButton),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(dialogContext, 'highSecurity'),
            child: Text(l.accountHighSecurityButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, 'restore'),
            child: Text(l.accountRestoreButton),
          ),
        ],
      ),
    );
  }

  Future<void> _createLocalWallet() async {
    final l = _l;
    final passphrase = await _passphraseDialog(
      l.createPassphraseTitle,
      l.createPassphraseHint,
    );
    if (passphrase == null) return;
    final confirm = await _passphraseDialog(
      l.confirmPassphraseTitle,
      l.confirmPassphraseHint,
    );
    if (confirm != passphrase) {
      if (mounted) setState(() => status = l.passphraseMismatchMessage);
      return;
    }
    final created = await localWallet.create(passphrase);
    final address = created['address']!.toString();
    final mnemonic = created['mnemonic']?.toString();
    if (mnemonic == null || !await _showRecoveryPhrase(mnemonic)) return;
    await _finishWalletLogin(address, local: true);
  }

  Future<void> _unlockLocalWallet() async {
    final l = _l;
    if (!await localWallet.hasWallet()) {
      if (mounted) setState(() => status = l.noAccountFoundMessage);
      return;
    }
    final passphrase = await _passphraseDialog(l.unlockTitle, l.unlockHint);
    if (passphrase == null) return;
    final address = await localWallet.unlock(passphrase);
    if (address == null) throw Exception(l.noAccountFoundMessage);
    await _finishWalletLogin(address, local: true);
    await _ensurePortalAccess(address, '');
  }

  Future<void> _restoreLocalWallet() async {
    final mnemonic = await _recoveryPhraseDialog();
    if (mnemonic == null) return;
    final l = _l;
    final passphrase = await _passphraseDialog(
      l.setPassphraseTitle,
      l.setPassphraseHint,
    );
    if (passphrase == null) return;
    final address = await localWallet.restore(mnemonic, passphrase);
    await _finishWalletLogin(address, local: true);
    await _ensurePortalAccess(address, '');
  }

  Future<bool> _showRecoveryPhrase(
    String phrase, {
    bool mandatory = true,
  }) async {
    var confirmed = false;
    final l = _l;
    return await showDialog<bool>(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (dialogContext) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              title: Text(l.backupPhraseTitle),
              content: SizedBox(
                width: 460,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l.backupPhraseBody),
                    const SizedBox(height: 16),
                    SelectableText(
                      phrase,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    CheckboxListTile(
                      value: confirmed,
                      onChanged: (value) =>
                          setDialogState(() => confirmed = value ?? false),
                      title: Text(l.backupPhraseConfirmCheckbox),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                ),
              ),
              actions: [
                FilledButton(
                  onPressed: (!mandatory || confirmed)
                      ? () => Navigator.pop(dialogContext, true)
                      : null,
                  child: Text(l.continueButton),
                ),
              ],
            ),
          ),
        ) ??
        false;
  }

  Future<void> _managePasskey() async {
    final l = _l;
    final passphrase = await _passphraseDialog(l.unlockTitle, l.unlockHint);
    if (passphrase == null) return;
    try {
      final address = await localWallet.unlock(passphrase);
      if (address == null ||
          address.toLowerCase() != walletAddress?.toLowerCase()) {
        if (mounted) setState(() => status = l.accountMismatchError);
        return;
      }
    } catch (_) {
      if (mounted) setState(() => status = l.accountMismatchError);
      return;
    }
    await _offerPasskeySetup(passphrase);
  }

  Future<void> _offerPasskeySetup(String passphrase) async {
    final l = _l;
    final setUp = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.passkeySetupTitle),
        content: Text(l.passkeySetupBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.skipButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.passkeySetupButton),
          ),
        ],
      ),
    );
    if (setUp != true) return;
    try {
      await passkey.enroll(passphrase).timeout(const Duration(seconds: 30));
      if (mounted) setState(() => status = l.statusPasskeyEnrolled);
    } catch (error) {
      if (mounted)
        setState(() => status = l.passkeyUnsupportedError(error.toString()));
    }
  }

  Future<String?> _recoveryPhraseDialog() async {
    final controller = TextEditingController();
    final l = _l;
    final result = await showDialog<String>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.restoreTitle),
        content: TextField(
          controller: controller,
          maxLines: 3,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l.restorePhraseFieldLabel,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: Text(l.restoreButton),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  Future<String?> _passphraseDialog(String title, String hint) async {
    final controller = TextEditingController();
    final l = _l;
    final result = await showDialog<String>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          decoration: InputDecoration(
            labelText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: Text(l.continueButton),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  Map<String, dynamic> _walletThirdParty(String address) {
    final normalized = address.toLowerCase();
    final id = int.parse(normalized.substring(2, 10), radix: 16);
    return {
      'rowid': id,
      'wallet': normalized,
      'nom': 'Account ${_shortWallet(address)}',
      'code_client': 'ACCT-${normalized.substring(2, 8).toUpperCase()}',
      'email': 'account@local.invalid',
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  Future<void> _loadClientStats() async {
    final wallet = walletAddress;
    if (wallet == null || !walletInitialized) return;
    try {
      final records = await indexedDb.encryptedTransactions(
        channel: activeChannel,
        wallet: wallet,
      );
      var total = 0.0;
      for (final record in records) {
        final payload = await walletCrypto.decrypt(
          record['encrypted_payload'].toString(),
        );
        total += (payload['total_ttc'] as num?)?.toDouble() ?? 0;
      }
      if (mounted)
        setState(() {
          clientTransactionCount = records.length;
          clientTransactionTotal = total;
        });
    } catch (error) {
      if (mounted)
        setState(
          () => status = _l.statusTransactionReadFailed(error.toString()),
        );
    }
  }

  Future<void> _itemDetail(Map<String, dynamic> product) async {
    final productId = _clientProductId(product);
    var quantity = cart[productId] ?? 1;
    final l = _l;
    final selected = await showDialog<int>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(_localizedProductLabel(product)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(product['description']?.toString() ?? ''),
              const SizedBox(height: 16),
              Text(
                'NT\$${_number(product['price'])}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => setDialogState(() {
                      if (quantity > 0) quantity--;
                    }),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '$quantity',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => setDialogState(() => quantity++),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l.cancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, quantity),
              child: Text(l.clientOrderConfirmButton),
            ),
          ],
        ),
      ),
    );
    if (selected == null) return;
    setState(() {
      if (selected == 0) {
        cart.remove(productId);
      } else {
        cart[productId] = selected;
      }
    });
  }

  Future<void> _submitClientOrder() async {
    final lines = <Map<String, dynamic>>[];
    var total = 0.0;
    for (final product in clientProducts) {
      final id = _clientProductId(product);
      final quantity = cart[id] ?? 0;
      if (quantity == 0) continue;
      final lineTotal = (product['price'] as num).toDouble() * quantity;
      total += lineTotal;
      lines.add({
        'rowid': DateTime.now().millisecondsSinceEpoch + lines.length,
        'fk_commande': DateTime.now().millisecondsSinceEpoch,
        'fk_product': id,
        'product': product,
        'qty': quantity,
        'subprice': product['price'],
        'total_ht': lineTotal,
        'total_ttc': lineTotal * 1.05,
      });
    }
    if (lines.isEmpty) return;
    if (!await _confirmClientInvoice(lines, total)) return;
    if (walletAddress == null) await _connectWallet();
    if (walletAddress == null) return;
    final transactionId = DateTime.now().millisecondsSinceEpoch;
    for (final line in lines) {
      line['fk_commande'] = transactionId;
    }
    final member = _walletThirdParty(walletAddress!);
    final firstProduct = Map<String, dynamic>.from(
      lines.first['product'] as Map,
    );
    final payload = {
      'channel': activeChannel,
      'wallet': walletAddress,
      'payment_method': 'cash',
      'contact': {'id': transactionId + 1, 'firstname': '', 'lastname': ''},
      'order': {
        'id': transactionId,
        'ref': 'WEB-$transactionId',
        'total_ht': total,
        'total_ttc': total * 1.05,
      },
      'thirdparty': {
        'id': member['rowid'],
        'name': member['nom'],
        'code': member['code_client'],
        'email': member['email'],
      },
      'product': firstProduct,
      'total_ttc': total * 1.05,
      'lines': lines,
      'created_at': DateTime.now().toIso8601String(),
    };
    final encryptedPayload = await walletCrypto.encrypt(payload);
    await indexedDb.saveEncryptedTransaction(
      id: transactionId,
      channel: activeChannel,
      wallet: walletAddress!,
      encryptedPayload: encryptedPayload,
    );
    await _loadClientStats();
    _sendRtcMessage({'type': 'client_order', 'payload': payload});
    _sendRtcMessage({
      'type': 'loyalty_earn',
      'wallet': walletAddress,
      'points': (total * 1.05 / 100).round(),
      'reason': 'Order WEB-$transactionId',
    });
    final l = _l;
    if (mounted)
      setState(() {
        cart.clear();
        status = l.statusOrderSaved('WEB-$transactionId');
      });
    if (mounted)
      ScaffoldMessenger.of(
        navigatorKey.currentContext!,
      ).showSnackBar(SnackBar(content: Text(l.orderSavedSnackbar)));
  }

  Future<bool> _confirmClientInvoice(
    List<Map<String, dynamic>> lines,
    double total,
  ) async {
    final l = _l;
    final result = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.checkoutInvoiceTitle),
        content: SizedBox(
          width: 430,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...lines.map((line) {
                final product = line['product'] as Map;
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('${product['label']} × ${line['qty']}'),
                  trailing: Text('NT\$${_number(line['total_ttc'])}'),
                );
              }),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.totalTtcLabel(_number(total * 1.05)),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    l.cashPaymentLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: 'cash',
                decoration: InputDecoration(labelText: l.paymentMethodLabel),
                items: [
                  DropdownMenuItem(
                    value: 'cash',
                    child: Text(l.cashPaymentLabel),
                  ),
                ],
                onChanged: null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.continueButton),
          ),
        ],
      ),
    );
    return result == true;
  }

  String _shortWallet(String address) => address.length > 12
      ? '${address.substring(0, 6)}…${address.substring(address.length - 4)}'
      : address;

  Future<void> _createChannel() async {
    final l = _l;
    final nameController = TextEditingController();
    final name = await showDialog<String>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.createChannelButton),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: l.channelNameFieldLabel,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, nameController.text),
            child: Text(l.createButton),
          ),
        ],
      ),
    );
    nameController.dispose();
    if (name == null) return;
    await _provisionChannel(name);
  }

  Future<void> _autoProvisionChannel(String storeName) async {
    final name = storeName.trim().isEmpty
        ? _l.storeNameDefault
        : storeName.trim();
    await _provisionChannel(name);
  }

  Future<void> _provisionChannel(String name) async {
    final l = _l;
    final merchantRows = await db.rows(
      'SELECT rowid, nom FROM erp.llx_societe WHERE is_merchant = true ORDER BY rowid LIMIT 1',
    );
    final merchantId = merchantRows.isEmpty
        ? null
        : merchantRows.first['rowid']?.toString();
    final channel = await indexedDb.createChannel(name, merchantId: merchantId);
    final code = channel['code'].toString();
    activeChannel = code;
    await webRtc.initialize(portal: true, channel: code);
    final roomId = await db.ensureChannelRoom(code);
    if (walletAddress != null) {
      await db.addSubscription(roomId, walletAddress!, role: 'owner');
    }
    await _logChannelEvent(l.channelCreatedLog(code, name), channelCode: code);
    final link = '${Uri.base.origin}/?channel=$code';
    final qrPng = await _channelQrPng(link);
    if (!mounted) return;
    showDialog<void>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.channelReadyTitle(code)),
        content: SizedBox(
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(qrPng, width: 220, height: 220),
              const SizedBox(height: 16),
              SelectableText(link, textAlign: TextAlign.center),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.closeButton),
          ),
          FilledButton.icon(
            onPressed: () =>
                channelPrint.open(_channelPrintHtml(code, link, qrPng)),
            icon: const Icon(Icons.print_outlined),
            label: Text(l.printButton),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _channelQrPng(String data) async {
    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: true,
    );
    final image = await painter.toImageData(600);
    return image!.buffer.asUint8List();
  }

  String _channelPrintHtml(String code, String link, Uint8List qrPng) {
    final qrBase64 = base64Encode(qrPng);
    return '''<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Channel $code</title>
<style>
  @page { margin: 10mm; }
  html, body { height: 100%; margin: 0; }
  body {
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    font-family: -apple-system, "Segoe UI", Roboto, sans-serif; text-align: center;
  }
  h1 { font-size: clamp(20px, 6vmin, 56px); margin: 0 0 4vmin; }
  img { width: min(70vmin, 500px); height: auto; }
  p { font-size: clamp(11px, 2.4vmin, 20px); word-break: break-all; margin-top: 4vmin; color: #333; max-width: 90vmin; }
</style>
</head>
<body>
  <h1>Channel $code</h1>
  <img src="data:image/png;base64,$qrBase64" alt="Channel QR code">
  <p>$link</p>
  <script>window.onload = function () { window.print(); };</script>
</body>
</html>''';
  }

  Future<void> _logChannelEvent(String message, {String? channelCode}) async {
    final roomId = await db.ensureChannelRoom(channelCode ?? activeChannel);
    await db.insertMessage(
      roomId: roomId,
      wallet: walletAddress,
      type: 'system',
      body: message,
    );
  }

  Future<void> _joinChannelAsAgent() async {
    if (walletAddress == null) return;
    final roomId = await db.ensureChannelRoom(activeChannel);
    await db.addSubscription(roomId, walletAddress!, role: 'agent');
    await db.insertMessage(
      roomId: roomId,
      wallet: walletAddress,
      type: 'system',
      body: _l.agentJoinedLog(_shortWallet(walletAddress!), activeChannel),
    );
    await _refreshCustomerService();
  }

  Future<void> _refreshCustomerService() async {
    final roomId = await db.ensureChannelRoom(activeChannel);
    final members = await db.subscriptions(roomId);
    final rooms = await db.livechatRooms(activeChannel);
    final log = await db.messages(roomId, type: 'system');
    final selected = selectedRoomId;
    final msgs = selected != null
        ? await db.messages(selected)
        : <Map<String, dynamic>>[];
    if (mounted)
      setState(() {
        channelMembers = members;
        serviceRooms = rooms;
        activityLog = log;
        serviceMessages = msgs;
      });
  }

  Future<void> _refreshMenuContent() async {
    final items = await db.cmsItems('site_content');
    if (mounted) setState(() => menuContentItems = items);
  }

  Future<void> _editMenuContentItem([Map<String, dynamic>? row]) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: navigatorKey.currentContext!,
      builder: (_) => _CmsItemDialog(row: row),
    );
    if (result == null) return;
    await db.saveCmsItem(
      id: row?['rowid'] as int?,
      collection: 'site_content',
      data: result,
    );
    await _refreshMenuContent();
  }

  Future<void> _refreshBookings() async {
    final machines = await db.machines();
    final bookings = await db.bookings();
    if (mounted)
      setState(() {
        machinesList = machines;
        bookingsList = bookings;
      });
    _sendRtcMessage({'type': 'booking_machines', 'machines': machines});
  }

  Future<void> _seedMachines() async {
    await db.seedMachines(4);
    await _refreshBookings();
  }

  Future<void> _setMachineStateAction(int id, String state) async {
    await db.setMachineState(id, state);
    await _refreshBookings();
  }

  Future<void> _updateBookingStatusAction(int id, String status) async {
    await db.updateBookingStatus(id, status);
    await _refreshBookings();
    final booking = bookingsList.firstWhere(
      (b) => b['id'] == id,
      orElse: () => {},
    );
    final wallet = booking['customer_wallet']?.toString();
    if (wallet != null && wallet.isNotEmpty) {
      _sendRtcMessage({
        'type': 'booking_status',
        'id': id,
        'status': status,
        'machineId': booking['machine_id'],
        'partySize': booking['party_size'],
        'start': booking['scheduled_start']?.toString(),
        'end': booking['scheduled_end']?.toString(),
      });
    }
  }

  Future<void> _refreshIam() async {
    final users = await db.iamUsers();
    final roles = await db.roles();
    if (mounted)
      setState(() {
        iamUsersList = users;
        iamRolesList = roles;
      });
  }

  Future<void> _refreshDbManagement() async {
    final counts = await db.tableCounts();
    if (mounted) setState(() => dbTableCounts = counts);
  }

  Future<void> _clearDbTable(String table) async {
    final l = _l;
    final confirmed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.clearTableConfirmTitle(table)),
        content: Text(l.clearTableConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.clearTableButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await db.clearTable(table);
    await _refreshDbManagement();
  }

  Future<void> _runDbQuery(String sql) async {
    final trimmed = sql.trim();
    if (trimmed.isEmpty) return;
    try {
      if (RegExp(r'^select', caseSensitive: false).hasMatch(trimmed)) {
        final result = await db.rows(trimmed);
        if (mounted)
          setState(() {
            dbQueryResult = result;
            dbQueryError = null;
          });
      } else {
        await db.execute(trimmed);
        if (mounted)
          setState(() {
            dbQueryResult = null;
            dbQueryError = null;
          });
        await _refreshDbManagement();
        if (mounted) setState(() => status = _l.statusQueryExecuted);
      }
    } catch (error) {
      if (mounted)
        setState(() {
          dbQueryResult = null;
          dbQueryError = error.toString();
        });
    }
  }

  Future<void> _addIamMember() async {
    final l = _l;
    final walletController = TextEditingController();
    var selectedRole = iamRolesList.isNotEmpty
        ? iamRolesList.first['id'].toString()
        : null;
    final proceed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l.addMemberButton),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: walletController,
                  decoration: InputDecoration(
                    labelText: l.walletAddressFieldLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  decoration: InputDecoration(
                    labelText: l.roleFieldLabel,
                    border: const OutlineInputBorder(),
                  ),
                  items: iamRolesList
                      .map(
                        (r) => DropdownMenuItem(
                          value: r['id'].toString(),
                          child: Text(r['name'].toString()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedRole = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l.cancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l.addMemberButton),
            ),
          ],
        ),
      ),
    );
    final wallet = walletController.text.trim();
    walletController.dispose();
    if (proceed != true || wallet.isEmpty || selectedRole == null) return;
    await db.grantRole(wallet, selectedRole!);
    await _refreshIam();
    if (mounted) setState(() => status = l.statusRoleGranted);
  }

  Future<void> _changeRole(
    String wallet,
    String? currentRoleId,
    String newRoleId,
  ) async {
    if (currentRoleId != null) await db.revokeRole(wallet, currentRoleId);
    await db.grantRole(wallet, newRoleId);
    await _refreshIam();
    if (mounted) setState(() => status = _l.statusRoleGranted);
  }

  Future<void> _removeMember(String wallet, String? roleId) async {
    if (roleId != null) await db.revokeRole(wallet, roleId);
    await _refreshIam();
    if (mounted) setState(() => status = _l.statusRoleRevoked);
  }

  Future<void> _createOrEditRole([Map<String, dynamic>? role]) async {
    final l = _l;
    final nameController = TextEditingController(
      text: role?['name']?.toString(),
    );
    final existingPermissions = Set<String>.from(
      (role?['permissions'] as List?) ?? const [],
    );
    final selected = {
      for (final p in DatabaseService.permissionCatalog)
        p: existingPermissions.contains(p),
    };
    final proceed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l.newRoleButton),
          content: SizedBox(
            width: 380,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    enabled: role == null,
                    decoration: InputDecoration(
                      labelText: l.roleNameFieldLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...DatabaseService.permissionCatalog.map(
                    (permission) => CheckboxListTile(
                      value: selected[permission],
                      onChanged: (value) => setDialogState(
                        () => selected[permission] = value ?? false,
                      ),
                      title: Text(permission),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l.cancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l.saveButton),
            ),
          ],
        ),
      ),
    );
    final name = nameController.text.trim();
    nameController.dispose();
    if (proceed != true) return;
    final permissions = selected.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    if (role == null) {
      if (name.isEmpty) return;
      await db.createRole(name, permissions);
    } else {
      await db.updateRolePermissions(role['id'].toString(), permissions);
    }
    await _refreshIam();
  }

  Future<void> _refreshLoyalty() async {
    final accounts = await db.loyaltyAccounts();
    if (mounted) setState(() => loyaltyAccounts = accounts);
  }

  Future<void> _adjustPoints(Map<String, dynamic> account) async {
    final l = _l;
    final wallet = account['contact_wallet'].toString();
    final pointsController = TextEditingController();
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.adjustPointsTitle),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pointsController,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                ),
                decoration: InputDecoration(
                  labelText: l.pointsFieldLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: l.reasonFieldLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.saveButton),
          ),
        ],
      ),
    );
    final points = int.tryParse(pointsController.text.trim()) ?? 0;
    final reason = reasonController.text.trim();
    pointsController.dispose();
    reasonController.dispose();
    if (confirmed != true || points == 0) return;
    if (points > 0) {
      await db.earnPoints(wallet, points, reason);
    } else {
      await db.redeemPoints(wallet, -points, reason);
    }
    await _refreshLoyalty();
    if (mounted) setState(() => status = l.statusPointsAdjusted);
  }

  Future<void> _resetAllData() async {
    final l = _l;
    final confirmed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.resetConfirmTitle),
        content: Text(l.resetConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.resetDataButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await db.resetAll();
    await indexedDb.resetAll();
    await _refresh();
    await _refreshCustomerService();
    await _refreshMenuContent();
    await _refreshLoyalty();
    if (mounted) setState(() => status = l.statusDataReset);
  }

  Future<void> _selectServiceRoom(int roomId) async {
    final msgs = await db.messages(roomId);
    if (mounted)
      setState(() {
        selectedRoomId = roomId;
        serviceMessages = msgs;
      });
  }

  Future<void> _sendServiceReply() async {
    final text = serviceReplyController.text.trim();
    final roomId = selectedRoomId;
    if (text.isEmpty || roomId == null) return;
    final room = serviceRooms.firstWhere((r) => r['rowid'] == roomId);
    final visitorWallet = room['visitor_wallet'].toString();
    await db.insertMessage(
      roomId: roomId,
      wallet: walletAddress,
      type: 'msg',
      body: text,
    );
    _sendRtcMessage({
      'type': 'chat',
      'channel': activeChannel,
      'wallet': visitorWallet,
      'sender': 'staff',
      'body': text,
      'ts': DateTime.now().toIso8601String(),
    });
    serviceReplyController.clear();
    await _selectServiceRoom(roomId);
    await _refreshCustomerService();
  }

  Future<void> _loadClientChat() async {
    final wallet = walletAddress;
    if (wallet == null) return;
    final msgs = await indexedDb.livechatMessages(
      channel: activeChannel,
      wallet: wallet,
    );
    if (mounted) setState(() => clientChatMessages = msgs);
  }

  Future<void> _sendClientChatMessage() async {
    final text = clientChatController.text.trim();
    if (text.isEmpty || walletAddress == null) return;
    final id = DateTime.now().millisecondsSinceEpoch;
    await indexedDb.saveLivechatMessage(
      id: id,
      channel: activeChannel,
      wallet: walletAddress!,
      direction: 'out',
      body: text,
    );
    _sendRtcMessage({
      'type': 'chat',
      'channel': activeChannel,
      'wallet': walletAddress,
      'sender': 'customer',
      'body': text,
      'clientMsgId': id,
      'ts': DateTime.now().toIso8601String(),
    });
    clientChatController.clear();
    await _loadClientChat();
  }

  Future<void> _openMemberZone() async {
    if (walletAddress == null) {
      await _connectWallet();
      return;
    }
    final l = _l;
    await showModalBottomSheet<void>(
      context: navigatorKey.currentContext!,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l.memberZoneTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contact_page_outlined),
              title: Text(l.preferencesButton),
              onTap: () {
                Navigator.pop(sheetContext);
                _editPreferences();
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: Text(l.chatTooltip),
              onTap: () {
                Navigator.pop(sheetContext);
                _openClientChat();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _openClientChat() async {
    if (walletAddress == null) await _connectWallet();
    if (walletAddress == null) return;
    await _loadClientChat();
    if (!mounted) return;
    final l = _l;
    await showModalBottomSheet<void>(
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: SizedBox(
          height: 480,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  l.chatWithSupportTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: clientChatMessages
                      .map(
                        (m) => Align(
                          alignment: m['direction'] == 'out'
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: m['direction'] == 'out'
                                  ? Theme.of(
                                      sheetContext,
                                    ).colorScheme.primaryContainer
                                  : Theme.of(
                                      sheetContext,
                                    ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(m['body'].toString()),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: clientChatController,
                        decoration: InputDecoration(
                          hintText: l.messageSupportHint,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _sendClientChatMessage,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportBackup() async {
    final envelope = await _backupEnvelope();
    await backup.download(
      'store-backup-${DateTime.now().millisecondsSinceEpoch}.json',
      jsonEncode(envelope),
    );
    if (mounted) setState(() => status = _l.statusBackupDownloaded);
  }

  Future<Map<String, dynamic>> _backupEnvelope() async {
    return {
      'version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'duckdb': await db.dumpAll(),
      'indexeddb': await indexedDb.dumpAll(),
    };
  }

  Future<void> _restoreEnvelope(Map<String, dynamic> envelope) async {
    await db.restoreAll(Map<String, dynamic>.from(envelope['duckdb'] as Map));
    await indexedDb.restoreAll(
      Map<String, dynamic>.from(envelope['indexeddb'] as Map),
    );
    await _refresh();
    await _refreshCustomerService();
  }

  Future<void> _importBackup() async {
    final l = _l;
    final confirmed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.restoreConfirmTitle),
        content: Text(l.restoreConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.restoreButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final raw = await backup.pickJsonFile();
      final envelope = jsonDecode(raw) as Map<String, dynamic>;
      await _restoreEnvelope(envelope);
      if (mounted) setState(() => status = l.statusBackupRestored);
    } catch (error) {
      if (mounted)
        setState(() => status = l.statusRestoreFailed(error.toString()));
    }
  }

  Future<bool> _googleWorkspaceReady() async {
    if (googleWorkspace.configured) return true;
    if (mounted) setState(() => status = _l.googleWorkspaceClientMissing);
    return false;
  }

  Future<void> _backupToGoogleDrive() async {
    if (!await _googleWorkspaceReady()) return;
    try {
      await googleWorkspace.saveDriveBackup(
        'lilygo-erp-backup.json',
        await _backupEnvelope(),
      );
      if (mounted) setState(() => status = _l.googleWorkspaceBackupDone);
    } catch (error) {
      if (mounted)
        setState(() => status = _l.statusRestoreFailed(error.toString()));
    }
  }

  Future<void> _restoreFromGoogleDrive() async {
    if (!await _googleWorkspaceReady()) return;
    final confirmed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(_l.restoreConfirmTitle),
        content: Text(_l.restoreConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(_l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(_l.restoreButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _restoreEnvelope(
        await googleWorkspace.restoreDriveBackup('lilygo-erp-backup.json'),
      );
      if (mounted) setState(() => status = _l.googleWorkspaceRestoreDone);
    } catch (error) {
      if (mounted)
        setState(() => status = _l.statusRestoreFailed(error.toString()));
    }
  }

  Future<void> _exportToGoogleSheet() async {
    if (!await _googleWorkspaceReady()) return;
    try {
      final url = await googleWorkspace.exportSheet(
        'LilyGO ERP Data ${DateTime.now().toIso8601String().substring(0, 10)}',
        await _backupEnvelope(),
      );
      if (mounted) setState(() => status = _l.googleWorkspaceSheetDone(url));
    } catch (error) {
      if (mounted)
        setState(() => status = _l.statusRestoreFailed(error.toString()));
    }
  }

  Future<void> _importFromGoogleSheet() async {
    if (!await _googleWorkspaceReady()) return;
    final controller = TextEditingController();
    final value = await showDialog<String>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(_l.googleSheetImportTooltip),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: _l.googleWorkspaceSheetIdLabel,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(_l.cancelButton),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(_l.continueButton),
          ),
        ],
      ),
    );
    final input = value?.trim() ?? '';
    controller.dispose();
    if (input.isEmpty) return;
    final match = RegExp(r'/spreadsheets/d/([a-zA-Z0-9_-]+)').firstMatch(input);
    final spreadsheetId = match?.group(1) ?? input;
    try {
      await _restoreEnvelope(await googleWorkspace.importSheet(spreadsheetId));
      if (mounted) setState(() => status = _l.googleWorkspaceSheetImportDone);
    } catch (error) {
      if (mounted)
        setState(() => status = _l.statusRestoreFailed(error.toString()));
    }
  }

  Widget _connectionChip({VoidCallback? onTap}) {
    final l = _l;
    final color = rtcStatus == 'connected'
        ? Colors.green
        : rtcStatus == 'stale'
        ? Colors.amber
        : rtcStatus == 'open'
        ? Colors.blue
        : rtcStatus == 'connecting'
        ? Colors.blueGrey
        : Colors.grey;
    final label = rtcStatus == 'connected'
        ? _isPortalRoute()
              ? '${l.connectionConnected} · $rtcClientCount ${rtcClientCount == 1 ? 'client' : 'clients'}'
              : l.connectionConnected
        : rtcStatus == 'stale'
        ? l.connectionReconnectNeeded
        : rtcStatus == 'connecting'
        ? l.connectionConnecting
        : rtcStatus == 'open'
        ? _isPortalRoute()
              ? 'Open · $rtcClientCount clients'
              : l.connectionConnecting
        : l.connectionNotConnected;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: onTap != null
          ? ActionChip(
              avatar: Icon(Icons.circle, size: 12, color: color),
              label: Text(label),
              onPressed: onTap,
            )
          : Chip(
              avatar: Icon(Icons.circle, size: 12, color: color),
              label: Text(label),
            ),
    );
  }

  Widget _languageSwitcher() => PopupMenuButton<Locale>(
    icon: const Icon(Icons.translate),
    tooltip: _l.preferencesLanguageLabel,
    onSelected: (locale) => setState(() => currentLocale = locale),
    itemBuilder: (_) => _supportedLocales.entries
        .map((e) => PopupMenuItem(value: e.key, child: Text(e.value)))
        .toList(),
  );

  @override
  void dispose() {
    subscription?.cancel();
    _rtcPollTimer?.cancel();
    clientChatController.dispose();
    serviceReplyController.dispose();
    radio.dispose();
    super.dispose();
  }

  Future<void> _pollRtc() async {
    final nextStatus = webRtc.status();
    final nextClientCount = webRtc.connectionCount();
    if (mounted &&
        (nextStatus != rtcStatus || nextClientCount != rtcClientCount)) {
      setState(() {
        rtcStatus = nextStatus;
        rtcClientCount = nextClientCount;
      });
    }
    for (final raw in webRtc.drainMessages()) {
      await _handleRtcMessage(raw);
    }
  }

  Future<void> _handleRtcMessage(String raw) async {
    Map<String, dynamic> envelope;
    try {
      envelope = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return;
    }
    final type = envelope['type'];
    if (type == 'client_ready') {
      if (_isPortalRoute()) {
        await _sendClientMenuSnapshot(envelope['__peer_id']?.toString() ?? '');
      }
      return;
    }
    if (type == 'product_sync') {
      if (_isPortalRoute()) return;
      final products = (envelope['products'] as List? ?? const [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
      await indexedDb.saveProducts(products);
      if (mounted) setState(() => clientProducts = products);
      return;
    }
    if (type == 'cms_sync') {
      if (_isPortalRoute()) return;
      final collection = envelope['collection']?.toString() ?? 'site_content';
      final items = (envelope['items'] as List? ?? const [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
      await indexedDb.saveCmsItems(collection: collection, items: items);
      if (collection == 'site_content') {
        if (mounted) setState(() => clientSiteContent = items);
      }
      return;
    }
    if (type == 'loyalty_earn') {
      if (!_isPortalRoute()) return;
      final wallet = envelope['wallet']?.toString();
      final points = (envelope['points'] as num?)?.toInt() ?? 0;
      final reason = envelope['reason']?.toString() ?? '';
      if (wallet != null && points > 0) {
        await db.earnPoints(wallet, points, reason);
        await _refreshLoyalty();
      }
      return;
    }
    if (type == 'client_order') {
      if (!_isPortalRoute()) return;
      final payload = envelope['payload'];
      if (payload is! Map) return;
      try {
        final order = OrderPayload.fromJson(Map<String, dynamic>.from(payload));
        await _receiveOrder(order);
        _sendRtcMessage({
          'type': 'client_order_ack',
          'ref': order.order['ref'],
          'status': 'stored',
          '__target_peer_id': envelope['__peer_id'],
        });
      } catch (error) {
        if (mounted)
          setState(() => status = _l.statusSyncError(error.toString()));
      }
      return;
    }
    if (type == 'client_order_ack') {
      if (_isPortalRoute()) return;
      if (mounted) setState(() => status = _l.orderSavedSnackbar);
      return;
    }
    if (type == 'booking_request') {
      if (!_isPortalRoute()) return;
      final machineId = (envelope['machineId'] as num?)?.toInt();
      final wallet = envelope['wallet']?.toString();
      final partySize = (envelope['partySize'] as num?)?.toInt() ?? 1;
      final start = DateTime.tryParse(envelope['start']?.toString() ?? '');
      final end = DateTime.tryParse(envelope['end']?.toString() ?? '');
      if (machineId == null || wallet == null || start == null || end == null)
        return;
      if (await db.hasOverlap(machineId, start, end)) return;
      final id = await db.createBooking(
        machineId: machineId,
        customerWallet: wallet,
        partySize: partySize,
        start: start,
        end: end,
      );
      await _refreshBookings();
      _sendRtcMessage({
        'type': 'booking_status',
        'id': id,
        'status': 'planned',
        'machineId': machineId,
        'partySize': partySize,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
      });
      return;
    }
    if (type == 'booking_machines') {
      if (_isPortalRoute()) return;
      final machines = (envelope['machines'] as List? ?? const [])
          .map((m) => Map<String, dynamic>.from(m as Map))
          .toList();
      if (mounted) setState(() => machinesList = machines);
      return;
    }
    if (type == 'booking_status') {
      if (_isPortalRoute()) return;
      final id = (envelope['id'] as num?)?.toInt();
      final status = envelope['status']?.toString();
      if (id == null || status == null) return;
      await indexedDb.saveBooking({...envelope, 'id': id, 'status': status});
      final synced = await indexedDb.bookings();
      if (mounted) setState(() => clientBookings = synced);
      return;
    }
    if (type != 'chat') return;
    final channel = envelope['channel']?.toString() ?? activeChannel;
    final wallet = envelope['wallet']?.toString() ?? '';
    final body = envelope['body']?.toString() ?? '';
    if (_isPortalRoute()) {
      final roomId = await db.ensureLivechatRoom(channel, wallet);
      await db.insertMessage(
        roomId: roomId,
        wallet: wallet,
        type: 'msg',
        body: body,
      );
      await _refreshCustomerService();
    } else {
      await indexedDb.saveLivechatMessage(
        id: DateTime.now().millisecondsSinceEpoch,
        channel: channel,
        wallet: walletAddress ?? wallet,
        direction: 'in',
        body: body,
        delivered: true,
      );
      if (walletAddress != null) await _loadClientChat();
    }
  }

  Future<void> _publishCmsCollection(String collection) async {
    final items = await db.cmsItems(collection);
    _sendRtcMessage({
      'type': 'cms_sync',
      'collection': collection,
      'items': items,
    });
    if (mounted) setState(() => status = _l.statusContentPublished);
  }

  Future<void> _sendClientMenuSnapshot(String targetPeerId) async {
    final products = await db.rows('''
      SELECT p.rowid, p.ref, p.label, p.price, p.tva_tx, p.photo, p.photo_mime, p.stock,
             c.label AS category_label
      FROM erp.llx_product p
      LEFT JOIN erp.llx_categorie_product cp ON cp.fk_product = p.rowid
      LEFT JOIN erp.llx_categorie c ON c.rowid = cp.fk_categorie
      ORDER BY p.rowid
    ''');
    final items = products.map((product) {
      return {
        ...product,
        'rowid': product['rowid'],
        'category': product['category_label'] ?? _l.uncategorizedLabel,
        'description': product['label'],
      };
    }).toList();
    _sendRtcMessage({
      'type': 'product_sync',
      'products': items,
      '__target_peer_id': targetPeerId,
    });
    _sendRtcMessage({
      'type': 'cms_sync',
      'collection': 'site_content',
      'items': await db.cmsItems('site_content'),
      '__target_peer_id': targetPeerId,
    });
  }

  void _sendRtcMessage(Map<String, dynamic> envelope) {
    try {
      webRtc.send(jsonEncode(envelope));
    } catch (_) {
      // Not connected — message is already saved locally; a fresh manual
      // signaling handshake is needed before it can be delivered.
    }
  }

  Future<void> _openClientConnection() async {
    final offerController = TextEditingController();
    final answerController = TextEditingController();
    var message = '';
    try {
      await showDialog<void>(
        context: navigatorKey.currentContext!,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Connect to store'),
            content: SizedBox(
              width: 520,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Paste the pairing code from the store portal.'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: offerController,
                    minLines: 4,
                    maxLines: 7,
                    decoration: const InputDecoration(
                      labelText: 'Pairing code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: answerController,
                    minLines: 4,
                    maxLines: 7,
                    decoration: const InputDecoration(
                      labelText: 'Response to send back',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(message),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  try {
                    final answer = await webRtc.acceptOffer(
                      offerController.text.trim(),
                    );
                    answerController.text = answer;
                    setDialogState(
                      () => message =
                          'Response ready. Send it back to the portal.',
                    );
                  } catch (error) {
                    setDialogState(() => message = 'Pairing failed: $error');
                  }
                },
                child: const Text('Create response'),
              ),
            ],
          ),
        ),
      );
    } finally {
      offerController.dispose();
      answerController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3F7FC7),
        primary: const Color(0xFF2A5A92),
        secondary: const Color(0xFF3F7FC7),
        surface: Colors.white,
        surfaceContainerHighest: const Color(0xFFF0F3F7),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF173D72),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Color(0xFFD9E0E8)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFD9E0E8),
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
      ),
    ),
    navigatorKey: navigatorKey,
    initialRoute: _isPortalRoute() ? '/portal' : '/',
    routes: {'/': (_) => _clientHome(), '/portal': (_) => _portal()},
    locale: currentLocale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );

  String _clientSiteText(
    String ref,
    String fallback, {
    bool description = false,
  }) {
    for (final item in clientSiteContent) {
      if (item['ref']?.toString() == ref) {
        final value = item[description ? 'description' : 'label']?.toString();
        if (value != null && value.trim().isNotEmpty) return value;
      }
    }
    return fallback;
  }

  Widget _clientHome() {
    final l = _l;
    final siteTitle = _clientSiteText('site.title', l.appTitle);
    final siteWelcome = _clientSiteText(
      'site.welcome',
      l.clientMenuSubtitle(activeChannel),
      description: true,
    );
    final siteNotice = _clientSiteText('site.notice', '');
    final siteContact = _clientSiteText('site.contact', '', description: true);
    final siteHours = _clientSiteText('site.hours', '', description: true);
    final sitePolicies = [
      _clientSiteText('site.privacy', '', description: true),
      _clientSiteText('site.terms', '', description: true),
      _clientSiteText('site.refund', '', description: true),
    ].where((text) => text.isNotEmpty).toList();
    final sitePages = clientSiteContent
        .where((item) => item['ref']?.toString().startsWith('page.') == true)
        .toList();
    final catalogLayout = _clientSiteText('catalog.layout', 'grid');
    final catalogColumns =
        int.tryParse(
          _clientSiteText('catalog.columns', '2'),
        )?.clamp(1, 4).toInt() ??
        2;
    final catalogSort = _clientSiteText('catalog.sort', 'default');
    final showCatalogCount =
        _clientSiteText('catalog.show_count', 'true') != 'false';
    final sortedProducts = [...clientProducts];
    if (catalogSort == 'name') {
      sortedProducts.sort(
        (a, b) =>
            _localizedProductLabel(a).compareTo(_localizedProductLabel(b)),
      );
    } else if (catalogSort == 'price_low') {
      sortedProducts.sort(
        (a, b) => (a['price'] as num).compareTo(b['price'] as num),
      );
    } else if (catalogSort == 'price_high') {
      sortedProducts.sort(
        (a, b) => (b['price'] as num).compareTo(a['price'] as num),
      );
    }
    final categories = <String, List<Map<String, dynamic>>>{};
    for (final product in sortedProducts) {
      (categories[product['category']?.toString() ?? l.menuFallbackCategory] ??=
              [])
          .add(product);
    }
    return Scaffold(
      appBar: AppBar(
        title: _BrandTitle(siteTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Chip(label: Text(activeChannel)),
          ),
          _connectionChip(onTap: _openClientConnection),
          _languageSwitcher(),
          if (walletAddress != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Chip(label: Text(_shortWallet(walletAddress!))),
            ),
          IconButton(
            onPressed: _openClientConnection,
            icon: const Icon(Icons.link_outlined),
            tooltip: 'Connect to store',
          ),
          IconButton(
            onPressed: _openMemberZone,
            icon: const Icon(Icons.badge_outlined),
            tooltip: l.memberZoneTooltip,
          ),
        ],
      ),
      body: !clientReady
          ? Center(
              child: status.toLowerCase().contains('error')
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(status, textAlign: TextAlign.center),
                    )
                  : const CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                Text(
                  l.clientMenuTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(siteWelcome),
                if (showCatalogCount)
                  Text(
                    '${clientProducts.length} products',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                const SizedBox(height: 12),
                if (siteNotice.isNotEmpty)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.campaign_outlined),
                      title: Text(
                        _clientSiteText('site.notice', 'Store notice'),
                      ),
                      subtitle: Text(siteNotice),
                    ),
                  ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.install_mobile_outlined),
                    title: Text(l.installAppTitle),
                    subtitle: Text('${l.installAppBody}\n${l.installAppHint}'),
                  ),
                ),
                if (walletAddress != null && machinesList.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _bookingCard(),
                ],
                if (siteContact.isNotEmpty ||
                    siteHours.isNotEmpty ||
                    sitePolicies.isNotEmpty)
                  Card(
                    child: ExpansionTile(
                      title: const Text('Store information'),
                      subtitle: Text(
                        [
                          siteContact,
                          siteHours,
                        ].where((text) => text.isNotEmpty).join(' · '),
                      ),
                      children: sitePolicies
                          .map((policy) => ListTile(title: Text(policy)))
                          .toList(),
                    ),
                  ),
                if (sitePages.isNotEmpty)
                  Card(
                    child: Column(
                      children: [
                        const ListTile(
                          leading: Icon(Icons.description_outlined),
                          title: Text('Store pages'),
                        ),
                        ...sitePages.map(
                          (page) => ListTile(
                            title: Text(page['label']?.toString() ?? ''),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _showClientSitePage(page),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                ...categories.entries.map(
                  (entry) => _clientCategory(
                    entry.key,
                    entry.value,
                    grid: catalogLayout == 'grid',
                    columns: catalogColumns,
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _clientCartBar(),
    );
  }

  Widget _bookingCard() {
    final l = _l;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.event_seat_outlined),
        title: Text(l.clientBookingCardTitle),
        subtitle: clientBookings.isEmpty
            ? null
            : Text(
                clientBookings
                    .map((b) => _bookingStatusLabel(l, b['status'].toString()))
                    .join(', '),
              ),
        trailing: FilledButton.icon(
          onPressed: _bookTable,
          icon: const Icon(Icons.add),
          label: Text(l.clientBookingSubmitButton),
        ),
      ),
    );
  }

  Future<void> _bookTable() async {
    final l = _l;
    final now = DateTime.now();
    final slots = List.generate(
      8,
      (i) => DateTime(now.year, now.month, now.day, now.hour + 1 + i),
    );
    int? selectedMachine = (machinesList.first['id'] as num).toInt();
    DateTime selectedSlot = slots.first;
    final partyController = TextEditingController(text: '2');
    final proceed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l.clientBookingCardTitle),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: selectedMachine,
                  decoration: InputDecoration(
                    labelText: l.clientBookingMachineLabel,
                  ),
                  items: machinesList
                      .map(
                        (m) => DropdownMenuItem(
                          value: (m['id'] as num).toInt(),
                          child: Text(m['name'].toString()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedMachine = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<DateTime>(
                  initialValue: selectedSlot,
                  decoration: InputDecoration(
                    labelText: l.clientBookingTimeLabel,
                  ),
                  items: slots
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(
                            '${s.hour.toString().padLeft(2, '0')}:00',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setDialogState(
                    () => selectedSlot = value ?? selectedSlot,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: partyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l.clientBookingPartySizeLabel,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l.cancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l.clientBookingSubmitButton),
            ),
          ],
        ),
      ),
    );
    final partySize = int.tryParse(partyController.text.trim()) ?? 1;
    partyController.dispose();
    if (proceed != true || selectedMachine == null) return;
    _sendRtcMessage({
      'type': 'booking_request',
      'machineId': selectedMachine,
      'wallet': walletAddress,
      'partySize': partySize,
      'start': selectedSlot.toIso8601String(),
      'end': selectedSlot.add(const Duration(hours: 1)).toIso8601String(),
    });
    if (mounted) setState(() => status = l.statusBookingRequested);
  }

  Future<void> _showClientSitePage(Map<String, dynamic> page) async {
    await showDialog<void>(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(page['label']?.toString() ?? ''),
        content: SingleChildScrollView(
          child: Text(page['description']?.toString() ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_l.cancelButton),
          ),
        ],
      ),
    );
  }

  Widget _clientCategory(
    String title,
    List<Map<String, dynamic>> products, {
    bool grid = false,
    int columns = 2,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 6),
        child: Text(
          title,
          style: Theme.of(navigatorKey.currentContext!).textTheme.titleLarge,
        ),
      ),
      if (grid)
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 900
                ? columns
                : constraints.maxWidth >= 600
                ? columns.clamp(1, 2).toInt()
                : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: count,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.55,
              ),
              itemBuilder: (context, index) =>
                  _clientProductCard(products[index]),
            );
          },
        )
      else
        ...products.map((product) {
          final quantity = cart[_clientProductId(product)] ?? 0;
          final label = _localizedProductLabel(product);
          return Card(
            child: ListTile(
              onTap: () => _itemDetail(product),
              leading: CircleAvatar(
                child: Text(label.isNotEmpty ? label.substring(0, 1) : '?'),
              ),
              title: Text(label),
              subtitle: Text(product['description']?.toString() ?? ''),
              trailing: SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('NT\$${_number(product['price'])}'),
                    if (quantity > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Badge(label: Text('$quantity')),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
    ],
  );

  Widget _clientProductCard(Map<String, dynamic> product) {
    final quantity = cart[_clientProductId(product)] ?? 0;
    final label = _localizedProductLabel(product);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _itemDetail(product),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _productPhoto(product, height: 116),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(
                    navigatorKey.currentContext!,
                  ).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                product['description']?.toString() ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('NT\$${_number(product['price'])}'),
                  if (quantity > 0) Badge(label: Text('$quantity')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productPhoto(Map<String, dynamic> product, {double? height}) {
    final photo = product['photo']?.toString();
    if (photo == null || photo.isEmpty) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        photo,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _clientCartBar() {
    final l = _l;
    final count = cart.values.fold<int>(0, (sum, value) => sum + value);
    final total = clientProducts.fold<double>(
      0,
      (sum, product) =>
          sum +
          ((cart[_clientProductId(product)] ?? 0) *
              (product['price'] as num).toDouble() *
              1.05),
    );
    final context = navigatorKey.currentContext!;
    return SafeArea(
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l.clientOrderTotalLabel(_number(total), count),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FilledButton(
              onPressed: count == 0 ? null : _submitClientOrder,
              child: Text(l.clientOrderConfirmButton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _portalLanding() {
    final l = _l;
    final context = navigatorKey.currentContext!;
    return Scaffold(
      appBar: AppBar(title: _BrandTitle(l.portalLoginTitle)),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storefront_outlined, size: 56),
                const SizedBox(height: 16),
                Text(
                  l.accountGateHeadline,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(l.accountGateBody),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _connectWallet,
                  icon: const Icon(Icons.login),
                  label: Text(l.accountSignInButton),
                ),
                if (passkey.hasPasskey()) ...[
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: _signInWithPasskey,
                    icon: const Icon(Icons.fingerprint),
                    label: Text(l.signInWithPasskeyButton),
                  ),
                ],
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _enterDemoMode,
                  icon: const Icon(Icons.play_circle_outline),
                  label: Text(l.demoModeLandingButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithPasskey() async {
    final l = _l;
    try {
      final passphrase = await passkey.unlock().timeout(
        const Duration(seconds: 30),
      );
      final address = await localWallet.unlock(passphrase);
      if (address == null) throw Exception(l.noAccountFoundMessage);
      await _finishWalletLogin(address, local: true);
    } catch (error) {
      if (mounted)
        setState(() => status = l.passkeyUnsupportedError(error.toString()));
    }
  }

  Future<void> _enterDemoMode() async {
    if (mounted) setState(() => walletAddress = 'demo-mode');
    await _start();
    await _refreshMyPermissions();
    await _chooseSampleScenario();
    await _seedMachines();
  }

  void _exitDemoMode() {
    setState(() => walletAddress = null);
  }

  Widget _portal() {
    if (walletAddress == null) return _portalLanding();
    final l = _l;
    final allSections = [
      (Icons.dashboard_outlined, l.navOverview, 'overview.view', _overview()),
      (
        Icons.point_of_sale_outlined,
        l.navRegister,
        'register.use',
        _register(),
      ),
      (
        Icons.savings_outlined,
        l.navRegisterSettlement,
        'register.use',
        _registerSettlement(),
      ),
      (
        Icons.query_stats_outlined,
        l.navSalesAnalysis,
        'overview.view',
        _salesAnalysis(),
      ),
      (
        Icons.notifications_active_outlined,
        l.backgroundSupportNav,
        'overview.view',
        _backgroundSupport(),
      ),
      (
        Icons.business_outlined,
        l.navThirdParties,
        'customers.manage',
        _customers(),
      ),
      (
        Icons.inventory_2_outlined,
        l.navProducts,
        'products.manage',
        _products(),
      ),
      (Icons.receipt_long_outlined, l.navOrders, 'orders.manage', _orders()),
      (
        Icons.cell_tower,
        l.navConnection,
        'connection.manage',
        _WebRtcPanel(api: api),
      ),
      (
        Icons.support_agent_outlined,
        l.navSupport,
        'support.manage',
        _customerService(),
      ),
      (
        Icons.restaurant_menu_outlined,
        'Site content',
        'content.manage',
        _menuContent(),
      ),
      (Icons.loyalty_outlined, l.navLoyalty, 'loyalty.manage', _loyalty()),
      (
        Icons.event_seat_outlined,
        l.navBookings,
        'bookings.manage',
        _bookings(),
      ),
      (
        Icons.admin_panel_settings_outlined,
        l.navAccessControl,
        'settings.manage',
        _accessControl(),
      ),
      (
        Icons.storage_outlined,
        l.navDatabase,
        'settings.manage',
        _databaseManagement(),
      ),
      (
        Icons.tune_outlined,
        l.navPosSettings,
        'settings.manage',
        _posSettings(),
      ),
    ];
    final visiblePermissions = myPermissions.isEmpty
        ? DatabaseService.permissionCatalog.toSet()
        : myPermissions;
    final sections = allSections
        .where((s) => visiblePermissions.contains(s.$3))
        .toList();
    final connectionIndex = sections.indexWhere(
      (s) => s.$3 == 'connection.manage',
    );
    return DefaultTabController(
      length: sections.length,
      child: Builder(
        builder: (tabContext) {
          final controller = DefaultTabController.of(tabContext);
          final destinations = sections.map((s) => (s.$1, s.$2)).toList();
          return Scaffold(
            appBar: AppBar(
              title: _BrandTitle(l.appTitle),
              actions: [
                if (walletAddress == 'demo-mode') ...[
                  Chip(
                    label: Text(l.demoModeBannerText),
                    backgroundColor: Colors.amber.shade200,
                  ),
                  TextButton(
                    onPressed: _exitDemoMode,
                    child: Text(l.exitDemoButton),
                  ),
                ] else
                  Chip(label: Text(_shortWallet(walletAddress!))),
                _connectionChip(
                  onTap: connectionIndex < 0
                      ? null
                      : () {
                          setState(() => portalSection = connectionIndex);
                          controller.animateTo(connectionIndex);
                        },
                ),
                _languageSwitcher(),
                IconButton(
                  onPressed: _editPreferences,
                  icon: const Icon(Icons.contact_page_outlined),
                  tooltip: l.preferencesTooltip,
                ),
                if (visiblePermissions.contains('settings.manage')) ...[
                  IconButton(
                    onPressed: _exportBackup,
                    icon: const Icon(Icons.download_outlined),
                    tooltip: l.backupTooltip,
                  ),
                  IconButton(
                    onPressed: _importBackup,
                    icon: const Icon(Icons.upload_outlined),
                    tooltip: l.restoreTooltip,
                  ),
                  IconButton(
                    onPressed: _backupToGoogleDrive,
                    icon: const Icon(Icons.cloud_upload_outlined),
                    tooltip: l.googleDriveBackupTooltip,
                  ),
                  IconButton(
                    onPressed: _restoreFromGoogleDrive,
                    icon: const Icon(Icons.cloud_download_outlined),
                    tooltip: l.googleDriveRestoreTooltip,
                  ),
                  IconButton(
                    onPressed: _exportToGoogleSheet,
                    icon: const Icon(Icons.table_view_outlined),
                    tooltip: l.googleSheetExportTooltip,
                  ),
                  IconButton(
                    onPressed: _importFromGoogleSheet,
                    icon: const Icon(Icons.table_rows_outlined),
                    tooltip: l.googleSheetImportTooltip,
                  ),
                  IconButton(
                    onPressed: _resetAllData,
                    icon: const Icon(Icons.delete_sweep_outlined),
                    tooltip: l.resetDataButton,
                  ),
                ],
                IconButton(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  tooltip: l.refreshTooltip,
                ),
              ],
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  color: Colors.white,
                  child: SizedBox(
                    width: 252,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: const Color(0xFF3F7FC7),
                          padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                          child: Text(
                            l.salesWorkspaceTitle.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.storefront_outlined),
                          title: Text(l.salesWorkspaceTitle),
                          subtitle: Text(l.salesWorkspaceSubtitle),
                        ),
                        const Divider(),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            children: destinations.indexed.map((entry) {
                              final index = entry.$1;
                              final item = entry.$2;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: ListTile(
                                  selected: portalSection == index,
                                  selectedTileColor: const Color(0xFFE8F1FB),
                                  shape: const RoundedRectangleBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  leading: Icon(item.$1, size: 20),
                                  title: Text(
                                    item.$2,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: portalSection == index
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() => portalSection = index);
                                    controller.animateTo(index);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            l.offlineTerminalFooter,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: TabBarView(
                    children: sections.map((s) => s.$4).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _backgroundSupport() {
    final l = _l;
    return _Page(
      children: [
        _SectionTitle(l.backgroundSupportTitle, l.backgroundSupportSubtitle),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.web_asset_outlined),
            title: Text(l.backgroundSupportWebTitle),
            subtitle: Text(l.backgroundSupportWebBody),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.android_outlined),
            title: Text(l.backgroundSupportAndroidTitle),
            subtitle: Text(l.backgroundSupportAndroidBody),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.phone_iphone_outlined),
            title: Text(l.backgroundSupportIosTitle),
            subtitle: Text(l.backgroundSupportIosBody),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.extension_outlined),
            title: Text(l.backgroundSupportChromeTitle),
            subtitle: Text(l.backgroundSupportChromeBody),
            trailing: FilledButton.icon(
              onPressed: () => _openBrowserDownload(
                '/downloads/lilygo-erp-chrome-extension.zip',
              ),
              icon: const Icon(Icons.download_outlined),
              label: Text(l.downloadChromeExtensionButton),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(l.backgroundSupportKeepOpen),
      ],
    );
  }

  void _openBrowserDownload(String path) {
    final window = js_util.getProperty(js_util.globalThis, 'window');
    js_util.callMethod(window, 'open', [path, '_blank']);
  }

  Widget _overview() {
    final l = _l;
    final context = navigatorKey.currentContext!;
    return _Page(
      padding: 28,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l.salesWorkspaceTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            FilledButton.icon(
              onPressed: _createChannel,
              icon: const Icon(Icons.link),
              label: Text(l.createChannelButton),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(status, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _Metric(
              label: l.metricOrders,
              value: '${_orderGroups().length}',
              icon: Icons.receipt_long,
            ),
            _Metric(
              label: l.metricThirdParties,
              value: '${customerRows.length}',
              icon: Icons.business,
            ),
            _Metric(
              label: l.metricProducts,
              value: '${productRows.length}',
              icon: Icons.inventory_2,
            ),
          ],
        ),
        const SizedBox(height: 28),
        Card(
          child: ListTile(
            leading: const Icon(Icons.cloud_off),
            title: Text(l.storageCardTitle),
            subtitle: Text(l.storageCardSubtitle(activeChannel)),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic>? _productById(int id) {
    for (final p in productRows) {
      if (p['rowid'] == id) return p;
    }
    return null;
  }

  List<Map<String, dynamic>> _registerCartLines() {
    final lines = <Map<String, dynamic>>[];
    for (final entry in registerCart.entries) {
      final product = _productById(entry.key);
      if (product == null) continue;
      final price = (product['price'] as num).toDouble();
      final taxRate = (product['tva_tx'] as num?)?.toDouble() ?? 0;
      final taxIncluded = product['tax_included'] != false;
      final qty = entry.value.toDouble();
      final lineTtc = taxIncluded
          ? price * qty
          : price * qty * (1 + taxRate / 100);
      final lineHt = taxIncluded ? lineTtc / (1 + taxRate / 100) : price * qty;
      lines.add({
        'product_id': entry.key,
        'label': product['label'],
        'qty': qty,
        'price': price,
        'tva_tx': taxRate,
        'total_ht': lineHt,
        'total_ttc': lineTtc,
      });
    }
    return lines;
  }

  String _formatDateTime(dynamic value) {
    if (value == null) return '—';
    final parsed = value is num
        ? DateTime.fromMillisecondsSinceEpoch(value.round())
        : DateTime.tryParse(value.toString());
    if (parsed == null) return value.toString();
    final local = parsed.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)} ${two(local.hour)}:${two(local.minute)}';
  }

  String _formatDate(dynamic value) {
    if (value == null) return '—';
    final parsed = value is num
        ? DateTime.fromMillisecondsSinceEpoch(value.round(), isUtc: true)
        : DateTime.tryParse(value.toString());
    if (parsed == null) return value.toString();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${parsed.year}-${two(parsed.month)}-${two(parsed.day)}';
  }

  Widget _register() {
    final l = _l;
    final filtered = registerCategoryFilter == null
        ? productRows
        : productRows
              .where((p) => p['category_id'] == registerCategoryFilter)
              .toList();
    final lines = _registerCartLines();
    final total = lines.fold<double>(
      0,
      (sum, line) => sum + (line['total_ttc'] as double),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(
                  l.registerSectionTitle,
                  l.registerSectionSubtitle,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(l.allCategoriesLabel),
                      selected: registerCategoryFilter == null,
                      onSelected: (_) =>
                          setState(() => registerCategoryFilter = null),
                    ),
                    ...categoryRows.map((category) {
                      final colorHex =
                          (category['color'] as String?) ?? '#3F7FC7';
                      return ChoiceChip(
                        avatar: CircleAvatar(
                          backgroundColor: Color(
                            int.parse(colorHex.substring(1), radix: 16) +
                                0xFF000000,
                          ),
                        ),
                        label: Text(category['label'].toString()),
                        selected: registerCategoryFilter == category['rowid'],
                        onSelected: (_) => setState(
                          () =>
                              registerCategoryFilter = category['rowid'] as int,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(child: Text(l.productsEmpty))
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 170,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1.15,
                              ),
                          itemCount: filtered.length,
                          itemBuilder: (_, index) {
                            final product = filtered[index];
                            final colorHex =
                                (product['category_color'] as String?) ??
                                '#607D8B';
                            final tileColor = Color(
                              int.parse(colorHex.substring(1), radix: 16) +
                                  0xFF000000,
                            );
                            return InkWell(
                              onTap: () => setState(() {
                                final id = product['rowid'] as int;
                                registerCart[id] = (registerCart[id] ?? 0) + 1;
                              }),
                              child: Card(
                                color: tileColor.withValues(alpha: 0.12),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        product['label'].toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text('NT\$${_number(product['price'])}'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        SizedBox(
          width: 340,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.cartTitle,
                  style: Theme.of(
                    navigatorKey.currentContext!,
                  ).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: lines.isEmpty
                      ? Center(child: Text(l.cartEmptyLabel))
                      : ListView(
                          children: lines.map((line) {
                            final id = line['product_id'] as int;
                            final qty = line['qty'] as double;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(line['label'].toString()),
                              subtitle: Text(
                                'NT\$${_number(line['total_ttc'])}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    onPressed: () => setState(() {
                                      final next = qty - 1;
                                      if (next <= 0) {
                                        registerCart.remove(id);
                                      } else {
                                        registerCart[id] = next.toInt();
                                      }
                                    }),
                                  ),
                                  Text(qty.toInt().toString()),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => setState(
                                      () => registerCart[id] =
                                          (registerCart[id] ?? 0) + 1,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l.totalLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'NT\$${_number(total)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: lines.isEmpty ? null : _checkout,
                  icon: const Icon(Icons.payments_outlined),
                  label: Text(l.payButtonLabel),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _checkout() async {
    final l = _l;
    if (activeRegisterSession == null) {
      ScaffoldMessenger.of(
        navigatorKey.currentContext!,
      ).showSnackBar(SnackBar(content: Text(l.registerNotOpenWarning)));
      return;
    }
    final lines = _registerCartLines();
    if (lines.isEmpty) return;
    final total = lines.fold<double>(
      0,
      (sum, line) => sum + (line['total_ttc'] as double),
    );
    final result = await showDialog<_CheckoutResult>(
      context: navigatorKey.currentContext!,
      builder: (_) =>
          _CheckoutDialog(total: total, paymentTypes: paymentTypeRows),
    );
    if (result == null) return;
    await db.recordPosSale(
      lines: lines,
      paymentCode: result.paymentCode,
      registerSessionId: activeRegisterSession!['rowid'] as int,
    );
    setState(() => registerCart.clear());
    await _refresh();
    if (!mounted) return;
    await showDialog<void>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.saleCompleteTitle),
        content: Text(
          result.changeDue != null && result.changeDue! > 0
              ? l.changeDueLabel(_number(result.changeDue!))
              : l.saleCompleteBody,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.okButton),
          ),
        ],
      ),
    );
  }

  Widget _registerSettlement() {
    final l = _l;
    final context = navigatorKey.currentContext!;
    final session = activeRegisterSession;
    return _Page(
      children: [
        _SectionTitle(l.registerSettlementTitle, l.registerSettlementSubtitle),
        const SizedBox(height: 16),
        if (session == null)
          _openRegisterCard()
        else
          _activeRegisterCard(session),
        const SizedBox(height: 28),
        Text(
          l.registerHistoryTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _DataTable(
          columns: [
            l.colOpenedAt,
            l.colClosedAt,
            l.colOpeningFloat,
            l.colCountedCash,
          ],
          rows: registerSessionHistory
              .map(
                (s) => [
                  _formatDateTime(s['date_creation']),
                  s['date_valid'] == null
                      ? '—'
                      : _formatDateTime(s['date_valid']),
                  'NT\$${_number(s['opening'])}',
                  s['cash'] == null ? '—' : 'NT\$${_number(s['cash'])}',
                ],
              )
              .toList(),
          empty: l.registerHistoryEmpty,
        ),
      ],
    );
  }

  Widget _openRegisterCard() {
    final l = _l;
    final opening = TextEditingController(text: '0');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.openRegisterCardTitle,
              style: Theme.of(
                navigatorKey.currentContext!,
              ).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 220,
              child: TextField(
                controller: opening,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l.openingFloatLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                await db.openRegisterSession(
                  openingFloat: double.tryParse(opening.text) ?? 0,
                  operator: walletAddress ?? 'staff',
                );
                await _refresh();
              },
              icon: const Icon(Icons.lock_open_outlined),
              label: Text(l.openRegisterButton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activeRegisterCard(Map<String, dynamic> session) {
    final l = _l;
    final context = navigatorKey.currentContext!;
    final sessionId = session['rowid'] as int;
    final sessionSales = posSaleRows
        .where((s) => s['pos_source'] == sessionId.toString())
        .toList();
    final byPayment = <String, double>{};
    for (final sale in sessionSales) {
      if (sale['refunded'] == true) continue;
      final code = sale['payment_code']?.toString() ?? 'LIQ';
      byPayment[code] = (byPayment[code] ?? 0) + (sale['total_ttc'] as num);
    }
    final cashTotal = byPayment['LIQ'] ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.activeSessionTitle(
                    _formatDateTime(session['date_creation']),
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(l.openingFloatSummary(_number(session['opening']))),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  children: [
                    for (final type in paymentTypeRows)
                      _Metric(
                        label: type['libelle'].toString(),
                        value: 'NT\$${_number(byPayment[type['code']] ?? 0)}',
                        icon: Icons.payments_outlined,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => _closeRegisterDialog(sessionId, cashTotal),
                  icon: const Icon(Icons.lock_outline),
                  label: Text(l.closeRegisterButton),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          l.recentSalesTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (sessionSales.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(l.recentSalesEmpty),
            ),
          )
        else
          Card(
            child: Column(
              children: sessionSales.map((sale) {
                final refunded = sale['refunded'] == true;
                return ListTile(
                  title: Text(sale['ref'].toString()),
                  subtitle: Text(_formatDateTime(sale['datef'])),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('NT\$${_number(sale['total_ttc'])}'),
                      const SizedBox(width: 12),
                      if (refunded)
                        Chip(label: Text(l.refundedChipLabel))
                      else
                        TextButton(
                          onPressed: () => _refundSale(sale['rowid'] as int),
                          child: Text(l.refundButton),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Future<void> _closeRegisterDialog(int sessionId, double expectedCash) async {
    final l = _l;
    final counted = TextEditingController(
      text: expectedCash.toStringAsFixed(0),
    );
    final confirmed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final countedValue = double.tryParse(counted.text) ?? 0;
          final variance = countedValue - expectedCash;
          return AlertDialog(
            title: Text(l.closeRegisterTitle),
            content: SizedBox(
              width: 340,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.expectedCashLabel(_number(expectedCash))),
                  const SizedBox(height: 12),
                  TextField(
                    controller: counted,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l.countedCashLabel,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  const SizedBox(height: 8),
                  Text(l.varianceLabel(_number(variance))),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l.cancelButton),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(l.closeRegisterButton),
              ),
            ],
          );
        },
      ),
    );
    if (confirmed != true) return;
    await db.closeRegisterSession(
      id: sessionId,
      cash: double.tryParse(counted.text) ?? 0,
      card: 0,
      cheque: 0,
      operator: walletAddress ?? 'staff',
    );
    await _refresh();
  }

  Future<void> _refundSale(int factureId) async {
    final l = _l;
    final confirmed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.refundConfirmTitle),
        content: Text(l.refundConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.refundButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await db.refundPosSale(factureId);
    await _refresh();
  }

  DateTime? _salesRangeSince() {
    final now = DateTime.now();
    switch (salesRange) {
      case 'today':
        return DateTime(now.year, now.month, now.day);
      case '7d':
        return now.subtract(const Duration(days: 7));
      case '30d':
        return now.subtract(const Duration(days: 30));
      default:
        return null;
    }
  }

  Future<void> _loadSalesAnalysis() async {
    final since = _salesRangeSince();
    final data = await Future.wait([
      db.dailySales(since: since),
      db.salesByCategory(since: since),
      db.salesByProduct(since: since),
    ]);
    if (!mounted) return;
    setState(() {
      dailySalesRows = data[0];
      salesByCategoryRows = data[1];
      salesByProductRows = data[2];
      salesAnalysisLoaded = true;
    });
  }

  Widget _barRow(String label, num value, num max, String display) {
    final fraction = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: fraction.toDouble(),
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3F7FC7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(display, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Future<void> _exportSalesCsv(
    String filename,
    List<Map<String, dynamic>> rowsData,
    List<String> columns,
  ) async {
    final buffer = StringBuffer();
    buffer.writeln(columns.join(','));
    for (final row in rowsData) {
      buffer.writeln(columns.map((c) => row[c]?.toString() ?? '').join(','));
    }
    await backup.downloadText(filename, buffer.toString());
  }

  Widget _salesAnalysis() {
    final l = _l;
    final context = navigatorKey.currentContext!;
    if (!salesAnalysisLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadSalesAnalysis());
    }
    final maxDaily = dailySalesRows.fold<num>(
      0,
      (m, r) => (r['total'] as num) > m ? r['total'] as num : m,
    );
    final maxCategory = salesByCategoryRows.fold<num>(
      0,
      (m, r) => (r['total'] as num) > m ? r['total'] as num : m,
    );
    final maxProduct = salesByProductRows.fold<num>(
      0,
      (m, r) => (r['total'] as num) > m ? r['total'] as num : m,
    );
    return _Page(
      children: [
        _SectionTitle(
          l.salesAnalysisSectionTitle,
          l.salesAnalysisSectionSubtitle,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: Text(l.rangeTodayLabel),
              selected: salesRange == 'today',
              onSelected: (_) {
                setState(() => salesRange = 'today');
                _loadSalesAnalysis();
              },
            ),
            ChoiceChip(
              label: Text(l.range7dLabel),
              selected: salesRange == '7d',
              onSelected: (_) {
                setState(() => salesRange = '7d');
                _loadSalesAnalysis();
              },
            ),
            ChoiceChip(
              label: Text(l.range30dLabel),
              selected: salesRange == '30d',
              onSelected: (_) {
                setState(() => salesRange = '30d');
                _loadSalesAnalysis();
              },
            ),
            ChoiceChip(
              label: Text(l.rangeAllLabel),
              selected: salesRange == 'all',
              onSelected: (_) {
                setState(() => salesRange = 'all');
                _loadSalesAnalysis();
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l.dailySalesLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () => _exportSalesCsv(
                'daily_sales.csv',
                dailySalesRows
                    .map((r) => {...r, 'day': _formatDate(r['day'])})
                    .toList(),
                ['day', 'total'],
              ),
              icon: const Icon(Icons.download_outlined),
              label: Text(l.exportCsvButton),
            ),
          ],
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: dailySalesRows.isEmpty
                ? Text(l.salesAnalysisEmpty)
                : Column(
                    children: dailySalesRows
                        .map(
                          (r) => _barRow(
                            _formatDate(r['day']),
                            r['total'] as num,
                            maxDaily,
                            'NT\$${_number(r['total'])}',
                          ),
                        )
                        .toList(),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l.salesByCategoryLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () => _exportSalesCsv(
                'sales_by_category.csv',
                salesByCategoryRows,
                ['label', 'qty', 'total'],
              ),
              icon: const Icon(Icons.download_outlined),
              label: Text(l.exportCsvButton),
            ),
          ],
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: salesByCategoryRows.isEmpty
                ? Text(l.salesAnalysisEmpty)
                : Column(
                    children: salesByCategoryRows
                        .map(
                          (r) => _barRow(
                            r['label'].toString(),
                            r['total'] as num,
                            maxCategory,
                            'NT\$${_number(r['total'])}',
                          ),
                        )
                        .toList(),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l.salesByProductLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () => _exportSalesCsv(
                'sales_by_product.csv',
                salesByProductRows,
                ['label', 'qty', 'total'],
              ),
              icon: const Icon(Icons.download_outlined),
              label: Text(l.exportCsvButton),
            ),
          ],
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: salesByProductRows.isEmpty
                ? Text(l.salesAnalysisEmpty)
                : Column(
                    children: salesByProductRows
                        .map(
                          (r) => _barRow(
                            r['label'].toString(),
                            r['total'] as num,
                            maxProduct,
                            'NT\$${_number(r['total'])}',
                          ),
                        )
                        .toList(),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _posSettings() {
    final l = _l;
    return _Page(
      children: [
        _SectionTitle(l.posSettingsSectionTitle, l.posSettingsSectionSubtitle),
        const SizedBox(height: 16),
        _PosSettingsPanel(
          initial: posSettings,
          onSave: (updated) async {
            for (final entry in updated.entries) {
              await db.setSetting(entry.key, entry.value);
            }
            await _refresh();
          },
        ),
      ],
    );
  }

  Widget _customers() {
    final l = _l;
    return _Page(
      children: [
        _SectionTitle(l.customersSectionTitle, l.customersSectionSubtitle),
        _DataTable(
          columns: [l.colName, l.colCustomerCode, l.colEmail],
          rows: customerRows
              .map((r) => [r['nom'], r['code_client'], r['email']])
              .toList(),
          empty: l.customersEmpty,
        ),
      ],
    );
  }

  Widget _products() {
    final l = _l;
    return _Page(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionTitle(l.productsSectionTitle, l.productsSectionSubtitle),
            Wrap(
              spacing: 8,
              children: [
                if (!productsShowCategories) ...[
                  OutlinedButton.icon(
                    onPressed: _chooseSampleScenario,
                    icon: const Icon(Icons.category_outlined),
                    label: const Text('Add sample scenario'),
                  ),
                  FilledButton.icon(
                    onPressed: () => _editProduct(),
                    icon: const Icon(Icons.add),
                    label: Text(l.newProductButton),
                  ),
                ] else
                  FilledButton.icon(
                    onPressed: () => _editCategory(),
                    icon: const Icon(Icons.add),
                    label: Text(l.newCategoryButton),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, label: Text(l.productsTabLabel)),
            ButtonSegment(value: true, label: Text(l.categoriesTabLabel)),
          ],
          selected: {productsShowCategories},
          onSelectionChanged: (value) =>
              setState(() => productsShowCategories = value.first),
        ),
        const SizedBox(height: 12),
        if (productsShowCategories)
          _categoriesPanel()
        else
          _DataTable(
            columns: [
              l.colReference,
              l.colLabel,
              l.colCategory,
              l.colPriceHt,
              l.colVat,
              l.colStock,
              '',
              '',
            ],
            rows: productRows
                .map(
                  (r) => [
                    r['ref'],
                    r['label'],
                    r['category_label'] ?? '—',
                    'NT\$${_number(r['price'])}',
                    '${_number(r['tva_tx'])}%',
                    _number(r['stock']),
                    'EDIT',
                    'LANG',
                  ],
                )
                .toList(),
            onAction: (index) => _editProduct(productRows[index]),
            onSecondaryAction: (index) =>
                _editProductTranslations(productRows[index]),
            empty: l.productsEmpty,
          ),
      ],
    );
  }

  Widget _categoriesPanel() {
    final l = _l;
    if (categoryRows.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l.categoriesEmpty),
        ),
      );
    }
    return Card(
      child: Column(
        children: categoryRows.map((category) {
          final count = productRows
              .where((p) => p['category_id'] == category['rowid'])
              .length;
          final colorHex = (category['color'] as String?) ?? '#3F7FC7';
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(
                int.parse(colorHex.substring(1), radix: 16) + 0xFF000000,
              ),
              radius: 12,
            ),
            title: Text(category['label'].toString()),
            subtitle: Text(l.productCountLabel(count)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _editCategory(category),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: () => _deleteCategory(category['rowid'] as int),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _orderGroups() {
    final groups = <int, Map<String, dynamic>>{};
    for (final row in orderRows) {
      final id = row['rowid'] as int;
      final group = groups.putIfAbsent(
        id,
        () => {...row, 'lines': <Map<String, dynamic>>[]},
      );
      (group['lines'] as List<Map<String, dynamic>>).add(row);
    }
    return groups.values.toList();
  }

  Widget _orders() {
    final l = _l;
    return _Page(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionTitle(l.ordersSectionTitle, l.ordersSectionSubtitle),
            Text(l.orderTransactionCount(_orderGroups().length)),
          ],
        ),
        const SizedBox(height: 12),
        if (_orderGroups().isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l.ordersEmptyMock),
            ),
          )
        else
          ..._orderGroups().map(_orderCard),
      ],
    );
  }

  Widget _orderCard(Map<String, dynamic> order) {
    final l = _l;
    final context = navigatorKey.currentContext!;
    final lines = order['lines'] as List<Map<String, dynamic>>;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['ref'].toString(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        order['customer'].toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: order['fk_statut'] as int),
                const SizedBox(width: 8),
                PopupMenuButton<int>(
                  tooltip: l.operateTransactionTooltip,
                  onSelected: (value) =>
                      _setOrderStatus(order['rowid'] as int, value),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text(l.validateOrderMenuItem),
                    ),
                    PopupMenuItem(value: 2, child: Text(l.acceptOrderMenuItem)),
                    PopupMenuItem(
                      value: 3,
                      child: Text(l.processOrderMenuItem),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Text(l.deliverOrderMenuItem),
                    ),
                    PopupMenuItem(
                      value: -1,
                      child: Text(l.cancelOrderMenuItem),
                    ),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const Divider(height: 24),
            ...lines.map(
              (line) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(child: Text(line['product'].toString())),
                    SizedBox(
                      width: 48,
                      child: Text('×${_number(line['qty'])}'),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        'NT\$${_number(line['subprice'])}',
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(
                      width: 110,
                      child: Text(
                        'NT\$${_number(line['total_ttc'])}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(l.totalHtLabel(_number(order['total_ht']))),
                const SizedBox(width: 20),
                Text(
                  l.totalTtcLabel(_number(order['total_ttc'])),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _customerService() {
    final l = _l;
    return _Page(
      padding: 20,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionTitle(
              l.supportSectionTitle,
              l.supportSectionSubtitle(activeChannel),
            ),
            FilledButton.icon(
              onPressed: _joinChannelAsAgent,
              icon: const Icon(Icons.badge_outlined),
              label: Text(l.joinAsAgentButton),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: channelMembers
              .map(
                (m) => Chip(
                  avatar: Icon(
                    m['role'] == 'owner' ? Icons.star : Icons.person_outline,
                    size: 16,
                  ),
                  label: Text(
                    '${_shortWallet(m['wallet'].toString())} · ${_roleLabel(navigatorKey.currentContext!, m['role'].toString())}',
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: false,
              label: Text(l.conversationsTab),
              icon: const Icon(Icons.forum_outlined),
            ),
            ButtonSegment(
              value: true,
              label: Text(l.activityLogTab),
              icon: const Icon(Icons.history),
            ),
          ],
          selected: {showActivityLog},
          onSelectionChanged: (selection) =>
              setState(() => showActivityLog = selection.first),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 480,
          child: showActivityLog
              ? _activityLogList()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 260, child: _serviceRoomList()),
                    const VerticalDivider(width: 1),
                    Expanded(child: _serviceThread()),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _activityLogList() {
    final l = _l;
    return activityLog.isEmpty
        ? Center(child: Text(l.noActivityYet))
        : ListView(
            children: activityLog
                .map(
                  (m) => ListTile(
                    leading: const Icon(Icons.circle_notifications_outlined),
                    title: Text(m['body'].toString()),
                    subtitle: Text(m['created_at'].toString()),
                  ),
                )
                .toList(),
          );
  }

  Widget _serviceRoomList() {
    final l = _l;
    return serviceRooms.isEmpty
        ? Center(child: Text(l.noConversationsYet))
        : ListView(
            children: serviceRooms
                .map(
                  (r) => ListTile(
                    selected: selectedRoomId == r['rowid'],
                    leading: const Icon(Icons.person_outline),
                    title: Text(_shortWallet(r['visitor_wallet'].toString())),
                    subtitle: Text(
                      r['last_message_at']?.toString() ?? l.noMessagesYet,
                    ),
                    onTap: () => _selectServiceRoom(r['rowid'] as int),
                  ),
                )
                .toList(),
          );
  }

  Widget _serviceThread() {
    final l = _l;
    if (selectedRoomId == null)
      return Center(child: Text(l.selectConversationPrompt));
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: serviceMessages
                .map(
                  (m) => ListTile(
                    dense: true,
                    title: Text(m['body'].toString()),
                    subtitle: Text(
                      '${m['wallet'] ?? l.roleAgentLabel} · ${m['created_at']}',
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: serviceReplyController,
                decoration: InputDecoration(hintText: l.replyHint),
              ),
            ),
            IconButton(
              onPressed: _sendServiceReply,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }

  Widget _menuContent() {
    final l = _l;
    return _Page(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _SectionTitle(
              'Site content',
              'Static content shown on the customer site',
            ),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _chooseSampleScenario,
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: const Text('Add sample scenario'),
                ),
                FilledButton.icon(
                  onPressed: () => _editMenuContentItem(),
                  icon: const Icon(Icons.add),
                  label: Text(l.newContentItemButton),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _publishCmsCollection('site_content'),
                  icon: const Icon(Icons.publish_outlined),
                  label: Text(l.publishButton),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        _DataTable(
          columns: [l.colReference, l.colLabel, 'Description', ''],
          rows: menuContentItems
              .map((r) => [r['ref'], r['label'], r['description'], 'EDIT'])
              .toList(),
          onAction: (index) => _editMenuContentItem(menuContentItems[index]),
          empty: l.contentEmpty,
        ),
      ],
    );
  }

  Widget _loyalty() {
    final l = _l;
    return _Page(
      children: [
        _SectionTitle(l.loyaltySectionTitle, l.loyaltySectionSubtitle),
        const SizedBox(height: 8),
        _DataTable(
          columns: [l.colWallet, l.colPointsBalance, l.colTier, ''],
          rows: loyaltyAccounts
              .map(
                (r) => [
                  _shortWallet(r['contact_wallet'].toString()),
                  r['points_balance'],
                  r['tier'],
                  'EDIT',
                ],
              )
              .toList(),
          onAction: (index) => _adjustPoints(loyaltyAccounts[index]),
          empty: l.loyaltyEmpty,
        ),
      ],
    );
  }

  Widget _bookings() {
    final l = _l;
    return _Page(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionTitle(l.bookingsSectionTitle, l.bookingsSectionSubtitle),
            OutlinedButton.icon(
              onPressed: _seedMachines,
              icon: const Icon(Icons.auto_awesome_outlined),
              label: Text(l.seedMachinesButton),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (machinesList.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l.machinesEmpty),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: machinesList.map((machine) {
              final state = machine['state'].toString();
              final color = state == 'occupied'
                  ? Colors.orange
                  : state == 'maintenance'
                  ? Colors.red
                  : Colors.green;
              final label = state == 'occupied'
                  ? l.machineStateOccupied
                  : state == 'maintenance'
                  ? l.machineStateMaintenance
                  : l.machineStateIdle;
              return PopupMenuButton<String>(
                onSelected: (value) =>
                    _setMachineStateAction(machine['id'] as int, value),
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'idle', child: Text(l.setIdleButton)),
                  PopupMenuItem(
                    value: 'maintenance',
                    child: Text(l.setMaintenanceButton),
                  ),
                ],
                child: Chip(
                  avatar: Icon(Icons.circle, size: 12, color: color),
                  label: Text('${machine['name']} · $label'),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 24),
        if (bookingsList.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l.bookingsEmpty),
            ),
          )
        else
          ...bookingsList.map((booking) {
            final machine = machinesList.firstWhere(
              (m) => m['id'] == booking['machine_id'],
              orElse: () => {'name': booking['machine_id'].toString()},
            );
            final status = booking['status'].toString();
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            machine['name'].toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${booking['scheduled_start']} → ${booking['scheduled_end']}',
                          ),
                          Text(
                            _shortWallet(
                              booking['customer_wallet']?.toString() ?? '',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Chip(label: Text(_bookingStatusLabel(l, status))),
                    PopupMenuButton<String>(
                      onSelected: (value) => _updateBookingStatusAction(
                        booking['id'] as int,
                        value,
                      ),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'released',
                          child: Text(l.releaseBookingMenuItem),
                        ),
                        PopupMenuItem(
                          value: 'in_progress',
                          child: Text(l.startBookingMenuItem),
                        ),
                        PopupMenuItem(
                          value: 'completed',
                          child: Text(l.completeBookingMenuItem),
                        ),
                        PopupMenuItem(
                          value: 'canceled',
                          child: Text(l.cancelBookingMenuItem),
                        ),
                      ],
                      child: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  String _bookingStatusLabel(AppLocalizations l, String status) =>
      switch (status) {
        'released' => l.bookingStatusReleased,
        'in_progress' => l.bookingStatusInProgress,
        'completed' => l.bookingStatusCompleted,
        'canceled' => l.bookingStatusCanceled,
        _ => l.bookingStatusPlanned,
      };

  Widget _accessControl() {
    final l = _l;
    return _Page(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionTitle(l.membersSectionTitle, l.membersSectionSubtitle),
            FilledButton.icon(
              onPressed: _addIamMember,
              icon: const Icon(Icons.person_add_alt_outlined),
              label: Text(l.addMemberButton),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (iamUsersList.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l.membersEmpty),
            ),
          )
        else
          ...iamUsersList.map(
            (user) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(_shortWallet(user['wallet'].toString())),
                subtitle: Text(user['role_name']?.toString() ?? l.noRoleLabel),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: user['role_id']?.toString(),
                      hint: Text(l.roleFieldLabel),
                      items: iamRolesList
                          .map(
                            (r) => DropdownMenuItem(
                              value: r['id'].toString(),
                              child: Text(r['name'].toString()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _changeRole(
                            user['wallet'].toString(),
                            user['role_id']?.toString(),
                            value,
                          );
                        }
                      },
                    ),
                    IconButton(
                      onPressed: () => _removeMember(
                        user['wallet'].toString(),
                        user['role_id']?.toString(),
                      ),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l.rolesSectionTitle,
              style: Theme.of(
                navigatorKey.currentContext!,
              ).textTheme.headlineSmall,
            ),
            OutlinedButton.icon(
              onPressed: () => _createOrEditRole(),
              icon: const Icon(Icons.add),
              label: Text(l.newRoleButton),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...iamRolesList.map(
          (role) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(role['name'].toString()),
              subtitle: Text((role['permissions'] as List).join(', ')),
              trailing: (role['is_builtin'] == true)
                  ? null
                  : IconButton(
                      onPressed: () => _createOrEditRole(role),
                      icon: const Icon(Icons.edit_outlined),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _databaseManagement() {
    final l = _l;
    final queryController = TextEditingController();
    return _Page(
      children: [
        _SectionTitle(l.databaseSectionTitle, l.databaseSectionSubtitle),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.sqlQueryLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: queryController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l.sqlQueryHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () => _runDbQuery(queryController.text),
                    icon: const Icon(Icons.play_arrow_outlined),
                    label: Text(l.runQueryButton),
                  ),
                ),
                if (dbQueryError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    dbQueryError!,
                    style: TextStyle(
                      color: Theme.of(
                        navigatorKey.currentContext!,
                      ).colorScheme.error,
                    ),
                  ),
                ],
                if (dbQueryResult != null) ...[
                  const SizedBox(height: 8),
                  if (dbQueryResult!.isEmpty)
                    Text(l.queryEmptyResult)
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: dbQueryResult!.first.keys
                            .map((k) => DataColumn(label: Text(k)))
                            .toList(),
                        rows: dbQueryResult!
                            .map(
                              (row) => DataRow(
                                cells: row.values
                                    .map((v) => DataCell(Text('${v ?? ''}')))
                                    .toList(),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l.tablesSectionTitle,
          style: Theme.of(navigatorKey.currentContext!).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        ...dbTableCounts.map(
          (entry) => Card(
            margin: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              title: Text(entry['table'].toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${entry['count']}'),
                  IconButton(
                    onPressed: (entry['count'] as int) == 0
                        ? null
                        : () => _clearDbTable(entry['table'].toString()),
                    icon: const Icon(Icons.delete_sweep_outlined),
                    tooltip: l.clearTableButton,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _number(dynamic value) =>
      value is num ? value.toStringAsFixed(2) : '$value';
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final int status;
  @override
  Widget build(BuildContext c) => Chip(
    label: Text(orderStatusLabel(c, status)),
    avatar: Icon(
      status == 4
          ? Icons.check_circle
          : status == -1
          ? Icons.cancel
          : Icons.timelapse,
      size: 17,
    ),
  );
}

class _Page extends StatelessWidget {
  const _Page({required this.children, this.padding = 28});
  final List<Widget> children;
  final double padding;
  @override
  Widget build(BuildContext c) => SingleChildScrollView(
    padding: EdgeInsets.fromLTRB(padding, padding - 4, padding, padding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, this.subtitle);
  final String title, subtitle;
  @override
  Widget build(BuildContext c) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(c).textTheme.headlineSmall?.copyWith(
          color: const Color(0xFF173D72),
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        subtitle,
        style: Theme.of(
          c,
        ).textTheme.bodySmall?.copyWith(color: const Color(0xFF667085)),
      ),
    ],
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});
  final String label, value;
  final IconData icon;
  @override
  Widget build(BuildContext c) => SizedBox(
    width: 205,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF3F7FC7), size: 22),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(c).textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF173D72),
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF667085), fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}

class _BrandTitle extends StatelessWidget {
  const _BrandTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
        child: const Text(
          'LILYGO',
          style: TextStyle(
            color: Color(0xFF173D72),
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Text(title),
    ],
  );
}

class _DataTable extends StatelessWidget {
  const _DataTable({
    required this.columns,
    required this.rows,
    required this.empty,
    this.onAction,
    this.onSecondaryAction,
  });
  final List<String> columns;
  final List<List<dynamic>> rows;
  final String empty;
  final ValueChanged<int>? onAction;
  final ValueChanged<int>? onSecondaryAction;
  @override
  Widget build(BuildContext c) {
    if (rows.isEmpty)
      return Card(
        child: Padding(padding: const EdgeInsets.all(24), child: Text(empty)),
      );
    final l = AppLocalizations.of(c);
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns.map((x) => DataColumn(label: Text(x))).toList(),
          rows: rows
              .asMap()
              .entries
              .map(
                (entry) => DataRow(
                  cells: entry.value
                      .asMap()
                      .entries
                      .map(
                        (cell) => DataCell(
                          cell.value == 'EDIT'
                              ? TextButton(
                                  onPressed: () => onAction?.call(entry.key),
                                  child: Text(l.editButton),
                                )
                              : cell.value == 'LANG'
                              ? IconButton(
                                  onPressed: () =>
                                      onSecondaryAction?.call(entry.key),
                                  icon: const Icon(Icons.translate),
                                  tooltip: l.translationsAction,
                                )
                              : Text('${cell.value ?? ''}'),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ProductDraft {
  const _ProductDraft(
    this.ref,
    this.label,
    this.price,
    this.tax,
    this.stock,
    this.categoryId,
    this.taxIncluded,
  );
  final String ref, label;
  final double price, tax, stock;
  final int? categoryId;
  final bool taxIncluded;
}

class _ProductDialog extends StatefulWidget {
  const _ProductDialog({
    this.row,
    this.categories = const [],
    this.defaultTaxIncluded = true,
    this.defaultTaxRate,
  });
  final Map<String, dynamic>? row;
  final List<Map<String, dynamic>> categories;
  final bool defaultTaxIncluded;
  final String? defaultTaxRate;
  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  late final ref = TextEditingController(
    text: widget.row?['ref']?.toString() ?? 'PROD-',
  );
  late final label = TextEditingController(
    text: widget.row?['label']?.toString() ?? '',
  );
  late final price = TextEditingController(
    text: widget.row?['price']?.toString() ?? '0',
  );
  late final tax = TextEditingController(
    text: widget.row?['tva_tx']?.toString() ?? widget.defaultTaxRate ?? '20',
  );
  late final stock = TextEditingController(
    text: widget.row?['stock']?.toString() ?? '0',
  );
  late int? categoryId = widget.row?['category_id'] as int?;
  late bool taxIncluded = widget.row == null
      ? widget.defaultTaxIncluded
      : widget.row?['tax_included'] != false;
  @override
  Widget build(BuildContext c) {
    final l = AppLocalizations.of(c);
    return AlertDialog(
      title: Text(widget.row == null ? l.newProductTitle : l.editProductTitle),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field(l.fieldReference, ref),
            _field(l.fieldLabel, label),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DropdownButtonFormField<int?>(
                initialValue: categoryId,
                decoration: InputDecoration(
                  labelText: l.fieldCategory,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l.noCategoryOption),
                  ),
                  ...widget.categories.map(
                    (cat) => DropdownMenuItem(
                      value: cat['rowid'] as int,
                      child: Text(cat['label'].toString()),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => categoryId = value),
              ),
            ),
            _field(l.fieldPriceHt, price, numeric: true),
            _field(l.fieldVat, tax, numeric: true),
            _field(l.fieldStock, stock, numeric: true),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.taxIncludedLabel),
              subtitle: Text(l.taxIncludedHint),
              value: taxIncluded,
              onChanged: (value) => setState(() => taxIncluded = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: Text(l.cancelButton),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            c,
            _ProductDraft(
              ref.text,
              label.text,
              double.tryParse(price.text) ?? 0,
              double.tryParse(tax.text) ?? 20,
              double.tryParse(stock.text) ?? 0,
              categoryId,
              taxIncluded,
            ),
          ),
          child: Text(l.saveButton),
        ),
      ],
    );
  }

  Widget _field(
    String name,
    TextEditingController controller, {
    bool numeric = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: controller,
      keyboardType: numeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: name,
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

class _CategoryDraft {
  const _CategoryDraft(this.label, this.color);
  final String label;
  final String color;
}

const _categoryColorPalette = [
  '#3F7FC7',
  '#E4572E',
  '#2E933C',
  '#F7B32B',
  '#8E44AD',
  '#17A2B8',
  '#D6336C',
  '#6C757D',
];

class _CategoryDialog extends StatefulWidget {
  const _CategoryDialog({this.row});
  final Map<String, dynamic>? row;
  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  late final label = TextEditingController(
    text: widget.row?['label']?.toString() ?? '',
  );
  late String color =
      widget.row?['color']?.toString() ?? _categoryColorPalette.first;
  @override
  Widget build(BuildContext c) {
    final l = AppLocalizations.of(c);
    return AlertDialog(
      title: Text(
        widget.row == null ? l.newCategoryTitle : l.editCategoryTitle,
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: label,
              decoration: InputDecoration(
                labelText: l.fieldLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _categoryColorPalette.map((hex) {
                final selected = hex == color;
                return GestureDetector(
                  onTap: () => setState(() => color = hex),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(hex.substring(1), radix: 16) + 0xFF000000,
                      ),
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: Colors.black87, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: Text(l.cancelButton),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, _CategoryDraft(label.text, color)),
          child: Text(l.saveButton),
        ),
      ],
    );
  }
}

class _PosSettingsPanel extends StatefulWidget {
  const _PosSettingsPanel({required this.initial, required this.onSave});
  final Map<String, String> initial;
  final Future<void> Function(Map<String, String> updated) onSave;
  @override
  State<_PosSettingsPanel> createState() => _PosSettingsPanelState();
}

class _PosSettingsPanelState extends State<_PosSettingsPanel> {
  late bool taxIncludedDefault =
      widget.initial['TAKEPOS_TAX_INCLUDED_DEFAULT'] != 'false';
  late final standardRate = TextEditingController(
    text: widget.initial['MAIN_TAX_STANDARD'] ?? '20',
  );
  late final reducedRate = TextEditingController(
    text: widget.initial['MAIN_TAX_REDUCED'] ?? '10',
  );
  @override
  Widget build(BuildContext c) {
    final l = AppLocalizations.of(c);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.defaultTaxModeLabel),
              subtitle: Text(l.taxIncludedHint),
              value: taxIncludedDefault,
              onChanged: (value) => setState(() => taxIncludedDefault = value),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: standardRate,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l.standardRateLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: reducedRate,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l.reducedRateLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => widget.onSave({
                'TAKEPOS_TAX_INCLUDED_DEFAULT': taxIncludedDefault.toString(),
                'MAIN_TAX_STANDARD': standardRate.text,
                'MAIN_TAX_REDUCED': reducedRate.text,
              }),
              child: Text(l.saveButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutResult {
  const _CheckoutResult(this.paymentCode, this.changeDue);
  final String paymentCode;
  final double? changeDue;
}

class _CheckoutDialog extends StatefulWidget {
  const _CheckoutDialog({required this.total, required this.paymentTypes});
  final double total;
  final List<Map<String, dynamic>> paymentTypes;
  @override
  State<_CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<_CheckoutDialog> {
  late String paymentCode = widget.paymentTypes.isNotEmpty
      ? widget.paymentTypes.first['code'].toString()
      : 'LIQ';
  final tendered = TextEditingController();
  @override
  Widget build(BuildContext c) {
    final l = AppLocalizations.of(c);
    final tenderedValue = double.tryParse(tendered.text);
    final change = tenderedValue == null ? null : tenderedValue - widget.total;
    final isCash = paymentCode == 'LIQ';
    final canComplete =
        !isCash || (tenderedValue != null && tenderedValue >= widget.total);
    return AlertDialog(
      title: Text(l.checkoutTitle),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.totalLabel, style: Theme.of(c).textTheme.bodyMedium),
            Text(
              'NT\$${widget.total.toStringAsFixed(0)}',
              style: Theme.of(c).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: widget.paymentTypes.map((p) {
                final code = p['code'].toString();
                return ChoiceChip(
                  label: Text(p['libelle'].toString()),
                  selected: paymentCode == code,
                  onSelected: (_) => setState(() => paymentCode = code),
                );
              }).toList(),
            ),
            if (isCash) ...[
              const SizedBox(height: 16),
              TextField(
                controller: tendered,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l.tenderedAmountLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    [
                          widget.total,
                          widget.total + 100,
                          widget.total + 500,
                          widget.total + 1000,
                        ]
                        .map(
                          (amount) => OutlinedButton(
                            onPressed: () => setState(
                              () => tendered.text = amount.toStringAsFixed(0),
                            ),
                            child: Text('NT\$${amount.toStringAsFixed(0)}'),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 8),
              if (change != null)
                Text(
                  l.changeDueLabel(_posNumber(change < 0 ? 0 : change)),
                  style: Theme.of(c).textTheme.titleMedium,
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: Text(l.cancelButton),
        ),
        FilledButton(
          onPressed: !canComplete
              ? null
              : () => Navigator.pop(
                  c,
                  _CheckoutResult(paymentCode, isCash ? change : null),
                ),
          child: Text(l.completeSaleButton),
        ),
      ],
    );
  }
}

String _posNumber(num value) =>
    value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);

class _ProductLangDialog extends StatefulWidget {
  const _ProductLangDialog({
    required this.productId,
    required this.baseLabel,
    required this.existing,
  });
  final int productId;
  final String baseLabel;
  final List<Map<String, dynamic>> existing;
  @override
  State<_ProductLangDialog> createState() => _ProductLangDialogState();
}

class _ProductLangDialogState extends State<_ProductLangDialog> {
  final db = DatabaseService();
  late String selectedLang = _supportedLocales.keys.first.languageCode == 'en'
      ? 'en'
      : _localeCode(_supportedLocales.keys.first);
  late final labelController = TextEditingController();
  late final descriptionController = TextEditingController();

  Map<String, dynamic>? _existingFor(String lang) => widget.existing
      .cast<Map<String, dynamic>?>()
      .firstWhere((row) => row?['lang'] == lang, orElse: () => null);

  @override
  void initState() {
    super.initState();
    _loadFields(selectedLang);
  }

  void _loadFields(String lang) {
    final row = _existingFor(lang);
    labelController.text = row?['label']?.toString() ?? '';
    descriptionController.text = row?['description']?.toString() ?? '';
  }

  @override
  void dispose() {
    labelController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    final l = AppLocalizations.of(c);
    return AlertDialog(
      title: Text(l.translationsDialogTitle),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.baseLabel, style: Theme.of(c).textTheme.bodySmall),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedLang,
              decoration: InputDecoration(
                labelText: l.translationsLanguageLabel,
                border: const OutlineInputBorder(),
              ),
              items: _supportedLocales.keys
                  .map((locale) => _localeCode(locale))
                  .map(
                    (code) => DropdownMenuItem(value: code, child: Text(code)),
                  )
                  .toList(),
              onChanged: (code) {
                if (code == null) return;
                setState(() {
                  selectedLang = code;
                  _loadFields(code);
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: labelController,
              decoration: InputDecoration(
                labelText: l.translationsLabelField,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l.translationsDescriptionField,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: Text(l.cancelButton),
        ),
        FilledButton(
          onPressed: () async {
            await db.saveProductLang(
              productId: widget.productId,
              lang: selectedLang,
              label: labelController.text.trim(),
              description: descriptionController.text.trim(),
            );
            if (c.mounted) Navigator.pop(c);
          },
          child: Text(l.saveButton),
        ),
      ],
    );
  }
}

class _CmsItemDialog extends StatefulWidget {
  const _CmsItemDialog({this.row});
  final Map<String, dynamic>? row;
  @override
  State<_CmsItemDialog> createState() => _CmsItemDialogState();
}

class _CmsItemDialogState extends State<_CmsItemDialog> {
  late final ref = TextEditingController(
    text: widget.row?['ref']?.toString() ?? '',
  );
  late final label = TextEditingController(
    text: widget.row?['label']?.toString() ?? '',
  );
  late final description = TextEditingController(
    text: widget.row?['description']?.toString() ?? '',
  );
  late final linkUrl = TextEditingController(
    text: widget.row?['link_url']?.toString() ?? '',
  );

  @override
  void dispose() {
    ref.dispose();
    label.dispose();
    description.dispose();
    linkUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    final l = AppLocalizations.of(c);
    return AlertDialog(
      title: Text(
        widget.row == null ? l.newContentItemTitle : l.editContentItemTitle,
      ),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field(l.fieldReference, ref),
            _field(l.fieldLabel, label),
            _field(l.fieldDescription, description),
            _field('Link URL (optional)', linkUrl),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: Text(l.cancelButton),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, {
            'ref': ref.text,
            'label': label.text,
            'labels': widget.row?['labels'],
            'description': description.text,
            'link_url': linkUrl.text,
          }),
          child: Text(l.saveButton),
        ),
      ],
    );
  }

  Widget _field(
    String name,
    TextEditingController controller, {
    bool numeric = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: controller,
      keyboardType: numeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: name,
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

class _WebRtcPanel extends StatefulWidget {
  const _WebRtcPanel({required this.api});
  final ApiService api;
  @override
  State<_WebRtcPanel> createState() => _WebRtcPanelState();
}

class _WebRtcPanelState extends State<_WebRtcPanel> {
  final service = WebRtcService();
  final notifications = NotificationService();
  final deviceQr = DeviceQrService();
  late final TextEditingController deviceUrlController;
  final offerController = TextEditingController();
  final answerController = TextEditingController();
  String state = 'new';
  String? message;

  @override
  void initState() {
    super.initState();
    deviceUrlController = TextEditingController(text: widget.api.baseUrl);
  }

  @override
  void dispose() {
    offerController.dispose();
    answerController.dispose();
    deviceUrlController.dispose();
    super.dispose();
  }

  Future<void> _enableNotifications() async {
    final l = AppLocalizations.of(context);
    final permission = await notifications.requestPermission();
    if (!mounted) return;
    setState(
      () => message = permission == 'granted'
          ? l.notificationsEnabled
          : l.notificationsBlocked,
    );
  }

  Future<void> _keepScreenAwake() async {
    final l = AppLocalizations.of(context);
    final enabled = notifications.awake
        ? await notifications.releaseAwake()
        : await notifications.keepAwake();
    if (!mounted) return;
    setState(
      () => message = enabled ? l.screenAwakeEnabled : l.notificationsBlocked,
    );
  }

  Future<void> _saveDeviceUrl() async {
    final l = AppLocalizations.of(context);
    widget.api.setBaseUrl(deviceUrlController.text);
    final reachable = await widget.api.health();
    if (!mounted) return;
    setState(
      () => message = reachable ? l.deviceReachable : l.deviceUnavailable,
    );
  }

  Future<void> _scanDeviceQr() async {
    final l = AppLocalizations.of(context);
    if (!deviceQr.supported) {
      setState(() => message = l.deviceQrUnsupported);
      return;
    }
    final scanned = await deviceQr.scan();
    if (!mounted || scanned.trim().isEmpty) return;
    deviceUrlController.text = scanned.trim();
    await _saveDeviceUrl();
  }

  Future<void> _generateOffer() async {
    final l = AppLocalizations.of(context);
    try {
      final offer = await service.createOffer();
      setState(() {
        offerController.text = offer;
        state = service.state();
        message = l.connectionOfferGeneratedMessage;
      });
    } catch (error) {
      setState(() => message = l.connectionOfferErrorMessage(error.toString()));
    }
  }

  Future<void> _acceptOffer() async {
    final l = AppLocalizations.of(context);
    try {
      final answer = await service.acceptOffer(offerController.text);
      setState(() {
        answerController.text = answer;
        state = service.state();
        message = l.connectionAnswerGeneratedMessage;
      });
    } catch (error) {
      setState(
        () => message = l.connectionAcceptErrorMessage(error.toString()),
      );
    }
  }

  Future<void> _applyAnswer() async {
    final l = AppLocalizations.of(context);
    try {
      state = await service.applyAnswer(answerController.text);
      setState(() => message = l.connectionAnswerAppliedMessage);
    } catch (error) {
      setState(() => message = l.connectionApplyErrorMessage(error.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _Page(
      children: [
        _SectionTitle(l.connectionSectionTitle, l.connectionSectionSubtitle),
        const SizedBox(height: 8),
        Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(Icons.desktop_windows_outlined),
                const SizedBox(width: 10),
                Expanded(child: Text(l.portalKeepOpenHint)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.alwaysOnConnectionHint),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: _enableNotifications,
                      icon: const Icon(Icons.notifications_active_outlined),
                      label: Text(
                        notifications.permission == 'granted'
                            ? l.notificationsEnabled
                            : l.enableNotificationsButton,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _keepScreenAwake,
                      icon: const Icon(Icons.brightness_7_outlined),
                      label: Text(
                        notifications.awake
                            ? l.screenAwakeEnabled
                            : l.keepAwakeButton,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.deviceConnectionTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(l.deviceConnectionBody),
                const SizedBox(height: 10),
                TextField(
                  controller: deviceUrlController,
                  decoration: InputDecoration(
                    labelText: l.deviceUrlLabel,
                    hintText: l.deviceUrlHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: _saveDeviceUrl,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(l.saveDeviceUrlButton),
                    ),
                    OutlinedButton.icon(
                      onPressed: _scanDeviceQr,
                      icon: const Icon(Icons.qr_code_scanner_outlined),
                      label: Text(l.scanDeviceQrButton),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.hub_outlined),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'PeerJS merchant room is active. Customers connect automatically using this channel.',
                      ),
                    ),
                    const Spacer(),
                    Chip(label: Text(service.status())),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => setState(() => state = service.status()),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh connection status'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

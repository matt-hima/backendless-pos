import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'l10n/generated/app_localizations.dart';
import 'models/order_payload.dart';
import 'data/dintaifung_menu.dart';
import 'services/api_service.dart';
import 'services/database_service.dart';
import 'services/webrtc_mock_service.dart';
import 'services/indexed_db_service.dart';
import 'services/wallet_auth_service.dart';
import 'services/wallet_crypto_service.dart';
import 'services/local_wallet_service.dart';
import 'services/channel_print_service.dart';
import 'services/backup_service.dart';
import 'services/webrtc_service.dart';

void main() => runApp(const LilyGoApp());

final _supportedLocales = {
  Locale('en'): 'English',
  Locale('ja'): '日本語',
  Locale('zh', 'TW'): '繁體中文',
  Locale('pt'): 'Português',
  Locale('es'): 'Español',
};

String _localeCode(Locale locale) =>
    locale.countryCode != null ? '${locale.languageCode}_${locale.countryCode}' : locale.languageCode;

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
  final channelPrint = ChannelPrintService();
  final backup = BackupService();
  final webRtc = WebRtcService();
  late final ApiService api;
  StreamSubscription<OrderPayload>? subscription;
  Timer? _rtcPollTimer;
  String status = '';
  List<Map<String, dynamic>> productRows = [];
  List<Map<String, dynamic>> customerRows = [];
  List<Map<String, dynamic>> orderRows = [];
  List<Map<String, dynamic>> clientProducts = [];
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

  AppLocalizations get _l => AppLocalizations.of(navigatorKey.currentContext!);

  @override
  void initState() {
    super.initState();
    api = ApiService();
    _startClient();
    if (Uri.base.path == '/portal') _start();
    _pollRtc();
    _rtcPollTimer = Timer.periodic(const Duration(seconds: 2), (_) => _pollRtc());
  }

  Future<void> _startClient() async {
    final fallback = dintaifungMenu
        .map((product) => {
              ...product,
              'rowid': product['id'],
              'category': _fallbackCategory(product['ref'] as String),
              'description': '${product['label']}｜鼎泰豐經典手作料理',
              'active': true
            })
        .toList();
    if (mounted)
      setState(() {
        clientProducts = fallback;
        clientReady = true;
      });
    try {
      await Future.any([
        indexedDb.initialize(),
        Future<void>.delayed(
            const Duration(seconds: 8),
            () => throw Exception(
                'IndexedDB initialization timed out; using local menu fallback'))
      ]);
      final cmsItems = await indexedDb.cmsItems('menu_items');
      if (cmsItems.isNotEmpty) {
        if (mounted)
          setState(() {
            clientProducts = cmsItems;
            clientReady = true;
          });
        return;
      }
      final products = await indexedDb.products();
      final normalizedProducts = products
          .map((product) =>
              {...product, 'rowid': product['rowid'] ?? product['id']})
          .where((product) => product['rowid'] != null)
          .toList();
      if (mounted)
        setState(() {
          clientProducts = normalizedProducts;
          clientReady = true;
        });
    } catch (error) {
      if (mounted) setState(() => status = _l.statusClientStorageError(error.toString()));
    }
  }

  String _fallbackCategory(String ref) => ref.contains('XLB') ||
          ref.contains('SHR') ||
          ref.contains('CHG') ||
          ref.contains('VEG')
      ? '點心'
      : ref.contains('SOU') || ref.contains('GRN')
          ? '小菜湯品'
          : ref.contains('DES')
              ? '甜點'
              : '主食';

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
      if (mounted) setState(() => status = _l.statusReadyMessage);
    } catch (error) {
      if (mounted) setState(() => status = _l.statusStartupError(error.toString()));
    }
  }

  Future<void> _refresh() async {
    final data = await Future.wait([
      db.rows(
          'SELECT rowid, ref, label, price, tva_tx, stock, updated_at FROM erp.llx_product ORDER BY rowid DESC'),
      db.rows(
          'SELECT rowid, nom, code_client, email, updated_at FROM erp.llx_societe WHERE is_merchant = false ORDER BY rowid DESC'),
      db.rows(
          'SELECT c.rowid, c.ref, c.fk_statut, s.nom AS customer, p.label AS product, d.qty, d.subprice, d.total_ht, d.total_ttc FROM erp.llx_commande c JOIN erp.llx_societe s ON s.rowid = c.fk_soc JOIN erp.llx_commandedet d ON d.fk_commande = c.rowid JOIN erp.llx_product p ON p.rowid = d.fk_product ORDER BY c.rowid DESC'),
    ]);
    if (!mounted) return;
    setState(() {
      productRows = data[0];
      customerRows = data[1];
      orderRows = data[2];
    });
  }

  Future<void> _receiveOrder(OrderPayload payload) async {
    try {
      await db.upsertOrder(payload);
      final bytes = await db.exportParquet();
      await api.syncParquet(bytes);
      await _refresh();
      if (mounted)
        setState(() => status = _l.statusOrderSynced(
            payload.order['ref'].toString(), payload.lines.length, bytes.length));
    } catch (error) {
      if (mounted) setState(() => status = _l.statusSyncError(error.toString()));
    }
  }

  Future<void> _setOrderStatus(int orderId, int nextStatus) async {
    await db.updateOrderStatus(orderId, nextStatus);
    await _refresh();
    final statusLabel = orderStatusLabel(navigatorKey.currentContext!, nextStatus);
    await _logChannelEvent(_l.orderStatusChangedLog(orderId, statusLabel));
    if (mounted) setState(() => status = _l.statusOrderStatusChanged(statusLabel));
  }

  Future<void> _editProduct([Map<String, dynamic>? row]) async {
    final result = await showDialog<_ProductDraft>(
        context: navigatorKey.currentContext!,
        builder: (_) => _ProductDialog(row: row));
    if (result == null) return;
    await db.saveProduct(
        id: row?['rowid'] as int?,
        ref: result.ref,
        label: result.label,
        price: result.price,
        tax: result.tax,
        stock: result.stock);
    await _logChannelEvent(_l.productSavedLog(result.ref, result.price.toStringAsFixed(2)));
    await _refresh();
    if (mounted) setState(() => status = _l.statusProductSaved(result.ref));
  }

  Future<void> _editProductTranslations(Map<String, dynamic> row) async {
    final productId = row['rowid'] as int;
    final existing = await db.productLangs(productId);
    if (!mounted) return;
    await showDialog<void>(
        context: navigatorKey.currentContext!,
        builder: (_) => _ProductLangDialog(
            productId: productId, baseLabel: row['label']?.toString() ?? '', existing: existing));
  }

  Future<void> _loadDintaifungMenu() async {
    for (final product in dintaifungMenu) {
      await db.saveProduct(
          id: product['id'] as int,
          ref: product['ref'] as String,
          label: product['label'] as String,
          price: product['price'] as double,
          tax: product['tva_tx'] as double,
          stock: product['stock'] as double);
    }
    await _refresh();
    if (mounted) setState(() => status = _l.statusMenuLoaded(dintaifungMenu.length));
  }

  Future<void> _openPortal() async {
    if (walletAddress == null) await _connectWallet();
    if (walletAddress == null) return;
    await _start();
    if (mounted) navigatorKey.currentState!.pushNamed('/portal');
  }

  Future<void> _connectWallet() async {
    try {
      final address = await walletAuth.connect();
      if (address != null) {
        await _finishWalletLogin(address);
        return;
      }
      await _accountEntry();
    } catch (error) {
      if (mounted) setState(() => status = _l.statusAccountCanceled(error.toString()));
    }
  }

  Future<void> _accountEntry() async {
    final l = _l;
    final isPortal = Uri.base.path == '/portal';
    final mobileController = TextEditingController();
    final birthdayController = TextEditingController();
    final storeNameController = TextEditingController();
    var advanced = false;
    final proceed = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l.accountEntryTitle),
          content: SizedBox(
            width: 420,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(l.accountEntryBody),
              const SizedBox(height: 16),
              TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: l.quickSetupMobileLabel, border: const OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                  controller: birthdayController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                      labelText: l.quickSetupBirthdayLabel, border: const OutlineInputBorder())),
              if (isPortal) ...[
                const SizedBox(height: 12),
                TextField(
                    controller: storeNameController,
                    decoration: InputDecoration(
                        labelText: l.storeNameFieldLabel, border: const OutlineInputBorder())),
              ],
              const SizedBox(height: 12),
              Text(l.quickSetupWarning, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () => setDialogState(() => advanced = true),
                      child: Text(l.accountAdvancedOptionsLink))),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l.cancelButton)),
            FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(l.continueButton))
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
    if (mobile.isEmpty || birthday.isEmpty) return;
    final passphrase = '$mobile-$birthday';
    if (await localWallet.hasWallet()) {
      try {
        final address = await localWallet.unlock(passphrase);
        if (address != null) {
          await _finishWalletLogin(address, local: true);
          return;
        }
      } catch (_) {
        // falls through to the mismatch message below
      }
      if (mounted) setState(() => status = l.accountMismatchError);
      return;
    }
    final created = await localWallet.create(passphrase);
    final address = created['address']!.toString();
    final mnemonic = created['mnemonic']?.toString();
    if (mnemonic != null) await _showRecoveryPhrase(mnemonic, mandatory: false);
    final updated = _walletThirdParty(address);
    updated['encrypted_profile'] = await walletCrypto.encrypt(
        {'phone_mobile': mobile, 'birthday': birthday, 'locale': _localeCode(currentLocale)});
    await indexedDb.saveWalletThirdParty(updated);
    if (mounted)
      setState(() {
        walletMobile = mobile;
        walletBirthday = birthday;
        rememberWalletInfo = true;
      });
    await _finishWalletLogin(address, local: true);
    if (isPortal) {
      final resolvedStoreName = storeName.isEmpty ? l.storeNameDefault : storeName;
      await db.registerMerchant(resolvedStoreName);
      await _refresh();
      await _autoProvisionChannel(resolvedStoreName);
    }
  }

  Future<void> _finishWalletLogin(String address, {bool local = false}) async {
    if (!local) await walletCrypto.initialize(address);
    final thirdparty = _walletThirdParty(address);
    await indexedDb.saveWalletThirdParty(thirdparty);
    if (mounted)
      setState(() {
        walletAddress = address;
        walletInitialized = true;
        status = _l.statusAccountConnected(_shortWallet(address));
      });
    await _loadClientStats();
    await _loadWalletProfile(address);
    if (Uri.base.path == '/portal') {
      await _start();
      await _logChannelEvent(_l.accountConnectedLog(_shortWallet(address)));
      await _refreshCustomerService();
    }
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
          walletMobile = profile['phone_mobile']?.toString() ?? profile['phone']?.toString() ?? '';
          walletBirthday = profile['birthday']?.toString() ?? '';
          rememberWalletInfo = true;
          if (localeCode != null && localeCode.isNotEmpty) currentLocale = _parseLocaleCode(localeCode);
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
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(l.preferencesBody),
              const SizedBox(height: 16),
              TextField(
                  controller: mobile,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: l.preferencesMobileLabel, border: const OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                  controller: birthday,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                      labelText: l.preferencesBirthdayLabel,
                      border: const OutlineInputBorder())),
              const SizedBox(height: 12),
              DropdownButtonFormField<Locale>(
                initialValue: selectedLocale,
                decoration: InputDecoration(
                    labelText: l.preferencesLanguageLabel, border: const OutlineInputBorder()),
                items: _supportedLocales.entries
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (locale) => setDialogState(() => selectedLocale = locale ?? selectedLocale),
              ),
              CheckboxListTile(
                  value: remember,
                  onChanged: (value) =>
                      setDialogState(() => remember = value ?? false),
                  title: Text(l.preferencesRememberCheckbox),
                  controlAffinity: ListTileControlAffinity.leading),
              Text(l.preferencesSecurityNote, style: const TextStyle(fontSize: 12)),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l.cancelButton)),
            FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(l.saveButton))
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
        'locale': _localeCode(selectedLocale)
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
              child: Text(l.accountUnlockButton)),
          OutlinedButton(
              onPressed: () => Navigator.pop(dialogContext, 'highSecurity'),
              child: Text(l.accountHighSecurityButton)),
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, 'restore'),
              child: Text(l.accountRestoreButton)),
        ],
      ),
    );
  }

  Future<void> _createLocalWallet() async {
    final l = _l;
    final passphrase = await _passphraseDialog(l.createPassphraseTitle, l.createPassphraseHint);
    if (passphrase == null) return;
    final confirm = await _passphraseDialog(l.confirmPassphraseTitle, l.confirmPassphraseHint);
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
  }

  Future<void> _restoreLocalWallet() async {
    final mnemonic = await _recoveryPhraseDialog();
    if (mnemonic == null) return;
    final l = _l;
    final passphrase = await _passphraseDialog(l.setPassphraseTitle, l.setPassphraseHint);
    if (passphrase == null) return;
    final address = await localWallet.restore(mnemonic, passphrase);
    await _finishWalletLogin(address, local: true);
  }

  Future<bool> _showRecoveryPhrase(String phrase, {bool mandatory = true}) async {
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
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(l.backupPhraseBody),
                  const SizedBox(height: 16),
                  SelectableText(phrase,
                      style: Theme.of(context).textTheme.titleMedium),
                  CheckboxListTile(
                    value: confirmed,
                    onChanged: (value) =>
                        setDialogState(() => confirmed = value ?? false),
                    title: Text(l.backupPhraseConfirmCheckbox),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ]),
              ),
              actions: [
                FilledButton(
                    onPressed: (!mandatory || confirmed)
                        ? () => Navigator.pop(dialogContext, true)
                        : null,
                    child: Text(l.continueButton)),
              ],
            ),
          ),
        ) ??
        false;
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
                border: const OutlineInputBorder())),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l.cancelButton)),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, controller.text),
              child: Text(l.restoreButton))
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
                labelText: hint, border: const OutlineInputBorder())),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l.cancelButton)),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, controller.text),
              child: Text(l.continueButton))
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
          channel: activeChannel, wallet: wallet);
      var total = 0.0;
      for (final record in records) {
        final payload =
            await walletCrypto.decrypt(record['encrypted_payload'].toString());
        total += (payload['total_ttc'] as num?)?.toDouble() ?? 0;
      }
      if (mounted)
        setState(() {
          clientTransactionCount = records.length;
          clientTransactionTotal = total;
        });
    } catch (error) {
      if (mounted) setState(() => status = _l.statusTransactionReadFailed(error.toString()));
    }
  }

  Future<void> _itemDetail(Map<String, dynamic> product) async {
    final productId = _clientProductId(product);
    var quantity = cart[productId] ?? 0;
    final l = _l;
    final selected = await showDialog<int>(
        context: navigatorKey.currentContext!,
        builder: (dialogContext) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
                    title: Text(_localizedProductLabel(product)),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(product['description']?.toString() ?? ''),
                      const SizedBox(height: 16),
                      Text('NT\$${_number(product['price'])}',
                          style: Theme.of(context).textTheme.headlineSmall),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => setDialogState(() {
                                      if (quantity > 0) quantity--;
                                    }),
                                icon: const Icon(Icons.remove_circle_outline)),
                            Text('$quantity',
                                style: Theme.of(context).textTheme.titleLarge),
                            IconButton(
                                onPressed: () =>
                                    setDialogState(() => quantity++),
                                icon: const Icon(Icons.add_circle_outline))
                          ])
                    ]),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(l.cancelButton)),
                      FilledButton(
                          onPressed: () =>
                              Navigator.pop(dialogContext, quantity),
                          child: Text(l.clientOrderConfirmButton))
                    ])));
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
    if (walletAddress == null) await _connectWallet();
    if (walletAddress == null) return;
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
        'qty': quantity,
        'subprice': product['price'],
        'total_ht': lineTotal,
        'total_ttc': lineTotal * 1.05
      });
    }
    if (lines.isEmpty) return;
    final transactionId = DateTime.now().millisecondsSinceEpoch;
    for (final line in lines) {
      line['fk_commande'] = transactionId;
    }
    final payload = {
      'channel': activeChannel,
      'wallet': walletAddress,
      'thirdparty': _walletThirdParty(walletAddress!),
      'total_ttc': total * 1.05,
      'lines': lines,
      'created_at': DateTime.now().toIso8601String()
    };
    final encryptedPayload = await walletCrypto.encrypt(payload);
    await indexedDb.saveEncryptedTransaction(
        id: transactionId,
        channel: activeChannel,
        wallet: walletAddress!,
        encryptedPayload: encryptedPayload);
    await _loadClientStats();
    _sendRtcMessage({
      'type': 'loyalty_earn',
      'wallet': walletAddress,
      'points': (total * 1.05 / 100).round(),
      'reason': 'Order WEB-$transactionId'
    });
    final l = _l;
    if (mounted)
      setState(() {
        cart.clear();
        status = l.statusOrderSaved('WEB-$transactionId');
      });
    if (mounted)
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(l.orderSavedSnackbar)));
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
                        border: const OutlineInputBorder())),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(l.cancelButton)),
                  FilledButton(
                      onPressed: () =>
                          Navigator.pop(dialogContext, nameController.text),
                      child: Text(l.createButton))
                ]));
    nameController.dispose();
    if (name == null) return;
    await _provisionChannel(name);
  }

  Future<void> _autoProvisionChannel(String storeName) async {
    final name = storeName.trim().isEmpty ? _l.storeNameDefault : storeName.trim();
    await _provisionChannel(name);
  }

  Future<void> _provisionChannel(String name) async {
    final l = _l;
    final channel = await indexedDb.createChannel(name);
    final code = channel['code'].toString();
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
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Image.memory(qrPng, width: 220, height: 220),
                      const SizedBox(height: 16),
                      SelectableText(link, textAlign: TextAlign.center)
                    ])),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(l.closeButton)),
                  FilledButton.icon(
                      onPressed: () => channelPrint
                          .open(_channelPrintHtml(code, link, qrPng)),
                      icon: const Icon(Icons.print_outlined),
                      label: Text(l.printButton))
                ]));
  }

  Future<Uint8List> _channelQrPng(String data) async {
    final painter =
        QrPainter(data: data, version: QrVersions.auto, gapless: true);
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
        roomId: roomId, wallet: walletAddress, type: 'system', body: message);
  }

  Future<void> _joinChannelAsAgent() async {
    if (walletAddress == null) return;
    final roomId = await db.ensureChannelRoom(activeChannel);
    await db.addSubscription(roomId, walletAddress!, role: 'agent');
    await db.insertMessage(
        roomId: roomId,
        wallet: walletAddress,
        type: 'system',
        body: _l.agentJoinedLog(_shortWallet(walletAddress!), activeChannel));
    await _refreshCustomerService();
  }

  Future<void> _refreshCustomerService() async {
    final roomId = await db.ensureChannelRoom(activeChannel);
    final members = await db.subscriptions(roomId);
    final rooms = await db.livechatRooms(activeChannel);
    final log = await db.messages(roomId, type: 'system');
    final selected = selectedRoomId;
    final msgs = selected != null ? await db.messages(selected) : <Map<String, dynamic>>[];
    if (mounted)
      setState(() {
        channelMembers = members;
        serviceRooms = rooms;
        activityLog = log;
        serviceMessages = msgs;
      });
  }

  Future<void> _refreshMenuContent() async {
    final items = await db.cmsItems('menu_items');
    if (mounted) setState(() => menuContentItems = items);
  }

  Future<void> _loadDemoMenuContent() async {
    for (final product in dintaifungMenu) {
      await db.saveCmsItem(collection: 'menu_items', data: {
        'ref': product['ref'],
        'label': product['label'],
        'labels': product['labels'],
        'price': product['price'],
        'tva_tx': product['tva_tx'],
        'stock': product['stock'],
        'category': _fallbackCategory(product['ref'] as String),
        'description': '${product['label']}｜鼎泰豐經典手作料理',
      });
    }
    await _refreshMenuContent();
  }

  Future<void> _editMenuContentItem([Map<String, dynamic>? row]) async {
    final result = await showDialog<Map<String, dynamic>>(
        context: navigatorKey.currentContext!,
        builder: (_) => _CmsItemDialog(row: row));
    if (result == null) return;
    await db.saveCmsItem(id: row?['rowid'] as int?, collection: 'menu_items', data: result);
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
    final booking = bookingsList.firstWhere((b) => b['id'] == id, orElse: () => {});
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
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextField(
                        controller: pointsController,
                        keyboardType: const TextInputType.numberWithOptions(signed: true),
                        decoration: InputDecoration(
                            labelText: l.pointsFieldLabel, border: const OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(
                        controller: reasonController,
                        decoration: InputDecoration(
                            labelText: l.reasonFieldLabel, border: const OutlineInputBorder())),
                  ])),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(l.cancelButton)),
                FilledButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(l.saveButton))
              ],
            ));
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
                    child: Text(l.cancelButton)),
                FilledButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(l.resetDataButton))
              ],
            ));
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
    await db.insertMessage(roomId: roomId, wallet: walletAddress, type: 'msg', body: text);
    _sendRtcMessage({
      'type': 'chat',
      'channel': activeChannel,
      'wallet': visitorWallet,
      'sender': 'staff',
      'body': text,
      'ts': DateTime.now().toIso8601String()
    });
    serviceReplyController.clear();
    await _selectServiceRoom(roomId);
    await _refreshCustomerService();
  }

  Future<void> _loadClientChat() async {
    final wallet = walletAddress;
    if (wallet == null) return;
    final msgs = await indexedDb.livechatMessages(channel: activeChannel, wallet: wallet);
    if (mounted) setState(() => clientChatMessages = msgs);
  }

  Future<void> _sendClientChatMessage() async {
    final text = clientChatController.text.trim();
    if (text.isEmpty || walletAddress == null) return;
    final id = DateTime.now().millisecondsSinceEpoch;
    await indexedDb.saveLivechatMessage(
        id: id, channel: activeChannel, wallet: walletAddress!, direction: 'out', body: text);
    _sendRtcMessage({
      'type': 'chat',
      'channel': activeChannel,
      'wallet': walletAddress,
      'sender': 'customer',
      'body': text,
      'clientMsgId': id,
      'ts': DateTime.now().toIso8601String()
    });
    clientChatController.clear();
    await _loadClientChat();
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
        padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
        child: SizedBox(
          height: 480,
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.all(12),
                child: Text(l.chatWithSupportTitle, style: const TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
                child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: clientChatMessages
                        .map((m) => Align(
                            alignment: m['direction'] == 'out'
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: m['direction'] == 'out'
                                        ? Theme.of(sheetContext).colorScheme.primaryContainer
                                        : Theme.of(sheetContext).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(m['body'].toString()))))
                        .toList())),
            Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  Expanded(
                      child: TextField(
                          controller: clientChatController,
                          decoration: InputDecoration(hintText: l.messageSupportHint))),
                  IconButton(onPressed: _sendClientChatMessage, icon: const Icon(Icons.send))
                ]))
          ]),
        ),
      ),
    );
  }

  Future<void> _exportBackup() async {
    final envelope = {
      'version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'duckdb': await db.dumpAll(),
      'indexeddb': await indexedDb.dumpAll(),
    };
    await backup.download(
        'store-backup-${DateTime.now().millisecondsSinceEpoch}.json', jsonEncode(envelope));
    if (mounted) setState(() => status = _l.statusBackupDownloaded);
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
                      child: Text(l.cancelButton)),
                  FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: Text(l.restoreButton))
                ]));
    if (confirmed != true) return;
    try {
      final raw = await backup.pickJsonFile();
      final envelope = jsonDecode(raw) as Map<String, dynamic>;
      await db.restoreAll(Map<String, dynamic>.from(envelope['duckdb'] as Map));
      await indexedDb.restoreAll(Map<String, dynamic>.from(envelope['indexeddb'] as Map));
      await _refresh();
      await _refreshCustomerService();
      if (mounted) setState(() => status = l.statusBackupRestored);
    } catch (error) {
      if (mounted) setState(() => status = l.statusRestoreFailed(error.toString()));
    }
  }

  Widget _connectionChip({VoidCallback? onTap}) {
    final l = _l;
    final color = rtcStatus == 'connected'
        ? Colors.green
        : rtcStatus == 'stale'
            ? Colors.amber
            : rtcStatus == 'connecting'
                ? Colors.blueGrey
                : Colors.grey;
    final label = rtcStatus == 'connected'
        ? l.connectionConnected
        : rtcStatus == 'stale'
            ? l.connectionReconnectNeeded
            : rtcStatus == 'connecting'
                ? l.connectionConnecting
                : l.connectionNotConnected;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: onTap != null
          ? ActionChip(
              avatar: Icon(Icons.circle, size: 12, color: color),
              label: Text(label),
              onPressed: onTap)
          : Chip(avatar: Icon(Icons.circle, size: 12, color: color), label: Text(label)),
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
    if (mounted && nextStatus != rtcStatus) setState(() => rtcStatus = nextStatus);
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
    if (type == 'cms_sync') {
      if (Uri.base.path == '/portal') return;
      final collection = envelope['collection']?.toString() ?? 'menu_items';
      final items = (envelope['items'] as List? ?? const [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
      await indexedDb.saveCmsItems(collection: collection, items: items);
      if (collection == 'menu_items') {
        final synced = await indexedDb.cmsItems('menu_items');
        if (mounted) setState(() => clientProducts = synced);
      }
      return;
    }
    if (type == 'loyalty_earn') {
      if (Uri.base.path != '/portal') return;
      final wallet = envelope['wallet']?.toString();
      final points = (envelope['points'] as num?)?.toInt() ?? 0;
      final reason = envelope['reason']?.toString() ?? '';
      if (wallet != null && points > 0) {
        await db.earnPoints(wallet, points, reason);
        await _refreshLoyalty();
      }
      return;
    }
    if (type == 'booking_request') {
      if (Uri.base.path != '/portal') return;
      final machineId = (envelope['machineId'] as num?)?.toInt();
      final wallet = envelope['wallet']?.toString();
      final partySize = (envelope['partySize'] as num?)?.toInt() ?? 1;
      final start = DateTime.tryParse(envelope['start']?.toString() ?? '');
      final end = DateTime.tryParse(envelope['end']?.toString() ?? '');
      if (machineId == null || wallet == null || start == null || end == null) return;
      if (await db.hasOverlap(machineId, start, end)) return;
      final id = await db.createBooking(
          machineId: machineId, customerWallet: wallet, partySize: partySize, start: start, end: end);
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
      if (Uri.base.path == '/portal') return;
      final machines = (envelope['machines'] as List? ?? const [])
          .map((m) => Map<String, dynamic>.from(m as Map))
          .toList();
      if (mounted) setState(() => machinesList = machines);
      return;
    }
    if (type == 'booking_status') {
      if (Uri.base.path == '/portal') return;
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
    if (Uri.base.path == '/portal') {
      final roomId = await db.ensureLivechatRoom(channel, wallet);
      await db.insertMessage(roomId: roomId, wallet: wallet, type: 'msg', body: body);
      await _refreshCustomerService();
    } else {
      await indexedDb.saveLivechatMessage(
          id: DateTime.now().millisecondsSinceEpoch,
          channel: channel,
          wallet: walletAddress ?? wallet,
          direction: 'in',
          body: body,
          delivered: true);
      if (walletAddress != null) await _loadClientChat();
    }
  }

  Future<void> _publishCmsCollection(String collection) async {
    final items = await db.cmsItems(collection);
    _sendRtcMessage({'type': 'cms_sync', 'collection': collection, 'items': items});
    if (mounted) setState(() => status = _l.statusContentPublished);
  }

  void _sendRtcMessage(Map<String, dynamic> envelope) {
    try {
      webRtc.send(jsonEncode(envelope));
    } catch (_) {
      // Not connected — message is already saved locally; a fresh manual
      // signaling handshake is needed before it can be delivered.
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        navigatorKey: navigatorKey,
        initialRoute: Uri.base.path == '/portal' ? '/portal' : '/',
        routes: {'/': (_) => _clientHome(), '/portal': (_) => _portal()},
        locale: currentLocale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );

  Widget _clientHome() {
    final l = _l;
    final categories = <String, List<Map<String, dynamic>>>{};
    for (final product in clientProducts) {
      (categories[product['category']?.toString() ?? l.menuFallbackCategory] ??= [])
          .add(product);
    }
    return Scaffold(
      appBar: AppBar(title: Text(l.appTitle), actions: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Chip(label: Text(activeChannel))),
        _connectionChip(),
        _languageSwitcher(),
        if (walletAddress != null) ...[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Chip(label: Text(_shortWallet(walletAddress!)))),
          IconButton(
              onPressed: _openClientChat,
              icon: const Icon(Icons.chat_bubble_outline),
              tooltip: l.chatTooltip)
        ] else
          IconButton(
              onPressed: _connectWallet,
              icon: const Icon(Icons.account_balance_wallet_outlined),
              tooltip: l.accountSignInTooltip),
        IconButton(
            onPressed: _openPortal,
            icon: const Icon(Icons.dashboard_outlined),
            tooltip: l.portalTooltip)
      ]),
      body: !clientReady
          ? Center(
              child: status.toLowerCase().contains('error')
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(status, textAlign: TextAlign.center))
                  : const CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                  Text(l.clientMenuTitle,
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text(l.clientMenuSubtitle(activeChannel)),
                  const SizedBox(height: 12),
                  Card(
                      child: ListTile(
                          leading: const Icon(Icons.lock_outline),
                          title: Text(
                              walletAddress == null ? l.clientOrderLockedTitle : l.clientOrderUnlockedTitle),
                          subtitle: Text(walletAddress == null
                              ? l.clientOrderLockedSubtitle
                              : l.clientOrderUnlockedSubtitle(
                                  clientTransactionCount, _number(clientTransactionTotal))),
                          trailing: walletAddress == null
                              ? FilledButton.icon(
                                  onPressed: _connectWallet,
                                  icon: const Icon(Icons.login),
                                  label: Text(l.accountSignInButton))
                              : OutlinedButton.icon(
                                  onPressed: _editPreferences,
                                  icon: const Icon(Icons.contact_page_outlined),
                                  label: Text(l.preferencesButton)))),
                  if (walletAddress != null && machinesList.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _bookingCard(),
                  ],
                  const SizedBox(height: 12),
                  ...categories.entries
                      .map((entry) => _clientCategory(entry.key, entry.value))
                ]),
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
                : Text(clientBookings
                    .map((b) => _bookingStatusLabel(l, b['status'].toString()))
                    .join(', ')),
            trailing: FilledButton.icon(
                onPressed: _bookTable,
                icon: const Icon(Icons.add),
                label: Text(l.clientBookingSubmitButton))));
  }

  Future<void> _bookTable() async {
    final l = _l;
    final now = DateTime.now();
    final slots = List.generate(
        8, (i) => DateTime(now.year, now.month, now.day, now.hour + 1 + i));
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
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButtonFormField<int>(
                initialValue: selectedMachine,
                decoration: InputDecoration(labelText: l.clientBookingMachineLabel),
                items: machinesList
                    .map((m) => DropdownMenuItem(
                        value: (m['id'] as num).toInt(), child: Text(m['name'].toString())))
                    .toList(),
                onChanged: (value) => setDialogState(() => selectedMachine = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<DateTime>(
                initialValue: selectedSlot,
                decoration: InputDecoration(labelText: l.clientBookingTimeLabel),
                items: slots
                    .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text('${s.hour.toString().padLeft(2, '0')}:00')))
                    .toList(),
                onChanged: (value) => setDialogState(() => selectedSlot = value ?? selectedSlot),
              ),
              const SizedBox(height: 12),
              TextField(
                  controller: partyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l.clientBookingPartySizeLabel)),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l.cancelButton)),
            FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(l.clientBookingSubmitButton)),
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

  Widget _clientCategory(String title, List<Map<String, dynamic>> products) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 6),
            child: Text(title, style: Theme.of(navigatorKey.currentContext!).textTheme.titleLarge)),
        ...products.map((product) {
          final quantity = cart[_clientProductId(product)] ?? 0;
          final label = _localizedProductLabel(product);
          return Card(
              child: ListTile(
                  onTap: () => _itemDetail(product),
                  leading: CircleAvatar(
                      child: Text(label.isNotEmpty ? label.substring(0, 1) : '?')),
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
                                  child: Badge(label: Text('$quantity')))
                          ]))));
        })
      ]);

  Widget _clientCartBar() {
    final l = _l;
    final count = cart.values.fold<int>(0, (sum, value) => sum + value);
    final total = clientProducts.fold<double>(
        0,
        (sum, product) =>
            sum +
            ((cart[_clientProductId(product)] ?? 0) *
                (product['price'] as num).toDouble() *
                1.05));
    final context = navigatorKey.currentContext!;
    return SafeArea(
        child: Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(children: [
              Expanded(
                  child: Text(l.clientOrderTotalLabel(_number(total), count),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold))),
              FilledButton(
                  onPressed: count == 0 || walletAddress == null
                      ? null
                      : _submitClientOrder,
                  child: Text(l.clientOrderConfirmButton))
            ])));
  }

  Widget _walletGate() {
    final l = _l;
    final context = navigatorKey.currentContext!;
    return Scaffold(
      appBar: AppBar(title: Text(l.portalLoginTitle)),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.account_balance_wallet, size: 56),
              const SizedBox(height: 16),
              Text(l.accountGateHeadline,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(l.accountGateBody),
              const SizedBox(height: 20),
              FilledButton.icon(
                  onPressed: _connectWallet,
                  icon: const Icon(Icons.login),
                  label: Text(l.accountSignInButton)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _portal() {
    if (walletAddress == null) return _walletGate();
    final l = _l;
    return DefaultTabController(
      length: 9,
      child: Builder(builder: (tabContext) {
        final controller = DefaultTabController.of(tabContext);
        final destinations = [
          (Icons.dashboard_outlined, l.navOverview),
          (Icons.business_outlined, l.navThirdParties),
          (Icons.inventory_2_outlined, l.navProducts),
          (Icons.receipt_long_outlined, l.navOrders),
          (Icons.cell_tower, l.navConnection),
          (Icons.support_agent_outlined, l.navSupport),
          (Icons.restaurant_menu_outlined, l.navContent),
          (Icons.loyalty_outlined, l.navLoyalty),
          (Icons.event_seat_outlined, l.navBookings),
        ];
        return Scaffold(
          appBar: AppBar(title: Text(l.appTitle), actions: [
            Chip(label: Text(_shortWallet(walletAddress!))),
            _connectionChip(onTap: () {
              setState(() => portalSection = 4);
              controller.animateTo(4);
            }),
            _languageSwitcher(),
            IconButton(
                onPressed: _editPreferences,
                icon: const Icon(Icons.contact_page_outlined),
                tooltip: l.preferencesTooltip),
            IconButton(
                onPressed: _exportBackup,
                icon: const Icon(Icons.download_outlined),
                tooltip: l.backupTooltip),
            IconButton(
                onPressed: _importBackup,
                icon: const Icon(Icons.upload_outlined),
                tooltip: l.restoreTooltip),
            IconButton(
                onPressed: _resetAllData,
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: l.resetDataButton),
            IconButton(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                tooltip: l.refreshTooltip)
          ]),
          body: Row(children: [
            Material(
              color: Theme.of(tabContext).colorScheme.surfaceContainerHighest,
              child: SizedBox(
                width: 236,
                child: Column(children: [
                  const SizedBox(height: 18),
                  ListTile(
                      leading: const Icon(Icons.storefront_outlined),
                      title: Text(l.salesWorkspaceTitle),
                      subtitle: Text(l.salesWorkspaceSubtitle)),
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            leading: Icon(item.$1),
                            title: Text(item.$2),
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
                      child: Text(l.offlineTerminalFooter, textAlign: TextAlign.center)),
                ]),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
                child: TabBarView(children: [
              _overview(),
              _customers(),
              _products(),
              _orders(),
              const _WebRtcPanel(),
              _customerService(),
              _menuContent(),
              _loyalty(),
              _bookings()
            ])),
          ]),
        );
      }),
    );
  }

  Widget _overview() {
    final l = _l;
    final context = navigatorKey.currentContext!;
    return _Page(padding: 28, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(l.salesWorkspaceTitle, style: Theme.of(context).textTheme.headlineMedium),
        FilledButton.icon(
            onPressed: _createChannel,
            icon: const Icon(Icons.link),
            label: Text(l.createChannelButton))
      ]),
      const SizedBox(height: 8),
      Text(status, style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 24),
      Wrap(spacing: 16, runSpacing: 16, children: [
        _Metric(
            label: l.metricOrders,
            value: '${_orderGroups().length}',
            icon: Icons.receipt_long),
        _Metric(
            label: l.metricThirdParties,
            value: '${customerRows.length}',
            icon: Icons.business),
        _Metric(
            label: l.metricProducts,
            value: '${productRows.length}',
            icon: Icons.inventory_2)
      ]),
      const SizedBox(height: 28),
      Card(
          child: ListTile(
              leading: const Icon(Icons.cloud_off),
              title: Text(l.storageCardTitle),
              subtitle: Text(l.storageCardSubtitle(activeChannel))))
    ]);
  }

  Widget _customers() {
    final l = _l;
    return _Page(children: [
      _SectionTitle(l.customersSectionTitle, l.customersSectionSubtitle),
      _DataTable(
          columns: [l.colName, l.colCustomerCode, l.colEmail],
          rows: customerRows
              .map((r) => [r['nom'], r['code_client'], r['email']])
              .toList(),
          empty: l.customersEmpty)
    ]);
  }

  Widget _products() {
    final l = _l;
    return _Page(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _SectionTitle(l.productsSectionTitle, l.productsSectionSubtitle),
        Wrap(spacing: 8, children: [
          OutlinedButton.icon(
              onPressed: _loadDintaifungMenu,
              icon: const Icon(Icons.restaurant),
              label: Text(l.loadSampleMenuButton)),
          FilledButton.icon(
              onPressed: () => _editProduct(),
              icon: const Icon(Icons.add),
              label: Text(l.newProductButton))
        ])
      ]),
      const SizedBox(height: 8),
      _DataTable(
          columns: [l.colReference, l.colLabel, l.colPriceHt, l.colVat, l.colStock, '', ''],
          rows: productRows
              .map((r) => [
                    r['ref'],
                    r['label'],
                    'NT\$${_number(r['price'])}',
                    '${_number(r['tva_tx'])}%',
                    _number(r['stock']),
                    'EDIT',
                    'LANG'
                  ])
              .toList(),
          onAction: (index) => _editProduct(productRows[index]),
          onSecondaryAction: (index) => _editProductTranslations(productRows[index]),
          empty: l.productsEmpty)
    ]);
  }

  List<Map<String, dynamic>> _orderGroups() {
    final groups = <int, Map<String, dynamic>>{};
    for (final row in orderRows) {
      final id = row['rowid'] as int;
      final group = groups.putIfAbsent(
          id, () => {...row, 'lines': <Map<String, dynamic>>[]});
      (group['lines'] as List<Map<String, dynamic>>).add(row);
    }
    return groups.values.toList();
  }

  Widget _orders() {
    final l = _l;
    return _Page(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _SectionTitle(l.ordersSectionTitle, l.ordersSectionSubtitle),
        Text(l.orderTransactionCount(_orderGroups().length))
      ]),
      const SizedBox(height: 12),
      if (_orderGroups().isEmpty)
        Card(
            child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l.ordersEmptyMock)))
      else
        ..._orderGroups().map(_orderCard)
    ]);
  }

  Widget _orderCard(Map<String, dynamic> order) {
    final l = _l;
    final context = navigatorKey.currentContext!;
    final lines = order['lines'] as List<Map<String, dynamic>>;
    return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(order['ref'].toString(),
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(order['customer'].toString(),
                          style: Theme.of(context).textTheme.bodyMedium)
                    ])),
                _StatusChip(status: order['fk_statut'] as int),
                const SizedBox(width: 8),
                PopupMenuButton<int>(
                    tooltip: l.operateTransactionTooltip,
                    onSelected: (value) =>
                        _setOrderStatus(order['rowid'] as int, value),
                    itemBuilder: (_) => [
                          PopupMenuItem(value: 1, child: Text(l.validateOrderMenuItem)),
                          PopupMenuItem(value: 2, child: Text(l.acceptOrderMenuItem)),
                          PopupMenuItem(value: 3, child: Text(l.processOrderMenuItem)),
                          PopupMenuItem(value: 4, child: Text(l.deliverOrderMenuItem)),
                          PopupMenuItem(value: -1, child: Text(l.cancelOrderMenuItem))
                        ],
                    child: const Icon(Icons.more_vert))
              ]),
              const Divider(height: 24),
              ...lines.map((line) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(children: [
                    Expanded(child: Text(line['product'].toString())),
                    SizedBox(
                        width: 48, child: Text('×${_number(line['qty'])}')),
                    SizedBox(
                        width: 100,
                        child: Text('NT\$${_number(line['subprice'])}',
                            textAlign: TextAlign.right)),
                    SizedBox(
                        width: 110,
                        child: Text('NT\$${_number(line['total_ttc'])}',
                            textAlign: TextAlign.right,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)))
                  ]))),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(l.totalHtLabel(_number(order['total_ht']))),
                const SizedBox(width: 20),
                Text(l.totalTtcLabel(_number(order['total_ttc'])),
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ])
            ])));
  }

  Widget _customerService() {
    final l = _l;
    return _Page(padding: 20, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _SectionTitle(l.supportSectionTitle, l.supportSectionSubtitle(activeChannel)),
        FilledButton.icon(
            onPressed: _joinChannelAsAgent,
            icon: const Icon(Icons.badge_outlined),
            label: Text(l.joinAsAgentButton))
      ]),
      const SizedBox(height: 12),
      Wrap(
          spacing: 8,
          runSpacing: 8,
          children: channelMembers
              .map((m) => Chip(
                  avatar: Icon(m['role'] == 'owner' ? Icons.star : Icons.person_outline, size: 16),
                  label: Text(
                      '${_shortWallet(m['wallet'].toString())} · ${_roleLabel(navigatorKey.currentContext!, m['role'].toString())}')))
              .toList()),
      const SizedBox(height: 16),
      SegmentedButton<bool>(
        segments: [
          ButtonSegment(value: false, label: Text(l.conversationsTab), icon: const Icon(Icons.forum_outlined)),
          ButtonSegment(value: true, label: Text(l.activityLogTab), icon: const Icon(Icons.history)),
        ],
        selected: {showActivityLog},
        onSelectionChanged: (selection) => setState(() => showActivityLog = selection.first),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 480,
        child: showActivityLog
            ? _activityLogList()
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 260, child: _serviceRoomList()),
                const VerticalDivider(width: 1),
                Expanded(child: _serviceThread()),
              ]),
      ),
    ]);
  }

  Widget _activityLogList() {
    final l = _l;
    return activityLog.isEmpty
        ? Center(child: Text(l.noActivityYet))
        : ListView(
            children: activityLog
                .map((m) => ListTile(
                    leading: const Icon(Icons.circle_notifications_outlined),
                    title: Text(m['body'].toString()),
                    subtitle: Text(m['created_at'].toString())))
                .toList());
  }

  Widget _serviceRoomList() {
    final l = _l;
    return serviceRooms.isEmpty
        ? Center(child: Text(l.noConversationsYet))
        : ListView(
            children: serviceRooms
                .map((r) => ListTile(
                    selected: selectedRoomId == r['rowid'],
                    leading: const Icon(Icons.person_outline),
                    title: Text(_shortWallet(r['visitor_wallet'].toString())),
                    subtitle: Text(r['last_message_at']?.toString() ?? l.noMessagesYet),
                    onTap: () => _selectServiceRoom(r['rowid'] as int)))
                .toList());
  }

  Widget _serviceThread() {
    final l = _l;
    if (selectedRoomId == null) return Center(child: Text(l.selectConversationPrompt));
    return Column(children: [
      Expanded(
          child: ListView(
              children: serviceMessages
                  .map((m) => ListTile(
                      dense: true,
                      title: Text(m['body'].toString()),
                      subtitle: Text('${m['wallet'] ?? l.roleAgentLabel} · ${m['created_at']}')))
                  .toList())),
      Row(children: [
        Expanded(
            child: TextField(
                controller: serviceReplyController,
                decoration: InputDecoration(hintText: l.replyHint))),
        IconButton(onPressed: _sendServiceReply, icon: const Icon(Icons.send))
      ])
    ]);
  }

  Widget _menuContent() {
    final l = _l;
    return _Page(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _SectionTitle(l.contentSectionTitle, l.contentSectionSubtitle),
        Wrap(spacing: 8, children: [
          OutlinedButton.icon(
              onPressed: _loadDemoMenuContent,
              icon: const Icon(Icons.auto_awesome_outlined),
              label: Text(l.demoModeButton)),
          FilledButton.icon(
              onPressed: () => _editMenuContentItem(),
              icon: const Icon(Icons.add),
              label: Text(l.newContentItemButton)),
          FilledButton.tonalIcon(
              onPressed: () => _publishCmsCollection('menu_items'),
              icon: const Icon(Icons.publish_outlined),
              label: Text(l.publishButton)),
        ])
      ]),
      const SizedBox(height: 8),
      _DataTable(
          columns: [l.colReference, l.colLabel, l.colCategory, l.colPriceHt, l.colStock, ''],
          rows: menuContentItems
              .map((r) => [
                    r['ref'],
                    r['label'],
                    r['category'],
                    'NT\$${_number(r['price'])}',
                    _number(r['stock']),
                    'EDIT'
                  ])
              .toList(),
          onAction: (index) => _editMenuContentItem(menuContentItems[index]),
          empty: l.contentEmpty)
    ]);
  }

  Widget _loyalty() {
    final l = _l;
    return _Page(children: [
      _SectionTitle(l.loyaltySectionTitle, l.loyaltySectionSubtitle),
      const SizedBox(height: 8),
      _DataTable(
          columns: [l.colWallet, l.colPointsBalance, l.colTier, ''],
          rows: loyaltyAccounts
              .map((r) => [
                    _shortWallet(r['contact_wallet'].toString()),
                    r['points_balance'],
                    r['tier'],
                    'EDIT'
                  ])
              .toList(),
          onAction: (index) => _adjustPoints(loyaltyAccounts[index]),
          empty: l.loyaltyEmpty)
    ]);
  }

  Widget _bookings() {
    final l = _l;
    return _Page(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _SectionTitle(l.bookingsSectionTitle, l.bookingsSectionSubtitle),
        OutlinedButton.icon(
            onPressed: _seedMachines,
            icon: const Icon(Icons.auto_awesome_outlined),
            label: Text(l.seedMachinesButton)),
      ]),
      const SizedBox(height: 12),
      if (machinesList.isEmpty)
        Card(child: Padding(padding: const EdgeInsets.all(24), child: Text(l.machinesEmpty)))
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
                onSelected: (value) => _setMachineStateAction(machine['id'] as int, value),
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'idle', child: Text(l.setIdleButton)),
                  PopupMenuItem(value: 'maintenance', child: Text(l.setMaintenanceButton)),
                ],
                child: Chip(
                    avatar: Icon(Icons.circle, size: 12, color: color),
                    label: Text('${machine['name']} · $label')),
              );
            }).toList()),
      const SizedBox(height: 24),
      if (bookingsList.isEmpty)
        Card(child: Padding(padding: const EdgeInsets.all(24), child: Text(l.bookingsEmpty)))
      else
        ...bookingsList.map((booking) {
          final machine = machinesList.firstWhere(
              (m) => m['id'] == booking['machine_id'],
              orElse: () => {'name': booking['machine_id'].toString()});
          final status = booking['status'].toString();
          return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(machine['name'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              '${booking['scheduled_start']} → ${booking['scheduled_end']}'),
                          Text(_shortWallet(booking['customer_wallet']?.toString() ?? '')),
                        ])),
                    Chip(label: Text(_bookingStatusLabel(l, status))),
                    PopupMenuButton<String>(
                        onSelected: (value) =>
                            _updateBookingStatusAction(booking['id'] as int, value),
                        itemBuilder: (_) => [
                              PopupMenuItem(
                                  value: 'released', child: Text(l.releaseBookingMenuItem)),
                              PopupMenuItem(
                                  value: 'in_progress', child: Text(l.startBookingMenuItem)),
                              PopupMenuItem(
                                  value: 'completed', child: Text(l.completeBookingMenuItem)),
                              PopupMenuItem(
                                  value: 'canceled', child: Text(l.cancelBookingMenuItem)),
                            ],
                        child: const Icon(Icons.more_vert))
                  ])));
        })
    ]);
  }

  String _bookingStatusLabel(AppLocalizations l, String status) => switch (status) {
        'released' => l.bookingStatusReleased,
        'in_progress' => l.bookingStatusInProgress,
        'completed' => l.bookingStatusCompleted,
        'canceled' => l.bookingStatusCanceled,
        _ => l.bookingStatusPlanned,
      };

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
          size: 17));
}

class _Page extends StatelessWidget {
  const _Page({required this.children, this.padding = 28});
  final List<Widget> children;
  final double padding;
  @override
  Widget build(BuildContext c) => SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children));
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, this.subtitle);
  final String title, subtitle;
  @override
  Widget build(BuildContext c) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(c).textTheme.headlineSmall),
        Text(subtitle, style: Theme.of(c).textTheme.bodySmall)
      ]);
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});
  final String label, value;
  final IconData icon;
  @override
  Widget build(BuildContext c) => SizedBox(
      width: 190,
      child: Card(
          child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon),
                    const SizedBox(height: 12),
                    Text(value, style: Theme.of(c).textTheme.headlineMedium),
                    Text(label)
                  ]))));
}

class _DataTable extends StatelessWidget {
  const _DataTable(
      {required this.columns,
      required this.rows,
      required this.empty,
      this.onAction,
      this.onSecondaryAction});
  final List<String> columns;
  final List<List<dynamic>> rows;
  final String empty;
  final ValueChanged<int>? onAction;
  final ValueChanged<int>? onSecondaryAction;
  @override
  Widget build(BuildContext c) {
    if (rows.isEmpty)
      return Card(
          child:
              Padding(padding: const EdgeInsets.all(24), child: Text(empty)));
    final l = AppLocalizations.of(c);
    return Card(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns:
                    columns.map((x) => DataColumn(label: Text(x))).toList(),
                rows: rows
                    .asMap()
                    .entries
                    .map((entry) => DataRow(
                        cells: entry.value
                            .asMap()
                            .entries
                            .map((cell) => DataCell(cell.value == 'EDIT'
                                ? TextButton(
                                    onPressed: () => onAction?.call(entry.key),
                                    child: Text(l.editButton))
                                : cell.value == 'LANG'
                                    ? IconButton(
                                        onPressed: () => onSecondaryAction?.call(entry.key),
                                        icon: const Icon(Icons.translate),
                                        tooltip: l.translationsAction)
                                    : Text('${cell.value ?? ''}')))
                            .toList()))
                    .toList())));
  }
}

class _ProductDraft {
  const _ProductDraft(this.ref, this.label, this.price, this.tax, this.stock);
  final String ref, label;
  final double price, tax, stock;
}

class _ProductDialog extends StatefulWidget {
  const _ProductDialog({this.row});
  final Map<String, dynamic>? row;
  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  late final ref =
      TextEditingController(text: widget.row?['ref']?.toString() ?? 'PROD-');
  late final label =
      TextEditingController(text: widget.row?['label']?.toString() ?? '');
  late final price =
      TextEditingController(text: widget.row?['price']?.toString() ?? '0');
  late final tax =
      TextEditingController(text: widget.row?['tva_tx']?.toString() ?? '20');
  late final stock =
      TextEditingController(text: widget.row?['stock']?.toString() ?? '0');
  @override
  Widget build(BuildContext c) {
    final l = AppLocalizations.of(c);
    return AlertDialog(
        title: Text(widget.row == null ? l.newProductTitle : l.editProductTitle),
        content: SizedBox(
            width: 420,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _field(l.fieldReference, ref),
              _field(l.fieldLabel, label),
              _field(l.fieldPriceHt, price, numeric: true),
              _field(l.fieldVat, tax, numeric: true),
              _field(l.fieldStock, stock, numeric: true)
            ])),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c), child: Text(l.cancelButton)),
          FilledButton(
              onPressed: () => Navigator.pop(
                  c,
                  _ProductDraft(
                      ref.text,
                      label.text,
                      double.tryParse(price.text) ?? 0,
                      double.tryParse(tax.text) ?? 20,
                      double.tryParse(stock.text) ?? 0)),
              child: Text(l.saveButton))
        ]);
  }

  Widget _field(String name, TextEditingController controller,
          {bool numeric = false}) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
              controller: controller,
              keyboardType: numeric
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
              decoration: InputDecoration(
                  labelText: name, border: const OutlineInputBorder())));
}

class _ProductLangDialog extends StatefulWidget {
  const _ProductLangDialog(
      {required this.productId, required this.baseLabel, required this.existing});
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

  Map<String, dynamic>? _existingFor(String lang) =>
      widget.existing.cast<Map<String, dynamic>?>().firstWhere(
          (row) => row?['lang'] == lang,
          orElse: () => null);

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
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.baseLabel, style: Theme.of(c).textTheme.bodySmall),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: selectedLang,
            decoration: InputDecoration(
                labelText: l.translationsLanguageLabel, border: const OutlineInputBorder()),
            items: _supportedLocales.keys
                .map((locale) => _localeCode(locale))
                .map((code) => DropdownMenuItem(value: code, child: Text(code)))
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
                  labelText: l.translationsLabelField, border: const OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                  labelText: l.translationsDescriptionField, border: const OutlineInputBorder())),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c), child: Text(l.cancelButton)),
        FilledButton(
            onPressed: () async {
              await db.saveProductLang(
                  productId: widget.productId,
                  lang: selectedLang,
                  label: labelController.text.trim(),
                  description: descriptionController.text.trim());
              if (c.mounted) Navigator.pop(c);
            },
            child: Text(l.saveButton))
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
  late final ref =
      TextEditingController(text: widget.row?['ref']?.toString() ?? '');
  late final label =
      TextEditingController(text: widget.row?['label']?.toString() ?? '');
  late final category =
      TextEditingController(text: widget.row?['category']?.toString() ?? '');
  late final price =
      TextEditingController(text: widget.row?['price']?.toString() ?? '0');
  late final tax =
      TextEditingController(text: widget.row?['tva_tx']?.toString() ?? '5');
  late final stock =
      TextEditingController(text: widget.row?['stock']?.toString() ?? '0');
  late final description =
      TextEditingController(text: widget.row?['description']?.toString() ?? '');

  @override
  void dispose() {
    ref.dispose();
    label.dispose();
    category.dispose();
    price.dispose();
    tax.dispose();
    stock.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    final l = AppLocalizations.of(c);
    return AlertDialog(
        title: Text(widget.row == null ? l.newContentItemTitle : l.editContentItemTitle),
        content: SizedBox(
            width: 420,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _field(l.fieldReference, ref),
              _field(l.fieldLabel, label),
              _field(l.fieldCategory, category),
              _field(l.fieldPriceHt, price, numeric: true),
              _field(l.fieldVat, tax, numeric: true),
              _field(l.fieldStock, stock, numeric: true),
              _field(l.fieldDescription, description),
            ])),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c), child: Text(l.cancelButton)),
          FilledButton(
              onPressed: () => Navigator.pop(c, {
                    'ref': ref.text,
                    'label': label.text,
                    'labels': widget.row?['labels'],
                    'category': category.text,
                    'price': double.tryParse(price.text) ?? 0,
                    'tva_tx': double.tryParse(tax.text) ?? 5,
                    'stock': double.tryParse(stock.text) ?? 0,
                    'description': description.text,
                  }),
              child: Text(l.saveButton))
        ]);
  }

  Widget _field(String name, TextEditingController controller,
          {bool numeric = false}) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
              controller: controller,
              keyboardType: numeric
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
              decoration: InputDecoration(
                  labelText: name, border: const OutlineInputBorder())));
}

class _WebRtcPanel extends StatefulWidget {
  const _WebRtcPanel();
  @override
  State<_WebRtcPanel> createState() => _WebRtcPanelState();
}

class _WebRtcPanelState extends State<_WebRtcPanel> {
  final service = WebRtcService();
  final offerController = TextEditingController();
  final answerController = TextEditingController();
  String state = 'new';
  String? message;

  @override
  void dispose() {
    offerController.dispose();
    answerController.dispose();
    super.dispose();
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
      setState(() => message = l.connectionAcceptErrorMessage(error.toString()));
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
    return _Page(children: [
      _SectionTitle(l.connectionSectionTitle, l.connectionSectionSubtitle),
      const SizedBox(height: 8),
      Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                const Icon(Icons.desktop_windows_outlined),
                const SizedBox(width: 10),
                Expanded(child: Text(l.portalKeepOpenHint)),
              ]))),
      const SizedBox(height: 8),
      Card(
          child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.shield_outlined),
                      const SizedBox(width: 8),
                      Text(message ?? l.connectionDefaultMessage),
                      const Spacer(),
                      Chip(label: Text(state))
                    ]),
                    const SizedBox(height: 12),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      FilledButton.icon(
                          onPressed: _generateOffer,
                          icon: const Icon(Icons.add_link),
                          label: Text(l.generateOfferButton)),
                      OutlinedButton.icon(
                          onPressed: _acceptOffer,
                          icon: const Icon(Icons.input),
                          label: Text(l.acceptOfferButton)),
                      FilledButton.tonalIcon(
                          onPressed: _applyAnswer,
                          icon: const Icon(Icons.link),
                          label: Text(l.applyAnswerButton))
                    ]),
                    const SizedBox(height: 16),
                    TextField(
                        controller: offerController,
                        minLines: 4,
                        maxLines: 8,
                        decoration: InputDecoration(
                            labelText: l.offerFieldLabel,
                            alignLabelWithHint: true,
                            border: const OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(
                        controller: answerController,
                        minLines: 4,
                        maxLines: 8,
                        decoration: InputDecoration(
                            labelText: l.answerFieldLabel,
                            alignLabelWithHint: true,
                            border: const OutlineInputBorder())),
                    const SizedBox(height: 12),
                    Text(l.connectionFooterNote),
                  ]))),
    ]);
  }
}

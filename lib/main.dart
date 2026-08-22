import 'dart:async';
import 'package:flutter/material.dart';
import 'models/order_payload.dart';
import 'data/dintaifung_menu.dart';
import 'services/api_service.dart';
import 'services/database_service.dart';
import 'services/webrtc_mock_service.dart';
import 'services/indexed_db_service.dart';
import 'services/wallet_auth_service.dart';
import 'services/wallet_crypto_service.dart';
import 'services/webrtc_service.dart';

void main() => runApp(const LilyGoApp());

class LilyGoApp extends StatefulWidget {
  const LilyGoApp({super.key});
  @override
  State<LilyGoApp> createState() => _LilyGoAppState();
}

class _LilyGoAppState extends State<LilyGoApp> {
  final db = DatabaseService();
  final radio = WebRtcMockService();
  final indexedDb = IndexedDbService();
  final walletAuth = WalletAuthService();
  final walletCrypto = WalletCryptoService();
  late final ApiService api;
  StreamSubscription<OrderPayload>? subscription;
  String status = 'Starting DuckDB-Wasm…';
  List<Map<String, dynamic>> productRows = [];
  List<Map<String, dynamic>> customerRows = [];
  List<Map<String, dynamic>> orderRows = [];
  List<Map<String, dynamic>> clientProducts = [];
  final Map<int, int> cart = {};
  bool databaseStarted = false;
  bool clientReady = false;
  String activeChannel = Uri.base.queryParameters['channel'] ?? 'default';
  String? walletAddress;
  int clientTransactionCount = 0;
  double clientTransactionTotal = 0;
  bool walletInitialized = false;

  @override
  void initState() {
    super.initState();
    api = ApiService();
    _startClient();
    if (Uri.base.path == '/portal') _start();
  }

  Future<void> _startClient() async {
    final fallback = dintaifungMenu
        .map((product) => {
              ...product,
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
      final products = await indexedDb.products();
      if (mounted)
        setState(() {
          clientProducts = products;
          clientReady = true;
        });
    } catch (error) {
      if (mounted) setState(() => status = 'Client storage error: $error');
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

  Future<void> _start() async {
    if (databaseStarted) return;
    databaseStarted = true;
    try {
      await db.initialize();
      subscription = radio.orders.listen(_receiveOrder);
      radio.start();
      await _refresh();
      if (mounted)
        setState(
            () => status = 'Ready — read and operate Dolibarr transactions');
    } catch (error) {
      if (mounted) setState(() => status = 'Startup error: $error');
    }
  }

  Future<void> _refresh() async {
    final data = await Future.wait([
      db.rows(
          'SELECT rowid, ref, label, price, tva_tx, stock, updated_at FROM llx_product ORDER BY rowid DESC'),
      db.rows(
          'SELECT rowid, nom, code_client, email, updated_at FROM llx_societe ORDER BY rowid DESC'),
      db.rows(
          'SELECT c.rowid, c.ref, c.fk_statut, s.nom AS customer, p.label AS product, d.qty, d.subprice, d.total_ht, d.total_ttc FROM llx_commande c JOIN llx_societe s ON s.rowid = c.fk_soc JOIN llx_commandedet d ON d.fk_commande = c.rowid JOIN llx_product p ON p.rowid = d.fk_product ORDER BY c.rowid DESC'),
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
        setState(() => status =
            'Synced ${payload.order['ref']} with ${payload.lines.length} lines (${bytes.length} bytes Parquet)');
    } catch (error) {
      if (mounted) setState(() => status = 'Sync error: $error');
    }
  }

  Future<void> _setOrderStatus(int orderId, int nextStatus) async {
    await db.updateOrderStatus(orderId, nextStatus);
    await _refresh();
    if (mounted)
      setState(() =>
          status = 'Order status changed to ${orderStatusLabel(nextStatus)}');
  }

  Future<void> _editProduct([Map<String, dynamic>? row]) async {
    final result = await showDialog<_ProductDraft>(
        context: context, builder: (_) => _ProductDialog(row: row));
    if (result == null) return;
    await db.saveProduct(
        id: row?['rowid'] as int?,
        ref: result.ref,
        label: result.label,
        price: result.price,
        tax: result.tax,
        stock: result.stock);
    await _refresh();
    if (mounted)
      setState(() => status = 'Product ${result.ref} saved locally in DuckDB');
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
    if (mounted)
      setState(() =>
          status = 'Loaded ${dintaifungMenu.length} 鼎泰豐 menu products locally');
  }

  Future<void> _openPortal() async {
    if (walletAddress == null) await _connectWallet();
    if (walletAddress == null) return;
    await _start();
    if (mounted) Navigator.of(context).pushNamed('/portal');
  }

  Future<void> _connectWallet() async {
    try {
      final address = await walletAuth.connect();
      if (address == null) {
        if (mounted)
          setState(() => status =
              'No browser wallet detected. Install MetaMask or another EIP-1193 wallet.');
        return;
      }
      await walletCrypto.initialize(address);
      if (mounted)
        setState(() {
          walletAddress = address;
          walletInitialized = true;
          status =
              'Wallet connected and encryption initialized: ${_shortWallet(address)}';
        });
      await _loadClientStats();
      if (Uri.base.path == '/portal') await _start();
    } catch (error) {
      if (mounted)
        setState(() => status = 'Wallet login canceled or failed: $error');
    }
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
      if (mounted)
        setState(() => status = 'Encrypted transaction read failed: $error');
    }
  }

  Future<void> _itemDetail(Map<String, dynamic> product) async {
    var quantity = cart[product['rowid'] as int] ?? 0;
    final selected = await showDialog<int>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
                    title: Text(product['label'].toString()),
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
                          child: const Text('Cancel')),
                      FilledButton(
                          onPressed: () =>
                              Navigator.pop(dialogContext, quantity),
                          child: const Text('Add to order'))
                    ])));
    if (selected == null) return;
    setState(() {
      if (selected == 0) {
        cart.remove(product['rowid']);
      } else {
        cart[product['rowid'] as int] = selected;
      }
    });
  }

  Future<void> _submitClientOrder() async {
    if (walletAddress == null) await _connectWallet();
    if (walletAddress == null) return;
    final lines = <Map<String, dynamic>>[];
    var total = 0.0;
    for (final product in clientProducts) {
      final id = product['rowid'] as int;
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
    if (mounted)
      setState(() {
        cart.clear();
        status =
            'Order WEB-$transactionId encrypted for this wallet and saved offline';
      });
    if (mounted)
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Order saved offline')));
  }

  String _shortWallet(String address) => address.length > 12
      ? '${address.substring(0, 6)}…${address.substring(address.length - 4)}'
      : address;

  Future<void> _createChannel() async {
    final nameController = TextEditingController(text: '鼎泰豐桌台頻道');
    final name = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
                title: const Text('Create order channel'),
                content: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        labelText: 'Channel name',
                        border: OutlineInputBorder())),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () =>
                          Navigator.pop(dialogContext, nameController.text),
                      child: const Text('Create'))
                ]));
    nameController.dispose();
    if (name == null) return;
    final channel = await indexedDb.createChannel(name);
    final link = '${Uri.base.origin}/?channel=${channel['code']}';
    if (!mounted) return;
    showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
                title: Text('Channel ${channel['code']} ready'),
                content: SelectableText(link),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Close'))
                ]));
  }

  @override
  void dispose() {
    subscription?.cancel();
    radio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Dolibarr Offline ERP',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        initialRoute: Uri.base.path == '/portal' ? '/portal' : '/',
        routes: {'/': (_) => _clientHome(), '/portal': (_) => _portal()},
      );

  Widget _clientHome() {
    final categories = <String, List<Map<String, dynamic>>>{};
    for (final product in clientProducts) {
      (categories[product['category']?.toString() ?? 'Menu'] ??= [])
          .add(product);
    }
    return Scaffold(
      appBar: AppBar(title: const Text('鼎泰豐點餐'), actions: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Chip(label: Text(activeChannel))),
        if (walletAddress != null)
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Chip(label: Text(_shortWallet(walletAddress!))))
        else
          IconButton(
              onPressed: _connectWallet,
              icon: const Icon(Icons.account_balance_wallet_outlined),
              tooltip: 'Connect wallet'),
        IconButton(
            onPressed: _openPortal,
            icon: const Icon(Icons.dashboard_outlined),
            tooltip: 'Portal')
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
                  Text('單點菜單',
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text('頻道：$activeChannel  ·  點選菜色查看詳情，加入您的訂單'),
                  const SizedBox(height: 12),
                  Card(
                      child: ListTile(
                          leading: const Icon(Icons.lock_outline),
                          title: Text(
                              walletAddress == null ? '連接錢包後送出訂單' : '此錢包的頻道交易'),
                          subtitle: Text(walletAddress == null
                              ? '只有錢包持有人可以建立與讀取自己的交易統計。'
                              : '已加密 $clientTransactionCount 筆 · 合計 NT\$${_number(clientTransactionTotal)}'))),
                  const SizedBox(height: 12),
                  ...categories.entries
                      .map((entry) => _clientCategory(entry.key, entry.value))
                ]),
      bottomNavigationBar: _clientCartBar(),
    );
  }

  Widget _clientCategory(String title, List<Map<String, dynamic>> products) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 6),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        ...products.map((product) {
          final quantity = cart[product['rowid'] as int] ?? 0;
          return Card(
              child: ListTile(
                  onTap: () => _itemDetail(product),
                  leading: CircleAvatar(
                      child: Text(product['label'].toString().substring(0, 1))),
                  title: Text(product['label'].toString()),
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
    final count = cart.values.fold<int>(0, (sum, value) => sum + value);
    final total = clientProducts.fold<double>(
        0,
        (sum, product) =>
            sum +
            ((cart[product['rowid'] as int] ?? 0) *
                (product['price'] as num).toDouble() *
                1.05));
    return SafeArea(
        child: Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(children: [
              Expanded(
                  child: Text('合計 NT\$${_number(total)}  ($count 項)',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold))),
              FilledButton(
                  onPressed: count == 0 ? null : _submitClientOrder,
                  child: const Text('確認點餐'))
            ])));
  }

  Widget _walletGate() => Scaffold(
        appBar: AppBar(title: const Text('Dolibarr Portal Login')),
        body: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.account_balance_wallet, size: 56),
                const SizedBox(height: 16),
                Text('Connect wallet to open portal',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                const Text(
                    'Your wallet address is used as the portal key. No private key is stored.'),
                const SizedBox(height: 20),
                FilledButton.icon(
                    onPressed: _connectWallet,
                    icon: const Icon(Icons.login),
                    label: const Text('Connect wallet')),
              ]),
            ),
          ),
        ),
      );

  Widget _portal() => walletAddress == null
      ? _walletGate()
      : DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(title: const Text('Dolibarr Offline ERP'), actions: [
              Chip(label: Text(_shortWallet(walletAddress!))),
              IconButton(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh data')
            ]),
            body: Column(children: [
              Material(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const TabBar(isScrollable: true, tabs: [
                    Tab(text: 'Overview', icon: Icon(Icons.dashboard_outlined)),
                    Tab(
                        text: 'Third parties',
                        icon: Icon(Icons.business_outlined)),
                    Tab(
                        text: 'Products',
                        icon: Icon(Icons.inventory_2_outlined)),
                    Tab(
                        text: 'Orders',
                        icon: Icon(Icons.receipt_long_outlined)),
                    Tab(text: 'WebRTC', icon: Icon(Icons.cell_tower))
                  ])),
              Expanded(
                  child: TabBarView(children: [
                _overview(),
                _customers(),
                _products(),
                _orders(),
                const _WebRtcPanel()
              ])),
            ]),
          ),
        );

  Widget _overview() => _Page(padding: 28, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Sales workspace',
              style: Theme.of(context).textTheme.headlineMedium),
          FilledButton.icon(
              onPressed: _createChannel,
              icon: const Icon(Icons.link),
              label: const Text('Create channel'))
        ]),
        const SizedBox(height: 8),
        Text(status, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        Wrap(spacing: 16, runSpacing: 16, children: [
          _Metric(
              label: 'Orders',
              value: '${_orderGroups().length}',
              icon: Icons.receipt_long),
          _Metric(
              label: 'Third parties',
              value: '${customerRows.length}',
              icon: Icons.business),
          _Metric(
              label: 'Products',
              value: '${productRows.length}',
              icon: Icons.inventory_2)
        ]),
        const SizedBox(height: 28),
        Card(
            child: ListTile(
                leading: const Icon(Icons.cloud_off),
                title: const Text('FQDN client storage'),
                subtitle: Text(
                    'Channel $activeChannel stores browser orders in IndexedDB. ESP32 sync requires a reachable LAN or relay endpoint; ${api.baseUrl} is not reachable from a public hosted page unless exposed securely.')))
      ]);

  Widget _customers() => _Page(children: [
        const _SectionTitle('Third parties', 'Dolibarr llx_societe'),
        _DataTable(
            columns: const ['Name', 'Customer code', 'Email'],
            rows: customerRows
                .map((r) => [r['nom'], r['code_client'], r['email']])
                .toList(),
            empty: 'No customers received yet.')
      ]);

  Widget _products() => _Page(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const _SectionTitle('Products', 'Dolibarr llx_product'),
          Wrap(spacing: 8, children: [
            OutlinedButton.icon(
                onPressed: _loadDintaifungMenu,
                icon: const Icon(Icons.restaurant),
                label: const Text('Load 鼎泰豐 menu')),
            FilledButton.icon(
                onPressed: () => _editProduct(),
                icon: const Icon(Icons.add),
                label: const Text('New product'))
          ])
        ]),
        const SizedBox(height: 8),
        _DataTable(
            columns: const [
              'Reference',
              'Label',
              'Price HT',
              'VAT',
              'Stock',
              ''
            ],
            rows: productRows
                .map((r) => [
                      r['ref'],
                      r['label'],
                      'NT\$${_number(r['price'])}',
                      '${_number(r['tva_tx'])}%',
                      _number(r['stock']),
                      'EDIT'
                    ])
                .toList(),
            onAction: (index) => _editProduct(productRows[index]),
            empty: 'No products yet. Add one or load the 鼎泰豐 menu.')
      ]);

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

  Widget _orders() => _Page(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const _SectionTitle(
              'Orders', 'Dolibarr llx_commande + llx_commandedet'),
          Text('${_orderGroups().length} transactions')
        ]),
        const SizedBox(height: 12),
        if (_orderGroups().isEmpty)
          const Card(
              child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Mock orders arrive every 10 seconds.')))
        else
          ..._orderGroups().map(_orderCard)
      ]);

  Widget _orderCard(Map<String, dynamic> order) {
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
                    tooltip: 'Operate transaction',
                    onSelected: (value) =>
                        _setOrderStatus(order['rowid'] as int, value),
                    itemBuilder: (_) => const [
                          PopupMenuItem(
                              value: 1, child: Text('Validate order')),
                          PopupMenuItem(value: 2, child: Text('Accept order')),
                          PopupMenuItem(value: 3, child: Text('Process order')),
                          PopupMenuItem(value: 4, child: Text('Deliver order')),
                          PopupMenuItem(value: -1, child: Text('Cancel order'))
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
                Text('Total HT  NT\$${_number(order['total_ht'])}'),
                const SizedBox(width: 20),
                Text('Total TTC  NT\$${_number(order['total_ttc'])}',
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ])
            ])));
  }

  String _number(dynamic value) =>
      value is num ? value.toStringAsFixed(2) : '$value';
}

const _statusLabels = {
  0: 'Draft',
  1: 'Validated',
  2: 'Accepted',
  3: 'In process',
  4: 'Delivered',
  -1: 'Canceled'
};
String orderStatusLabel(int status) => _statusLabels[status] ?? 'Unknown';

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final int status;
  @override
  Widget build(BuildContext c) => Chip(
      label: Text(orderStatusLabel(status)),
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
      this.onAction});
  final List<String> columns;
  final List<List<dynamic>> rows;
  final String empty;
  final ValueChanged<int>? onAction;
  @override
  Widget build(BuildContext c) {
    if (rows.isEmpty)
      return Card(
          child:
              Padding(padding: const EdgeInsets.all(24), child: Text(empty)));
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
                                    child: const Text('Edit'))
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
  Widget build(BuildContext c) => AlertDialog(
          title: Text(widget.row == null ? 'New product' : 'Edit product'),
          content: SizedBox(
              width: 420,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _field('Reference', ref),
                _field('Label', label),
                _field('Price HT', price, numeric: true),
                _field('VAT %', tax, numeric: true),
                _field('Stock', stock, numeric: true)
              ])),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(
                    c,
                    _ProductDraft(
                        ref.text,
                        label.text,
                        double.tryParse(price.text) ?? 0,
                        double.tryParse(tax.text) ?? 20,
                        double.tryParse(stock.text) ?? 0)),
                child: const Text('Save'))
          ]);
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
  String message = 'Google STUN: stun:stun.l.google.com:19302';

  @override
  void dispose() {
    offerController.dispose();
    answerController.dispose();
    super.dispose();
  }

  Future<void> _generateOffer() async {
    try {
      final offer = await service.createOffer();
      setState(() {
        offerController.text = offer;
        state = service.state();
        message =
            'Offer generated. Share it with the remote client, then paste its answer.';
      });
    } catch (error) {
      setState(() => message = 'Offer error: $error');
    }
  }

  Future<void> _acceptOffer() async {
    try {
      final answer = await service.acceptOffer(offerController.text);
      setState(() {
        answerController.text = answer;
        state = service.state();
        message =
            'Answer generated. Return it to the portal that created the offer.';
      });
    } catch (error) {
      setState(() => message = 'Accept offer error: $error');
    }
  }

  Future<void> _applyAnswer() async {
    try {
      state = await service.applyAnswer(answerController.text);
      setState(() => message = 'Remote answer applied. WebRTC state: $state');
    } catch (error) {
      setState(() => message = 'Answer error: $error');
    }
  }

  @override
  Widget build(BuildContext context) => _Page(children: [
        const _SectionTitle(
            'WebRTC connection', 'Portal connection info and manual signaling'),
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
                        Text(message),
                        const Spacer(),
                        Chip(label: Text(state))
                      ]),
                      const SizedBox(height: 12),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        FilledButton.icon(
                            onPressed: _generateOffer,
                            icon: const Icon(Icons.add_link),
                            label: const Text('Generate portal offer')),
                        OutlinedButton.icon(
                            onPressed: _acceptOffer,
                            icon: const Icon(Icons.input),
                            label: const Text('Accept remote offer')),
                        FilledButton.tonalIcon(
                            onPressed: _applyAnswer,
                            icon: const Icon(Icons.link),
                            label: const Text('Apply remote answer'))
                      ]),
                      const SizedBox(height: 16),
                      TextField(
                          controller: offerController,
                          minLines: 4,
                          maxLines: 8,
                          decoration: const InputDecoration(
                              labelText: 'Offer / remote offer JSON',
                              alignLabelWithHint: true,
                              border: OutlineInputBorder())),
                      const SizedBox(height: 12),
                      TextField(
                          controller: answerController,
                          minLines: 4,
                          maxLines: 8,
                          decoration: const InputDecoration(
                              labelText: 'Answer / remote answer JSON',
                              alignLabelWithHint: true,
                              border: OutlineInputBorder())),
                      const SizedBox(height: 12),
                      const Text(
                          'Google STUN helps discover peer routes. It does not provide a signaling service or relay ESP32 storage traffic.'),
                    ]))),
      ]);
}

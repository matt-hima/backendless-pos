import 'dart:convert';
import 'dart:typed_data';
import 'dart:js_util' as js_util;
import '../models/order_payload.dart';
import '../data/dintaifung_menu.dart';

class DatabaseService {
  dynamic get _bridge => js_util.getProperty(js_util.globalThis, 'DuckDBBridge');

  Future<void> initialize() async {
    await _promise(js_util.callMethod(_bridge, 'init', const []));
    await execute('''
      CREATE SCHEMA IF NOT EXISTS erp;
      CREATE SCHEMA IF NOT EXISTS chat;
      CREATE SCHEMA IF NOT EXISTS cms;
      CREATE SCHEMA IF NOT EXISTS loyalty;
      CREATE TABLE IF NOT EXISTS erp.llx_societe (
        rowid BIGINT PRIMARY KEY, nom VARCHAR NOT NULL, code_client VARCHAR,
        email VARCHAR, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS erp.llx_socpeople (
        rowid BIGINT PRIMARY KEY, fk_soc BIGINT NOT NULL, firstname VARCHAR,
        lastname VARCHAR, phone_mobile VARCHAR,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS erp.llx_commande (
        rowid BIGINT PRIMARY KEY, ref VARCHAR NOT NULL, fk_soc BIGINT NOT NULL,
        total_ht DOUBLE, total_ttc DOUBLE,
        fk_statut INTEGER DEFAULT 0,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS erp.llx_product (
        rowid BIGINT PRIMARY KEY, ref VARCHAR NOT NULL, label VARCHAR NOT NULL,
        price DOUBLE NOT NULL, tva_tx DOUBLE DEFAULT 20,
        stock DOUBLE DEFAULT 0, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS erp.llx_commandedet (
        rowid BIGINT PRIMARY KEY, fk_commande BIGINT NOT NULL,
        fk_product BIGINT NOT NULL, qty DOUBLE NOT NULL,
        subprice DOUBLE NOT NULL, total_ht DOUBLE NOT NULL,
        total_ttc DOUBLE NOT NULL
      );
      CREATE TABLE IF NOT EXISTS erp.llx_product_lang (
        rowid BIGINT PRIMARY KEY, fk_product BIGINT NOT NULL, lang VARCHAR NOT NULL,
        label VARCHAR, description VARCHAR,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS chat.rc_rooms (
        rowid BIGINT PRIMARY KEY, t VARCHAR NOT NULL DEFAULT 'c',
        channel_code VARCHAR NOT NULL, name VARCHAR,
        visitor_wallet VARCHAR, status VARCHAR DEFAULT 'open',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        last_message_at TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS chat.rc_subscriptions (
        rowid BIGINT PRIMARY KEY, fk_room BIGINT NOT NULL,
        wallet VARCHAR NOT NULL, role VARCHAR NOT NULL DEFAULT 'member',
        joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS chat.rc_messages (
        rowid BIGINT PRIMARY KEY, fk_room BIGINT NOT NULL,
        wallet VARCHAR, t VARCHAR NOT NULL DEFAULT 'msg',
        body VARCHAR NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS cms.collections (
        id VARCHAR PRIMARY KEY, icon VARCHAR, note VARCHAR,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS cms.fields (
        rowid BIGINT PRIMARY KEY, collection VARCHAR NOT NULL, field VARCHAR NOT NULL,
        type VARCHAR NOT NULL, sort INTEGER
      );
      CREATE TABLE IF NOT EXISTS cms.items (
        rowid BIGINT PRIMARY KEY, collection VARCHAR NOT NULL, data VARCHAR NOT NULL,
        sort INTEGER, status VARCHAR DEFAULT 'published',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS loyalty.accounts (
        id VARCHAR PRIMARY KEY, contact_wallet VARCHAR NOT NULL,
        points_balance INTEGER DEFAULT 0, tier VARCHAR DEFAULT 'standard',
        date_entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        deleted BOOLEAN DEFAULT false
      );
      CREATE TABLE IF NOT EXISTS loyalty.points_transactions (
        id VARCHAR PRIMARY KEY, loyalty_account_id VARCHAR NOT NULL,
        points INTEGER NOT NULL, reason VARCHAR,
        date_entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        deleted BOOLEAN DEFAULT false
      );
      CREATE SCHEMA IF NOT EXISTS mes;
      CREATE TABLE IF NOT EXISTS mes.machines (
        id BIGINT PRIMARY KEY, name VARCHAR NOT NULL,
        state VARCHAR NOT NULL DEFAULT 'idle',
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS mes.production_orders (
        id BIGINT PRIMARY KEY, ref VARCHAR NOT NULL, machine_id BIGINT NOT NULL,
        customer_wallet VARCHAR, party_size INTEGER,
        scheduled_start TIMESTAMP NOT NULL, scheduled_end TIMESTAMP NOT NULL,
        status VARCHAR NOT NULL DEFAULT 'planned',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    ''');
    await execute('ALTER TABLE erp.llx_commande ADD COLUMN IF NOT EXISTS fk_statut INTEGER DEFAULT 0;');
    await execute('ALTER TABLE erp.llx_socpeople ADD COLUMN IF NOT EXISTS phone_mobile VARCHAR;');
    await execute('ALTER TABLE erp.llx_societe ADD COLUMN IF NOT EXISTS is_merchant BOOLEAN DEFAULT false;');
    for (final product in dintaifungMenu) {
      await saveProduct(
        id: product['id'] as int,
        ref: product['ref'] as String,
        label: product['label'] as String,
        price: product['price'] as double,
        tax: product['tva_tx'] as double,
        stock: product['stock'] as double,
      );
    }
  }

  Future<void> execute(String sql) async {
    await _promise(js_util.callMethod(_bridge, 'exec', [sql]));
  }

  Future<void> upsertOrder(OrderPayload payload) async {
    final companyId = payload.thirdparty['id'] as int;
    final contactId = payload.contact['id'] as int;
    final orderId = payload.order['id'] as int;
    await execute('''
      INSERT INTO erp.llx_societe (rowid, nom, code_client, email)
      VALUES ($companyId, ${_q(payload.thirdparty['name'])}, ${_q(payload.thirdparty['code'])}, ${_q(payload.thirdparty['email'])})
      ON CONFLICT (rowid) DO UPDATE SET nom = EXCLUDED.nom, code_client = EXCLUDED.code_client, email = EXCLUDED.email, updated_at = now();
      INSERT INTO erp.llx_socpeople (rowid, fk_soc, firstname, lastname)
      VALUES ($contactId, $companyId, ${_q(payload.contact['firstname'])}, ${_q(payload.contact['lastname'])})
      ON CONFLICT (rowid) DO UPDATE SET fk_soc = EXCLUDED.fk_soc, firstname = EXCLUDED.firstname, lastname = EXCLUDED.lastname, updated_at = now();
      INSERT INTO erp.llx_commande (rowid, ref, fk_soc, total_ht, total_ttc, fk_statut)
      VALUES ($orderId, ${_q(payload.order['ref'])}, $companyId, ${payload.order['total_ht']}, ${payload.order['total_ttc']}, 0)
      ON CONFLICT (rowid) DO UPDATE SET ref = EXCLUDED.ref, fk_soc = EXCLUDED.fk_soc, total_ht = EXCLUDED.total_ht, total_ttc = EXCLUDED.total_ttc, updated_at = now();
    ''');
    for (var index = 0; index < payload.lines.length; index++) {
      final line = payload.lines[index];
      final product = Map<String, dynamic>.from(line['product'] as Map);
      final lineId = orderId * 100 + index;
      await execute('''
        INSERT INTO erp.llx_product (rowid, ref, label, price, tva_tx, stock)
        VALUES (${product['id']}, ${_q(product['ref'])}, ${_q(product['label'])}, ${product['price']}, ${product['tva_tx']}, ${product['stock']})
        ON CONFLICT (rowid) DO UPDATE SET ref = EXCLUDED.ref, label = EXCLUDED.label, price = EXCLUDED.price, tva_tx = EXCLUDED.tva_tx, stock = EXCLUDED.stock, updated_at = now();
        INSERT INTO erp.llx_commandedet (rowid, fk_commande, fk_product, qty, subprice, total_ht, total_ttc)
        VALUES ($lineId, $orderId, ${product['id']}, ${line['quantity']}, ${product['price']}, ${line['total_ht']}, ${line['total_ttc']})
        ON CONFLICT (rowid) DO UPDATE SET fk_product = EXCLUDED.fk_product, qty = EXCLUDED.qty, subprice = EXCLUDED.subprice, total_ht = EXCLUDED.total_ht, total_ttc = EXCLUDED.total_ttc;
      ''');
    }
  }

  Future<void> registerMerchant(String name) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO erp.llx_societe (rowid, nom, is_merchant) VALUES ($id, ${_q(name)}, true);
    ''');
  }

  Future<int> orderCount() async => int.parse(await _queryScalar('SELECT COUNT(*) FROM erp.llx_commande'));
  Future<int> productCount() async => int.parse(await _queryScalar('SELECT COUNT(*) FROM erp.llx_product'));

  Future<void> updateOrderStatus(int orderId, int status) async {
    await execute('UPDATE erp.llx_commande SET fk_statut = $status, updated_at = now() WHERE rowid = $orderId;');
  }

  Future<List<Map<String, dynamic>>> rows(String sql) async {
    final raw = await _promise(js_util.callMethod(_bridge, 'queryRows', [sql]));
    return (jsonDecode(raw as String) as List).map((row) => Map<String, dynamic>.from(row as Map)).toList();
  }

  Future<void> saveProduct({int? id, required String ref, required String label, required double price, required double tax, required double stock}) async {
    final productId = id ?? DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO erp.llx_product (rowid, ref, label, price, tva_tx, stock)
      VALUES ($productId, ${_q(ref)}, ${_q(label)}, $price, $tax, $stock)
      ON CONFLICT (rowid) DO UPDATE SET ref = EXCLUDED.ref, label = EXCLUDED.label, price = EXCLUDED.price, tva_tx = EXCLUDED.tva_tx, stock = EXCLUDED.stock, updated_at = now();
    ''');
  }

  Future<Uint8List> exportParquet() async {
    await _promise(js_util.callMethod(_bridge, 'exportParquet', const []));
    final base64 = await _promise(js_util.callMethod(_bridge, 'readExportBase64', const []));
    return Uint8List.fromList(base64Decode(base64 as String));
  }

  Future<int> ensureChannelRoom(String channelCode) async {
    final existing = await rows(
        "SELECT rowid FROM chat.rc_rooms WHERE channel_code = ${_q(channelCode)} AND t = 'c'");
    if (existing.isNotEmpty) return existing.first['rowid'] as int;
    final roomId = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO chat.rc_rooms (rowid, t, channel_code, name)
      VALUES ($roomId, 'c', ${_q(channelCode)}, ${_q('Channel $channelCode')});
    ''');
    return roomId;
  }

  Future<int> ensureLivechatRoom(String channelCode, String visitorWallet) async {
    final existing = await rows(
        "SELECT rowid FROM chat.rc_rooms WHERE channel_code = ${_q(channelCode)} AND visitor_wallet = ${_q(visitorWallet)} AND t = 'l'");
    if (existing.isNotEmpty) return existing.first['rowid'] as int;
    final roomId = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO chat.rc_rooms (rowid, t, channel_code, visitor_wallet, name)
      VALUES ($roomId, 'l', ${_q(channelCode)}, ${_q(visitorWallet)}, ${_q('Visitor $visitorWallet')});
    ''');
    return roomId;
  }

  Future<void> addSubscription(int roomId, String wallet, {String role = 'member'}) async {
    final existing = await rows(
        'SELECT rowid FROM chat.rc_subscriptions WHERE fk_room = $roomId AND wallet = ${_q(wallet)}');
    if (existing.isNotEmpty) return;
    final subId = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO chat.rc_subscriptions (rowid, fk_room, wallet, role)
      VALUES ($subId, $roomId, ${_q(wallet)}, ${_q(role)});
    ''');
  }

  Future<List<Map<String, dynamic>>> subscriptions(int roomId) =>
      rows('SELECT * FROM chat.rc_subscriptions WHERE fk_room = $roomId ORDER BY joined_at');

  Future<List<Map<String, dynamic>>> livechatRooms(String channelCode) => rows(
      "SELECT * FROM chat.rc_rooms WHERE channel_code = ${_q(channelCode)} AND t = 'l' ORDER BY last_message_at DESC NULLS LAST");

  Future<void> insertMessage(
      {required int roomId, String? wallet, required String type, required String body}) async {
    final msgId = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO chat.rc_messages (rowid, fk_room, wallet, t, body)
      VALUES ($msgId, $roomId, ${wallet == null ? 'NULL' : _q(wallet)}, ${_q(type)}, ${_q(body)});
      UPDATE chat.rc_rooms SET last_message_at = now(), updated_at = now() WHERE rowid = $roomId;
    ''');
  }

  Future<List<Map<String, dynamic>>> messages(int roomId, {String? type}) => rows(
      'SELECT * FROM chat.rc_messages WHERE fk_room = $roomId'
      '${type != null ? " AND t = ${_q(type)}" : ''}'
      ' ORDER BY created_at');

  Future<void> saveProductLang(
      {required int productId, required String lang, String? label, String? description}) async {
    final existing = await rows(
        'SELECT rowid FROM erp.llx_product_lang WHERE fk_product = $productId AND lang = ${_q(lang)}');
    if (existing.isNotEmpty) {
      await execute('''
        UPDATE erp.llx_product_lang SET label = ${label == null ? 'NULL' : _q(label)},
          description = ${description == null ? 'NULL' : _q(description)}, updated_at = now()
        WHERE rowid = ${existing.first['rowid']};
      ''');
    } else {
      await execute('''
        INSERT INTO erp.llx_product_lang (rowid, fk_product, lang, label, description)
        VALUES (${DateTime.now().millisecondsSinceEpoch}, $productId, ${_q(lang)}, ${label == null ? 'NULL' : _q(label)}, ${description == null ? 'NULL' : _q(description)});
      ''');
    }
  }

  Future<List<Map<String, dynamic>>> productLangs(int productId) =>
      rows('SELECT * FROM erp.llx_product_lang WHERE fk_product = $productId ORDER BY lang');

  Future<int> ensureCollection(String id) async {
    final existing = await rows('SELECT id FROM cms.collections WHERE id = ${_q(id)}');
    if (existing.isEmpty) {
      await execute("INSERT INTO cms.collections (id) VALUES (${_q(id)});");
    }
    return 1;
  }

  Future<void> saveCmsItem({int? id, required String collection, required Map<String, dynamic> data}) async {
    await ensureCollection(collection);
    final json = _q(jsonEncode(data));
    if (id != null) {
      await execute('''
        UPDATE cms.items SET data = $json, updated_at = now() WHERE rowid = $id;
      ''');
    } else {
      final itemId = DateTime.now().millisecondsSinceEpoch;
      await execute('''
        INSERT INTO cms.items (rowid, collection, data) VALUES ($itemId, ${_q(collection)}, $json);
      ''');
    }
  }

  Future<List<Map<String, dynamic>>> cmsItems(String collection) async {
    final raw = await rows(
        "SELECT * FROM cms.items WHERE collection = ${_q(collection)} ORDER BY sort, rowid");
    return raw.map((row) {
      final data = Map<String, dynamic>.from(jsonDecode(row['data'].toString()) as Map);
      return {'rowid': row['rowid'], 'collection': row['collection'], ...data};
    }).toList();
  }

  Future<void> deleteCmsItem(int id) async {
    await execute('DELETE FROM cms.items WHERE rowid = $id;');
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toRadixString(16);

  Future<String> ensureLoyaltyAccount(String wallet) async {
    final existing = await rows(
        'SELECT id FROM loyalty.accounts WHERE contact_wallet = ${_q(wallet)} AND deleted = false');
    if (existing.isNotEmpty) return existing.first['id'].toString();
    final id = _newId();
    await execute('''
      INSERT INTO loyalty.accounts (id, contact_wallet) VALUES (${_q(id)}, ${_q(wallet)});
    ''');
    return id;
  }

  String _tierFor(int balance) => balance >= 2000 ? 'gold' : balance >= 500 ? 'silver' : 'standard';

  Future<void> _applyPointsDelta(String wallet, int delta, String reason) async {
    final accountId = await ensureLoyaltyAccount(wallet);
    final account = await rows('SELECT points_balance FROM loyalty.accounts WHERE id = ${_q(accountId)}');
    final current = (account.first['points_balance'] as num?)?.toInt() ?? 0;
    final next = current + delta;
    if (next < 0) throw Exception('Insufficient points balance');
    await execute('''
      INSERT INTO loyalty.points_transactions (id, loyalty_account_id, points, reason)
      VALUES (${_q(_newId())}, ${_q(accountId)}, $delta, ${_q(reason)});
      UPDATE loyalty.accounts SET points_balance = $next, tier = ${_q(_tierFor(next))}, date_modified = now()
      WHERE id = ${_q(accountId)};
    ''');
  }

  Future<void> earnPoints(String wallet, int points, String reason) =>
      _applyPointsDelta(wallet, points, reason);

  Future<void> redeemPoints(String wallet, int points, String reason) =>
      _applyPointsDelta(wallet, -points, reason);

  Future<Map<String, dynamic>?> loyaltyAccount(String wallet) async {
    final result = await rows(
        'SELECT * FROM loyalty.accounts WHERE contact_wallet = ${_q(wallet)} AND deleted = false');
    return result.isEmpty ? null : result.first;
  }

  Future<List<Map<String, dynamic>>> loyaltyAccounts() =>
      rows('SELECT * FROM loyalty.accounts WHERE deleted = false ORDER BY date_modified DESC');

  Future<List<Map<String, dynamic>>> loyaltyHistory(String wallet) async {
    final account = await loyaltyAccount(wallet);
    if (account == null) return [];
    return rows(
        "SELECT * FROM loyalty.points_transactions WHERE loyalty_account_id = ${_q(account['id'].toString())} ORDER BY date_entered DESC");
  }

  Future<void> seedMachines(int count) async {
    final existing = await rows('SELECT COUNT(*) AS c FROM mes.machines');
    var next = ((existing.first['c'] as num?)?.toInt() ?? 0) + 1;
    for (var i = 0; i < count; i++) {
      final id = DateTime.now().millisecondsSinceEpoch + i;
      await execute('''
        INSERT INTO mes.machines (id, name) VALUES ($id, ${_q('Table $next')});
      ''');
      next++;
    }
  }

  Future<List<Map<String, dynamic>>> machines() =>
      rows('SELECT * FROM mes.machines ORDER BY name');

  Future<void> setMachineState(int id, String state) async {
    await execute("UPDATE mes.machines SET state = ${_q(state)}, updated_at = now() WHERE id = $id;");
  }

  Future<bool> hasOverlap(int machineId, DateTime start, DateTime end) async {
    final overlapping = await rows('''
      SELECT id FROM mes.production_orders
      WHERE machine_id = $machineId AND status NOT IN ('completed', 'canceled')
        AND scheduled_start < TIMESTAMP '${end.toIso8601String()}'
        AND scheduled_end > TIMESTAMP '${start.toIso8601String()}'
    ''');
    return overlapping.isNotEmpty;
  }

  Future<int> createBooking({
    required int machineId,
    required String customerWallet,
    required int partySize,
    required DateTime start,
    required DateTime end,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO mes.production_orders
        (id, ref, machine_id, customer_wallet, party_size, scheduled_start, scheduled_end)
      VALUES ($id, ${_q('BK-$id')}, $machineId, ${_q(customerWallet)}, $partySize,
        TIMESTAMP '${start.toIso8601String()}', TIMESTAMP '${end.toIso8601String()}');
    ''');
    return id;
  }

  Future<void> updateBookingStatus(int id, String status) async {
    final order = await rows('SELECT machine_id FROM mes.production_orders WHERE id = $id');
    if (order.isEmpty) return;
    await execute('''
      UPDATE mes.production_orders SET status = ${_q(status)}, updated_at = now() WHERE id = $id;
    ''');
    final machineId = order.first['machine_id'] as int;
    if (status == 'in_progress') {
      await setMachineState(machineId, 'occupied');
    } else if (status == 'completed' || status == 'canceled') {
      final machine = await rows('SELECT state FROM mes.machines WHERE id = $machineId');
      if (machine.isNotEmpty && machine.first['state'] != 'maintenance') {
        await setMachineState(machineId, 'idle');
      }
    }
  }

  Future<List<Map<String, dynamic>>> bookings() =>
      rows('SELECT * FROM mes.production_orders ORDER BY scheduled_start DESC');

  static const _dumpTables = [
    'erp.llx_societe', 'erp.llx_socpeople', 'erp.llx_commande', 'erp.llx_product', 'erp.llx_commandedet',
    'erp.llx_product_lang', 'chat.rc_rooms', 'chat.rc_subscriptions', 'chat.rc_messages',
    'cms.collections', 'cms.fields', 'cms.items',
    'loyalty.accounts', 'loyalty.points_transactions',
    'mes.machines', 'mes.production_orders'
  ];

  Future<Map<String, dynamic>> dumpAll() async {
    final dump = <String, dynamic>{};
    for (final table in _dumpTables) {
      dump[table] = await rows('SELECT * FROM $table');
    }
    return dump;
  }

  Future<void> restoreAll(Map<String, dynamic> dump) async {
    for (final table in _dumpTables) {
      await execute('DELETE FROM $table;');
      final tableRows = (dump[table] as List? ?? const []);
      for (final row in tableRows) {
        final map = Map<String, dynamic>.from(row as Map);
        final columns = map.keys.toList();
        final values = columns.map((c) => _sqlValue(map[c])).join(', ');
        await execute('INSERT INTO $table (${columns.join(', ')}) VALUES ($values);');
      }
    }
  }

  Future<void> resetAll() async {
    for (final table in _dumpTables) {
      await execute('DELETE FROM $table;');
    }
  }

  String _sqlValue(dynamic value) {
    if (value == null) return 'NULL';
    if (value is num) return value.toString();
    if (value is bool) return value.toString();
    return _q(value);
  }

  String _q(Object? value) => "'${value.toString().replaceAll("'", "''")}'";

  Future<String> _queryScalar(String sql) async {
    final result = await _promise(js_util.callMethod(_bridge, 'queryScalar', [sql]));
    return result.toString();
  }

  Future<dynamic> _promise(dynamic value) => js_util.promiseToFuture(value);
}

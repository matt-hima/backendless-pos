import 'dart:convert';
import 'dart:typed_data';
import 'dart:js_util' as js_util;
import '../models/order_payload.dart';

class DatabaseService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'DuckDBBridge');

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
        photo VARCHAR, photo_mime VARCHAR,
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
      CREATE TABLE IF NOT EXISTS erp.llx_categorie (
        rowid BIGINT PRIMARY KEY, entity INTEGER DEFAULT 1, fk_parent BIGINT,
        label VARCHAR NOT NULL, type SMALLINT DEFAULT 0, description VARCHAR,
        visible SMALLINT DEFAULT 1, color VARCHAR(8) DEFAULT '#3F7FC7',
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS erp.llx_categorie_product (
        fk_categorie BIGINT NOT NULL, fk_product BIGINT NOT NULL,
        PRIMARY KEY (fk_categorie, fk_product)
      );
      CREATE TABLE IF NOT EXISTS erp.llx_c_paiement (
        code VARCHAR PRIMARY KEY, libelle VARCHAR NOT NULL, active SMALLINT DEFAULT 1
      );
      CREATE TABLE IF NOT EXISTS erp.llx_facture (
        rowid BIGINT PRIMARY KEY, entity INTEGER DEFAULT 1, ref VARCHAR NOT NULL,
        fk_soc BIGINT NOT NULL, type SMALLINT DEFAULT 0, fk_statut SMALLINT DEFAULT 1,
        paye SMALLINT DEFAULT 0, total_ht DOUBLE, total_tva DOUBLE, total_ttc DOUBLE,
        datef TIMESTAMP DEFAULT CURRENT_TIMESTAMP, module_source VARCHAR,
        pos_source VARCHAR, fk_facture_source BIGINT,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS erp.llx_facturedet (
        rowid BIGINT PRIMARY KEY, fk_facture BIGINT NOT NULL, fk_product BIGINT,
        qty DOUBLE NOT NULL, subprice DOUBLE NOT NULL, tva_tx DOUBLE DEFAULT 0,
        total_ht DOUBLE NOT NULL, total_ttc DOUBLE NOT NULL, description VARCHAR
      );
      CREATE TABLE IF NOT EXISTS erp.llx_paiement (
        rowid BIGINT PRIMARY KEY, entity INTEGER DEFAULT 1,
        datep TIMESTAMP DEFAULT CURRENT_TIMESTAMP, amount DOUBLE NOT NULL,
        fk_payment VARCHAR, num_payment VARCHAR, note VARCHAR
      );
      CREATE TABLE IF NOT EXISTS erp.llx_paiement_facture (
        fk_paiement BIGINT NOT NULL, fk_facture BIGINT NOT NULL, amount DOUBLE NOT NULL
      );
      CREATE TABLE IF NOT EXISTS erp.llx_pos_cash_fence (
        rowid BIGINT PRIMARY KEY, entity INTEGER DEFAULT 1, ref VARCHAR,
        opening DOUBLE DEFAULT 0, cash DOUBLE, card DOUBLE, cheque DOUBLE,
        status SMALLINT DEFAULT 0, date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        date_valid TIMESTAMP, day_close INTEGER, month_close INTEGER, year_close INTEGER,
        posmodule VARCHAR DEFAULT 'takepos', posnumber VARCHAR DEFAULT '1',
        fk_user_create VARCHAR, fk_user_valid VARCHAR
      );
      CREATE TABLE IF NOT EXISTS erp.llx_const (
        rowid BIGINT PRIMARY KEY, entity INTEGER DEFAULT 1, name VARCHAR NOT NULL,
        value VARCHAR, type VARCHAR DEFAULT 'chaine', note VARCHAR
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
      CREATE SCHEMA IF NOT EXISTS iam;
      CREATE TABLE IF NOT EXISTS iam.realm (
        id VARCHAR PRIMARY KEY, name VARCHAR NOT NULL
      );
      CREATE TABLE IF NOT EXISTS iam.users (
        id VARCHAR PRIMARY KEY, display_name VARCHAR, enabled BOOLEAN DEFAULT true,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS iam.roles (
        id VARCHAR PRIMARY KEY, name VARCHAR NOT NULL, description VARCHAR,
        is_builtin BOOLEAN DEFAULT false
      );
      CREATE TABLE IF NOT EXISTS iam.role_permissions (
        rowid BIGINT PRIMARY KEY, role_id VARCHAR NOT NULL, permission VARCHAR NOT NULL
      );
      CREATE TABLE IF NOT EXISTS iam.user_role_mapping (
        rowid BIGINT PRIMARY KEY, user_id VARCHAR NOT NULL, role_id VARCHAR NOT NULL,
        granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    ''');
    // Keep existing local databases compatible with the product-photo fields.
    for (final statement in [
      'ALTER TABLE erp.llx_product ADD COLUMN photo VARCHAR',
      'ALTER TABLE erp.llx_product ADD COLUMN photo_mime VARCHAR',
    ]) {
      try {
        await execute(statement);
      } catch (_) {
        // DuckDB reports an error when the migration column already exists.
      }
    }
    await execute(
      'ALTER TABLE erp.llx_commande ADD COLUMN IF NOT EXISTS fk_statut INTEGER DEFAULT 0;',
    );
    await execute(
      'ALTER TABLE erp.llx_socpeople ADD COLUMN IF NOT EXISTS phone_mobile VARCHAR;',
    );
    await execute(
      'ALTER TABLE erp.llx_societe ADD COLUMN IF NOT EXISTS is_merchant BOOLEAN DEFAULT false;',
    );
    await execute(
      'ALTER TABLE erp.llx_product ADD COLUMN IF NOT EXISTS tax_included BOOLEAN DEFAULT true;',
    );
    await execute('''
      DELETE FROM erp.llx_commandedet WHERE fk_commande IN (SELECT rowid FROM erp.llx_commande WHERE ref LIKE 'MOCK-%');
      DELETE FROM erp.llx_commande WHERE ref LIKE 'MOCK-%';
    ''');
    await _seedBuiltinRoles();
    await _seedPaymentTypes();
  }

  Future<void> _seedPaymentTypes() async {
    const types = {'LIQ': 'Cash', 'CB': 'Card', 'VIR': 'Other'};
    for (final entry in types.entries) {
      await execute('''
        INSERT INTO erp.llx_c_paiement (code, libelle) VALUES (${_q(entry.key)}, ${_q(entry.value)})
        ON CONFLICT (code) DO NOTHING;
      ''');
    }
  }

  static const permissionCatalog = [
    'overview.view',
    'register.use',
    'customers.manage',
    'products.manage',
    'orders.manage',
    'content.manage',
    'loyalty.manage',
    'bookings.manage',
    'support.manage',
    'connection.manage',
    'settings.manage',
  ];

  static const _builtinRoles = {
    'owner': permissionCatalog,
    'manager': [
      'overview.view',
      'register.use',
      'customers.manage',
      'products.manage',
      'orders.manage',
      'content.manage',
      'loyalty.manage',
      'bookings.manage',
      'support.manage',
      'connection.manage',
    ],
    'staff': [
      'overview.view',
      'register.use',
      'orders.manage',
      'bookings.manage',
      'support.manage',
    ],
  };

  Future<void> _seedBuiltinRoles() async {
    final existing = await rows(
      "SELECT id FROM iam.roles WHERE is_builtin = true",
    );
    final existingIds = existing.map((r) => r['id'].toString()).toSet();
    for (final entry in _builtinRoles.entries) {
      if (existingIds.contains(entry.key)) continue;
      final displayName =
          '${entry.key[0].toUpperCase()}${entry.key.substring(1)}';
      await execute('''
        INSERT INTO iam.roles (id, name, description, is_builtin)
        VALUES (${_q(entry.key)}, ${_q(displayName)}, ${_q('Built-in role')}, true);
      ''');
      for (final permission in entry.value) {
        await execute('''
          INSERT INTO iam.role_permissions (rowid, role_id, permission)
          VALUES (${_nextId()}, ${_q(entry.key)}, ${_q(permission)});
        ''');
      }
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

  Future<int> orderCount() async =>
      int.parse(await _queryScalar('SELECT COUNT(*) FROM erp.llx_commande'));
  Future<int> productCount() async =>
      int.parse(await _queryScalar('SELECT COUNT(*) FROM erp.llx_product'));

  Future<void> updateOrderStatus(int orderId, int status) async {
    await execute(
      'UPDATE erp.llx_commande SET fk_statut = $status, updated_at = now() WHERE rowid = $orderId;',
    );
  }

  Future<List<Map<String, dynamic>>> rows(String sql) async {
    final raw = await _promise(js_util.callMethod(_bridge, 'queryRows', [sql]));
    return (jsonDecode(raw as String) as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }

  Future<void> saveProduct({
    int? id,
    required String ref,
    required String label,
    required double price,
    required double tax,
    required double stock,
    String? photo,
    String? photoMime,
    int? categoryId,
    bool taxIncluded = true,
  }) async {
    final productId = id ?? DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO erp.llx_product
        (rowid, ref, label, price, tva_tx, photo, photo_mime, stock, tax_included)
      VALUES (
        $productId, ${_q(ref)}, ${_q(label)}, $price, $tax,
        ${photo == null ? 'NULL' : _q(photo)},
        ${photoMime == null ? 'NULL' : _q(photoMime)},
        $stock, $taxIncluded
      )
      ON CONFLICT (rowid) DO UPDATE SET
        ref = EXCLUDED.ref, label = EXCLUDED.label, price = EXCLUDED.price,
        tva_tx = EXCLUDED.tva_tx, photo = EXCLUDED.photo,
        photo_mime = EXCLUDED.photo_mime,
        stock = EXCLUDED.stock, tax_included = EXCLUDED.tax_included, updated_at = now();
    ''');
    if (categoryId != null) await setProductCategory(productId, categoryId);
  }

  // --- Categories (Dolibarr llx_categorie / llx_categorie_product) ---

  Future<void> saveCategory({
    int? id,
    required String label,
    required String color,
    int? parentId,
  }) async {
    final categoryId = id ?? DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO erp.llx_categorie (rowid, label, color, fk_parent, type)
      VALUES ($categoryId, ${_q(label)}, ${_q(color)}, ${parentId ?? 'NULL'}, 0)
      ON CONFLICT (rowid) DO UPDATE SET
        label = EXCLUDED.label, color = EXCLUDED.color, fk_parent = EXCLUDED.fk_parent,
        updated_at = now();
    ''');
  }

  Future<List<Map<String, dynamic>>> categories() =>
      rows('SELECT * FROM erp.llx_categorie WHERE type = 0 ORDER BY label');

  Future<void> deleteCategory(int id) async {
    await execute('DELETE FROM erp.llx_categorie_product WHERE fk_categorie = $id;');
    await execute('DELETE FROM erp.llx_categorie WHERE rowid = $id;');
  }

  Future<int> ensureCategory(String label) async {
    final existing = await rows(
      'SELECT rowid FROM erp.llx_categorie WHERE label = ${_q(label)} AND type = 0',
    );
    if (existing.isNotEmpty) return existing.first['rowid'] as int;
    final id = DateTime.now().millisecondsSinceEpoch + (_idSeq++ % 1000);
    await saveCategory(id: id, label: label, color: '#3F7FC7');
    return id;
  }

  Future<void> setProductCategory(int productId, int? categoryId) async {
    await execute(
      'DELETE FROM erp.llx_categorie_product WHERE fk_product = $productId;',
    );
    if (categoryId != null) {
      await execute('''
        INSERT INTO erp.llx_categorie_product (fk_categorie, fk_product)
        VALUES ($categoryId, $productId);
      ''');
    }
  }

  // --- POS settings (Dolibarr llx_const) ---

  Future<void> setSetting(String name, String value) async {
    final existing = await rows(
      'SELECT rowid FROM erp.llx_const WHERE name = ${_q(name)}',
    );
    if (existing.isNotEmpty) {
      await execute(
        'UPDATE erp.llx_const SET value = ${_q(value)} WHERE rowid = ${existing.first['rowid']};',
      );
    } else {
      await execute('''
        INSERT INTO erp.llx_const (rowid, name, value) VALUES (${_nextId()}, ${_q(name)}, ${_q(value)});
      ''');
    }
  }

  Future<Map<String, String>> settingsMap() async {
    final result = await rows('SELECT name, value FROM erp.llx_const');
    return {
      for (final row in result) row['name'].toString(): row['value'].toString(),
    };
  }

  // --- Register till (Dolibarr llx_pos_cash_fence) ---

  Future<int> ensureWalkInCustomer() async {
    const walkInId = 999999000;
    final existing = await rows(
      'SELECT rowid FROM erp.llx_societe WHERE rowid = $walkInId',
    );
    if (existing.isEmpty) {
      await execute('''
        INSERT INTO erp.llx_societe (rowid, nom, code_client, is_merchant)
        VALUES ($walkInId, ${_q('Walk-in customer')}, ${_q('WALKIN')}, false);
      ''');
    }
    return walkInId;
  }

  Future<int> openRegisterSession({
    required double openingFloat,
    required String operator,
  }) async {
    final active = await activeRegisterSession();
    if (active != null) return active['rowid'] as int;
    final id = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO erp.llx_pos_cash_fence (rowid, ref, opening, status, fk_user_create)
      VALUES ($id, ${_q('CF-$id')}, $openingFloat, 0, ${_q(operator)});
    ''');
    return id;
  }

  Future<Map<String, dynamic>?> activeRegisterSession() async {
    final result = await rows(
      'SELECT * FROM erp.llx_pos_cash_fence WHERE status = 0 ORDER BY date_creation DESC LIMIT 1',
    );
    return result.isEmpty ? null : result.first;
  }

  Future<void> closeRegisterSession({
    required int id,
    required double cash,
    required double card,
    required double cheque,
    required String operator,
  }) async {
    final now = DateTime.now();
    await execute('''
      UPDATE erp.llx_pos_cash_fence SET
        status = 1, date_valid = now(), cash = $cash, card = $card, cheque = $cheque,
        day_close = ${now.day}, month_close = ${now.month}, year_close = ${now.year},
        fk_user_valid = ${_q(operator)}
      WHERE rowid = $id;
    ''');
  }

  Future<List<Map<String, dynamic>>> registerSessions() =>
      rows('SELECT * FROM erp.llx_pos_cash_fence ORDER BY date_creation DESC');

  Future<List<Map<String, dynamic>>> paymentTypes() =>
      rows("SELECT * FROM erp.llx_c_paiement WHERE active = 1 ORDER BY code");

  Future<List<Map<String, dynamic>>> posSales() => rows('''
    SELECT f.rowid, f.ref, f.total_ttc, f.datef, f.pos_source, pm.fk_payment AS payment_code,
           EXISTS(
             SELECT 1 FROM erp.llx_facture r WHERE r.fk_facture_source = f.rowid AND r.type = 2
           ) AS refunded
    FROM erp.llx_facture f
    LEFT JOIN erp.llx_paiement_facture pf ON pf.fk_facture = f.rowid
    LEFT JOIN erp.llx_paiement pm ON pm.rowid = pf.fk_paiement
    WHERE f.type = 0 AND f.module_source = 'takepos'
    ORDER BY f.datef DESC
    LIMIT 100
  ''');

  // --- POS sales (Dolibarr llx_facture / llx_facturedet / llx_paiement) ---

  Future<int> recordPosSale({
    required List<Map<String, dynamic>> lines,
    required String paymentCode,
    int? registerSessionId,
  }) async {
    final customerId = await ensureWalkInCustomer();
    final factureId = DateTime.now().millisecondsSinceEpoch;
    var totalHt = 0.0;
    var totalTtc = 0.0;
    for (final line in lines) {
      totalHt += line['total_ht'] as double;
      totalTtc += line['total_ttc'] as double;
    }
    await execute('''
      INSERT INTO erp.llx_facture
        (rowid, ref, fk_soc, type, fk_statut, paye, total_ht, total_tva, total_ttc, module_source, pos_source)
      VALUES (
        $factureId, ${_q('POS$factureId')}, $customerId, 0, 1, 1,
        $totalHt, ${totalTtc - totalHt}, $totalTtc,
        'takepos', ${registerSessionId == null ? 'NULL' : _q(registerSessionId.toString())}
      );
    ''');
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      final lineId = factureId * 100 + index;
      final productId = line['product_id'] as int;
      final qty = line['qty'] as double;
      await execute('''
        INSERT INTO erp.llx_facturedet (rowid, fk_facture, fk_product, qty, subprice, tva_tx, total_ht, total_ttc, description)
        VALUES ($lineId, $factureId, $productId, $qty, ${line['price']}, ${line['tva_tx']}, ${line['total_ht']}, ${line['total_ttc']}, ${_q(line['label'].toString())});
        UPDATE erp.llx_product SET stock = stock - $qty, updated_at = now() WHERE rowid = $productId;
      ''');
    }
    final paiementId = DateTime.now().millisecondsSinceEpoch + 1;
    await execute('''
      INSERT INTO erp.llx_paiement (rowid, amount, fk_payment) VALUES ($paiementId, $totalTtc, ${_q(paymentCode)});
      INSERT INTO erp.llx_paiement_facture (fk_paiement, fk_facture, amount) VALUES ($paiementId, $factureId, $totalTtc);
    ''');
    return factureId;
  }

  Future<List<Map<String, dynamic>>> dailySales({DateTime? since}) => rows('''
    SELECT CAST(datef AS DATE) AS day, SUM(total_ttc) AS total
    FROM erp.llx_facture
    WHERE module_source = 'takepos'
    ${since == null ? '' : "AND datef >= TIMESTAMP '${since.toIso8601String()}'"}
    GROUP BY 1 ORDER BY 1
  ''');

  Future<List<Map<String, dynamic>>> salesByCategory({DateTime? since}) => rows('''
    SELECT COALESCE(cat.label, 'Uncategorized') AS label, SUM(d.total_ttc) AS total, SUM(d.qty) AS qty
    FROM erp.llx_facturedet d
    JOIN erp.llx_facture f ON f.rowid = d.fk_facture
    LEFT JOIN erp.llx_categorie_product cp ON cp.fk_product = d.fk_product
    LEFT JOIN erp.llx_categorie cat ON cat.rowid = cp.fk_categorie
    WHERE f.module_source = 'takepos'
    ${since == null ? '' : "AND f.datef >= TIMESTAMP '${since.toIso8601String()}'"}
    GROUP BY 1 ORDER BY total DESC
  ''');

  Future<List<Map<String, dynamic>>> salesByProduct({DateTime? since}) => rows('''
    SELECT p.label AS label, SUM(d.total_ttc) AS total, SUM(d.qty) AS qty
    FROM erp.llx_facturedet d
    JOIN erp.llx_facture f ON f.rowid = d.fk_facture
    JOIN erp.llx_product p ON p.rowid = d.fk_product
    WHERE f.module_source = 'takepos'
    ${since == null ? '' : "AND f.datef >= TIMESTAMP '${since.toIso8601String()}'"}
    GROUP BY 1 ORDER BY total DESC
  ''');

  Future<bool> isRefunded(int factureId) async {
    final result = await rows(
      'SELECT rowid FROM erp.llx_facture WHERE fk_facture_source = $factureId AND type = 2',
    );
    return result.isNotEmpty;
  }

  Future<void> refundPosSale(int factureId) async {
    final source = await rows(
      'SELECT * FROM erp.llx_facture WHERE rowid = $factureId',
    );
    if (source.isEmpty) return;
    final facture = source.first;
    final lines = await rows(
      'SELECT * FROM erp.llx_facturedet WHERE fk_facture = $factureId',
    );
    final refundId = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO erp.llx_facture
        (rowid, ref, fk_soc, type, fk_statut, paye, total_ht, total_tva, total_ttc, module_source, fk_facture_source)
      VALUES (
        $refundId, ${_q('${facture['ref']}-AVOIR')}, ${facture['fk_soc']}, 2, 1, 1,
        ${-(facture['total_ht'] as num)}, ${-(facture['total_tva'] as num)}, ${-(facture['total_ttc'] as num)},
        'takepos', $factureId
      );
    ''');
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      final lineId = refundId * 100 + index;
      final productId = line['fk_product'] as int?;
      final qty = (line['qty'] as num).toDouble();
      await execute('''
        INSERT INTO erp.llx_facturedet (rowid, fk_facture, fk_product, qty, subprice, tva_tx, total_ht, total_ttc, description)
        VALUES ($lineId, $refundId, ${productId ?? 'NULL'}, ${-qty}, ${line['subprice']}, ${line['tva_tx']}, ${-(line['total_ht'] as num)}, ${-(line['total_ttc'] as num)}, ${_q((line['description'] ?? '').toString())});
      ''');
      if (productId != null) {
        await execute(
          'UPDATE erp.llx_product SET stock = stock + $qty, updated_at = now() WHERE rowid = $productId;',
        );
      }
    }
  }

  Future<Uint8List> exportParquet() async {
    await _promise(js_util.callMethod(_bridge, 'exportParquet', const []));
    final base64 = await _promise(
      js_util.callMethod(_bridge, 'readExportBase64', const []),
    );
    return Uint8List.fromList(base64Decode(base64 as String));
  }

  Future<int> ensureChannelRoom(String channelCode) async {
    final existing = await rows(
      "SELECT rowid FROM chat.rc_rooms WHERE channel_code = ${_q(channelCode)} AND t = 'c'",
    );
    if (existing.isNotEmpty) return existing.first['rowid'] as int;
    final roomId = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO chat.rc_rooms (rowid, t, channel_code, name)
      VALUES ($roomId, 'c', ${_q(channelCode)}, ${_q('Channel $channelCode')});
    ''');
    return roomId;
  }

  Future<int> ensureLivechatRoom(
    String channelCode,
    String visitorWallet,
  ) async {
    final existing = await rows(
      "SELECT rowid FROM chat.rc_rooms WHERE channel_code = ${_q(channelCode)} AND visitor_wallet = ${_q(visitorWallet)} AND t = 'l'",
    );
    if (existing.isNotEmpty) return existing.first['rowid'] as int;
    final roomId = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO chat.rc_rooms (rowid, t, channel_code, visitor_wallet, name)
      VALUES ($roomId, 'l', ${_q(channelCode)}, ${_q(visitorWallet)}, ${_q('Visitor $visitorWallet')});
    ''');
    return roomId;
  }

  Future<void> addSubscription(
    int roomId,
    String wallet, {
    String role = 'member',
  }) async {
    final existing = await rows(
      'SELECT rowid FROM chat.rc_subscriptions WHERE fk_room = $roomId AND wallet = ${_q(wallet)}',
    );
    if (existing.isNotEmpty) return;
    final subId = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO chat.rc_subscriptions (rowid, fk_room, wallet, role)
      VALUES ($subId, $roomId, ${_q(wallet)}, ${_q(role)});
    ''');
  }

  Future<List<Map<String, dynamic>>> subscriptions(int roomId) => rows(
    'SELECT * FROM chat.rc_subscriptions WHERE fk_room = $roomId ORDER BY joined_at',
  );

  Future<List<Map<String, dynamic>>> livechatRooms(String channelCode) => rows(
    "SELECT * FROM chat.rc_rooms WHERE channel_code = ${_q(channelCode)} AND t = 'l' ORDER BY last_message_at DESC NULLS LAST",
  );

  Future<void> insertMessage({
    required int roomId,
    String? wallet,
    required String type,
    required String body,
  }) async {
    final msgId = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO chat.rc_messages (rowid, fk_room, wallet, t, body)
      VALUES ($msgId, $roomId, ${wallet == null ? 'NULL' : _q(wallet)}, ${_q(type)}, ${_q(body)});
      UPDATE chat.rc_rooms SET last_message_at = now(), updated_at = now() WHERE rowid = $roomId;
    ''');
  }

  Future<List<Map<String, dynamic>>> messages(int roomId, {String? type}) =>
      rows(
        'SELECT * FROM chat.rc_messages WHERE fk_room = $roomId'
        '${type != null ? " AND t = ${_q(type)}" : ''}'
        ' ORDER BY created_at',
      );

  Future<void> saveProductLang({
    required int productId,
    required String lang,
    String? label,
    String? description,
  }) async {
    final existing = await rows(
      'SELECT rowid FROM erp.llx_product_lang WHERE fk_product = $productId AND lang = ${_q(lang)}',
    );
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

  Future<List<Map<String, dynamic>>> productLangs(int productId) => rows(
    'SELECT * FROM erp.llx_product_lang WHERE fk_product = $productId ORDER BY lang',
  );

  Future<int> ensureCollection(String id) async {
    final existing = await rows(
      'SELECT id FROM cms.collections WHERE id = ${_q(id)}',
    );
    if (existing.isEmpty) {
      await execute("INSERT INTO cms.collections (id) VALUES (${_q(id)});");
    }
    return 1;
  }

  Future<void> saveCmsItem({
    int? id,
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    await ensureCollection(collection);
    final json = _q(jsonEncode(data));
    if (id != null) {
      await execute('''
        UPDATE cms.items SET data = $json, updated_at = now() WHERE rowid = $id;
      ''');
    } else {
      final itemId = _nextId();
      await execute('''
        INSERT INTO cms.items (rowid, collection, data) VALUES ($itemId, ${_q(collection)}, $json);
      ''');
    }
  }

  int _idSeq = 0;
  int _nextId() =>
      DateTime.now().millisecondsSinceEpoch * 1000 + (_idSeq++ % 1000);

  Future<List<Map<String, dynamic>>> cmsItems(String collection) async {
    final raw = await rows(
      "SELECT * FROM cms.items WHERE collection = ${_q(collection)} ORDER BY sort, rowid",
    );
    return raw.map((row) {
      final data = Map<String, dynamic>.from(
        jsonDecode(row['data'].toString()) as Map,
      );
      return {'rowid': row['rowid'], 'collection': row['collection'], ...data};
    }).toList();
  }

  Future<void> deleteCmsItem(int id) async {
    await execute('DELETE FROM cms.items WHERE rowid = $id;');
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toRadixString(16);

  Future<String> ensureLoyaltyAccount(String wallet) async {
    final existing = await rows(
      'SELECT id FROM loyalty.accounts WHERE contact_wallet = ${_q(wallet)} AND deleted = false',
    );
    if (existing.isNotEmpty) return existing.first['id'].toString();
    final id = _newId();
    await execute('''
      INSERT INTO loyalty.accounts (id, contact_wallet) VALUES (${_q(id)}, ${_q(wallet)});
    ''');
    return id;
  }

  String _tierFor(int balance) => balance >= 2000
      ? 'gold'
      : balance >= 500
      ? 'silver'
      : 'standard';

  Future<void> _applyPointsDelta(
    String wallet,
    int delta,
    String reason,
  ) async {
    final accountId = await ensureLoyaltyAccount(wallet);
    final account = await rows(
      'SELECT points_balance FROM loyalty.accounts WHERE id = ${_q(accountId)}',
    );
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
      'SELECT * FROM loyalty.accounts WHERE contact_wallet = ${_q(wallet)} AND deleted = false',
    );
    return result.isEmpty ? null : result.first;
  }

  Future<List<Map<String, dynamic>>> loyaltyAccounts() => rows(
    'SELECT * FROM loyalty.accounts WHERE deleted = false ORDER BY date_modified DESC',
  );

  Future<List<Map<String, dynamic>>> loyaltyHistory(String wallet) async {
    final account = await loyaltyAccount(wallet);
    if (account == null) return [];
    return rows(
      "SELECT * FROM loyalty.points_transactions WHERE loyalty_account_id = ${_q(account['id'].toString())} ORDER BY date_entered DESC",
    );
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
    await execute(
      "UPDATE mes.machines SET state = ${_q(state)}, updated_at = now() WHERE id = $id;",
    );
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
    final order = await rows(
      'SELECT machine_id FROM mes.production_orders WHERE id = $id',
    );
    if (order.isEmpty) return;
    await execute('''
      UPDATE mes.production_orders SET status = ${_q(status)}, updated_at = now() WHERE id = $id;
    ''');
    final machineId = order.first['machine_id'] as int;
    if (status == 'in_progress') {
      await setMachineState(machineId, 'occupied');
    } else if (status == 'completed' || status == 'canceled') {
      final machine = await rows(
        'SELECT state FROM mes.machines WHERE id = $machineId',
      );
      if (machine.isNotEmpty && machine.first['state'] != 'maintenance') {
        await setMachineState(machineId, 'idle');
      }
    }
  }

  Future<List<Map<String, dynamic>>> bookings() =>
      rows('SELECT * FROM mes.production_orders ORDER BY scheduled_start DESC');

  Future<void> ensureIamUser(String wallet) async {
    final existing = await rows(
      'SELECT id FROM iam.users WHERE id = ${_q(wallet)}',
    );
    if (existing.isNotEmpty) return;
    await execute('INSERT INTO iam.users (id) VALUES (${_q(wallet)});');
  }

  Future<void> grantRole(String wallet, String roleId) async {
    await ensureIamUser(wallet);
    final existing = await rows(
      'SELECT rowid FROM iam.user_role_mapping WHERE user_id = ${_q(wallet)} AND role_id = ${_q(roleId)}',
    );
    if (existing.isNotEmpty) return;
    await execute('''
      INSERT INTO iam.user_role_mapping (rowid, user_id, role_id) VALUES (${_nextId()}, ${_q(wallet)}, ${_q(roleId)});
    ''');
  }

  Future<void> revokeRole(String wallet, String roleId) async {
    await execute(
      'DELETE FROM iam.user_role_mapping WHERE user_id = ${_q(wallet)} AND role_id = ${_q(roleId)};',
    );
  }

  Future<List<Map<String, dynamic>>> iamUsers() async {
    return rows('''
      SELECT u.id AS wallet, u.display_name, u.enabled, r.id AS role_id, r.name AS role_name
      FROM iam.users u
      LEFT JOIN iam.user_role_mapping m ON m.user_id = u.id
      LEFT JOIN iam.roles r ON r.id = m.role_id
      ORDER BY u.created_at
    ''');
  }

  Future<List<Map<String, dynamic>>> roles() async {
    final roleRows = await rows(
      'SELECT * FROM iam.roles ORDER BY is_builtin DESC, name',
    );
    final result = <Map<String, dynamic>>[];
    for (final role in roleRows) {
      final permissions = await rows(
        'SELECT permission FROM iam.role_permissions WHERE role_id = ${_q(role['id'].toString())}',
      );
      result.add({
        ...role,
        'permissions': permissions
            .map((p) => p['permission'].toString())
            .toList(),
      });
    }
    return result;
  }

  Future<String> createRole(String name, List<String> permissions) async {
    final id = _newId();
    await execute(
      "INSERT INTO iam.roles (id, name, is_builtin) VALUES (${_q(id)}, ${_q(name)}, false);",
    );
    await updateRolePermissions(id, permissions);
    return id;
  }

  Future<void> updateRolePermissions(
    String roleId,
    List<String> permissions,
  ) async {
    await execute(
      'DELETE FROM iam.role_permissions WHERE role_id = ${_q(roleId)};',
    );
    for (final permission in permissions) {
      await execute('''
        INSERT INTO iam.role_permissions (rowid, role_id, permission) VALUES (${_nextId()}, ${_q(roleId)}, ${_q(permission)});
      ''');
    }
  }

  Future<Set<String>> permissionsForWallet(String wallet) async {
    final permissionRows = await rows('''
      SELECT DISTINCT rp.permission
      FROM iam.user_role_mapping m
      JOIN iam.role_permissions rp ON rp.role_id = m.role_id
      WHERE m.user_id = ${_q(wallet)}
    ''');
    return permissionRows.map((r) => r['permission'].toString()).toSet();
  }

  static const allTables = [
    'erp.llx_societe',
    'erp.llx_socpeople',
    'erp.llx_commande',
    'erp.llx_product',
    'erp.llx_commandedet',
    'erp.llx_product_lang',
    'erp.llx_categorie',
    'erp.llx_categorie_product',
    'erp.llx_c_paiement',
    'erp.llx_facture',
    'erp.llx_facturedet',
    'erp.llx_paiement',
    'erp.llx_paiement_facture',
    'erp.llx_pos_cash_fence',
    'erp.llx_const',
    'chat.rc_rooms',
    'chat.rc_subscriptions',
    'chat.rc_messages',
    'cms.collections',
    'cms.fields',
    'cms.items',
    'loyalty.accounts',
    'loyalty.points_transactions',
    'mes.machines',
    'mes.production_orders',
    'iam.users',
    'iam.roles',
    'iam.role_permissions',
    'iam.user_role_mapping',
  ];

  Future<Map<String, dynamic>> dumpAll() async {
    final dump = <String, dynamic>{};
    for (final table in allTables) {
      dump[table] = await rows('SELECT * FROM $table');
    }
    return dump;
  }

  Future<void> restoreAll(Map<String, dynamic> dump) async {
    for (final table in allTables) {
      await execute('DELETE FROM $table;');
      final tableRows = (dump[table] as List? ?? const []);
      for (final row in tableRows) {
        final map = Map<String, dynamic>.from(row as Map);
        final columns = map.keys.toList();
        final values = columns.map((c) => _sqlValue(map[c])).join(', ');
        await execute(
          'INSERT INTO $table (${columns.join(', ')}) VALUES ($values);',
        );
      }
    }
  }

  Future<void> resetAll() async {
    for (final table in allTables) {
      await execute('DELETE FROM $table;');
    }
  }

  Future<List<Map<String, dynamic>>> tableCounts() async {
    final counts = <Map<String, dynamic>>[];
    for (final table in allTables) {
      final count = await _queryScalar('SELECT COUNT(*) FROM $table');
      counts.add({'table': table, 'count': int.tryParse(count) ?? 0});
    }
    return counts;
  }

  Future<void> clearTable(String table) async {
    if (!allTables.contains(table))
      throw ArgumentError('Unknown table: $table');
    await execute('DELETE FROM $table;');
  }

  String _sqlValue(dynamic value) {
    if (value == null) return 'NULL';
    if (value is num) return value.toString();
    if (value is bool) return value.toString();
    return _q(value);
  }

  String _q(Object? value) => "'${value.toString().replaceAll("'", "''")}'";

  Future<String> _queryScalar(String sql) async {
    final result = await _promise(
      js_util.callMethod(_bridge, 'queryScalar', [sql]),
    );
    return result.toString();
  }

  Future<dynamic> _promise(dynamic value) => js_util.promiseToFuture(value);
}

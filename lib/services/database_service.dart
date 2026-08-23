import 'dart:convert';
import 'dart:typed_data';
import 'dart:js_util' as js_util;
import '../data/suitecrm_schema.dart';
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
        date_livraison DATE,
        fk_statut INTEGER DEFAULT 0,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS erp.llx_product (
        rowid BIGINT PRIMARY KEY, ref VARCHAR NOT NULL, label VARCHAR NOT NULL,
        description VARCHAR, barcode VARCHAR, fk_barcode_type INTEGER,
        price DOUBLE NOT NULL, tva_tx DOUBLE DEFAULT 20,
        fk_product_type SMALLINT DEFAULT 0,
        tosell SMALLINT DEFAULT 1, tobuy SMALLINT DEFAULT 1,
        seuil_stock_alerte DOUBLE,
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
        location_type VARCHAR NOT NULL DEFAULT 'table', capacity INTEGER,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS mes.production_orders (
        id BIGINT PRIMARY KEY, ref VARCHAR NOT NULL, machine_id BIGINT NOT NULL,
        customer_wallet VARCHAR, party_size INTEGER,
        scheduled_start TIMESTAMP NOT NULL, scheduled_end TIMESTAMP NOT NULL,
        status VARCHAR NOT NULL DEFAULT 'planned',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS mes.workers (
        id BIGINT PRIMARY KEY, code VARCHAR, name VARCHAR NOT NULL,
        email VARCHAR, phone VARCHAR, is_active BOOLEAN DEFAULT true,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS mes.shifts (
        id BIGINT PRIMARY KEY, name VARCHAR NOT NULL, code VARCHAR,
        start_time VARCHAR NOT NULL, end_time VARCHAR NOT NULL,
        days_of_week VARCHAR DEFAULT '[1,2,3,4,5]', machine_id BIGINT,
        is_active BOOLEAN DEFAULT true, sort_order INTEGER DEFAULT 0,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS mes.downtime_reasons (
        id BIGINT PRIMARY KEY, name VARCHAR NOT NULL, code VARCHAR UNIQUE,
        is_planned BOOLEAN DEFAULT false, is_active BOOLEAN DEFAULT true,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS mes.production_downtimes (
        id BIGINT PRIMARY KEY, machine_id BIGINT NOT NULL, downtime_reason_id BIGINT NOT NULL,
        started_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, ended_at TIMESTAMP,
        duration_minutes INTEGER, notes VARCHAR, reported_by VARCHAR,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
      CREATE SCHEMA IF NOT EXISTS op;
      CREATE TABLE IF NOT EXISTS op.statuses (
        id BIGINT PRIMARY KEY, name VARCHAR NOT NULL, is_closed BOOLEAN DEFAULT false,
        is_default BOOLEAN DEFAULT false, color VARCHAR(8) DEFAULT '#3F7FC7',
        position INTEGER DEFAULT 0
      );
      CREATE TABLE IF NOT EXISTS op.work_packages (
        id BIGINT PRIMARY KEY, subject VARCHAR NOT NULL, description VARCHAR,
        status_id BIGINT NOT NULL, priority VARCHAR DEFAULT 'normal',
        customer_wallet VARCHAR, assigned_worker_id BIGINT, machine_id BIGINT,
        start_date TIMESTAMP, due_date TIMESTAMP,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS op.journals (
        id BIGINT PRIMARY KEY, work_package_id BIGINT NOT NULL, user_wallet VARCHAR,
        notes VARCHAR, from_status_id BIGINT, to_status_id BIGINT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS op.work_package_participants (
        id BIGINT PRIMARY KEY, work_package_id BIGINT NOT NULL, wallet VARCHAR NOT NULL,
        role VARCHAR NOT NULL DEFAULT 'watcher',
        added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    ''');
    await execute(suiteCrmSchema);
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
    await execute(
      'ALTER TABLE erp.llx_product ADD COLUMN IF NOT EXISTS description VARCHAR;',
    );
    await execute(
      'ALTER TABLE erp.llx_product ADD COLUMN IF NOT EXISTS barcode VARCHAR;',
    );
    await execute(
      'ALTER TABLE erp.llx_product ADD COLUMN IF NOT EXISTS fk_barcode_type INTEGER;',
    );
    await execute(
      'ALTER TABLE erp.llx_product ADD COLUMN IF NOT EXISTS fk_product_type SMALLINT DEFAULT 0;',
    );
    await execute(
      'ALTER TABLE erp.llx_product ADD COLUMN IF NOT EXISTS tosell SMALLINT DEFAULT 1;',
    );
    await execute(
      'ALTER TABLE erp.llx_product ADD COLUMN IF NOT EXISTS tobuy SMALLINT DEFAULT 1;',
    );
    await execute(
      'ALTER TABLE erp.llx_product ADD COLUMN IF NOT EXISTS seuil_stock_alerte DOUBLE;',
    );
    await execute(
      'ALTER TABLE erp.llx_commande ADD COLUMN IF NOT EXISTS date_livraison DATE;',
    );
    await execute(
      'ALTER TABLE mes.production_orders ADD COLUMN IF NOT EXISTS worker_id BIGINT;',
    );
    await execute(
      "ALTER TABLE mes.machines ADD COLUMN IF NOT EXISTS location_type VARCHAR DEFAULT 'table';",
    );
    await execute(
      'ALTER TABLE mes.machines ADD COLUMN IF NOT EXISTS capacity INTEGER;',
    );
    await execute('''
      DELETE FROM erp.llx_commandedet WHERE fk_commande IN (SELECT rowid FROM erp.llx_commande WHERE ref LIKE 'MOCK-%');
      DELETE FROM erp.llx_commande WHERE ref LIKE 'MOCK-%';
    ''');
    await _seedBuiltinRoles();
    await _seedPaymentTypes();
    await _seedDowntimeReasons();
    await _seedServiceStatuses();
    await _seedSuiteCrmRewards();
  }

  Future<void> _seedSuiteCrmRewards() async {
    const rewards = [
      ('breakfast', 'Complimentary breakfast', 'Breakfast for two guests', 100),
      ('late_checkout', 'Late checkout', 'Checkout extended to 2 PM', 250),
      ('room_upgrade', 'Room upgrade', 'One-category room upgrade', 500),
    ];
    for (final reward in rewards) {
      await execute('''
        INSERT INTO suitecrm.rewards (id, name, description, points_cost)
        VALUES (${_q(reward.$1)}, ${_q(reward.$2)}, ${_q(reward.$3)}, ${reward.$4})
        ON CONFLICT (id) DO NOTHING;
      ''');
    }
  }

  Future<void> _seedServiceStatuses() async {
    final existing = await rows('SELECT name FROM op.statuses');
    if (existing.isNotEmpty) return;
    const statuses = [
      ('New', false, true, '#1A67A3'),
      ('In progress', false, false, '#D9822B'),
      ('On hold', false, false, '#8091A5'),
      ('Closed', true, false, '#2E9E5B'),
    ];
    for (var i = 0; i < statuses.length; i++) {
      final (name, isClosed, isDefault, color) = statuses[i];
      final id = _nextId();
      await execute('''
        INSERT INTO op.statuses (id, name, is_closed, is_default, color, position)
        VALUES ($id, ${_q(name)}, $isClosed, $isDefault, ${_q(color)}, $i);
      ''');
    }
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

  Future<void> _seedDowntimeReasons() async {
    final existing = await rows('SELECT code FROM mes.downtime_reasons');
    final existingCodes = existing.map((r) => r['code'].toString()).toSet();
    const reasons = {
      'MAINT': ('Maintenance', true),
      'CLEAN': ('Cleaning', true),
      'CLOSED': ('Closed', false),
    };
    for (final entry in reasons.entries) {
      if (existingCodes.contains(entry.key)) continue;
      final id = DateTime.now().millisecondsSinceEpoch + (_idSeq++ % 1000);
      await execute('''
        INSERT INTO mes.downtime_reasons (id, name, code, is_planned)
        VALUES ($id, ${_q(entry.value.$1)}, ${_q(entry.key)}, ${entry.value.$2});
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
    'service_events.manage',
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
      'service_events.manage',
      'support.manage',
      'connection.manage',
    ],
    'staff': [
      'overview.view',
      'register.use',
      'orders.manage',
      'bookings.manage',
      'service_events.manage',
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
      INSERT INTO erp.llx_commande (rowid, ref, fk_soc, total_ht, total_ttc, date_livraison, fk_statut)
      VALUES ($orderId, ${_q(payload.order['ref'])}, $companyId, ${payload.order['total_ht']}, ${payload.order['total_ttc']}, ${payload.order['date_livraison'] == null ? 'NULL' : "DATE '${payload.order['date_livraison']}'"}, ${payload.order['fk_statut'] ?? 0})
      ON CONFLICT (rowid) DO UPDATE SET ref = EXCLUDED.ref, fk_soc = EXCLUDED.fk_soc, total_ht = EXCLUDED.total_ht, total_ttc = EXCLUDED.total_ttc, date_livraison = EXCLUDED.date_livraison, fk_statut = EXCLUDED.fk_statut, updated_at = now();
    ''');
    for (var index = 0; index < payload.lines.length; index++) {
      final line = payload.lines[index];
      final product = Map<String, dynamic>.from(line['product'] as Map);
      final lineId = orderId * 100 + index;
      await execute('''
        INSERT INTO erp.llx_product (rowid, ref, label, price, tva_tx, stock, fk_product_type)
        VALUES (${product['id']}, ${_q(product['ref'])}, ${_q(product['label'])}, ${product['price']}, ${product['tva_tx']}, ${product['stock']}, ${product['fk_product_type'] ?? 0})
        ON CONFLICT (rowid) DO UPDATE SET ref = EXCLUDED.ref, label = EXCLUDED.label, price = EXCLUDED.price, tva_tx = EXCLUDED.tva_tx, stock = EXCLUDED.stock, fk_product_type = EXCLUDED.fk_product_type, updated_at = now();
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
    String? description,
    String? barcode,
    int productType = 0,
    bool tosell = true,
    bool tobuy = true,
    double? stockAlertThreshold,
  }) async {
    final productId = id ?? DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO erp.llx_product
        (rowid, ref, label, description, barcode, price, tva_tx, photo, photo_mime,
         stock, tax_included, fk_product_type, tosell, tobuy, seuil_stock_alerte)
      VALUES (
        $productId, ${_q(ref)}, ${_q(label)},
        ${description == null ? 'NULL' : _q(description)},
        ${barcode == null ? 'NULL' : _q(barcode)},
        $price, $tax,
        ${photo == null ? 'NULL' : _q(photo)},
        ${photoMime == null ? 'NULL' : _q(photoMime)},
        $stock, $taxIncluded, $productType, ${tosell ? 1 : 0}, ${tobuy ? 1 : 0},
        ${stockAlertThreshold ?? 'NULL'}
      )
      ON CONFLICT (rowid) DO UPDATE SET
        ref = EXCLUDED.ref, label = EXCLUDED.label, description = EXCLUDED.description,
        barcode = EXCLUDED.barcode, price = EXCLUDED.price,
        tva_tx = EXCLUDED.tva_tx, photo = EXCLUDED.photo,
        photo_mime = EXCLUDED.photo_mime, stock = EXCLUDED.stock,
        tax_included = EXCLUDED.tax_included, fk_product_type = EXCLUDED.fk_product_type,
        tosell = EXCLUDED.tosell, tobuy = EXCLUDED.tobuy,
        seuil_stock_alerte = EXCLUDED.seuil_stock_alerte, updated_at = now();
    ''');
    await setProductCategory(productId, categoryId);
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
    await execute(
      'DELETE FROM erp.llx_categorie_product WHERE fk_categorie = $id;',
    );
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
  //
  // Internal fulfillment routing on checkout (not user-facing wording — the
  // UI just shows a normal POS sale): a Dolibarr product line
  // (fk_product_type = 0, "Goods") is checked against on-hand stock with the
  // same OpenMES-style availability reason codes checkAvailability() uses
  // for machines/workers, then decremented. A line for fk_product_type = 1
  // ("Service") instead opens an op.work_packages service event so staff can
  // carry it through the OpenProject-style New -> In progress -> Closed
  // state machine.

  // Mirrors checkAvailability()'s {available, reason} shape, but keyed to a
  // product's on-hand erp.llx_product.stock instead of a schedule window.
  Future<Map<String, dynamic>> checkStockAvailability({
    required int productId,
    required double qty,
  }) async {
    final productRows = await rows(
      'SELECT stock, tosell FROM erp.llx_product WHERE rowid = $productId',
    );
    if (productRows.isEmpty) {
      return {'available': false, 'reason': 'PRODUCT_NOT_FOUND'};
    }
    final product = productRows.first;
    if (product['tosell'] == 0) {
      return {'available': false, 'reason': 'PRODUCT_DISABLED'};
    }
    final stock = (product['stock'] as num).toDouble();
    if (stock < qty) {
      return {'available': false, 'reason': 'OUT_OF_STOCK'};
    }
    return {'available': true, 'reason': null};
  }

  Future<int> recordPosSale({
    required List<Map<String, dynamic>> lines,
    required String paymentCode,
    int? registerSessionId,
  }) async {
    for (final line in lines) {
      final productType = (line['fk_product_type'] as num?)?.toInt() ?? 0;
      if (productType != 0) continue;
      final availability = await checkStockAvailability(
        productId: line['product_id'] as int,
        qty: line['qty'] as double,
      );
      if (availability['available'] != true) {
        throw Exception(
          'Stock unavailable for ${line['label']}: ${availability['reason']}',
        );
      }
    }
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
      final productType = (line['fk_product_type'] as num?)?.toInt() ?? 0;
      if (productType == 1) {
        await createServiceEvent(
          subject: line['label'].toString(),
          description:
              'From POS sale POS$factureId · qty ${qty.toStringAsFixed(qty.truncateToDouble() == qty ? 0 : 2)}',
        );
      }
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

  Future<List<Map<String, dynamic>>> salesByCategory({DateTime? since}) =>
      rows('''
    SELECT COALESCE(cat.label, 'Uncategorized') AS label, SUM(d.total_ttc) AS total, SUM(d.qty) AS qty
    FROM erp.llx_facturedet d
    JOIN erp.llx_facture f ON f.rowid = d.fk_facture
    LEFT JOIN erp.llx_categorie_product cp ON cp.fk_product = d.fk_product
    LEFT JOIN erp.llx_categorie cat ON cat.rowid = cp.fk_categorie
    WHERE f.module_source = 'takepos'
    ${since == null ? '' : "AND f.datef >= TIMESTAMP '${since.toIso8601String()}'"}
    GROUP BY 1 ORDER BY total DESC
  ''');

  Future<List<Map<String, dynamic>>> salesByProduct({DateTime? since}) =>
      rows('''
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

  Future<List<Map<String, dynamic>>> allProductLangs() => rows(
    'SELECT fk_product, lang, label, description FROM erp.llx_product_lang ORDER BY fk_product, lang',
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

  // WordPress-style post_status: 'draft' until deliberately published, then
  // 'trash' instead of an immediate hard delete — see setCmsItemStatus.
  Future<void> saveCmsItem({
    int? id,
    required String collection,
    required Map<String, dynamic> data,
    String status = 'published',
  }) async {
    await ensureCollection(collection);
    final json = _q(jsonEncode(data));
    if (id != null) {
      await execute('''
        UPDATE cms.items SET data = $json, status = ${_q(status)}, updated_at = now() WHERE rowid = $id;
      ''');
    } else {
      final itemId = _nextId();
      await execute('''
        INSERT INTO cms.items (rowid, collection, data, status) VALUES ($itemId, ${_q(collection)}, $json, ${_q(status)});
      ''');
    }
  }

  Future<void> setCmsItemStatus(int id, String status) async {
    await execute(
      "UPDATE cms.items SET status = ${_q(status)}, updated_at = now() WHERE rowid = $id;",
    );
  }

  int _idSeq = 0;
  int _nextId() =>
      DateTime.now().millisecondsSinceEpoch * 1000 + (_idSeq++ % 1000);

  Future<List<Map<String, dynamic>>> cmsItems(
    String collection, {
    String? status,
  }) async {
    final raw = await rows(
      "SELECT * FROM cms.items WHERE collection = ${_q(collection)}"
      "${status == null ? '' : ' AND status = ${_q(status)}'}"
      " ORDER BY sort, rowid",
    );
    return raw.map((row) {
      final data = Map<String, dynamic>.from(
        jsonDecode(row['data'].toString()) as Map,
      );
      return {
        'rowid': row['rowid'],
        'collection': row['collection'],
        'status': row['status'],
        ...data,
      };
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

  Future<String> ensureSuiteCrmMembership(String wallet) async {
    final accountRows = await rows(
      'SELECT id FROM suitecrm.accounts WHERE name = ${_q(wallet)} AND deleted = false',
    );
    final accountId = accountRows.isNotEmpty
        ? accountRows.first['id'].toString()
        : _newId();
    if (accountRows.isEmpty) {
      await execute('''
        INSERT INTO suitecrm.accounts (id, name) VALUES (${_q(accountId)}, ${_q(wallet)});
      ''');
    }
    final contactRows = await rows(
      'SELECT id FROM suitecrm.contacts WHERE account_id = ${_q(accountId)} AND deleted = false',
    );
    final contactId = contactRows.isNotEmpty
        ? contactRows.first['id'].toString()
        : _newId();
    if (contactRows.isEmpty) {
      await execute('''
        INSERT INTO suitecrm.contacts (id, account_id, first_name, last_name)
        VALUES (${_q(contactId)}, ${_q(accountId)}, ${_q('Member')}, ${_q(wallet)});
      ''');
    }
    final membershipRows = await rows(
      'SELECT id FROM suitecrm.memberships WHERE account_id = ${_q(accountId)} AND deleted = false',
    );
    if (membershipRows.isNotEmpty) return membershipRows.first['id'].toString();
    final membershipId = _newId();
    await execute('''
        INSERT INTO suitecrm.memberships
        (id, account_id, contact_id, membership_number)
      VALUES (${_q(membershipId)}, ${_q(accountId)}, ${_q(contactId)}, ${_q('LILY-${accountId.substring(0, 8)}')});
    ''');
    return membershipId;
  }

  Future<List<Map<String, dynamic>>> rewards() => rows('''
    SELECT * FROM suitecrm.rewards
    WHERE active = true AND deleted = false ORDER BY points_cost, name
  ''');

  Future<void> awardBookingPoints({
    required int bookingId,
    required String wallet,
    int points = 100,
  }) async {
    final booking = await rows(
      'SELECT id, points_awarded FROM suitecrm.bookings WHERE id = ${_q(bookingId.toString())} AND deleted = false',
    );
    if (booking.isEmpty ||
        ((booking.first['points_awarded'] as num?)?.toInt() ?? 0) > 0) {
      return;
    }
    final membershipId = await ensureSuiteCrmMembership(wallet);
    await earnPoints(wallet, points, 'Booking BK-$bookingId completed');
    final ledgerId = _newId();
    await execute('''
      INSERT INTO suitecrm.points_ledger
        (id, membership_id, booking_id, points, transaction_type, description)
      VALUES (${_q(ledgerId)}, ${_q(membershipId)}, ${_q(bookingId.toString())}, $points,
        'earn', ${_q('Completed booking')});
      UPDATE suitecrm.bookings SET points_awarded = $points,
        status = 'Completed', date_modified = now()
      WHERE id = ${_q(bookingId.toString())};
      UPDATE suitecrm.memberships SET points_balance = points_balance + $points,
        lifetime_points = lifetime_points + $points, date_modified = now()
      WHERE id = ${_q(membershipId)};
    ''');
  }

  Future<void> claimReward({
    required String wallet,
    required String rewardId,
  }) async {
    final membershipId = await ensureSuiteCrmMembership(wallet);
    final rewardRows = await rows(
      'SELECT * FROM suitecrm.rewards WHERE id = ${_q(rewardId)} AND active = true AND deleted = false',
    );
    if (rewardRows.isEmpty) throw Exception('Reward not found');
    final cost = (rewardRows.first['points_cost'] as num).toInt();
    final membership = await rows(
      'SELECT points_balance FROM suitecrm.memberships WHERE id = ${_q(membershipId)}',
    );
    final balance = (membership.first['points_balance'] as num?)?.toInt() ?? 0;
    if (balance < cost) throw Exception('Insufficient points balance');
    final claimId = _newId();
    await redeemPoints(wallet, cost, 'Claimed ${rewardRows.first['name']}');
    await execute('''
      INSERT INTO suitecrm.reward_claims
        (id, membership_id, reward_id, points_spent)
      VALUES (${_q(claimId)}, ${_q(membershipId)}, ${_q(rewardId)}, $cost);
      INSERT INTO suitecrm.points_ledger
        (id, membership_id, reward_claim_id, points, transaction_type, description)
      VALUES (${_q(_newId())}, ${_q(membershipId)}, ${_q(claimId)}, -$cost,
        'redeem', ${_q('Claimed ${rewardRows.first['name']}')});
      UPDATE suitecrm.memberships SET points_balance = points_balance - $cost,
        date_modified = now() WHERE id = ${_q(membershipId)};
    ''');
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

  // --- Service locations (OpenMES `machines` — a merchant-managed table,
  // room, or other physical resource that bookings/service events schedule
  // against) ---

  Future<void> saveMachine({
    int? id,
    required String name,
    String locationType = 'table',
    int? capacity,
  }) async {
    final machineId = id ?? _nextId();
    await execute('''
      INSERT INTO mes.machines (id, name, location_type, capacity)
      VALUES ($machineId, ${_q(name)}, ${_q(locationType)}, ${capacity ?? 'NULL'})
      ON CONFLICT (id) DO UPDATE SET
        name = EXCLUDED.name, location_type = EXCLUDED.location_type,
        capacity = EXCLUDED.capacity, updated_at = now();
    ''');
  }

  Future<void> deleteMachine(int id) async {
    await execute(
      'UPDATE mes.shifts SET machine_id = NULL WHERE machine_id = $id;',
    );
    await execute('DELETE FROM mes.machines WHERE id = $id;');
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

  // --- Full-service booking & availability (schema: OpenMES workers/shifts/
  // downtime_reasons/production_downtimes; flow: pos-api-dev's layered
  // ScheduleService.validate()/AvailabilityHandler.check() reason-code checks) ---

  Future<Map<String, dynamic>> checkAvailability({
    required int machineId,
    required DateTime start,
    required DateTime end,
    int? workerId,
  }) async {
    final shiftRows = await rows(
      'SELECT * FROM mes.shifts WHERE is_active = true AND (machine_id = $machineId OR machine_id IS NULL)',
    );
    if (shiftRows.isNotEmpty) {
      final weekday = start.weekday; // 1=Mon .. 7=Sun, matches ISO days_of_week
      final startMinutes = start.hour * 60 + start.minute;
      final endMinutes = end.hour * 60 + end.minute;
      final coveredByAnyShift = shiftRows.any((shift) {
        final days = (jsonDecode(shift['days_of_week'].toString()) as List)
            .map((d) => (d as num).toInt())
            .toSet();
        if (!days.contains(weekday)) return false;
        final shiftStart = _minutesOf(shift['start_time'].toString());
        final shiftEnd = _minutesOf(shift['end_time'].toString());
        return startMinutes >= shiftStart && endMinutes <= shiftEnd;
      });
      if (!coveredByAnyShift) {
        return {'available': false, 'reason': 'OUT_OF_SCHEDULE'};
      }
    }
    final downtime = await rows('''
      SELECT id FROM mes.production_downtimes
      WHERE machine_id = $machineId
        AND started_at < TIMESTAMP '${end.toIso8601String()}'
        AND COALESCE(ended_at, TIMESTAMP '9999-12-31') > TIMESTAMP '${start.toIso8601String()}'
    ''');
    if (downtime.isNotEmpty) {
      return {'available': false, 'reason': 'MACHINE_BUSY'};
    }
    if (await hasOverlap(machineId, start, end)) {
      return {'available': false, 'reason': 'RESOURCE_BOOKED'};
    }
    if (workerId != null) {
      final workerBusy = await rows('''
        SELECT id FROM mes.production_orders
        WHERE worker_id = $workerId AND status NOT IN ('completed', 'canceled')
          AND scheduled_start < TIMESTAMP '${end.toIso8601String()}'
          AND scheduled_end > TIMESTAMP '${start.toIso8601String()}'
      ''');
      if (workerBusy.isNotEmpty) {
        return {'available': false, 'reason': 'WORKER_BUSY'};
      }
    }
    return {'available': true, 'reason': null};
  }

  int _minutesOf(String hhmm) {
    final parts = hhmm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  Future<int> createBooking({
    required int machineId,
    required String customerWallet,
    required int partySize,
    required DateTime start,
    required DateTime end,
    int? workerId,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO mes.production_orders
        (id, ref, machine_id, customer_wallet, party_size, scheduled_start, scheduled_end, worker_id)
      VALUES ($id, ${_q('BK-$id')}, $machineId, ${_q(customerWallet)}, $partySize,
        TIMESTAMP '${start.toIso8601String()}', TIMESTAMP '${end.toIso8601String()}',
        ${workerId ?? 'NULL'});
    ''');
    final suiteBookingId = id.toString();
    await ensureSuiteCrmMembership(customerWallet);
    final accountRows = await rows(
      'SELECT id FROM suitecrm.accounts WHERE name = ${_q(customerWallet)} AND deleted = false',
    );
    final accountId = accountRows.first['id'].toString();
    final meetingId = _newId();
    await execute('''
      INSERT INTO suitecrm.meetings
        (id, name, date_start, date_end, status, parent_type, parent_id)
      VALUES (${_q(meetingId)}, ${_q('Booking BK-$id')},
        TIMESTAMP '${start.toIso8601String()}', TIMESTAMP '${end.toIso8601String()}',
        'Planned', 'bookings', ${_q(suiteBookingId)});
      INSERT INTO suitecrm.bookings
        (id, name, account_id, resource_id, meeting_id, check_in, check_out, status)
      VALUES (${_q(suiteBookingId)}, ${_q('BK-$id')}, ${_q(accountId)},
        ${_q(machineId.toString())}, ${_q(meetingId)},
        TIMESTAMP '${start.toIso8601String()}', TIMESTAMP '${end.toIso8601String()}', 'Planned');
    ''');
    return id;
  }

  Future<void> updateBooking({
    required int id,
    required int machineId,
    required int partySize,
    required DateTime start,
    required DateTime end,
    int? workerId,
  }) async {
    await execute('''
      UPDATE mes.production_orders SET
        machine_id = $machineId, party_size = $partySize,
        scheduled_start = TIMESTAMP '${start.toIso8601String()}',
        scheduled_end = TIMESTAMP '${end.toIso8601String()}',
        worker_id = ${workerId ?? 'NULL'}, updated_at = now()
      WHERE id = $id;
    ''');
  }

  Future<void> deleteBooking(int id) async {
    await execute('DELETE FROM mes.production_orders WHERE id = $id;');
  }

  // --- Workers (OpenMES `workers`) ---

  Future<void> saveWorker({
    int? id,
    required String code,
    required String name,
    String? email,
    String? phone,
    bool active = true,
  }) async {
    final workerId = id ?? DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO mes.workers (id, code, name, email, phone, is_active)
      VALUES ($workerId, ${_q(code)}, ${_q(name)},
        ${email == null || email.isEmpty ? 'NULL' : _q(email)},
        ${phone == null || phone.isEmpty ? 'NULL' : _q(phone)}, $active)
      ON CONFLICT (id) DO UPDATE SET
        code = EXCLUDED.code, name = EXCLUDED.name, email = EXCLUDED.email,
        phone = EXCLUDED.phone, is_active = EXCLUDED.is_active, updated_at = now();
    ''');
  }

  Future<List<Map<String, dynamic>>> workers() =>
      rows('SELECT * FROM mes.workers ORDER BY name');

  Future<void> deleteWorker(int id) async {
    await execute(
      'UPDATE mes.production_orders SET worker_id = NULL WHERE worker_id = $id;',
    );
    await execute('DELETE FROM mes.workers WHERE id = $id;');
  }

  // --- Shifts (OpenMES `shifts` — recurring weekly availability windows) ---

  Future<void> saveShift({
    int? id,
    required String name,
    String? code,
    required String startTime,
    required String endTime,
    required List<int> daysOfWeek,
    int? machineId,
    bool active = true,
  }) async {
    final shiftId = id ?? DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO mes.shifts (id, name, code, start_time, end_time, days_of_week, machine_id, is_active)
      VALUES ($shiftId, ${_q(name)}, ${code == null || code.isEmpty ? 'NULL' : _q(code)},
        ${_q(startTime)}, ${_q(endTime)}, ${_q(jsonEncode(daysOfWeek))},
        ${machineId ?? 'NULL'}, $active)
      ON CONFLICT (id) DO UPDATE SET
        name = EXCLUDED.name, code = EXCLUDED.code, start_time = EXCLUDED.start_time,
        end_time = EXCLUDED.end_time, days_of_week = EXCLUDED.days_of_week,
        machine_id = EXCLUDED.machine_id, is_active = EXCLUDED.is_active, updated_at = now();
    ''');
  }

  Future<List<Map<String, dynamic>>> shifts() =>
      rows('SELECT * FROM mes.shifts ORDER BY sort_order, start_time');

  Future<void> deleteShift(int id) async {
    await execute('DELETE FROM mes.shifts WHERE id = $id;');
  }

  // --- Downtime (OpenMES `downtime_reasons` / `production_downtimes`) ---

  Future<List<Map<String, dynamic>>> downtimeReasons() => rows(
    'SELECT * FROM mes.downtime_reasons WHERE is_active = true ORDER BY name',
  );

  Future<List<Map<String, dynamic>>> allDowntimeReasons() =>
      rows('SELECT * FROM mes.downtime_reasons ORDER BY name');

  // `code` carries its own UNIQUE constraint, and DuckDB rejects an
  // ON CONFLICT ... DO UPDATE that assigns to a uniquely-constrained column
  // outside the conflict target — so this updates or inserts explicitly
  // instead of the ON CONFLICT upsert pattern used elsewhere.
  Future<void> saveDowntimeReason({
    int? id,
    required String name,
    required String code,
    bool isPlanned = false,
    bool isActive = true,
  }) async {
    if (id != null) {
      await execute('''
        UPDATE mes.downtime_reasons SET
          name = ${_q(name)}, code = ${_q(code)}, is_planned = $isPlanned,
          is_active = $isActive, updated_at = now()
        WHERE id = $id;
      ''');
    } else {
      await execute('''
        INSERT INTO mes.downtime_reasons (id, name, code, is_planned, is_active)
        VALUES (${_nextId()}, ${_q(name)}, ${_q(code)}, $isPlanned, $isActive);
      ''');
    }
  }

  Future<void> deleteDowntimeReason(int id) async {
    await execute(
      'DELETE FROM mes.production_downtimes WHERE downtime_reason_id = $id;',
    );
    await execute('DELETE FROM mes.downtime_reasons WHERE id = $id;');
  }

  Future<int> startDowntime({
    required int machineId,
    required int reasonId,
    String? notes,
    String? reportedBy,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    await execute('''
      INSERT INTO mes.production_downtimes (id, machine_id, downtime_reason_id, notes, reported_by)
      VALUES ($id, $machineId, $reasonId,
        ${notes == null || notes.isEmpty ? 'NULL' : _q(notes)},
        ${reportedBy == null ? 'NULL' : _q(reportedBy)});
    ''');
    await setMachineState(machineId, 'maintenance');
    return id;
  }

  Future<void> endDowntime(int id) async {
    final row = await rows(
      'SELECT machine_id, started_at FROM mes.production_downtimes WHERE id = $id',
    );
    if (row.isEmpty) return;
    final startedAt = row.first['started_at'];
    final startedAtMs = startedAt is num
        ? startedAt.round()
        : DateTime.tryParse(startedAt.toString())?.millisecondsSinceEpoch;
    final durationMinutes = startedAtMs == null
        ? 0
        : DateTime.now()
              .difference(DateTime.fromMillisecondsSinceEpoch(startedAtMs))
              .inMinutes;
    await execute('''
      UPDATE mes.production_downtimes SET ended_at = now(),
        duration_minutes = $durationMinutes
      WHERE id = $id;
    ''');
    final machineId = row.first['machine_id'] as int;
    final stillDown = await rows(
      'SELECT id FROM mes.production_downtimes WHERE machine_id = $machineId AND ended_at IS NULL',
    );
    if (stillDown.isEmpty) {
      await setMachineState(machineId, 'idle');
    }
  }

  Future<List<Map<String, dynamic>>> activeDowntimes() => rows('''
    SELECT d.*, m.name AS machine_name, r.name AS reason_name
    FROM mes.production_downtimes d
    JOIN mes.machines m ON m.id = d.machine_id
    JOIN mes.downtime_reasons r ON r.id = d.downtime_reason_id
    WHERE d.ended_at IS NULL
    ORDER BY d.started_at DESC
  ''');

  Future<List<Map<String, dynamic>>> downtimeHistory() => rows('''
    SELECT d.*, m.name AS machine_name, r.name AS reason_name
    FROM mes.production_downtimes d
    JOIN mes.machines m ON m.id = d.machine_id
    JOIN mes.downtime_reasons r ON r.id = d.downtime_reason_id
    ORDER BY d.started_at DESC
    LIMIT 100
  ''');

  // --- Service events & state (schema: OpenProject statuses/work_packages/
  // journals; a service event is a work_package, its lifecycle state is
  // status_id, and every state change is journaled for audit history) ---

  Future<List<Map<String, dynamic>>> serviceStatuses() =>
      rows('SELECT * FROM op.statuses ORDER BY position');

  Future<int> _defaultStatusId() async {
    final rowsResult = await rows(
      'SELECT id FROM op.statuses WHERE is_default = true LIMIT 1',
    );
    if (rowsResult.isNotEmpty) return (rowsResult.first['id'] as num).toInt();
    final fallback = await rows(
      'SELECT id FROM op.statuses ORDER BY position LIMIT 1',
    );
    return (fallback.first['id'] as num).toInt();
  }

  Future<int> createServiceEvent({
    required String subject,
    String? description,
    int? statusId,
    String priority = 'normal',
    String? customerWallet,
    int? assignedWorkerId,
    int? machineId,
    DateTime? startDate,
    DateTime? dueDate,
    String? userWallet,
  }) async {
    // Reuse the OpenMES availability engine so a service event can't double-
    // book a worker that's already covering a table booking (or another
    // service event) in the same window.
    if (assignedWorkerId != null && startDate != null && dueDate != null) {
      final availability = await checkAvailability(
        machineId: machineId ?? -1,
        start: startDate,
        end: dueDate,
        workerId: assignedWorkerId,
      );
      if (availability['available'] != true) {
        throw Exception('Worker unavailable: ${availability['reason']}');
      }
    }
    final id = _nextId();
    final resolvedStatusId = statusId ?? await _defaultStatusId();
    await execute('''
      INSERT INTO op.work_packages
        (id, subject, description, status_id, priority, customer_wallet,
         assigned_worker_id, machine_id, start_date, due_date)
      VALUES ($id, ${_q(subject)},
        ${description == null || description.isEmpty ? 'NULL' : _q(description)},
        $resolvedStatusId, ${_q(priority)},
        ${customerWallet == null ? 'NULL' : _q(customerWallet)},
        ${assignedWorkerId ?? 'NULL'}, ${machineId ?? 'NULL'},
        ${startDate == null ? 'NULL' : "TIMESTAMP '${startDate.toIso8601String()}'"},
        ${dueDate == null ? 'NULL' : "TIMESTAMP '${dueDate.toIso8601String()}'"});
      INSERT INTO op.journals (id, work_package_id, user_wallet, notes, from_status_id, to_status_id)
      VALUES (${_nextId()}, $id, ${userWallet == null ? 'NULL' : _q(userWallet)},
        ${_q('Service event created')}, NULL, $resolvedStatusId);
    ''');
    if (customerWallet != null && customerWallet.isNotEmpty) {
      await addServiceEventParticipant(id, customerWallet, role: 'customer');
    }
    if (userWallet != null && userWallet.isNotEmpty) {
      await addServiceEventParticipant(id, userWallet, role: 'creator');
    }
    return id;
  }

  Future<List<Map<String, dynamic>>> serviceEvents({int? statusId}) => rows('''
    SELECT wp.*, s.name AS status_name, s.is_closed AS status_is_closed, s.color AS status_color
    FROM op.work_packages wp
    JOIN op.statuses s ON s.id = wp.status_id
    ${statusId == null ? '' : 'WHERE wp.status_id = $statusId'}
    ORDER BY wp.updated_at DESC
  ''');

  // --- Service event participants (track by participant, wallet-keyed to
  // line up with the iam.users identity the Keycloak-style role/permission
  // checks already use) ---

  Future<void> addServiceEventParticipant(
    int eventId,
    String wallet, {
    String role = 'watcher',
  }) async {
    await ensureIamUser(wallet);
    final existing = await rows(
      'SELECT id FROM op.work_package_participants WHERE work_package_id = $eventId AND wallet = ${_q(wallet)} AND role = ${_q(role)}',
    );
    if (existing.isNotEmpty) return;
    await execute('''
      INSERT INTO op.work_package_participants (id, work_package_id, wallet, role)
      VALUES (${_nextId()}, $eventId, ${_q(wallet)}, ${_q(role)});
    ''');
  }

  Future<void> removeServiceEventParticipant(
    int eventId,
    String wallet, {
    String? role,
  }) async {
    await execute(
      'DELETE FROM op.work_package_participants '
      'WHERE work_package_id = $eventId AND wallet = ${_q(wallet)}'
      '${role == null ? '' : ' AND role = ${_q(role)}'};',
    );
  }

  Future<List<Map<String, dynamic>>> serviceEventParticipants(int eventId) =>
      rows('''
    SELECT p.*, u.display_name
    FROM op.work_package_participants p
    LEFT JOIN iam.users u ON u.id = p.wallet
    WHERE p.work_package_id = $eventId
    ORDER BY p.added_at
  ''');

  Future<List<Map<String, dynamic>>> serviceEventsForParticipant(
    String wallet,
  ) => rows('''
    SELECT DISTINCT wp.*, s.name AS status_name, s.is_closed AS status_is_closed, s.color AS status_color
    FROM op.work_packages wp
    JOIN op.statuses s ON s.id = wp.status_id
    JOIN op.work_package_participants p ON p.work_package_id = wp.id
    WHERE p.wallet = ${_q(wallet)}
    ORDER BY wp.updated_at DESC
  ''');

  Future<void> setServiceEventState(
    int eventId,
    int toStatusId, {
    String? userWallet,
    String? notes,
  }) async {
    final current = await rows(
      'SELECT status_id FROM op.work_packages WHERE id = $eventId',
    );
    if (current.isEmpty) return;
    final fromStatusId = (current.first['status_id'] as num).toInt();
    await execute('''
      UPDATE op.work_packages SET status_id = $toStatusId, updated_at = now()
      WHERE id = $eventId;
      INSERT INTO op.journals (id, work_package_id, user_wallet, notes, from_status_id, to_status_id)
      VALUES (${_nextId()}, $eventId, ${userWallet == null ? 'NULL' : _q(userWallet)},
        ${notes == null || notes.isEmpty ? 'NULL' : _q(notes)}, $fromStatusId, $toStatusId);
    ''');
  }

  Future<List<Map<String, dynamic>>> serviceEventJournal(int eventId) =>
      rows('''
    SELECT j.*, fs.name AS from_status_name, ts.name AS to_status_name
    FROM op.journals j
    LEFT JOIN op.statuses fs ON fs.id = j.from_status_id
    LEFT JOIN op.statuses ts ON ts.id = j.to_status_id
    WHERE j.work_package_id = $eventId
    ORDER BY j.created_at
  ''');

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
    'suitecrm.accounts',
    'suitecrm.contacts',
    'suitecrm.meetings',
    'suitecrm.meetings_contacts',
    'suitecrm.aos_products',
    'suitecrm.aos_products_quotes',
    'suitecrm.memberships',
    'suitecrm.bookings',
    'suitecrm.points_ledger',
    'suitecrm.rewards',
    'suitecrm.reward_claims',
    'mes.machines',
    'mes.production_orders',
    'mes.workers',
    'mes.shifts',
    'mes.downtime_reasons',
    'mes.production_downtimes',
    'iam.users',
    'iam.roles',
    'iam.role_permissions',
    'iam.user_role_mapping',
    'op.statuses',
    'op.work_packages',
    'op.journals',
    'op.work_package_participants',
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

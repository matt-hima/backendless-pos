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
      CREATE TABLE IF NOT EXISTS llx_societe (
        rowid BIGINT PRIMARY KEY, nom VARCHAR NOT NULL, code_client VARCHAR,
        email VARCHAR, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS llx_socpeople (
        rowid BIGINT PRIMARY KEY, fk_soc BIGINT NOT NULL, firstname VARCHAR,
        lastname VARCHAR, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS llx_commande (
        rowid BIGINT PRIMARY KEY, ref VARCHAR NOT NULL, fk_soc BIGINT NOT NULL,
        total_ht DOUBLE, total_ttc DOUBLE,
        fk_statut INTEGER DEFAULT 0,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS llx_product (
        rowid BIGINT PRIMARY KEY, ref VARCHAR NOT NULL, label VARCHAR NOT NULL,
        price DOUBLE NOT NULL, tva_tx DOUBLE DEFAULT 20,
        stock DOUBLE DEFAULT 0, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS llx_commandedet (
        rowid BIGINT PRIMARY KEY, fk_commande BIGINT NOT NULL,
        fk_product BIGINT NOT NULL, qty DOUBLE NOT NULL,
        subprice DOUBLE NOT NULL, total_ht DOUBLE NOT NULL,
        total_ttc DOUBLE NOT NULL
      );
    ''');
    await execute('ALTER TABLE llx_commande ADD COLUMN IF NOT EXISTS fk_statut INTEGER DEFAULT 0;');
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
    final q = (Object? value) => "'${value.toString().replaceAll("'", "''")}'";
    await execute('''
      INSERT INTO llx_societe (rowid, nom, code_client, email)
      VALUES ($companyId, ${q(payload.thirdparty['name'])}, ${q(payload.thirdparty['code'])}, ${q(payload.thirdparty['email'])})
      ON CONFLICT (rowid) DO UPDATE SET nom = EXCLUDED.nom, code_client = EXCLUDED.code_client, email = EXCLUDED.email, updated_at = now();
      INSERT INTO llx_socpeople (rowid, fk_soc, firstname, lastname)
      VALUES ($contactId, $companyId, ${q(payload.contact['firstname'])}, ${q(payload.contact['lastname'])})
      ON CONFLICT (rowid) DO UPDATE SET fk_soc = EXCLUDED.fk_soc, firstname = EXCLUDED.firstname, lastname = EXCLUDED.lastname, updated_at = now();
      INSERT INTO llx_commande (rowid, ref, fk_soc, total_ht, total_ttc, fk_statut)
      VALUES ($orderId, ${q(payload.order['ref'])}, $companyId, ${payload.order['total_ht']}, ${payload.order['total_ttc']}, 0)
      ON CONFLICT (rowid) DO UPDATE SET ref = EXCLUDED.ref, fk_soc = EXCLUDED.fk_soc, total_ht = EXCLUDED.total_ht, total_ttc = EXCLUDED.total_ttc, updated_at = now();
    ''');
    for (var index = 0; index < payload.lines.length; index++) {
      final line = payload.lines[index];
      final product = Map<String, dynamic>.from(line['product'] as Map);
      final lineId = orderId * 100 + index;
      await execute('''
        INSERT INTO llx_product (rowid, ref, label, price, tva_tx, stock)
        VALUES (${product['id']}, ${q(product['ref'])}, ${q(product['label'])}, ${product['price']}, ${product['tva_tx']}, ${product['stock']})
        ON CONFLICT (rowid) DO UPDATE SET ref = EXCLUDED.ref, label = EXCLUDED.label, price = EXCLUDED.price, tva_tx = EXCLUDED.tva_tx, stock = EXCLUDED.stock, updated_at = now();
        INSERT INTO llx_commandedet (rowid, fk_commande, fk_product, qty, subprice, total_ht, total_ttc)
        VALUES ($lineId, $orderId, ${product['id']}, ${line['quantity']}, ${product['price']}, ${line['total_ht']}, ${line['total_ttc']})
        ON CONFLICT (rowid) DO UPDATE SET fk_product = EXCLUDED.fk_product, qty = EXCLUDED.qty, subprice = EXCLUDED.subprice, total_ht = EXCLUDED.total_ht, total_ttc = EXCLUDED.total_ttc;
      ''');
    }
  }

  Future<int> orderCount() async => int.parse(await _queryScalar('SELECT COUNT(*) FROM llx_commande'));
  Future<int> productCount() async => int.parse(await _queryScalar('SELECT COUNT(*) FROM llx_product'));

  Future<void> updateOrderStatus(int orderId, int status) async {
    await execute('UPDATE llx_commande SET fk_statut = $status, updated_at = now() WHERE rowid = $orderId;');
  }

  Future<List<Map<String, dynamic>>> rows(String sql) async {
    final raw = await _promise(js_util.callMethod(_bridge, 'queryRows', [sql]));
    return (jsonDecode(raw as String) as List).map((row) => Map<String, dynamic>.from(row as Map)).toList();
  }

  Future<void> saveProduct({int? id, required String ref, required String label, required double price, required double tax, required double stock}) async {
    final productId = id ?? DateTime.now().millisecondsSinceEpoch;
    String q(Object value) => "'${value.toString().replaceAll("'", "''")}'";
    await execute('''
      INSERT INTO llx_product (rowid, ref, label, price, tva_tx, stock)
      VALUES ($productId, ${q(ref)}, ${q(label)}, $price, $tax, $stock)
      ON CONFLICT (rowid) DO UPDATE SET ref = EXCLUDED.ref, label = EXCLUDED.label, price = EXCLUDED.price, tva_tx = EXCLUDED.tva_tx, stock = EXCLUDED.stock, updated_at = now();
    ''');
  }

  Future<Uint8List> exportParquet() async {
    await _promise(js_util.callMethod(_bridge, 'exportParquet', const []));
    final base64 = await _promise(js_util.callMethod(_bridge, 'readExportBase64', const []));
    return Uint8List.fromList(base64Decode(base64 as String));
  }

  Future<String> _queryScalar(String sql) async {
    final result = await _promise(js_util.callMethod(_bridge, 'queryScalar', [sql]));
    return result.toString();
  }

  Future<dynamic> _promise(dynamic value) => js_util.promiseToFuture(value);
}

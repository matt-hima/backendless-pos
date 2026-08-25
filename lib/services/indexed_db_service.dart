import 'dart:convert';
import 'dart:js_util' as js_util;

class IndexedDbService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'IndexedDbBridge');

  Future<void> initialize() async {
    await _promise(js_util.callMethod(_bridge, 'init', [jsonEncode([])]));
  }

  Future<List<Map<String, dynamic>>> products() async {
    final result = await _promise(
      js_util.callMethod(_bridge, 'products', const []),
    );
    return (jsonDecode(result as String) as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }

  Future<void> saveProducts(
    List<Map<String, dynamic>> products, {
    String? revision,
  }) async {
    await _promise(
      js_util.callMethod(_bridge, 'saveProducts', [
        jsonEncode(products),
        revision,
      ]),
    );
  }

  Future<String?> catalogRevision() async {
    final raw = await _promise(
      js_util.callMethod(_bridge, 'catalogRevision', const []),
    );
    return raw?.toString();
  }

  Future<void> saveWalletThirdParty(Map<String, dynamic> thirdparty) async {
    await _promise(
      js_util.callMethod(_bridge, 'saveWalletThirdParty', [
        jsonEncode(thirdparty),
      ]),
    );
  }

  Future<void> saveMemberSession({
    required String wallet,
    required DateTime expiresAt,
  }) async {
    await _promise(
      js_util.callMethod(_bridge, 'saveMemberSession', [
        jsonEncode({
          'id': wallet.toLowerCase(),
          'wallet': wallet.toLowerCase(),
          'expires_at': expiresAt.toIso8601String(),
        }),
      ]),
    );
  }

  Future<void> expireMemberData() async {
    await _promise(
      js_util.callMethod(_bridge, 'expireMemberData', [
        DateTime.now().toIso8601String(),
      ]),
    );
  }

  Future<Map<String, dynamic>?> memberSession() async {
    final raw = await _promise(
      js_util.callMethod(_bridge, 'memberSession', const []),
    );
    if (raw == null || raw == 'null') return null;
    return Map<String, dynamic>.from(jsonDecode(raw as String) as Map);
  }

  Future<Map<String, dynamic>?> walletThirdParty(String wallet) async {
    final raw = await _promise(
      js_util.callMethod(_bridge, 'walletThirdParty', [wallet]),
    );
    if (raw == null || raw == 'null') return null;
    return Map<String, dynamic>.from(jsonDecode(raw as String) as Map);
  }

  Future<void> saveEncryptedTransaction({
    required int id,
    required String channel,
    required String wallet,
    required String encryptedPayload,
  }) async {
    await _promise(
      js_util.callMethod(_bridge, 'saveEncryptedTransaction', [
        jsonEncode({
          'rowid': id,
          'ref': 'WEB-$id',
          'channel': channel,
          'wallet': wallet,
          'encrypted_payload': encryptedPayload,
          'fk_statut': 0,
          'created_at': DateTime.now().toIso8601String(),
        }),
      ]),
    );
  }

  Future<List<Map<String, dynamic>>> encryptedTransactions({
    required String channel,
    required String wallet,
  }) async {
    final raw = await _promise(
      js_util.callMethod(_bridge, 'transactions', [channel, wallet]),
    );
    return (jsonDecode(raw as String) as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }

  Future<void> updateEncryptedTransactionStatus({
    required int id,
    required String status,
  }) async {
    await _promise(
      js_util.callMethod(_bridge, 'updateTransactionStatus', [id, status]),
    );
  }

  Future<Map<String, dynamic>> createChannel(
    String name, {
    String? merchantId,
  }) async {
    final result = await _promise(
      js_util.callMethod(_bridge, 'createChannel', [name, merchantId]),
    );
    return Map<String, dynamic>.from(jsonDecode(result as String) as Map);
  }

  Future<void> saveLivechatMessage({
    required int id,
    required String channel,
    required String wallet,
    required String direction,
    required String body,
    bool delivered = false,
  }) async {
    await _promise(
      js_util.callMethod(_bridge, 'saveLivechatMessage', [
        jsonEncode({
          'rowid': id,
          'channel': channel,
          'wallet': wallet,
          'direction': direction,
          'body': body,
          'created_at': DateTime.now().toIso8601String(),
          'delivered': delivered,
        }),
      ]),
    );
  }

  Future<List<Map<String, dynamic>>> livechatMessages({
    required String channel,
    required String wallet,
  }) async {
    final raw = await _promise(
      js_util.callMethod(_bridge, 'livechatMessages', [channel, wallet]),
    );
    return (jsonDecode(raw as String) as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }

  Future<Map<String, dynamic>> dumpAll() async {
    final raw = await _promise(
      js_util.callMethod(_bridge, 'dumpAll', const []),
    );
    return Map<String, dynamic>.from(jsonDecode(raw as String) as Map);
  }

  Future<void> restoreAll(Map<String, dynamic> dump) async {
    await _promise(
      js_util.callMethod(_bridge, 'restoreAll', [jsonEncode(dump)]),
    );
  }

  Future<void> resetAll() async {
    await _promise(js_util.callMethod(_bridge, 'resetAll', const []));
  }

  Future<void> saveCmsItems({
    required String collection,
    required List<Map<String, dynamic>> items,
  }) async {
    await _promise(
      js_util.callMethod(_bridge, 'saveCmsItems', [
        collection,
        jsonEncode(items),
      ]),
    );
  }

  Future<List<Map<String, dynamic>>> cmsItems(String collection) async {
    final raw = await _promise(
      js_util.callMethod(_bridge, 'cmsItems', [collection]),
    );
    return (jsonDecode(raw as String) as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }

  Future<void> saveBooking(Map<String, dynamic> booking) async {
    await _promise(
      js_util.callMethod(_bridge, 'saveBooking', [jsonEncode(booking)]),
    );
  }

  Future<List<Map<String, dynamic>>> bookings() async {
    final raw = await _promise(
      js_util.callMethod(_bridge, 'bookings', const []),
    );
    return (jsonDecode(raw as String) as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }

  Future<dynamic> _promise(dynamic value) => js_util.promiseToFuture(value);
}

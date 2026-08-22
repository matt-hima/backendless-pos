import 'dart:convert';
import 'dart:js_util' as js_util;
import '../data/dintaifung_menu.dart';

class IndexedDbService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'IndexedDbBridge');

  Future<void> initialize() async {
    final products = dintaifungMenu
        .map((product) => {
              ...product,
              'category': _category(product['ref'] as String),
              'description': _description(product['label'] as String),
              'active': true,
            })
        .toList();
    await _promise(js_util.callMethod(_bridge, 'init', [jsonEncode(products)]));
  }

  Future<List<Map<String, dynamic>>> products() async {
    final result =
        await _promise(js_util.callMethod(_bridge, 'products', const []));
    return (jsonDecode(result as String) as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }

  Future<void> saveWalletThirdParty(Map<String, dynamic> thirdparty) async {
    await _promise(js_util
        .callMethod(_bridge, 'saveWalletThirdParty', [jsonEncode(thirdparty)]));
  }

  Future<void> saveEncryptedTransaction(
      {required int id,
      required String channel,
      required String wallet,
      required String encryptedPayload}) async {
    await _promise(js_util.callMethod(_bridge, 'saveEncryptedTransaction', [
      jsonEncode({
        'rowid': id,
        'ref': 'WEB-$id',
        'channel': channel,
        'wallet': wallet,
        'encrypted_payload': encryptedPayload,
        'fk_statut': 0,
        'created_at': DateTime.now().toIso8601String()
      })
    ]));
  }

  Future<List<Map<String, dynamic>>> encryptedTransactions(
      {required String channel, required String wallet}) async {
    final raw = await _promise(
        js_util.callMethod(_bridge, 'transactions', [channel, wallet]));
    return (jsonDecode(raw as String) as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }

  Future<Map<String, dynamic>> createChannel(String name) async {
    final result =
        await _promise(js_util.callMethod(_bridge, 'createChannel', [name]));
    return Map<String, dynamic>.from(jsonDecode(result as String) as Map);
  }

  String _category(String ref) => ref.contains('XLB') ||
          ref.contains('SHR') ||
          ref.contains('CHG') ||
          ref.contains('VEG')
      ? '點心'
      : ref.contains('SOU') || ref.contains('GRN')
          ? '小菜湯品'
          : ref.contains('DES')
              ? '甜點'
              : '主食';
  String _description(String label) => '$label｜鼎泰豐經典手作料理';
  Future<dynamic> _promise(dynamic value) => js_util.promiseToFuture(value);
}

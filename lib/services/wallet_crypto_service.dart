import 'dart:convert';
import 'dart:js_util' as js_util;

class WalletCryptoService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'WalletCryptoBridge');

  Future<void> initialize(String walletAddress) async {
    await js_util.promiseToFuture(
        js_util.callMethod(_bridge, 'initWallet', [walletAddress]));
  }

  Future<String> encrypt(Map<String, dynamic> value) async {
    final encrypted = await js_util.promiseToFuture(
        js_util.callMethod(_bridge, 'encrypt', [jsonEncode(value)]));
    return encrypted as String;
  }

  Future<Map<String, dynamic>> decrypt(String envelope) async {
    final value = await js_util
        .promiseToFuture(js_util.callMethod(_bridge, 'decrypt', [envelope]));
    return Map<String, dynamic>.from(jsonDecode(value as String) as Map);
  }
}

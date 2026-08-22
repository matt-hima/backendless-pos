import 'dart:convert';
import 'dart:js_util' as js_util;

class LocalWalletService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'LocalWalletBridge');

  Future<bool> hasWallet() async => await js_util
      .promiseToFuture(js_util.callMethod(_bridge, 'hasWallet', []));

  Future<Map<String, dynamic>> create(String passphrase) async {
    final result = await js_util
        .promiseToFuture(js_util.callMethod(_bridge, 'create', [passphrase]));
    return Map<String, dynamic>.from(jsonDecode(result as String) as Map);
  }

  Future<String?> unlock(String passphrase) async {
    final address = await js_util
        .promiseToFuture(js_util.callMethod(_bridge, 'unlock', [passphrase]));
    return address as String?;
  }

  Future<String> restore(String mnemonic, String passphrase) async {
    final address = await js_util.promiseToFuture(
        js_util.callMethod(_bridge, 'restore', [mnemonic, passphrase]));
    return address as String;
  }
}

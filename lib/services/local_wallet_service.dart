import 'dart:js_util' as js_util;

class LocalWalletService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'LocalWalletBridge');

  Future<bool> hasWallet() async => await js_util
      .promiseToFuture(js_util.callMethod(_bridge, 'hasWallet', []));

  Future<String> create(String passphrase) async {
    final address = await js_util
        .promiseToFuture(js_util.callMethod(_bridge, 'create', [passphrase]));
    return address as String;
  }

  Future<String?> unlock(String passphrase) async {
    final address = await js_util
        .promiseToFuture(js_util.callMethod(_bridge, 'unlock', [passphrase]));
    return address as String?;
  }
}

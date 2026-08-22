import 'dart:js_util' as js_util;

class PasskeyService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'PasskeyBridge');

  bool hasPasskey() => js_util.callMethod(_bridge, 'hasPasskey', const []) as bool;

  Future<void> enroll(String passphrase) => js_util
      .promiseToFuture(js_util.callMethod(_bridge, 'enroll', [passphrase]));

  Future<String> unlock() async {
    final passphrase = await js_util
        .promiseToFuture(js_util.callMethod(_bridge, 'unlock', const []));
    return passphrase as String;
  }
}

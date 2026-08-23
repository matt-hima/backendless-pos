import 'dart:js_util' as js_util;

class NotificationService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'NotificationBridge');

  bool get supported =>
      js_util.callMethod(_bridge, 'supported', const []) as bool;
  String get permission =>
      js_util.callMethod(_bridge, 'permission', const []).toString();
  Future<String> requestPermission() async => (await js_util.promiseToFuture(
    js_util.callMethod(_bridge, 'request', const []),
  )).toString();
  Future<bool> show(String title, String body) async =>
      js_util.callMethod(_bridge, 'show', [title, body]) as bool;
  Future<bool> keepAwake() async =>
      (await js_util.promiseToFuture(
            js_util.callMethod(_bridge, 'keepAwake', const []),
          ))
          as bool;
  Future<bool> releaseAwake() async =>
      (await js_util.promiseToFuture(
            js_util.callMethod(_bridge, 'releaseAwake', const []),
          ))
          as bool;
  bool get awake => js_util.callMethod(_bridge, 'awake', const []) as bool;
}

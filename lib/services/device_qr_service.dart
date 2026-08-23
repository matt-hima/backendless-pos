import 'dart:js_util' as js_util;

class DeviceQrService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'DeviceQrBridge');
  bool get supported =>
      js_util.callMethod(_bridge, 'supported', const []) as bool;
  Future<String> scan() async =>
      (await js_util.promiseToFuture(
            js_util.callMethod(_bridge, 'scan', const []),
          ))
          as String;
}

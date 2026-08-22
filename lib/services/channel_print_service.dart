import 'dart:js_util' as js_util;

class ChannelPrintService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'PrintChannelBridge');

  Future<bool> open(String html) async =>
      await js_util.callMethod(_bridge, 'open', [html]) as bool;
}

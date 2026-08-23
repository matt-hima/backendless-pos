import 'dart:js_util' as js_util;

class MerchantLinkService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'MerchantLinksBridge');

  void save({required String channel, required String link, String? name}) {
    js_util.callMethod(_bridge, 'save', [channel, link, name ?? channel]);
  }
}

import 'dart:js_util' as js_util;

class WebRtcService {
  dynamic get _bridge => js_util.getProperty(js_util.globalThis, 'WebRtcBridge');

  Future<String> createOffer() async => (await _promise(js_util.callMethod(_bridge, 'createOffer', const []))) as String;
  Future<String> acceptOffer(String offer) async => (await _promise(js_util.callMethod(_bridge, 'acceptOffer', [offer]))) as String;
  Future<String> applyAnswer(String answer) async => (await _promise(js_util.callMethod(_bridge, 'applyAnswer', [answer]))).toString();
  String state() => js_util.callMethod(_bridge, 'state', const []).toString();
  void send(String message) => js_util.callMethod(_bridge, 'send', [message]);
  Future<dynamic> _promise(dynamic value) => js_util.promiseToFuture(value);
}


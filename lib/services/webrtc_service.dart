import 'dart:convert';
import 'dart:js_util' as js_util;

class WebRtcService {
  dynamic get _bridge => js_util.getProperty(js_util.globalThis, 'WebRtcBridge');

  Future<String> createOffer() async => (await _promise(js_util.callMethod(_bridge, 'createOffer', const []))) as String;
  Future<String> acceptOffer(String offer) async => (await _promise(js_util.callMethod(_bridge, 'acceptOffer', [offer]))) as String;
  Future<String> applyAnswer(String answer) async => (await _promise(js_util.callMethod(_bridge, 'applyAnswer', [answer]))).toString();
  String state() => js_util.callMethod(_bridge, 'state', const []).toString();

  /// Combined liveness status: 'connected' | 'stale' | 'connecting' | 'disconnected'.
  /// 'stale' means the data channel is open but no heartbeat has been seen
  /// recently — likely a silently-dead connection.
  String status() => js_util.callMethod(_bridge, 'status', const []).toString();

  void send(String message) => js_util.callMethod(_bridge, 'send', [message]);

  /// Polls buffered inbound messages (heartbeat ping/pong is filtered out on
  /// the JS side already). Call this periodically instead of registering a
  /// JS->Dart callback, since passing Dart closures into JS isn't otherwise
  /// used anywhere in this codebase.
  List<String> drainMessages() {
    final raw = js_util.callMethod(_bridge, 'drainMessages', const []) as String;
    return (jsonDecode(raw) as List).cast<String>();
  }

  Future<dynamic> _promise(dynamic value) => js_util.promiseToFuture(value);
}


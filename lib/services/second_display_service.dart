import 'dart:js_util' as js_util;

class SecondDisplayService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'SecondDisplayBridge');

  bool get supported =>
      js_util.callMethod(_bridge, 'supported', const <Object>[]) as bool;

  bool open(String url) =>
      js_util.callMethod(_bridge, 'open', <Object>[url]) as bool;
}

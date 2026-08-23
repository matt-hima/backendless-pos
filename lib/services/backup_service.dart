import 'dart:js_util' as js_util;

class BackupService {
  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'BackupBridge');

  Future<void> download(String filename, String json) async {
    js_util.callMethod(_bridge, 'downloadJson', [filename, json]);
  }

  Future<void> downloadText(
    String filename,
    String content, [
    String mimeType = 'text/csv',
  ]) async {
    js_util.callMethod(_bridge, 'downloadText', [filename, content, mimeType]);
  }

  Future<String> pickJsonFile() async =>
      await _promise(js_util.callMethod(_bridge, 'pickJsonFile', const []))
          as String;

  Future<dynamic> _promise(dynamic value) => js_util.promiseToFuture(value);
}

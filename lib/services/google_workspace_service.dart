import 'dart:convert';
import 'dart:js_util' as js_util;

class GoogleWorkspaceService {
  static const clientId = String.fromEnvironment('GOOGLE_OAUTH_CLIENT_ID');

  dynamic get _bridge =>
      js_util.getProperty(js_util.globalThis, 'GoogleWorkspaceBridge');

  bool get configured =>
      js_util.callMethod(_bridge, 'configured', [clientId]) as bool;

  Future<void> saveDriveBackup(
    String filename,
    Map<String, dynamic> envelope,
  ) async {
    await _promise(
      js_util.callMethod(_bridge, 'saveDriveJson', [
        clientId,
        filename,
        jsonEncode(envelope),
      ]),
    );
  }

  Future<Map<String, dynamic>> restoreDriveBackup(String filename) async {
    final raw = await _promise(
      js_util.callMethod(_bridge, 'restoreDriveJson', [clientId, filename]),
    );
    return Map<String, dynamic>.from(jsonDecode(raw as String) as Map);
  }

  Future<String> exportSheet(
    String title,
    Map<String, dynamic> envelope,
  ) async {
    final url = await _promise(
      js_util.callMethod(_bridge, 'exportSheet', [
        clientId,
        title,
        jsonEncode(envelope),
      ]),
    );
    return url.toString();
  }

  Future<Map<String, dynamic>> importSheet(String spreadsheetId) async {
    final raw = await _promise(
      js_util.callMethod(_bridge, 'importSheet', [clientId, spreadsheetId]),
    );
    return Map<String, dynamic>.from(jsonDecode(raw as String) as Map);
  }

  Future<dynamic> _promise(dynamic value) => js_util.promiseToFuture(value);
}

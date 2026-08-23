import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? const String.fromEnvironment('API_URL', defaultValue: 'http://192.168.64.3:8000');
  final String baseUrl;

  Future<void> syncParquet(Uint8List bytes) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/storage/sync?filename=dolibarr_orders.parquet'),
      headers: {'Content-Type': 'application/octet-stream', 'Content-Disposition': 'attachment; filename="dolibarr_orders.parquet"'},
      body: bytes,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Mock LilyGO rejected upload (${response.statusCode}): ${response.body}');
    }
  }

  /// Returns true when the device proves possession of its local key.
  /// A device outage is intentionally treated as offline mode by the portal.
  Future<bool> deviceAttest(String subject) async {
    try {
      final nonce = '$subject-${DateTime.now().microsecondsSinceEpoch}';
      final response = await http.post(
        Uri.parse('$baseUrl/api/device/attest'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nonce': nonce}),
      );
      return response.statusCode >= 200 &&
          response.statusCode < 300 &&
          (jsonDecode(response.body) as Map)['verified'] == true;
    } catch (_) {
      return false;
    }
  }
}

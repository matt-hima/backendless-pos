import 'dart:typed_data';
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
}


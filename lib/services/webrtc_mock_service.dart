import 'dart:async';
import 'dart:math';
import '../models/order_payload.dart';
import '../data/dintaifung_menu.dart';

/// Stand-in for @astrophant/webrtc-radio-sdk during local development.
class WebRtcMockService {
  final _controller = StreamController<OrderPayload>.broadcast();
  Timer? _timer;
  int _sequence = 0;
  final _random = Random();

  Stream<OrderPayload> get orders => _controller.stream;

  void start() {
    _timer ??= Timer.periodic(const Duration(seconds: 10), (_) => _emitOrder());
  }

  void _emitOrder() {
    final number = ++_sequence;
    final menu = [...dintaifungMenu]..shuffle(_random);
    final lineCount = 2 + _random.nextInt(2);
    final lines = menu.take(lineCount).map((product) {
      final quantity = 1 + _random.nextInt(3);
      final totalHt = (product['price'] as double) * quantity;
      return {
        'product': product,
        'quantity': quantity,
        'total_ht': totalHt,
        'total_ttc': totalHt * 1.05,
      };
    }).toList();
    final totalHt = lines.fold<double>(0, (sum, line) => sum + (line['total_ht'] as double));
    final totalTtc = lines.fold<double>(0, (sum, line) => sum + (line['total_ttc'] as double));
    final firstProduct = Map<String, dynamic>.from(lines.first['product'] as Map);

    _controller.add(OrderPayload.fromJson({
      'thirdparty': {
        'id': 1000 + number,
        'name': 'Example Customer $number',
        'code': 'CUST-${number.toString().padLeft(4, '0')}',
        'email': 'customer$number@example.test',
      },
      'contact': {'id': 2000 + number, 'firstname': 'Ada', 'lastname': 'Lovelace'},
      'order': {
        'id': 3000 + number,
        'ref': 'MOCK-${DateTime.now().year}-$number',
        'total_ht': totalHt,
        'total_ttc': totalTtc,
      },
      'product': firstProduct,
      'lines': lines,
    }));
  }

  Future<void> dispose() async {
    _timer?.cancel();
    await _controller.close();
  }
}

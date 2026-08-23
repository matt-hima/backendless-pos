import 'dart:async';
import '../models/order_payload.dart';

/// Stand-in for @astrophant/webrtc-radio-sdk during local development.
class WebRtcMockService {
  final _controller = StreamController<OrderPayload>.broadcast();
  Timer? _timer;

  Stream<OrderPayload> get orders => _controller.stream;

  void start() {
    _timer ??= Timer.periodic(const Duration(seconds: 10), (_) => _emitOrder());
  }

  void _emitOrder() {
    // Mock orders are disabled until a sample scenario is selected.
  }

  Future<void> dispose() async {
    _timer?.cancel();
    await _controller.close();
  }
}

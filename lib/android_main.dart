import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

const _clientUrl = String.fromEnvironment(
  'CLIENT_URL',
  defaultValue: 'https://remote-order.web.app/portal',
);

void main() => runApp(const AndroidNativeApp());

class AndroidNativeApp extends StatefulWidget {
  const AndroidNativeApp({super.key});

  @override
  State<AndroidNativeApp> createState() => _AndroidNativeAppState();
}

class _AndroidNativeAppState extends State<AndroidNativeApp> {
  static const _platform = MethodChannel('lilygo/android_client');
  late final TextEditingController channelController;
  String message = '';

  String get channel => channelController.text.trim().isEmpty
      ? 'default'
      : channelController.text.trim();

  String get storeLink =>
      '$_clientUrl${_clientUrl.contains('?') ? '&' : '?'}channel=$channel';

  @override
  void initState() {
    super.initState();
    channelController = TextEditingController(text: 'default');
    _initializeNativeDuckDb();
    _initializeNativeWebRtc();
  }

  Future<void> _initializeNativeDuckDb() async {
    try {
      final initialized = await _platform.invokeMethod<bool>(
        'initializeDuckDb',
      );
      if (mounted && initialized != true) {
        setState(() => message = 'Native DuckDB could not be opened');
      }
    } on PlatformException catch (error) {
      if (mounted)
        setState(() => message = 'Native DuckDB unavailable: ${error.message}');
    }
  }

  Future<void> _initializeNativeWebRtc() async {
    try {
      await _platform.invokeMethod<bool>('initializeWebRtc');
      await _platform.invokeMethod<bool>('initializePieceExchange');
      if (mounted) setState(() => message = 'Native WebRTC ready');
    } on PlatformException catch (error) {
      if (mounted)
        setState(() => message = 'Native WebRTC unavailable: ${error.message}');
    }
  }

  Future<Map<Object?, Object?>> pieceExchangeStatus() async {
    final status = await _platform.invokeMethod<Object?>('pieceExchangeStatus');
    return status is Map ? Map<Object?, Object?>.from(status) : const {};
  }

  @override
  void dispose() {
    channelController.dispose();
    super.dispose();
  }

  Future<Uint8List> qrBytes() async {
    final data = await QrPainter(
      data: storeLink,
      version: QrVersions.auto,
      gapless: true,
    ).toImageData(720);
    return data!.buffer.asUint8List();
  }

  Future<void> copyLink() async {
    await Clipboard.setData(ClipboardData(text: storeLink));
    if (mounted) setState(() => message = 'Store link copied');
  }

  Future<void> openClient() async {
    try {
      await _platform.invokeMethod<void>('openClient', {'url': storeLink});
    } on PlatformException catch (error) {
      if (mounted)
        setState(() => message = error.message ?? 'Unable to open client');
    }
  }

  Future<void> showSecondDisplay() async {
    try {
      final shown = await _platform.invokeMethod<bool>('showSecondDisplay', {
        'qr': await qrBytes(),
        'link': storeLink,
        'channel': channel,
      });
      if (mounted) {
        setState(
          () => message = shown == true
              ? 'QR shown on the second display'
              : 'No second display is connected',
        );
      }
    } on PlatformException catch (error) {
      if (mounted)
        setState(() => message = error.message ?? 'Second display unavailable');
    }
  }

  @override
  Widget build(BuildContext context) {
    final link = storeLink;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LilyGO Portal',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF0B4F71),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('LilyGO Portal'),
          actions: [
            IconButton(
              tooltip: 'Open client site',
              onPressed: openClient,
              icon: const Icon(Icons.open_in_browser),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Store operations',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Native Flutter portal for channel, display, and device control.',
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Portal dashboard',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Expanded(
                            child: _PortalMetric(
                              icon: Icons.receipt_long,
                              label: 'Orders',
                              value: 'Ready',
                            ),
                          ),
                          Expanded(
                            child: _PortalMetric(
                              icon: Icons.people_alt_outlined,
                              label: 'Staff',
                              value: 'Connected',
                            ),
                          ),
                          Expanded(
                            child: _PortalMetric(
                              icon: Icons.wifi,
                              label: 'Channel',
                              value: 'Online',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Use this portal to manage the store channel, customer link, and connected displays.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Store connection',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: channelController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Store channel',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: QrImageView(
                  data: link,
                  size: 280,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              SelectableText(link, textAlign: TextAlign.center),
              const SizedBox(height: 18),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: copyLink,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy link'),
                  ),
                  FilledButton.icon(
                    onPressed: openClient,
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('Open client'),
                  ),
                  OutlinedButton.icon(
                    onPressed: showSecondDisplay,
                    icon: const Icon(Icons.tv),
                    label: const Text('2nd display QR'),
                  ),
                ],
              ),
              if (message.isNotEmpty) ...[
                const SizedBox(height: 16),
                Center(child: Text(message)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PortalMetric extends StatelessWidget {
  const _PortalMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    ),
  );
}

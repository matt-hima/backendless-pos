import 'package:flutter_web3/flutter_web3.dart';

class WalletAuthService {
  String? get currentAddress => ethereum?.selectedAddress;
  bool get isSupported => ethereum != null;

  Future<String?> connect() async {
    final provider = ethereum;
    if (provider == null) return null;
    await provider.requestAccount();
    return provider.selectedAddress;
  }
}


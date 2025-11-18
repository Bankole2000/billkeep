import 'package:billkeep/database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultWalletNotifier extends Notifier<Wallet?> {
  @override
  Wallet? build() {
    return null;
  }

  void setDefaultWallet(Wallet? wallet) {
    state = wallet;
  }
}

final defaultWalletProvider =
    NotifierProvider<DefaultWalletNotifier, Wallet?>(
        () => DefaultWalletNotifier());
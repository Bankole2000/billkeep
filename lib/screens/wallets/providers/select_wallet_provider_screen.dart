import 'package:billkeep/providers/bank_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/wallets/providers/add_wallet_provider_screen.dart';
import 'package:billkeep/utils/wallet_types.dart';
import 'package:billkeep/widgets/wallets/wallet_provider_select_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletProviderSelectScreen extends ConsumerWidget {
  const WalletProviderSelectScreen({super.key, this.walletType});

  final WalletType? walletType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    final filteredWalletProviders = ref.watch(filteredWalletProvidersProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.text),
        actionsIconTheme: IconThemeData(color: colors.text),
        title: Text('Select Provider', style: TextStyle(color: colors.text)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: CupertinoSearchTextField(
              backgroundColor: const Color(0xFFE0E0E0),
              placeholder: 'Search by name, code, or symbol',
              placeholderStyle: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 20,
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                CupertinoIcons.search,
                color: Colors.blueAccent,
              ),
              suffixIcon: const Icon(
                CupertinoIcons.xmark_circle_fill,
                color: Colors.redAccent,
              ),
              onChanged: (value) {
                ref.read(walletProviderSearchQueryProvider.notifier).state =
                    value;
              },
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          SizedBox(width: 4),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddWalletProviderScreen(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: WalletProviderList(
        showCreditCardOnly: walletType == WalletType.CREDIT_CARD,
        showMobileMoneyOnly:
            walletType == WalletType.MOBILE_MONEY ||
            walletType == WalletType.DIGITAL_WALLET,
        showFiatOnly: walletType == WalletType.BANK_ACCOUNT,
        showCryptoOnly: walletType == WalletType.CRYPTO_WALLET,
        walletProviders: filteredWalletProviders,
        onWalletProviderSelected: (walletProvider) {
          ref.read(walletProviderSearchQueryProvider.notifier).state = '';
          Navigator.pop(context, walletProvider);
        },
      ),
    );
  }
}

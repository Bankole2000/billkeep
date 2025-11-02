import 'package:billkeep/providers/bank_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/wallets/providers/add_wallet_provider_screen.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:billkeep/widgets/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_flags/country_flags.dart';
import '../../database/database.dart';

class WalletProviderList extends ConsumerWidget {
  final Function(WalletProvider)? onWalletProviderSelected;
  final bool showActiveWalletProvidersOnly;
  final bool showCryptoOnly;
  final bool showFiatOnly;
  final bool showMobileMoneyOnly;
  final bool showCreditCardOnly;
  final List<WalletProvider> walletProviders;

  const WalletProviderList({
    super.key,
    required this.walletProviders,
    this.onWalletProviderSelected,
    this.showActiveWalletProvidersOnly = false,
    this.showCryptoOnly = false,
    this.showFiatOnly = false,
    this.showCreditCardOnly = false,
    this.showMobileMoneyOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<WalletProvider> filteredWalletProviders = walletProviders;

    // if (showActiveWalletProvidersOnly) {
    //   filteredWalletProviders = filteredWalletProviders.where((c) => c.isActive).toList();
    // }

    if (showCryptoOnly) {
      filteredWalletProviders = filteredWalletProviders
          .where((c) => c.isCrypto)
          .toList();
    }

    if (showFiatOnly) {
      filteredWalletProviders = filteredWalletProviders
          .where((c) => c.isFiatBank)
          .toList();
    }

    if (showMobileMoneyOnly) {
      filteredWalletProviders = filteredWalletProviders
          .where((c) => c.isMobileMoney)
          .toList();
    }

    if (showCreditCardOnly) {
      filteredWalletProviders = filteredWalletProviders
          .where((c) => c.isCreditCard)
          .toList();
    }

    if (filteredWalletProviders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No Wallet Providers found',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredWalletProviders.length,
      itemBuilder: (context, index) {
        final walletProvider = filteredWalletProviders[index];
        return WalletProviderListItem(
          walletProvider: walletProvider,
          onTap: () {
            onWalletProviderSelected!(walletProvider);
          },
        );
      },
    );
  }
}

class WalletProviderListItem extends ConsumerWidget {
  final WalletProvider walletProvider;
  final VoidCallback? onTap;

  const WalletProviderListItem({
    super.key,
    required this.walletProvider,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.textMute.withAlpha(50), width: .5),
        borderRadius: BorderRadius.circular(0),
      ),
      contentPadding: EdgeInsets.only(right: 10, left: 16),
      leading: _buildWalletProviderAvatar(),
      title: Row(
        children: [
          Text(
            walletProvider.name,
            style: TextStyle(fontWeight: FontWeight.w500, color: colors.text),
          ),
          const SizedBox(width: 8),
          if (walletProvider.isCrypto)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'CRYPTO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ),
          // if (!walletProvider.isActive)
          //   Container(
          //     margin: const EdgeInsets.only(left: 4),
          //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          //     decoration: BoxDecoration(
          //       color: Colors.grey.shade300,
          //       borderRadius: BorderRadius.circular(4),
          //     ),
          //     child: Text(
          //       'INACTIVE',
          //       style: TextStyle(
          //         fontSize: 10,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.grey.shade700,
          //       ),
          //     ),
          //   ),
        ],
      ),
      subtitle: Text(
        // '${walletProvider.description} • ${walletProvider.symbol}',
        '${walletProvider.description}',
        style: TextStyle(fontSize: 12, color: colors.textMute),
      ),
      trailing: IconButton(
        icon: Icon(Icons.chevron_right_rounded),
        color: colors.text,
        onPressed: () {
          Navigator.push(
            context,
            AppPageRoute.slideRight(
              AddWalletProviderScreen(walletProvider: walletProvider),
            ),
          );
        },
      ),
      onTap: onTap,
    );
  }

  Widget _buildWalletProviderAvatar() {
    if (walletProvider.imageUrl != null &&
        walletProvider.imageUrl!.isNotEmpty) {
      return SizedBox(
        width: 50,
        height: 50,
        child: AppImage(
          imageUrl: walletProvider.imageUrl!,
          width: 50,
          height: 50,
          circular: true,
        ),
      );
      // CircleAvatar(
      //   backgroundImage: NetworkImage(merchant.imageUrl!),
      //   backgroundColor: Colors.grey.shade200,
      // );
    }

    // Show country flag if available, otherwise show walletProvider symbol
    // if (walletProvider.countryISO2 != null && walletProvider.countryISO2!.isNotEmpty) {
    //   return Container(
    //     width: 50,
    //     height: 50,
    //     decoration: BoxDecoration(
    //       shape: BoxShape.circle,
    //       border: Border.all(color: Colors.grey.shade300, width: 1),
    //     ),
    //     child: ClipOval(
    //       child: walletProvider.isCrypto
    //           ? Transform.translate(
    //               offset: Offset(0, -5),
    //               child: Text(
    //                 walletProvider.countryISO2!,
    //                 style: TextStyle(fontSize: 35),
    //               ),
    //             )
    //           : CountryFlag.fromCountryCode(
    //               walletProvider.countryISO2!,
    //               // width: 50,
    //               // height: 50,
    //             ),
    //     ),
    //   );
    // }

    // For crypto or walletProviders without country, show symbol in circle
    return CircleAvatar(
      backgroundColor: walletProvider.isCrypto
          ? Colors.orange.shade100
          : Colors.blue.shade100,
      // child: Text(
      //   // walletProvider.symbol,
      //   walletProvider.countryISO2!,
      //   style: TextStyle(
      //     fontSize: 20,
      //     fontWeight: FontWeight.bold,
      //     color: walletProvider.isCrypto
      //         ? Colors.orange.shade800
      //         : Colors.blue.shade800,
      //   ),
      // ),
    );
  }
}

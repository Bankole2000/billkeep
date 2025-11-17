import 'dart:io' show Platform;

import 'package:billkeep/providers/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/user_preferences_provider.dart';
import 'package:billkeep/utils/wallet_types.dart';
import 'package:billkeep/widgets/wallets/select_wallet_type_bottomsheet.dart';
import 'package:billkeep/widgets/wallets/wallet_provider_dropdown.dart';

/// Wallet creation step in onboarding
class WalletStep extends ConsumerWidget {
  final TextEditingController walletNameController;
  final TextEditingController initialBalanceController;
  final WalletType? walletType;
  final WalletProvider? walletProvider;
  final ValueChanged<WalletType?> onWalletTypeChanged;
  final ValueChanged<WalletProvider?> onWalletProviderChanged;

  const WalletStep({
    super.key,
    required this.walletNameController,
    required this.initialBalanceController,
    required this.walletType,
    required this.walletProvider,
    required this.onWalletTypeChanged,
    required this.onWalletProviderChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Your First Wallet',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'A wallet helps you track money in different accounts.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Wallet name
          TextFormField(
            controller: walletNameController,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Wallet Name',
              hintText: 'e.g., Main Wallet, Cash, Bank Account',
              prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a wallet name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Wallet type
          WalletTypeDropdown(
            selectedType: walletType,
            onChanged: onWalletTypeChanged,
          ),
          const SizedBox(height: 16),

          // Initial balance
          TextFormField(
            controller: initialBalanceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Initial Balance',
              prefixIcon: Padding(
                padding:  EdgeInsets.only(
                  top: Platform.isIOS ? 14 : 11.0,
                  left: 12.0,
                  right: 4.0,
                ),
                child: DefaultCurrencyDisplay(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an initial balance';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Wallet provider (if not cash)
          if (walletType != null && walletType != WalletType.CASH)
            WalletProviderDropdown(
              onChanged: onWalletProviderChanged,
              selectedWalletType: walletType!,
            ),
        ],
      ),
    );
  }
}

/// Default currency display widget
class DefaultCurrencyDisplay extends ConsumerWidget {
  const DefaultCurrencyDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyAsync = ref.watch(defaultCurrencyObjectProvider);

    return currencyAsync.when(
      data: (currency) {
        if (currency == null) return const Text('?');
        return Text('${currency.code} - ${currency.symbol}');
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text('Error: $err'),
    );
  }
}

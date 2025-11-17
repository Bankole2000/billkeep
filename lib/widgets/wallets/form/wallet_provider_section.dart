import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database.dart';
import '../../../screens/wallets/providers/select_wallet_provider_screen.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_enums.dart';
import '../../../utils/image_helpers.dart';
import '../../../utils/wallet_types.dart';
import '../../common/dynamic_avatar.dart';

/// Wallet provider selection section
class WalletProviderSection extends ConsumerWidget {
  final WalletType? selectedWalletType;
  final WalletProvider? selectedWalletProvider;
  final bool useProviderAppearance;
  final ValueChanged<WalletProvider> onProviderSelected;
  final ValueChanged<bool> onUseProviderAppearanceChanged;

  const WalletProviderSection({
    super.key,
    required this.selectedWalletType,
    required this.selectedWalletProvider,
    required this.useProviderAppearance,
    required this.onProviderSelected,
    required this.onUseProviderAppearanceChanged,
  });

  Future<void> _selectWalletProvider(BuildContext context) async {
    final result = await Navigator.of(context).push<WalletProvider>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) =>
            WalletProviderSelectScreen(walletType: selectedWalletType),
      ),
    );
    if (result != null) {
      onProviderSelected(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hide section for cash wallets
    if (selectedWalletType == WalletType.CASH || selectedWalletType == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const Padding(
          padding: EdgeInsets.only(
            left: 20,
            top: 10,
            bottom: 0,
          ),
          child: Text('Wallet Provider'),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: ListTile(
            dense: true,
            leading: selectedWalletProvider == null
                ? const DynamicAvatar(icon: Icons.account_balance, size: 44)
                : _buildProviderAvatar(),
            visualDensity: selectedWalletProvider == null
                ? const VisualDensity(vertical: 2)
                : null,
            title: selectedWalletProvider != null
                ? Text(selectedWalletProvider!.name)
                : const Text('Select Provider'),
            subtitle: selectedWalletProvider != null
                ? Text(selectedWalletProvider!.description!)
                : null,
            onTap: () => _selectWalletProvider(context),
          ),
        ),
        const Divider(height: 1),
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: SwitchListTile(
              value: useProviderAppearance,
              onChanged: onUseProviderAppearanceChanged,
              title: const Text('Use Provider Appearance'),
              subtitle: const Text(
                'Use provider appearance as the wallet appearance',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProviderAvatar() {
    return DynamicAvatar(
      icon: selectedWalletProvider?.iconType == IconSelectionType.icon.name
          ? IconData(
              selectedWalletProvider!.iconCodePoint!,
              fontFamily: 'MaterialIcons',
            )
          : null,
      emoji: selectedWalletProvider?.iconType == IconSelectionType.emoji.name
          ? selectedWalletProvider?.iconEmoji
          : null,
      image: selectedWalletProvider?.iconType == IconSelectionType.image.name ||
              selectedWalletProvider?.iconType == null
          ? (selectedWalletProvider?.localImagePath != null
              ? FileImage(File(selectedWalletProvider!.localImagePath!))
              : selectedWalletProvider!.imageUrl != null
                  ? cachedImageProvider(selectedWalletProvider!.imageUrl!)
                  : null)
          : null,
      size: 44,
      color: selectedWalletProvider?.color != null
          ? HexColor.fromHex(selectedWalletProvider!.color!)
          : null,
    );
  }
}


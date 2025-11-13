import 'dart:io';

import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/wallets/providers/select_wallet_provider_screen.dart';
import 'package:billkeep/utils/app_colors.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/image_helpers.dart';
import 'package:billkeep/utils/wallet_types.dart';
import 'package:billkeep/widgets/common/dynamic_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletProviderDropdown extends ConsumerStatefulWidget {
  final WalletProvider? selectedProvider;
  final WalletType selectedWalletType;
  final ValueChanged<WalletProvider?> onChanged;

  const WalletProviderDropdown({
    super.key,
    this.selectedProvider,
    required this.onChanged,
    required this.selectedWalletType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WalletProviderDropdownState();
}

class _WalletProviderDropdownState
    extends ConsumerState<WalletProviderDropdown> {
  WalletProvider? _selectedWalletProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.selectedProvider != null) {
      _selectedWalletProvider = widget.selectedProvider;
      widget.onChanged(_selectedWalletProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    void _selectWalletProvider() async {
      final result = await Navigator.of(context).push<WalletProvider?>(
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) =>
              WalletProviderSelectScreen(walletType: widget.selectedWalletType),
        ),
      );
      print(result);
      if (result != null) {
        setState(() {
          _selectedWalletProvider = result;
        });
      }
    }

    final colors = ref.watch(appColorsProvider);

    return InkWell(
      onTap: _selectWalletProvider,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: colors.text),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (_selectedWalletProvider != null) ...[
              _buildWalletProviderAvatar(_selectedWalletProvider),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  _selectedWalletProvider!.name,
                  style: TextStyle(fontSize: 16, color: colors.text),
                ),
              ),
            ] else ...[
              Icon(
                Icons.account_balance_wallet_outlined,
                color: colors.textMute,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Select Wallet Provider',
                  style: TextStyle(color: colors.textMute),
                ),
              ),
            ],
            Icon(Icons.arrow_drop_down, color: colors.text),
          ],
        ),
      ),
    );
  }
}

Widget _buildWalletProviderAvatar(WalletProvider? walletProvider) {
  if (walletProvider == null) {
    return DynamicAvatar(icon: Icons.account_balance, size: 44);
  } else {
    return DynamicAvatar(
      icon: walletProvider.iconType == IconSelectionType.icon.name
          ? IconData(walletProvider.iconCodePoint!, fontFamily: 'MaterialIcons')
          : null,
      emoji: walletProvider.iconType == IconSelectionType.emoji.name
          ? walletProvider.iconEmoji
          : null,
      image:
          walletProvider.iconType == IconSelectionType.image.name ||
              walletProvider.iconType == null
          ? (walletProvider.localImagePath != null
                ? FileImage(File(walletProvider.localImagePath!))
                : walletProvider.imageUrl != null
                ? cachedImageProvider(walletProvider.imageUrl!)
                : null)
          : null,
      size: 44,
      color: walletProvider.color != null
          ? HexColor.fromHex(walletProvider.color!)
          : null,
    );
  }
}

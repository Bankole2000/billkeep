import 'dart:io';

import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/providers/wallet_provider.dart';
import 'package:billkeep/screens/wallets/add_wallet_screen.dart';
import 'package:billkeep/utils/app_colors.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:billkeep/utils/wallet_types.dart';
import 'package:billkeep/widgets/common/dynamic_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletListSelectItem extends ConsumerWidget {
  const WalletListSelectItem({
    super.key,
    required this.isSelected,
    required this.walletWithRelations,
    required this.onSelectWallet,
  });

  final WalletWithRelations walletWithRelations;
  final bool isSelected;
  final void Function() onSelectWallet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    Wallet wallet = walletWithRelations.wallet;
    return InkWell(
      onTap: onSelectWallet,
      child: ListTile(
        tileColor: Colors.amber,
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        // visualDensity: VisualDensity(vertical: -5),
        leading: DynamicAvatar(
          emojiOffset: Platform.isIOS ? Offset(6, 2) : Offset(3, -1),
          icon: wallet.iconType == IconSelectionType.icon.name
              ? IconData(wallet.iconCodePoint!, fontFamily: 'MaterialIcons')
              : null,
          emoji: wallet.iconType == IconSelectionType.emoji.name
              ? wallet.iconEmoji
              : null,
          image:
              wallet.iconType == IconSelectionType.image.name &&
                  wallet.localImagePath != null
              ? FileImage(File(wallet.localImagePath!))
              : wallet.imageUrl != null
              ? NetworkImage(wallet.imageUrl!)
              : null,
          color: wallet.color != null
              ? HexColor.fromHex('#${wallet.color}')
              : colors.textMute,
        ),

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              wallet.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? colors.text : colors.textMute,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
        subtitle: Text(
          '${walletWithRelations.currency.symbol} - ${WalletTypes.getInfo(WalletTypes.stringToEnum(wallet.walletType)).name} - ${walletWithRelations.currency.code} ${wallet.providerId != null ? walletWithRelations.provider?.name : ""}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? colors.navy : colors.textMute,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              AppPageRoute.slideRight(AddWalletScreen(wallet: wallet)),
            );
          },
          icon: Icon(Icons.chevron_right_rounded),
        ),
        onTap: onSelectWallet,
      ),
    );
  }
}

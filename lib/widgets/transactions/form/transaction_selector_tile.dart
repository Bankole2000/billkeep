import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database.dart';
import '../../../providers/ui_providers.dart';
import '../../../utils/app_enums.dart';
import '../../../utils/image_helpers.dart';
import '../../common/dynamic_avatar.dart';

/// Generic selector tile for transaction form fields
class TransactionSelectorTile extends ConsumerWidget {
  final String label;
  final String? selectedText;
  final Widget? leadingAvatar;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isVisible;

  const TransactionSelectorTile({
    super.key,
    required this.label,
    this.selectedText,
    this.leadingAvatar,
    required this.onTap,
    this.trailing,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      visualDensity: const VisualDensity(vertical: 0.1),
      leading: leadingAvatar,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(color: colors.textMute),
          ),
          if (selectedText != null)
            Flexible(
              child: Text(
                selectedText!,
                style: TextStyle(color: colors.text),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

/// Category selector tile
class CategorySelectorTile extends ConsumerWidget {
  final Category? selectedCategory;
  final VoidCallback onTap;

  const CategorySelectorTile({
    super.key,
    required this.selectedCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TransactionSelectorTile(
      label: 'Category',
      selectedText: selectedCategory?.name,
      leadingAvatar: DynamicAvatar(
        emoji: selectedCategory?.iconEmoji,
        color: selectedCategory?.color != null
            ? HexColor.fromHex(selectedCategory!.color!)
            : Colors.blueGrey,
        icon: selectedCategory != null ? null : Icons.folder,
        emojiOffset: Platform.isIOS
            ? const Offset(6, 0)
            : const Offset(1, -2),
      ),
      onTap: onTap,
    );
  }
}

/// Merchant selector tile
class MerchantSelectorTile extends ConsumerWidget {
  final Merchant? selectedMerchant;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final bool isVisible;

  const MerchantSelectorTile({
    super.key,
    required this.selectedMerchant,
    required this.onTap,
    required this.onAdd,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TransactionSelectorTile(
      label: 'Merchant',
      selectedText: selectedMerchant?.name,
      leadingAvatar: _buildMerchantAvatar(ref),
      trailing: _buildAddButton(ref),
      onTap: onTap,
      isVisible: isVisible,
    );
  }

  Widget _buildMerchantAvatar(WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return DynamicAvatar(
      image: selectedMerchant?.imageUrl != null
          ? cachedImageProvider(selectedMerchant!.imageUrl!)
          : null,
      icon: selectedMerchant != null ? null : Icons.store,
      color: colors.fire,
    );
  }

  Widget _buildAddButton(WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return IconButton(
      onPressed: onAdd,
      icon: Icon(Icons.add, color: colors.text),
    );
  }
}

/// Project selector tile
class ProjectSelectorTile extends ConsumerWidget {
  final Project? selectedProject;
  final VoidCallback onTap;

  const ProjectSelectorTile({
    super.key,
    required this.selectedProject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TransactionSelectorTile(
      label: 'Project',
      selectedText: selectedProject == null
          ? 'No Project Selected'
          : selectedProject!.name,
      leadingAvatar: _buildProjectAvatar(),
      onTap: onTap,
    );
  }

  Widget _buildProjectAvatar() {
    return DynamicAvatar(
      emojiOffset: const Offset(3, -1),
      icon: selectedProject?.iconType == IconSelectionType.icon.name
          ? IconData(
              selectedProject!.iconCodePoint!,
              fontFamily: 'MaterialIcons',
            )
          : null,
      emoji: selectedProject?.iconType == IconSelectionType.emoji.name
          ? selectedProject?.iconEmoji
          : null,
      image: selectedProject?.iconType == IconSelectionType.image.name &&
              selectedProject?.localImagePath != null
          ? FileImage(File(selectedProject!.localImagePath!))
          : selectedProject?.imageUrl != null
              ? cachedImageProvider(selectedProject!.imageUrl!)
              : null,
      color: selectedProject?.color != null
          ? HexColor.fromHex('#${selectedProject?.color}')
          : Colors.grey.shade100,
    );
  }
}

/// Wallet selector tile
class WalletSelectorTile extends ConsumerWidget {
  final Wallet? selectedWallet;
  final String label;
  final VoidCallback onTap;
  final bool isVisible;

  const WalletSelectorTile({
    super.key,
    required this.selectedWallet,
    required this.label,
    required this.onTap,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TransactionSelectorTile(
      label: label,
      selectedText: selectedWallet != null
          ? '${selectedWallet!.currency} - ${selectedWallet!.name}'
          : null,
      leadingAvatar: _buildWalletAvatar(),
      onTap: onTap,
      isVisible: isVisible,
    );
  }

  Widget _buildWalletAvatar() {
    return DynamicAvatar(
      emojiOffset: Platform.isIOS
          ? const Offset(6, 2)
          : const Offset(3, -1),
      icon: selectedWallet?.iconType == IconSelectionType.icon.name
          ? IconData(
              selectedWallet!.iconCodePoint!,
              fontFamily: 'MaterialIcons',
            )
          : null,
      emoji: selectedWallet?.iconType == IconSelectionType.emoji.name
          ? selectedWallet?.iconEmoji
          : null,
      image: selectedWallet?.iconType == IconSelectionType.image.name &&
              selectedWallet?.localImagePath != null
          ? FileImage(File(selectedWallet!.localImagePath!))
          : selectedWallet?.imageUrl != null
              ? cachedImageProvider(selectedWallet!.imageUrl!)
              : null,
      color: selectedWallet?.color != null
          ? HexColor.fromHex('#${selectedWallet?.color}')
          : Colors.grey.shade100,
    );
  }
}

/// Helper to convert hex string to Color
extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

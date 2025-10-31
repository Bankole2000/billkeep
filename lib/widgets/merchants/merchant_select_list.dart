import 'package:billkeep/providers/merchant_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/merchants/add_merchant_screen.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:billkeep/widgets/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
// import '../../providers/merchant_provider.dart';

class MerchantsList extends ConsumerWidget {
  final Function(Merchant)? onMerchantSelected;
  final bool showDefaultMerchantsOnly;
  final bool showCustomMerchantsOnly;
  final List<Merchant> merchants;

  const MerchantsList({
    super.key,
    required this.merchants,
    this.onMerchantSelected,
    this.showDefaultMerchantsOnly = false,
    this.showCustomMerchantsOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (merchants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No merchants found',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: merchants.length,
      itemBuilder: (context, index) {
        final merchant = merchants[index];
        return MerchantListItem(
          merchant: merchant,
          onTap: () {
            ref.read(merchantSearchQueryProvider.notifier).state = '';
            Navigator.pop(context, merchant);
          },
        );
      },
    );
  }
}

class MerchantListItem extends ConsumerWidget {
  final Merchant merchant;
  final VoidCallback? onTap;

  const MerchantListItem({super.key, required this.merchant, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    // final activeColor = ref.watch(activeThemeColorProvider);
    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colors.textMute.withAlpha(50),
          width: .5,
        ), // Customize color and width
        borderRadius: BorderRadius.circular(0), // Optional: Add rounded corners
      ),
      contentPadding: EdgeInsets.only(right: 10, left: 16),
      leading: _buildMerchantAvatar(),
      title: Text(
        merchant.name,
        style: TextStyle(fontWeight: FontWeight.w500, color: colors.text),
      ),
      subtitle: merchant.description != null
          ? Text(
              merchant.description!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: colors.textMute),
            )
          : null,
      trailing: IconButton(
        onPressed: () => {
          Navigator.push(
            context,
            AppPageRoute.slideRight(AddMerchantScreen(merchant: merchant)),
          ),
        },
        icon: Icon(Icons.chevron_right_rounded, color: colors.text),
      ),
      onTap: onTap,
    );
  }

  Widget _buildMerchantAvatar() {
    // Priority: imageUrl > localImagePath > iconEmoji > iconCodePoint > default
    if (merchant.imageUrl != null && merchant.imageUrl!.isNotEmpty) {
      return SizedBox(
        width: 50,
        height: 50,
        child: AppImage(
          imageUrl: merchant.imageUrl!,
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

    if (merchant.localImagePath != null &&
        merchant.localImagePath!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: AssetImage(merchant.localImagePath!),
        backgroundColor: Colors.grey.shade200,
      );
    }

    final backgroundColor = merchant.color != null
        ? Color(int.parse(merchant.color!.replaceFirst('#', '0xFF')))
        : Colors.grey.shade200;

    if (merchant.iconEmoji != null && merchant.iconEmoji!.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: backgroundColor,
        child: Text(merchant.iconEmoji!, style: const TextStyle(fontSize: 24)),
      );
    }

    if (merchant.iconCodePoint != null) {
      return CircleAvatar(
        backgroundColor: backgroundColor,
        child: Icon(
          IconData(merchant.iconCodePoint!, fontFamily: merchant.iconType),
          color: Colors.white,
        ),
      );
    }

    // Default icon
    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: Icon(Icons.store, color: Colors.white),
    );
  }
}

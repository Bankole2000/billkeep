import 'package:billkeep/screens/merchants/add_merchant_screen.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:billkeep/widgets/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../providers/merchant_provider.dart';

class MerchantsList extends ConsumerWidget {
  final Function(Merchant)? onMerchantSelected;
  final bool showDefaultMerchantsOnly;
  final bool showCustomMerchantsOnly;

  const MerchantsList({
    super.key,
    this.onMerchantSelected,
    this.showDefaultMerchantsOnly = false,
    this.showCustomMerchantsOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Select the appropriate provider based on filters
    final merchantsAsync = showDefaultMerchantsOnly
        ? ref.watch(defaultMerchantsProvider)
        : showCustomMerchantsOnly
        ? ref.watch(customMerchantsProvider)
        : ref.watch(allMerchantsProvider);

    return merchantsAsync.when(
      data: (merchants) {
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
              onTap: () {},
              // onTap: onMerchantSelected != null
              //     ? () => onMerchantSelected!(merchant)
              //     : null,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading merchants',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class MerchantListItem extends StatelessWidget {
  final Merchant merchant;
  final VoidCallback? onTap;

  const MerchantListItem({super.key, required this.merchant, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(right: 10, left: 16),
      leading: _buildMerchantAvatar(),
      title: Text(
        merchant.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: merchant.description != null
          ? Text(
              merchant.description!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            )
          : null,
      // trailing: merchant.isDefault
      //     ? Chip(
      //         label: const Text('Default', style: TextStyle(fontSize: 10)),
      //         backgroundColor: Colors.blue.shade50,
      //         labelStyle: TextStyle(color: Colors.blue.shade700),
      //         visualDensity: VisualDensity.compact,
      //       )
      //     : null,
      trailing: IconButton(
        onPressed: () => {
          Navigator.push(
            context,
            AppPageRoute.slideRight(AddMerchantScreen(merchant: merchant)),
          ),
        },
        icon: Icon(Icons.chevron_right_rounded),
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

import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/widgets/merchants/merchant_select_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionMerchantSelectScreen extends ConsumerStatefulWidget {
  const TransactionMerchantSelectScreen({super.key});

  @override
  ConsumerState<TransactionMerchantSelectScreen> createState() =>
      _TransactionMerchantSelectScreenState();
}

class _TransactionMerchantSelectScreenState
    extends ConsumerState<TransactionMerchantSelectScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    super.initState();
    searchTextController = TextEditingController();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: activeColor,
        iconTheme: IconThemeData(color: colors.textInverse),
        actionsIconTheme: IconThemeData(color: colors.textInverse),
        title: Text(
          'Select Merchant',
          style: TextStyle(color: colors.textInverse),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: CupertinoSearchTextField(
              backgroundColor: const Color(0xFFE0E0E0),
              controller: searchTextController,
              placeholder: 'Search',
              placeholderStyle: const TextStyle(
                color: Color(0xFF9E9E9E), // 🔹 Placeholder color
                fontSize: 20,
              ),
              style: const TextStyle(
                color: Colors.black, // 🔹 Input text color
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                CupertinoIcons.search,
                color: Colors.blueAccent, // 🔹 Icon color
              ),
              suffixIcon: const Icon(
                CupertinoIcons.xmark_circle_fill,
                color: Colors.redAccent, // 🔹 Clear button color
              ),
              onChanged: (value) {
                // handle search
              },
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        ],
      ),
      body: MerchantsList(),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: SizedBox(
      //     height: 56,
      //     width: double.infinity,
      //     child: ElevatedButton(
      //       onPressed: () {},
      //       style: ElevatedButton.styleFrom(
      //         backgroundColor: activeColor,
      //         foregroundColor: colors.textInverse,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(6),
      //         ),
      //       ),
      //       child: const Text(
      //         'SAVE',
      //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

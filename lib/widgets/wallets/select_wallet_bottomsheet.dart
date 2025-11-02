import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/wallet_provider.dart';
import 'package:billkeep/screens/wallets/add_wallet_screen.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:billkeep/widgets/wallets/wallet_list_select_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectWalletBottomSheet extends ConsumerWidget {
  const SelectWalletBottomSheet({super.key, this.selectedWallet});

  final Wallet? selectedWallet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletsWithRelationsProvider);
    return Container(
      height: 400, // Adjust height as needed
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: CupertinoColors.systemGrey5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(width: 24),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10),
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(25),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: Size(20, 20),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.clear,
                        color: CupertinoColors.label,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Select Wallet',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(right: 10),
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(25),
                    onPressed: () => {
                      Navigator.push(
                        context,
                        AppPageRoute.slideRight(AddWalletScreen()),
                      ),
                    },
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: Size(20, 20),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.add,
                        color: CupertinoColors.label,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 20 + MediaQuery.of(context).padding.bottom,
            // top: 50,
            child: ClipRRect(
              child: SizedBox(
                height: 320,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SizedBox(height: 40),
                      ...wallets.when(
                        data: (wt) {
                          if (wt.isEmpty) {
                            return const [
                              Center(
                                child: Text(
                                  'No projects yet. Tap + to create one.',
                                ),
                              ),
                            ];
                          }
                          return wt
                              .expand(
                                (w) => [
                                  WalletListSelectItem(
                                    isSelected:
                                        selectedWallet?.id == w.wallet.id,
                                    walletWithRelations: w,
                                    onSelectWallet: () {
                                      // selectProject(p);
                                      Navigator.of(context).pop(w);
                                    },
                                  ),
                                  Divider(),
                                ],
                              )
                              .toList();
                        },
                        error: (error, stack) => [
                          Text('Error loading Projects'),
                        ],
                        loading: () => [
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/wallet_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletTypeDropdown extends ConsumerStatefulWidget {
  final WalletType? selectedType;
  final ValueChanged<WalletType?> onChanged;

  const WalletTypeDropdown({
    super.key,
    this.selectedType,
    required this.onChanged,
  });

  @override
  ConsumerState<WalletTypeDropdown> createState() => _WalletTypeDropdownState();
}

class _WalletTypeDropdownState extends ConsumerState<WalletTypeDropdown> {
  void _showWalletTypeSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Select Wallet Type',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: WalletTypes.all.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final walletType = WalletTypes.all[index];
                  final isSelected = widget.selectedType == walletType.type;

                  return ListTile(
                    leading: Icon(
                      walletType.icon,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          walletType.name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(e.g., ${walletType.examples.take(2).join(', ')})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          walletType.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                    onTap: () {
                      widget.onChanged(walletType.type);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final selectedInfo = widget.selectedType != null
        ? WalletTypes.getInfo(widget.selectedType!)
        : null;

    return InkWell(
      onTap: _showWalletTypeSelector,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: colors.textInverse),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (selectedInfo != null) ...[
              Icon(selectedInfo.icon, color: colors.textInverse),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedInfo.name,
                  style: TextStyle(fontSize: 16, color: colors.textInverse),
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
                  'Select wallet type',
                  style: TextStyle(color: colors.textMute),
                ),
              ),
            ],
            Icon(Icons.arrow_drop_down, color: colors.textInverse),
          ],
        ),
      ),
    );
  }
}

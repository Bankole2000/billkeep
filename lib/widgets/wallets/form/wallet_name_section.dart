import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/ui_providers.dart';

/// Wallet name input section for wallet form
class WalletNameSection extends ConsumerWidget {
  final TextEditingController nameController;

  const WalletNameSection({
    super.key,
    required this.nameController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        child: ListTile(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          contentPadding: const EdgeInsets.only(
            top: 0,
            left: 10,
            right: 20,
          ),
          visualDensity: const VisualDensity(vertical: 0.1),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Icon(
              Icons.edit_sharp,
              size: 30,
              color: colors.textMute,
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(top: 0, left: 10),
            child: Text('Wallet Name', textAlign: TextAlign.start),
          ),
          subtitle: CupertinoTextFormFieldRow(
            controller: nameController,
            style: const TextStyle(fontSize: 30),
            padding: EdgeInsets.zero,
            placeholder: 'Required',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a wallet name';
              }
              return null;
            },
          ),
          onTap: () {},
          minTileHeight: 10,
        ),
      ),
    );
  }
}

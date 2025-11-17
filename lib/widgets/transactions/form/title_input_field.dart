import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/ui_providers.dart';

/// Title input field for transaction forms
class TitleInputField extends ConsumerWidget {
  final TextEditingController controller;

  const TitleInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return ListTile(
      tileColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 30),
      visualDensity: const VisualDensity(vertical: 0.1),
      leading: Icon(Icons.edit_sharp, color: colors.text),
      title: CupertinoTextFormFieldRow(
        controller: controller,
        style: TextStyle(color: colors.text),
        padding: EdgeInsets.zero,
        prefix: Text(
          'Title',
          style: TextStyle(color: colors.textMute),
        ),
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              value.trim().length <= 1 ||
              value.trim().length > 50) {
            return 'Must be text of less than 50 characters';
          }
          return null;
        },
      ),
      onTap: () {},
    );
  }
}

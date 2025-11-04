import 'dart:io' show Platform;

import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectRecurrenceBottomSheet extends ConsumerWidget {
  const SelectRecurrenceBottomSheet({super.key, this.selectedRecurrence});

  final TransactionRecurrence? selectedRecurrence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
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
                  'Repeat Every',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(right: 10),
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(25),
                    onPressed: () => {
                      Navigator.pop(context, selectedRecurrence),
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
                        CupertinoIcons.check_mark,
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
            top: Platform.isIOS ? 50 : null,
            child: ClipRRect(
              child: SizedBox(
                height: 320,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...recurrenceOptions.entries.map((entry) {
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: colors.textMute,
                              width: 1,
                            ), // Customize color and width
                            borderRadius: BorderRadius.circular(
                              0,
                            ), // Optional: Add rounded corners
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          title: Text(
                            entry.value,
                            style: TextStyle(
                              fontWeight: selectedRecurrence == entry.key
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: selectedRecurrence == entry.key
                                  ? colors.navy
                                  : colors.textMute,
                            ),
                          ),
                          leading: Icon(
                            recurrenceIcons[entry.key],
                            color: selectedRecurrence == entry.key
                                ? colors.navy
                                : Colors.grey,
                          ),
                          trailing: selectedRecurrence == entry.key
                              ? Icon(
                                  Icons.check,
                                  color: colors.navy,
                                )
                              : null,
                          onTap: () {
                            Navigator.pop(context, entry.key);
                          },
                        );
                      }),
                      
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

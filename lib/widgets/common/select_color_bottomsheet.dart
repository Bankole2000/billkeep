import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/widgets/common/color_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectColorBottomSheet extends ConsumerWidget {
  const SelectColorBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorPickerType = ColorPickerType.block;
    final activeColor = ref.watch(activeThemeColorProvider);
    final colors = ref.watch(appColorsProvider);
    return Container(
      height: 650, // Adjust height as needed
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
                  'Select Color',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(right: 10),
                  child: IconButton(
                    tooltip: 'Toggle view',
                    icon: Icon(
                      colorPickerType == ColorPickerType.block
                          ? Icons.view_list
                          : Icons.grid_view,
                    ),
                    onPressed: () {
                      // final notifier = ref.read(
                      //   categoryViewModeProvider.notifier,
                      // );
                      // notifier.state =
                      colorPickerType == ColorPickerType.block
                          ? ColorPickerType.material
                          : ColorPickerType.block;
                    },
                  ),

                  // CupertinoButton(
                  //   borderRadius: BorderRadius.circular(25),
                  //   onPressed: () => {},
                  //   padding: EdgeInsets.symmetric(horizontal: 16),
                  //   minimumSize: Size(20, 20),
                  //   child: Container(
                  //     width: 30,
                  //     height: 30,
                  //     decoration: BoxDecoration(
                  //       color: CupertinoColors.systemGrey5,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: Icon(
                  //       CupertinoIcons.add,
                  //       color: CupertinoColors.label,
                  //     ),
                  //   ),
                  // ),
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
                height: 370,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ColorPickerWidget(
                        // pickerColor: Colors.grey.shade500,
                        onColorChanged: (Color) {},
                        currentColor: Colors.grey.shade500,
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 20, // Safe area
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // Adjust this valu
                  ),
                  backgroundColor: activeColor,
                ),
                label: Text(
                  'Select Color',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: colors.textInverse,
                  ),
                ),
                icon: Icon(Icons.add, size: 24, color: colors.textInverse),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

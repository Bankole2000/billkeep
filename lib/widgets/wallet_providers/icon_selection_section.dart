import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/widgets/common/emoji_picker_widget.dart';
import 'package:billkeep/widgets/common/icon_picker_widget.dart';
import 'package:billkeep/widgets/common/sliding_segment_control_label.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';

/// Icon selection section with emoji/icon/image segments
class IconSelectionSection extends StatelessWidget {
  final IconSelectionType selectedSegment;
  final ValueChanged<IconSelectionType> onSegmentChanged;
  final IconData? selectedIcon;
  final ValueChanged<IconData>? onIconSelected;
  final String? selectedEmoji;
  final ValueChanged<String>? onEmojiSelected;
  final Widget? imagePreview;

  const IconSelectionSection({
    super.key,
    required this.selectedSegment,
    required this.onSegmentChanged,
    this.selectedIcon,
    this.onIconSelected,
    this.selectedEmoji,
    this.onEmojiSelected,
    this.imagePreview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Icon Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Segment control for icon type selection
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomSlidingSegmentedControl<IconSelectionType>(
            initialValue: selectedSegment,
            children: {
              IconSelectionType.emoji: SlidingSegmentControlLabel(
                label: 'Emoji',
                icon: Icons.emoji_emotions,
              ),
              IconSelectionType.icon: SlidingSegmentControlLabel(
                label: 'Icon',
                icon: Icons.ac_unit,
              ),
              IconSelectionType.image: SlidingSegmentControlLabel(
                label: 'Image',
                icon: Icons.image,
              ),
            },
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            thumbDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6),
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInToLinear,
            onValueChanged: onSegmentChanged,
          ),
        ),

        const SizedBox(height: 20),

        // Icon content based on selected segment
        if (selectedSegment == IconSelectionType.emoji && onEmojiSelected != null)
          EmojiPickerWidget(
            selectedEmoji: selectedEmoji ?? '🏦',
            onEmojiSelected: onEmojiSelected!,
          )
        else if (selectedSegment == IconSelectionType.icon && onIconSelected != null)
          IconPickerWidget(
            selectedIcon: selectedIcon ?? Icons.account_balance,
            onIconSelected: onIconSelected!,
          )
        else if (selectedSegment == IconSelectionType.image && imagePreview != null)
          imagePreview!,

        const SizedBox(height: 20),
      ],
    );
  }
}

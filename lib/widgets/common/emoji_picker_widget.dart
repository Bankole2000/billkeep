import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

/// A widget for picking emojis
/// Designed for use in modals/bottom sheets (not full screen)
class EmojiPickerWidget extends StatelessWidget {
  final Function(String) onEmojiSelected;
  final double height;
  final Color? backgroundColor;
  final bool checkPlatformCompatibility;
  final int columns;
  final double emojiSize;
  final bool enableSkinTones;
  final bool showRecentsTab;
  final bool showSearchView;

  const EmojiPickerWidget({
    super.key,
    required this.onEmojiSelected,
    this.height = 300,
    this.backgroundColor,
    this.checkPlatformCompatibility = true,
    this.columns = 7,
    this.emojiSize = 32,
    this.enableSkinTones = true,
    this.showRecentsTab = true,
    this.showSearchView = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: EmojiPicker(
        onEmojiSelected: (Category? category, Emoji emoji) {
          onEmojiSelected(emoji.emoji);
        },
        onBackspacePressed: null, // Hide backspace button
        config: Config(
          height: height,
          checkPlatformCompatibility: checkPlatformCompatibility,
          viewOrderConfig: ViewOrderConfig(
            top: showSearchView ? EmojiPickerItem.searchBar : EmojiPickerItem.categoryBar,
            middle: EmojiPickerItem.emojiView,
            bottom: showSearchView ? EmojiPickerItem.categoryBar : EmojiPickerItem.searchBar,
          ),
          emojiViewConfig: EmojiViewConfig(
            columns: columns,
            emojiSizeMax: emojiSize *
                (foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS
                    ? 1.20
                    : 1.0),
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            recentsLimit: 28,
            replaceEmojiOnLimitExceed: false,
            noRecents: Text(
              'No Recents',
              style: TextStyle(fontSize: 20, color: Colors.black26),
              textAlign: TextAlign.center,
            ),
            loadingIndicator: const SizedBox.shrink(),
            buttonMode: ButtonMode.MATERIAL,
          ),
          skinToneConfig: SkinToneConfig(
            enabled: enableSkinTones,
            dialogBackgroundColor: Colors.white,
            indicatorColor: Colors.grey,
          ),
          categoryViewConfig: CategoryViewConfig(
            initCategory: Category.RECENT,
            backgroundColor: backgroundColor ?? const Color(0xFFF2F2F2),
            indicatorColor: Colors.blue,
            iconColor: Colors.grey,
            iconColorSelected: Colors.blue,
            backspaceColor: Colors.blue,
            categoryIcons: const CategoryIcons(),
            recentTabBehavior: showRecentsTab
                ? RecentTabBehavior.RECENT
                : RecentTabBehavior.NONE,
          ),
          bottomActionBarConfig: const BottomActionBarConfig(
            enabled: false,
          ),
          searchViewConfig: SearchViewConfig(
            backgroundColor: backgroundColor ?? const Color(0xFFF2F2F2),
            buttonIconColor: Colors.blue,
            hintText: 'Search emoji',
          ),
        ),
      ),
    );
  }
}

/// Simple emoji selector button that shows a bottom sheet
class EmojiSelectorButton extends StatefulWidget {
  final String? selectedEmoji;
  final Function(String) onEmojiSelected;
  final double buttonSize;
  final Color? backgroundColor;
  final double pickerHeight;

  const EmojiSelectorButton({
    super.key,
    this.selectedEmoji,
    required this.onEmojiSelected,
    this.buttonSize = 48,
    this.backgroundColor,
    this.pickerHeight = 300,
  });

  @override
  State<EmojiSelectorButton> createState() => _EmojiSelectorButtonState();
}

class _EmojiSelectorButtonState extends State<EmojiSelectorButton> {
  String? _selectedEmoji;

  @override
  void initState() {
    super.initState();
    _selectedEmoji = widget.selectedEmoji;
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: widget.pickerHeight + 40,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: EmojiPickerWidget(
                  height: widget.pickerHeight,
                  backgroundColor: widget.backgroundColor,
                  onEmojiSelected: (emoji) {
                    setState(() {
                      _selectedEmoji = emoji;
                    });
                    widget.onEmojiSelected(emoji);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showEmojiPicker,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: widget.buttonSize,
                  height: widget.buttonSize,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _selectedEmoji ?? '😀',
                      style: TextStyle(fontSize: widget.buttonSize * 0.6),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _selectedEmoji == null ? 'Select Emoji' : 'Emoji Selected',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:image_picker/image_picker.dart';
import '../../../main.dart' as main;
import '../../../providers/ui_providers.dart';
import '../../../screens/camera/camera_screen.dart';
import '../../../utils/app_enums.dart';
import '../../../utils/image_helpers.dart';
import '../../../utils/validators.dart';
import '../../common/color_picker_widget.dart';
import '../../common/dynamic_avatar.dart';
import '../../common/emoji_picker_widget.dart';
import '../../common/icon_picker_widget.dart';
import '../../common/sliding_segment_control_label.dart';

/// Appearance configuration section for wallet form
class AppearanceSection extends ConsumerStatefulWidget {
  final bool useProviderAppearance;
  final IconSelectionType selectedSegment;
  final IconData? selectedIcon;
  final String? selectedEmoji;
  final Color? selectedColor;
  final TextEditingController imageUrlController;
  final File? localImageFile;
  final ValueChanged<IconSelectionType> onSegmentChanged;
  final ValueChanged<IconData?> onIconSelected;
  final ValueChanged<String> onEmojiSelected;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<File> onLocalImageChanged;

  const AppearanceSection({
    super.key,
    required this.useProviderAppearance,
    required this.selectedSegment,
    required this.selectedIcon,
    required this.selectedEmoji,
    required this.selectedColor,
    required this.imageUrlController,
    required this.localImageFile,
    required this.onSegmentChanged,
    required this.onIconSelected,
    required this.onEmojiSelected,
    required this.onColorChanged,
    required this.onLocalImageChanged,
  });

  @override
  ConsumerState<AppearanceSection> createState() => _AppearanceSectionState();
}

class _AppearanceSectionState extends ConsumerState<AppearanceSection> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onLocalImageChanged(File(image.path));
        widget.imageUrlController.text = image.path;
      }
    } catch (e) {
      if (mounted) {
        _showError('Error selecting image: $e');
      }
    }
  }

  Future<void> _takePhoto() async {
    if (main.cameras.isEmpty) {
      if (mounted) {
        _showError('No camera available on this device');
      }
      return;
    }

    final XFile? photo = await Navigator.push<XFile>(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: main.cameras.first),
      ),
    );

    if (photo != null) {
      widget.onLocalImageChanged(File(photo.path));
      widget.imageUrlController.text = photo.path;
    }
  }

  Future<void> _pasteUrl() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final pastedText = clipboardData?.text;
    if (pastedText != null && Validators.isValidUrl(pastedText)) {
      widget.imageUrlController.text = pastedText;
    } else {
      _showError('Invalid Image url in Clipboard');
    }
  }

  void _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.imageUrlController.text));
    if (mounted) {
      final colors = ref.read(appColorsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ImageURL Copied to Clipboard'),
          backgroundColor: colors.navy,
        ),
      );
    }
  }

  void _showError(String message) {
    final colors = ref.read(appColorsProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors.fire,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useProviderAppearance) {
      return const SizedBox.shrink();
    }

    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);

    return Column(
      children: [
        // Appearance preview and selector
        _buildAppearancePreview(colors),
        const Divider(height: 1),

        // Icon picker
        if (widget.selectedSegment == IconSelectionType.icon)
          IconPickerWidget(
            onIconSelected: widget.onIconSelected,
          ),

        // Emoji picker
        if (widget.selectedSegment == IconSelectionType.emoji)
          EmojiPickerWidget(
            onEmojiSelected: widget.onEmojiSelected,
          ),

        // Image picker
        if (widget.selectedSegment == IconSelectionType.image)
          _buildImagePicker(colors, activeColor),

        const Divider(height: 1),
      ],
    );
  }

  Widget _buildAppearancePreview(dynamic colors) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        child: ListTile(
          tileColor: colors.surface,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          contentPadding: const EdgeInsets.only(
            top: 0,
            left: 10,
            right: 20,
          ),
          visualDensity: const VisualDensity(vertical: 0.1),
          title: Padding(
            padding: const EdgeInsets.only(
              top: 0,
              left: 8,
              bottom: 10,
            ),
            child: Text(
              'Appearance',
              textAlign: TextAlign.start,
              style: TextStyle(color: colors.text),
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 4),
              _buildAvatarPreview(),
              _buildSegmentedControl(colors),
              const Spacer(),
              ColorSelectorButton(
                selectedColor: widget.selectedColor,
                onColorChanged: widget.onColorChanged,
                pickerType: ColorPickerType.block,
              ),
            ],
          ),
          onTap: () {},
          minTileHeight: 10,
        ),
      ),
    );
  }

  Widget _buildAvatarPreview() {
    return DynamicAvatar(
      emojiOffset: Platform.isIOS ? const Offset(11, 6) : const Offset(7, 5),
      icon: widget.selectedSegment == IconSelectionType.icon
          ? widget.selectedIcon
          : null,
      emoji: widget.selectedSegment == IconSelectionType.emoji
          ? widget.selectedEmoji
          : null,
      image: widget.selectedSegment == IconSelectionType.image
          ? (widget.localImageFile != null
              ? FileImage(widget.localImageFile!)
              : widget.imageUrlController.text.trim().isNotEmpty
                  ? cachedImageProvider(widget.imageUrlController.text)
                  : null)
          : null,
      size: 50,
      color: widget.selectedColor,
    );
  }

  Widget _buildSegmentedControl(dynamic colors) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomSlidingSegmentedControl<IconSelectionType>(
        initialValue: widget.selectedSegment,
        children: {
          IconSelectionType.icon: SlidingSegmentControlLabel(
            isActive: widget.selectedSegment == IconSelectionType.icon,
            label: 'Icon',
            icon: iconSelectionTypeIcons[IconSelectionType.icon]!,
            activeColor: colors.fire,
          ),
          IconSelectionType.emoji: SlidingSegmentControlLabel(
            icon: iconSelectionTypeIcons[IconSelectionType.emoji]!,
            label: 'Emoji',
            isActive: widget.selectedSegment == IconSelectionType.emoji,
            activeColor: colors.wave,
          ),
          IconSelectionType.image: SlidingSegmentControlLabel(
            icon: iconSelectionTypeIcons[IconSelectionType.image]!,
            label: 'Image',
            isActive: widget.selectedSegment == IconSelectionType.image,
            activeColor: colors.water,
          ),
        },
        onValueChanged: widget.onSegmentChanged,
        innerPadding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        thumbDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(dynamic colors, Color activeColor) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: CupertinoTextFormFieldRow(
              controller: widget.imageUrlController,
              padding: EdgeInsets.zero,
              prefix: Text(
                'Url: ',
                style: TextStyle(color: colors.textMute),
              ),
            ),
          ),
          IconButton(
            onPressed: _copyToClipboard,
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Row(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImageFromGallery,
              label: const Text('Gallery'),
              icon: const Icon(Icons.image),
              style: ElevatedButton.styleFrom(
                backgroundColor: activeColor,
                foregroundColor: colors.textInverse,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _takePhoto,
              label: const Text('Camera'),
              icon: const Icon(Icons.camera_alt),
              style: ElevatedButton.styleFrom(
                backgroundColor: activeColor,
                foregroundColor: colors.textInverse,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _pasteUrl,
              label: const Text('Url'),
              icon: const Icon(Icons.link),
              style: ElevatedButton.styleFrom(
                backgroundColor: activeColor,
                foregroundColor: colors.textInverse,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

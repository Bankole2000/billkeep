import 'dart:io';

import 'package:billkeep/database/database.dart';
import 'package:billkeep/main.dart' as main;
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/camera/camera_screen.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/validators.dart';
import 'package:billkeep/widgets/common/color_picker_widget.dart';
import 'package:billkeep/widgets/common/dynamic_avatar.dart';
import 'package:billkeep/widgets/common/emoji_picker_widget.dart';
import 'package:billkeep/widgets/common/icon_picker_widget.dart';
import 'package:billkeep/widgets/common/sliding_segment_control_label.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddWalletProviderScreen extends ConsumerStatefulWidget {
  const AddWalletProviderScreen({super.key, this.walletProvider});

  final WalletProvider? walletProvider;

  @override
  ConsumerState<AddWalletProviderScreen> createState() =>
      _AddWalletProviderScreenState();
}

class _AddWalletProviderScreenState
    extends ConsumerState<AddWalletProviderScreen> {
  late TextEditingController searchTextController;
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  IconSelectionType _selectedSegment = IconSelectionType.emoji;
  String? walletProviderId;
  File? _localImageFile;
  final _formKey = GlobalKey<FormState>();
  bool _isFocused = false;

  Color? _selectedColor;
  IconData? _selectedIcon = Icons.account_balance;
  String? _selectedEmoji = '🏦';
  var enteredName = '';
  var enteredDescription = '';
  var enteredWebsite = '';
  var imageUrl = '';

  @override
  void initState() {
    super.initState();
    if (widget.walletProvider != null) {
      walletProviderId = widget.walletProvider?.id;
      if (widget.walletProvider?.iconType == IconSelectionType.image.name ||
          widget.walletProvider?.iconType == 'localImage') {
        _selectedSegment = IconSelectionType.image;
        if (widget.walletProvider?.localImagePath != null) {
          _localImageFile = File(widget.walletProvider!.localImagePath!);
        }
        _imageUrlController.text =
            widget.walletProvider?.imageUrl ?? 'https://picsum.photos/200/300';
      } else {
        _selectedSegment = stringToIconSelectionType(
          widget.walletProvider!.iconType,
        );
      }
      setState(() {
        enteredName = widget.walletProvider!.name;
        enteredDescription = widget.walletProvider!.description ?? '';
        enteredWebsite = widget.walletProvider!.websiteUrl ?? '';
        imageUrl = widget.walletProvider!.imageUrl ?? '';
        if (imageUrl.isNotEmpty) _selectedSegment = IconSelectionType.image;
      });
    }
    searchTextController = TextEditingController();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

    Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _localImageFile = File(image.path);
          _imageUrlController.text = image.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    // Check if cameras are available
    if (main.cameras.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No camera available on this device'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Navigate to camera screen and wait for result
    final XFile? photo = await Navigator.push<XFile>(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: main.cameras.first),
      ),
    );

    if (photo != null) {
      setState(() {
        _localImageFile = File(photo.path);
        _imageUrlController.text = photo.path;
      });
    }
  }

  void _pasteUrl() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final pastedText = clipboardData?.text;
    if (pastedText != null && Validators.isValidUrl(pastedText)) {
      setState(() {
        _imageUrlController.text = pastedText;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Image url in Clipboard'),
          backgroundColor: ref.read(appColorsProvider).fire,
        ),
      );
    }
  }

  void _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: _imageUrlController.text));
  }


  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return Scaffold(
      // backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: activeColor,
        iconTheme: IconThemeData(color: colors.textInverse),
        actionsIconTheme: IconThemeData(color: colors.textInverse),
        title: Text(
          '${walletProviderId == null ? 'New' : 'Edit'} Wallet Provider',
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
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - ((100 as num)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Material(
                    // elevation: 5,
                    elevation: _isFocused ? 4.0 : 0.0,
                    child: ListTile(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        left: 10,
                        right: 20,
                      ),
                      visualDensity: VisualDensity(vertical: 0.1),
                      trailing: Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Icon(
                          Icons.edit_sharp,
                          size: 30,
                          color: colors.textMute,
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsetsGeometry.only(top: 0, left: 10),
                        child: Text(
                          'Wallet Provider Name',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      subtitle: CupertinoTextFormFieldRow(
                        // focusNode: _focusNode,
                        initialValue: enteredName,
                        style: TextStyle(fontSize: 36),
                        padding: EdgeInsets.all(0),
                        placeholder: 'Required',
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),
                Divider(height: 1),
                SizedBox(height: 20),

                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Material(
                    // elevation: 5,
                    elevation: _isFocused ? 4.0 : 0.0,
                    child: ListTile(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        left: 10,
                        right: 20,
                      ),
                      visualDensity: VisualDensity(vertical: 0.1),
                      trailing: Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Icon(
                          Icons.edit_note,
                          size: 24,
                          color: colors.textMute,
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsetsGeometry.only(top: 0, left: 8),
                        child: Text('Description', textAlign: TextAlign.start),
                      ),
                      subtitle: CupertinoTextFormFieldRow(
                        // focusNode: _focusNode,
                        initialValue: enteredDescription,
                        style: TextStyle(fontSize: 20),
                        padding: EdgeInsets.all(0),
                        placeholder: 'Optional',
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),
                Divider(height: 1),
                SizedBox(height: 20),

                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Material(
                    // elevation: 5,
                    elevation: _isFocused ? 4.0 : 0.0,
                    child: ListTile(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        left: 10,
                        right: 20,
                      ),
                      visualDensity: VisualDensity(vertical: 0.1),
                      trailing: Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Icon(
                          Icons.link,
                          size: 24,
                          color: colors.textMute,
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsetsGeometry.only(top: 0, left: 8),
                        child: Text('Website Url', textAlign: TextAlign.start),
                      ),
                      subtitle: CupertinoTextFormFieldRow(
                        // focusNode: _focusNode,
                        initialValue: enteredWebsite,
                        style: TextStyle(fontSize: 20),
                        padding: EdgeInsets.all(0),
                        placeholder: 'Optional',
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),
                Divider(height: 1),

                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Material(
                    // elevation: 5,
                    elevation: _isFocused ? 4.0 : 0.0,
                    child: ListTile(
                      tileColor: colors.surface,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        left: 10,
                        right: 20,
                      ),
                      visualDensity: VisualDensity(vertical: 0.1),
                      title: Padding(
                        padding: EdgeInsetsGeometry.only(
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
                        // children: [],
                        children: [
                          SizedBox(width: 4),
                          DynamicAvatar(
                            emojiOffset: Platform.isIOS ? Offset(11, 6) : Offset(7, 5),
                            icon: _selectedSegment == IconSelectionType.icon
                                ? _selectedIcon
                                : null,
                            emoji: _selectedSegment == IconSelectionType.emoji
                                ? _selectedEmoji
                                : null,
                            image: _selectedSegment == IconSelectionType.image
                                ? (_localImageFile != null
                                      ? FileImage(_localImageFile!)
                                      : _imageUrlController.text
                                            .trim()
                                            .isNotEmpty
                                      ? NetworkImage(_imageUrlController.text)
                                      : null)
                                : null,
                            size: 50,
                            color: _selectedColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomSlidingSegmentedControl<IconSelectionType>(
                              // isStretch: true,
                              initialValue: _selectedSegment,
                              children: {
                                IconSelectionType
                                    .icon: SlidingSegmentControlLabel(
                                  isActive:
                                      _selectedSegment ==
                                      IconSelectionType.icon,
                                  label: 'Icon',
                                  icon:
                                      iconSelectionTypeIcons[IconSelectionType
                                          .icon]!,
                                  activeColor: colors.fire,
                                ),
                                IconSelectionType
                                    .emoji: SlidingSegmentControlLabel(
                                  icon:
                                      iconSelectionTypeIcons[IconSelectionType
                                          .emoji]!,
                                  label: 'Emoji',
                                  isActive:
                                      _selectedSegment ==
                                      IconSelectionType.emoji,
                                  activeColor: colors.wave,
                                ),
                                IconSelectionType
                                    .image: SlidingSegmentControlLabel(
                                  icon:
                                      iconSelectionTypeIcons[IconSelectionType
                                          .image]!,
                                  label: 'Image',
                                  isActive:
                                      _selectedSegment ==
                                      IconSelectionType.image,
                                  activeColor: colors.water,
                                ),
                              },
                              onValueChanged: (value) {
                                setState(() {
                                  _selectedSegment = value;
                                });
                              },
                              innerPadding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              thumbDecoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          ColorSelectorButton(
                            selectedColor: _selectedColor,
                            onColorChanged: (color) {
                              print(color);
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            pickerType: ColorPickerType.block,
                          ),
                        ],
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),
                Divider(height: 1),
                if (_selectedSegment == IconSelectionType.icon)
                  IconPickerWidget(
                    onIconSelected: (icon) {
                      setState(() {
                        _selectedIcon = icon;
                      });
                      print(icon);
                    },
                  ),
                if (_selectedSegment == IconSelectionType.emoji)
                  EmojiPickerWidget(
                    onEmojiSelected: (emoji) {
                      setState(() {
                        _selectedEmoji = emoji;
                      });
                      print(emoji);
                    },
                  ),
                if (_selectedSegment == IconSelectionType.image)
                  ListTile(
                    // leading: AppImage(height: 50, width: 50),
                    title: Row(
                      children: [
                        Expanded(
                          child: CupertinoTextFormFieldRow(
                            controller: _imageUrlController,
                            // initialValue: _imageUrl,
                            padding: EdgeInsets.all(0),
                            prefix: Text(
                              'Url: ',
                              style: TextStyle(color: colors.textMute),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _copyToClipboard(_imageUrlController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('ImageURL Copied to Clipboard'),
                                backgroundColor: colors.navy,
                              ),
                            );
                          },
                          icon: Icon(Icons.copy),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: EdgeInsetsGeometry.only(top: 8, bottom: 16),
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _pickImageFromGallery,
                            label: Text('Gallery'),
                            icon: Icon(Icons.image),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: activeColor,
                              foregroundColor: colors.textInverse,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: _takePhoto,
                            label: Text('Camera'),
                            icon: Icon(Icons.camera_alt),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: activeColor,
                              foregroundColor: colors.textInverse,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: _pasteUrl,
                            label: Text('Url'),
                            icon: Icon(Icons.link),
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
                  ),
                Divider(),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: activeColor,
              foregroundColor: colors.textInverse,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'SAVE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

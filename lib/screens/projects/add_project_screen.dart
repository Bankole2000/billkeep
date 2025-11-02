import 'dart:io';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/project_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/utils/app_colors.dart';
import 'package:billkeep/utils/validators.dart';
import 'package:billkeep/widgets/common/color_picker_widget.dart';
import 'package:billkeep/widgets/common/dynamic_avatar.dart';
import 'package:billkeep/widgets/common/emoji_picker_widget.dart';
import 'package:billkeep/widgets/common/icon_picker_widget.dart';
import 'package:billkeep/widgets/common/sliding_segment_control_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:image_picker/image_picker.dart';
import 'package:billkeep/main.dart' as main;
import 'package:billkeep/screens/camera/camera_screen.dart';

class AddProjectScreen extends ConsumerStatefulWidget {
  const AddProjectScreen({super.key, this.projectToEdit});

  final Project? projectToEdit;

  @override
  ConsumerState<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends ConsumerState<AddProjectScreen> {
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  IconSelectionType _selectedSegment = IconSelectionType.icon;

  Color? _selectedColor;
  IconData? _selectedIcon = Icons.folder;
  String? _selectedEmoji = '📂';
  String? projectId;
  File? _localImageFile;
  final ImagePicker _picker = ImagePicker();
  bool? _isArchived = false;
  bool? _isLoading = false;

  // late TextEditingController searchTextController;
  final _formKey = GlobalKey<FormState>();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    if (widget.projectToEdit != null) {
      projectId = widget.projectToEdit!.id;
      if (widget.projectToEdit?.iconType == IconSelectionType.image.name ||
          widget.projectToEdit?.iconType == 'localImage') {
        _selectedSegment = IconSelectionType.image;
        if (widget.projectToEdit?.localImagePath != null) {
          _localImageFile = File(widget.projectToEdit!.localImagePath!);
        }
        _imageUrlController.text =
            widget.projectToEdit?.imageUrl ?? 'https://picsum.photos/200/300';
      } else {
        _selectedSegment = stringToIconSelectionType(
          widget.projectToEdit!.iconType,
        );
      }
      _nameController.text = widget.projectToEdit!.name;
      _descriptionController.text = widget.projectToEdit!.description!;
      _selectedColor = widget.projectToEdit!.color != null
          ? HexColor.fromHex('#${widget.projectToEdit!.color}')
          : ref.read(appColorsProvider).textMute;
      _selectedIcon = IconData(
        widget.projectToEdit!.iconCodePoint!,
        fontFamily: 'MaterialIcons',
      );
      _selectedEmoji = widget.projectToEdit!.iconEmoji ?? '📂';
      _isArchived = widget.projectToEdit!.isArchived;
    } else {
      _imageUrlController.text = 'https://picsum.photos/200/300';
    }
  }

  @override
  void dispose() {
    // searchTextController.dispose();
    _imageUrlController.dispose();
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

  void _saveProject() async {
    print(_selectedColor);
    print(_selectedIcon);
    print(_selectedEmoji);
    print(_imageUrlController.text);
    print(_localImageFile);
    print(_localImageFile?.path);
    print(_selectedSegment);
    print('\n');
    // TODO: check
    if (_formKey.currentState!.validate()) {
      if (mounted) {
        setState(() => _isLoading = true);
      }
      print('Form validated');
      var iconType =
          _selectedSegment == IconSelectionType.image &&
              Validators.isValidUrl(_imageUrlController.text)
          ? IconSelectionType.image.name
          : _selectedSegment == IconSelectionType.image &&
                !Validators.isValidUrl(_imageUrlController.text)
          ? 'localImage'
          : _selectedSegment.name;
      try {
        final result = projectId == null
            ? await ref
                  .read(projectRepositoryProvider)
                  .createProject(
                    name: _nameController.text.trim(),
                    description: _descriptionController.text.trim(),
                    iconType: iconType,
                    color: _selectedColor?.toHexString(),
                    emoji: _selectedEmoji,
                    localImagePath:
                        iconType == 'localImage' && _localImageFile != null
                        ? _localImageFile?.path
                        : null,
                    imageUrl:
                        iconType == IconSelectionType.image.name &&
                            _imageUrlController.text.trim().isNotEmpty
                        ? _imageUrlController.text.trim()
                        : null,
                    isArchived: _isArchived,
                    iconCodePoint: _selectedIcon?.codePoint,
                  )
            : await ref
                  .read(projectRepositoryProvider)
                  .updateProject(
                    projectId: projectId!,
                    name: _nameController.text.trim(),
                    description: _descriptionController.text.trim(),
                    iconType: iconType,
                    color: _selectedColor?.toHexString(),
                    emoji: _selectedEmoji,
                    localImagePath:
                        iconType == 'localImage' && _localImageFile != null
                        ? _localImageFile?.path
                        : null,
                    imageUrl:
                        iconType == IconSelectionType.image.name &&
                            _imageUrlController.text.trim().isNotEmpty
                        ? _imageUrlController.text.trim()
                        : null,
                    isArchived: _isArchived,
                    iconCodePoint: _selectedIcon?.codePoint,
                  );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Success: Project ${projectId == null ? 'created' : 'updated'}',
              ),
              backgroundColor: ref.read(appColorsProvider).navy,
            ),
          );
          Navigator.pop(context, result);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: ref.read(appColorsProvider).fire,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.text),
        actionsIconTheme: IconThemeData(color: colors.text),
        title: Text(
          '${projectId == null ? 'New' : 'Edit'} Project',
          style: TextStyle(color: colors.text),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
          SizedBox(width: 10),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          SizedBox(width: 10),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - ((100 as num)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                          'Project Name',
                          textAlign: TextAlign.start,
                          style: TextStyle(color: colors.text),
                        ),
                      ),
                      subtitle: CupertinoTextFormFieldRow(
                        // focusNode: _focusNode,
                        controller: _nameController,
                        style: TextStyle(fontSize: 36, color: colors.text),
                        padding: EdgeInsets.all(0),
                        placeholder: 'Required',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a project name';
                          }
                          return null;
                        },
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),
                Divider(height: 1),
                SizedBox(height: 10),
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
                        controller: _descriptionController,
                        style: TextStyle(fontSize: 20),
                        padding: EdgeInsets.all(0),
                        placeholder: 'Optional',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a project description';
                          }
                          return null;
                        },
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),
                Divider(height: 1),
                SizedBox(height: 10),

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
                          SizedBox(width: 4),
                          DynamicAvatar(
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
      //  const ProjectForm(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveProject,
            style: ElevatedButton.styleFrom(
              backgroundColor: activeColor,
              foregroundColor: colors.textInverse,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              projectId == null ? 'SAVE' : 'UPDATE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

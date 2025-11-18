import 'dart:io';
import 'package:billkeep/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../providers/project_provider.dart';
import '../../providers/ui_providers.dart';
import '../../screens/projects/add_project_settings_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_enums.dart';
import '../../utils/validators.dart';
import '../../widgets/projects/form/project_details_section.dart';
import '../../widgets/wallets/form/appearance_section.dart';

/// Refactored add/edit project screen
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
  bool? _isArchived = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeFromProject();
  }

  void _initializeFromProject() {
    if (widget.projectToEdit != null) {
      final project = widget.projectToEdit!;
      projectId = project.id;
      _nameController.text = project.name;
      _descriptionController.text = project.description ?? '';
      _isArchived = project.isArchived;

      // Initialize appearance
      if (project.iconType == IconSelectionType.image.name ||
          project.iconType == 'localImage') {
        _selectedSegment = IconSelectionType.image;
        if (project.localImagePath != null) {
          _localImageFile = File(project.localImagePath!);
        }
        _imageUrlController.text =
            project.imageUrl ?? 'https://picsum.photos/200/300';
      } else {
        _selectedSegment = stringToIconSelectionType(project.iconType);
      }

      if (project.iconCodePoint != null) {
        _selectedIcon = IconData(
          project.iconCodePoint!,
          fontFamily: 'MaterialIcons',
        );
      }
      _selectedEmoji = project.iconEmoji ?? '📂';
      _selectedColor = project.color != null
          ? HexColor.fromHex('#${project.color}')
          : null;
    } else {
      _imageUrlController.text = 'https://picsum.photos/200/300';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedColor ??= ref.read(appColorsProvider).textMute;
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final iconType = _determineIconType();

      final resultId = projectId == null
          ? await _createProject(iconType)
          : await _updateProject(iconType);

      if (mounted) {
        _showSuccess('Project ${projectId == null ? 'created' : 'updated'}');
        Navigator.pop(context, resultId);
      }
    } catch (e) {
      if (mounted) {
        _showError('Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _determineIconType() {
    if (_selectedSegment == IconSelectionType.image) {
      return Validators.isValidUrl(_imageUrlController.text)
          ? IconSelectionType.image.name
          : 'localImage';
    }
    return _selectedSegment.name;
  }

  Future<String> _createProject(String iconType) async {
    final userId = ref.read(currentUserIdProvider);
    return await ref.read(projectRepositoryProvider).createProject(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          iconType: iconType,
          color: _selectedColor?.toHexString(),
          emoji: _selectedEmoji,
          localImagePath: iconType == 'localImage' && _localImageFile != null
              ? _localImageFile?.path
              : null,
          imageUrl: iconType == IconSelectionType.image.name &&
                  _imageUrlController.text.trim().isNotEmpty
              ? _imageUrlController.text.trim()
              : null,
          isArchived: _isArchived,
          iconCodePoint: _selectedIcon?.codePoint,
          userId: userId!,
        );
  }

  Future<String> _updateProject(String iconType) async {
    return await ref.read(projectRepositoryProvider).updateProject(
          projectId: projectId!,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          iconType: iconType,
          color: _selectedColor?.toHexString(),
          emoji: _selectedEmoji,
          localImagePath: iconType == 'localImage' && _localImageFile != null
              ? _localImageFile?.path
              : null,
          imageUrl: iconType == IconSelectionType.image.name &&
                  _imageUrlController.text.trim().isNotEmpty
              ? _imageUrlController.text.trim()
              : null,
          isArchived: _isArchived,
          iconCodePoint: _selectedIcon?.codePoint,
        );
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

  void _showSuccess(String message) {
    final colors = ref.read(appColorsProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors.navy,
      ),
    );
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.of(context).push<Currency>(
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) =>
                      AddProjectSettingsScreen(project: widget.projectToEdit),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Project details (name & description)
                ProjectDetailsSection(
                  nameController: _nameController,
                  descriptionController: _descriptionController,
                ),

                Divider(height: 1, color: colors.textMute.withAlpha(50)),

                // Appearance section (reused from wallets!)
                AppearanceSection(
                  useProviderAppearance: false, // Projects don't have providers
                  selectedSegment: _selectedSegment,
                  selectedIcon: _selectedIcon,
                  selectedEmoji: _selectedEmoji,
                  selectedColor: _selectedColor,
                  imageUrlController: _imageUrlController,
                  localImageFile: _localImageFile,
                  onSegmentChanged: (segment) =>
                      setState(() => _selectedSegment = segment),
                  onIconSelected: (icon) =>
                      setState(() => _selectedIcon = icon),
                  onEmojiSelected: (emoji) =>
                      setState(() => _selectedEmoji = emoji),
                  onColorChanged: (color) =>
                      setState(() => _selectedColor = color),
                  onLocalImageChanged: (file) =>
                      setState(() => _localImageFile = file),
                ),
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
            onPressed: _isLoading ? null : _saveProject,
            style: ElevatedButton.styleFrom(
              backgroundColor: activeColor,
              foregroundColor: colors.textInverse,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'SAVE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

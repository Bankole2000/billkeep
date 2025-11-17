import 'package:flutter/material.dart';

/// Action buttons for image selection (Gallery, Camera, URL, Paste, Copy)
class ImagePickerActions extends StatelessWidget {
  final VoidCallback onPickFromGallery;
  final VoidCallback onTakePhoto;
  final VoidCallback? onPasteUrl;
  final VoidCallback? onCopyUrl;
  final bool showUrlActions;

  const ImagePickerActions({
    super.key,
    required this.onPickFromGallery,
    required this.onTakePhoto,
    this.onPasteUrl,
    this.onCopyUrl,
    this.showUrlActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Gallery button
        _ActionButton(
          icon: Icons.photo_library,
          label: 'Gallery',
          onPressed: onPickFromGallery,
        ),

        // Camera button
        _ActionButton(
          icon: Icons.camera_alt,
          label: 'Camera',
          onPressed: onTakePhoto,
        ),

        // Paste URL button (if enabled)
        if (showUrlActions && onPasteUrl != null)
          _ActionButton(
            icon: Icons.content_paste,
            label: 'Paste',
            onPressed: onPasteUrl!,
          ),

        // Copy URL button (if enabled)
        if (showUrlActions && onCopyUrl != null)
          _ActionButton(
            icon: Icons.copy,
            label: 'Copy',
            onPressed: onCopyUrl!,
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          iconSize: 32,
          color: Theme.of(context).primaryColor,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

/// A widget for picking Material icons
/// Designed for use in modals/bottom sheets (not full screen)
class IconPickerWidget extends StatefulWidget {
  final IconData? preSelectedIcon;
  final Function(IconData?) onIconSelected;
  final bool showSearchBar;
  final bool showTooltips;
  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;

  const IconPickerWidget({
    super.key,
    this.preSelectedIcon,
    required this.onIconSelected,
    this.showSearchBar = true,
    this.showTooltips = false,
    this.iconSize = 40.0,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  State<IconPickerWidget> createState() => _IconPickerWidgetState();
}

class _IconPickerWidgetState extends State<IconPickerWidget> {
  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.preSelectedIcon;
  }

  Future<void> _pickIcon() async {
    final icon = await showIconPicker(context);

    if (icon != null) {
      setState(() {
        _selectedIcon = icon.data;
      });
      widget.onIconSelected(icon.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickIcon,
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _selectedIcon ?? Icons.add,
                    color: widget.iconColor ?? Colors.grey.shade700,
                    size: widget.iconSize,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _selectedIcon == null ? 'Select Icon' : 'Icon Selected',
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

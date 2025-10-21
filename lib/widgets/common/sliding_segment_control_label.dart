import 'package:billkeep/providers/ui_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SlidingSegmentControlLabel extends ConsumerWidget {
  const SlidingSegmentControlLabel({
    super.key,
    required this.isActive,
    required this.label,
    required this.icon,
    required this.activeColor,
  });

  final String label;
  final bool isActive;
  final IconData icon;
  final Color? activeColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: isActive ? activeColor : colors.textMute),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isActive ? colors.text : colors.textMute,
          ),
        ),
      ],
    );
  }
}

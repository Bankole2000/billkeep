import 'package:billkeep/providers/ui_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomAppBarNavigationItem extends ConsumerWidget {
  const BottomAppBarNavigationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    this.activeColor = Colors.blueAccent,
  });

  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final Color? activeColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = isSelected ? activeColor : Colors.grey;
    return InkWell(
      onTap: () {
        ref
            .read(activeThemeColorProvider.notifier)
            .setActiveColor(activeColor!);
        ref
            .read(bottomAppBarNavigationIndexProvider.notifier)
            .selectIndex(index);
      },
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

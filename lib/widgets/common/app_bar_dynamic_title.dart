import 'package:billkeep/providers/ui_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarDynamicTitle extends ConsumerWidget {
  const AppBarDynamicTitle({
    super.key,
    required this.width,
    required this.projectTitle,
    this.pageType,
  });

  final double width;
  final String projectTitle;
  final String? pageType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        decoration: BoxDecoration(
          // color: Colors.white.withAlpha(39),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pageType != null)
              Text(
                '$pageType: ',
                maxLines: 1,
                style: TextStyle(color: colors.textMute, fontSize: 17),
              ),
            Expanded(
              child: Text(
                projectTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colors.text, fontSize: 17),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: colors.text),
          ],
        ),
      ),
    );
  }
}

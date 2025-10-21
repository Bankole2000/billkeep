import 'package:billkeep/providers/project_provider.dart';
import 'package:billkeep/widgets/common/app_bar_dynamic_title.dart';
import 'package:billkeep/widgets/projects/project_select_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarActiveProjectSelector extends ConsumerWidget {
  const AppBarActiveProjectSelector({super.key, this.pageType});

  final String? pageType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProject = ref.watch(activeProjectProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get 85% of the AppBar width
        final width = constraints.maxWidth * 0.85;
        return InkWell(
          onTap: () {
            // Handle tap here
            showModalBottomSheet<void>(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0), // Change this value
                ),
              ),
              builder: (BuildContext context) => ProjectSelectBottomSheet(),
            );
          },
          borderRadius: BorderRadius.circular(4),
          child: AppBarDynamicTitle(
            width: width,
            projectTitle: activeProject.project == null
                ? 'Select Active Project'
                : activeProject.project!.name,
            pageType: pageType ?? 'Project',
          ),
        );
      },
    );
  }
}

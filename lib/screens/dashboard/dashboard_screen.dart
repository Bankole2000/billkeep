import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/widgets/common/app_bar_dynamic_title.dart';
import 'package:billkeep/widgets/projects/project_select_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: activeColor,
        title: LayoutBuilder(
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
                projectTitle: 'This is a long project title',
                pageType: 'Dashboard',
              ),
            );
          },
        ),
      ),
      body: const Center(child: Text('Dashboard - Coming Soon')),
    );
  }
}

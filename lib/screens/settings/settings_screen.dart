import 'package:billkeep/widgets/common/app_bar_dynamic_title.dart';
import 'package:billkeep/widgets/projects/project_select_bottom_sheet.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: LayoutBuilder(
          builder: (context, constraints) {
            // Get 85% of the AppBar width
            final width = constraints.maxWidth * 0.85;
            return InkWell(
              onTap: () {
                // Handle tap here
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) => ProjectSelectBottomSheet(),
                );
              },
              borderRadius: BorderRadius.circular(4),
              child: AppBarDynamicTitle(
                width: width,
                projectTitle: 'This is a long project title',
                pageType: 'Settings',
              ),
            );
          },
        ),
      ),
      body: const Center(child: Text('Settings - Coming Soon')),
    );
  }
}

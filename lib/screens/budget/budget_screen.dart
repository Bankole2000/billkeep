import 'package:billkeep/widgets/common/app_bar_dynamic_title.dart';
import 'package:billkeep/widgets/projects/project_select_bottom_sheet.dart';
import 'package:flutter/material.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

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
                pageType: 'Budget',
              ),
            );
          },
        ),
      ),
      body: const Center(child: Text('Budget - Coming Soon')),
    );
  }
}

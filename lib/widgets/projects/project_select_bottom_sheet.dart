// my_bottom_sheet.dart
// import 'package:billkeep/screens/projects/settings_screen.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/widgets/projects/add_project_button.dart';
import 'package:billkeep/widgets/projects/project_list_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectSelectBottomSheet extends ConsumerWidget {
  const ProjectSelectBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        height: 600,
        color: colors.surface,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Select Project',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.text,
                ),
              ),
            ),
            Expanded(child: ProjectList()),
            SizedBox(height: 16),
            AddProjectButton(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

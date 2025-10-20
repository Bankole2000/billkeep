import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/projects/add_project_screen.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddProjectButton extends ConsumerWidget {
  const AddProjectButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            // TODO: Implement Monetization here
            Navigator.push(
              context,
              AppPageRoute.slideVertical(AddProjectScreen()),
            );
          },
          label: Text(
            'Add Project',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: colors.textInverse,
            ),
          ),
          icon: Icon(Icons.add, size: 24, color: colors.textInverse),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // Adjust this valu
            ),
            backgroundColor: activeColor,
          ),
        ),
      ),
    );
  }
}

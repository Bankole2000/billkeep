import 'package:billkeep/screens/projects/add_project_screen.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:flutter/material.dart';

class AddProjectButton extends StatelessWidget {
  const AddProjectButton({super.key});

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          icon: Icon(Icons.add, size: 24),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6), // Adjust this value
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TabbarIconLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const TabbarIconLabel({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18), // Adjust size as needed
          SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

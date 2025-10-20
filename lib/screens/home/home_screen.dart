import 'dart:ui';

import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/projects/add_project_screen.dart';
import 'package:billkeep/screens/settings/database_management_screen.dart';
import 'package:billkeep/screens/sms/sms_import_screen.dart';
import 'package:billkeep/widgets/common/app_bar_dynamic_title.dart';
import 'package:billkeep/widgets/navigation/side_drawer_navigation.dart';
import 'package:billkeep/widgets/project_dropdown.dart';
import 'package:billkeep/widgets/projects/project_select_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/widgets/projects/project_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Example wallet list
  final List<String> wallets = [
    'Main Wallet',
    'Project A',
    'Travel Fund',
    'Savings',
    'Bankole\'s Esan\'s Big Project',
  ];

  String selectedWallet = 'Main Wallet';

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    return Scaffold(
      drawer: const SideNavigationDrawer(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // centerTitle: false,
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
                pageType: 'Project',
              ),
            );
          },
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
            60,
          ), // height of the bottom section
          child: Container(
            color: Colors.indigo.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Text(
                  "Subsection below AppBar",
                  style: TextStyle(color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),

      body: const Center(child: Text('Home Screen - Coming Soon')),
    );
  }
}

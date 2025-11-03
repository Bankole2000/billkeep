import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/home/old_ui.dart';
import 'package:billkeep/screens/settings/database_management_screen.dart';
import 'package:billkeep/screens/sms/sms_import_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideNavigationDrawer extends ConsumerWidget {
  const SideNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeColor = ref.watch(activeThemeColorProvider);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              // color: Theme.of(context).colorScheme.inversePrimary,
              color: activeColor.withAlpha(177),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'BillKeep',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Expense & Income Tracker'),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to profile
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_sync),
            title: const Text('Sync Status'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Show sync status
            },
          ),
          ListTile(
            leading: const Icon(Icons.sms),
            title: const Text('SMS Auto-Import'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SmsImportScreen(),
                ),
              );
            },
          ),
          // In your drawer or settings screen:
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Database Management'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DatabaseManagementScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Old UI'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OldUIHomeScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Export Data'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Export functionality
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              // TODO: About screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Help screen
            },
          ),
        ],
      ),
    );
  }
}

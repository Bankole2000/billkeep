import 'package:billkeep/screens/projects/add_project_screen.dart';
import 'package:billkeep/screens/settings/database_management_screen.dart';
import 'package:billkeep/screens/sms/sms_import_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/widgets/projects/project_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('BillKeep'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const ProjectList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProjectScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Drawer
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
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

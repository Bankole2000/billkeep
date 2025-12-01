import 'package:billkeep/providers/project_provider.dart';
import 'package:billkeep/widgets/projects/edit_project_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';

final settingsSegmentProvider = StateProvider<int>((ref) => 0);

class SettingsScreen extends ConsumerWidget {
  final Project project;

  const SettingsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSegment = ref.watch(settingsSegmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${project.name} - Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Segmented control
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  label: Text('General'),
                  icon: Icon(Icons.settings),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('Notifications'),
                  icon: Icon(Icons.notifications),
                ),
                ButtonSegment(
                  value: 2,
                  label: Text('Advanced'),
                  icon: Icon(Icons.tune),
                ),
              ],
              selected: {selectedSegment},
              onSelectionChanged: (Set<int> newSelection) {
                ref.read(settingsSegmentProvider.notifier).state =
                    newSelection.first;
              },
            ),
          ),

          // Content based on segment
          Expanded(
            child: [
              _GeneralSettings(project: project),
              _NotificationSettings(project: project),
              _AdvancedSettings(project: project),
            ][selectedSegment],
          ),
        ],
      ),
    );
  }
}

// General Settings
class _GeneralSettings extends ConsumerWidget {
  final Project project;

  const _GeneralSettings({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Project'),
                subtitle: Text('Name: ${project.name}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditProjectForm(project: project),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.archive),
                title: const Text('Archive Project'),
                subtitle: const Text('Hide from active projects'),
                trailing: Switch(
                  value: project.isArchived,
                  onChanged: (value) async {
                    // await ref
                    //     .read(projectRepositoryProvider)
                    //     .toggleArchiveProject(project.id, value);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value ? 'Project archived' : 'Project unarchived',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete Project',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text('Permanently delete this project'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showDeleteConfirmation(context, ref);
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.sync),
                title: const Text('Sync Status'),
                subtitle: Text(project.isSynced ? 'Synced' : 'Not synced'),
                trailing: Icon(
                  project.isSynced ? Icons.check_circle : Icons.cloud_off,
                  color: project.isSynced ? Colors.green : Colors.orange,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.cloud_upload),
                title: const Text('Sync Now'),
                subtitle: const Text('Upload local changes'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sync - Coming Soon')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project?'),
        content: const Text(
          'This will permanently delete the project and all associated data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // await ref
              //     .read(projectRepositoryProvider)
              //     .deleteProject(project.id);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close settings
                Navigator.pop(context); // Close project detail
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Project deleted')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Notification Settings
class _NotificationSettings extends StatefulWidget {
  final Project project;

  const _NotificationSettings({required this.project});

  @override
  State<_NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<_NotificationSettings> {
  bool _renewalReminders = true;
  bool _budgetAlerts = true;
  bool _smsImport = false;
  bool _emailImport = false;
  int _reminderDays = 7;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Reminders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SwitchListTile(
                title: const Text('Renewal Reminders'),
                subtitle: const Text('Get notified before subscriptions renew'),
                value: _renewalReminders,
                onChanged: (value) {
                  setState(() => _renewalReminders = value);
                },
              ),
              if (_renewalReminders)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Text('Remind me'),
                      const SizedBox(width: 16),
                      DropdownButton<int>(
                        value: _reminderDays,
                        items: const [
                          DropdownMenuItem(
                            value: 1,
                            child: Text('1 day before'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('3 days before'),
                          ),
                          DropdownMenuItem(
                            value: 7,
                            child: Text('7 days before'),
                          ),
                          DropdownMenuItem(
                            value: 14,
                            child: Text('14 days before'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _reminderDays = value!);
                        },
                      ),
                    ],
                  ),
                ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Budget Alerts'),
                subtitle: const Text('Notify when approaching budget limit'),
                value: _budgetAlerts,
                onChanged: (value) {
                  setState(() => _budgetAlerts = value);
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Auto-Import',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SwitchListTile(
                title: const Text('SMS Import'),
                subtitle: const Text('Auto-detect transactions from SMS'),
                value: _smsImport,
                onChanged: (value) {
                  setState(() => _smsImport = value);
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('SMS Import - Coming Soon')),
                    );
                  }
                },
              ),
              if (_smsImport)
                ListTile(
                  title: const Text('Configure SMS Rules'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('SMS Configuration - Coming Soon'),
                      ),
                    );
                  },
                ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Email Import'),
                subtitle: const Text('Auto-detect transactions from emails'),
                value: _emailImport,
                onChanged: (value) {
                  setState(() => _emailImport = value);
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email Import - Coming Soon'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Advanced Settings
class _AdvancedSettings extends StatelessWidget {
  final Project project;

  const _AdvancedSettings({required this.project});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Export Data'),
                subtitle: const Text('Download project data as CSV/JSON'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showExportOptions(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text('Backup Project'),
                subtitle: const Text('Create a local backup'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Backup - Coming Soon')),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Restore from Backup'),
                subtitle: const Text('Import project from backup'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Restore - Coming Soon')),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Debug Info',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text('Project ID'),
                subtitle: Text(project.id),
              ),
              ListTile(
                title: const Text('Created'),
                subtitle: Text(project.createdAt.toString().split('.')[0]),
              ),
              ListTile(
                title: const Text('Last Updated'),
                subtitle: Text(project.updatedAt.toString().split('.')[0]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.table_chart),
            title: const Text('Export as CSV'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('CSV Export - Coming Soon')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Export as JSON'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('JSON Export - Coming Soon')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('Export as PDF Report'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF Export - Coming Soon')),
              );
            },
          ),
        ],
      ),
    );
  }
}

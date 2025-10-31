import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../database/database.dart' hide Provider;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// Provider for database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

class DatabaseManagementScreen extends ConsumerStatefulWidget {
  const DatabaseManagementScreen({super.key});

  @override
  ConsumerState<DatabaseManagementScreen> createState() =>
      _DatabaseManagementScreenState();
}

class _DatabaseManagementScreenState
    extends ConsumerState<DatabaseManagementScreen> {
  bool _isProcessing = false;
  String? _databasePath;

  @override
  void initState() {
    super.initState();
    _loadDatabasePath();
  }

  Future<void> _loadDatabasePath() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final path = p.join(dbFolder.path, 'billkeep.sqlite');
    setState(() {
      _databasePath = path;
    });
  }

  Future<void> _copyPathToClipboard() async {
    if (_databasePath != null) {
      await Clipboard.setData(ClipboardData(text: _databasePath!));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Database path copied to clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<bool> _checkDatabaseExists() async {
    if (_databasePath == null) return false;
    final file = File(_databasePath!);
    return await file.exists();
  }

  Future<String> _getDatabaseSize() async {
    if (_databasePath == null) return 'Unknown';
    final file = File(_databasePath!);
    if (!await file.exists()) return 'Not found';

    final bytes = await file.length();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  Future<void> _reinitializeDatabase() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reinitialize Database?'),
        content: const Text(
          'This will:\n'
          '• Close the database connection\n'
          '• Delete the database files\n'
          '• Close the app\n\n'
          'When you reopen the app, a fresh database will be created with all migrations applied.\n\n'
          'This action cannot be undone!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reinitialize & Close App'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);

    try {
      // Close current database
      await ref.read(databaseProvider).close();

      // Delete database and auxiliary files
      await AppDatabase.deleteAndReinitialize();

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Database Deleted'),
            content: const Text(
              'Database files have been deleted successfully.\n\n'
              'The app will now close. When you reopen it, a fresh database will be created.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Close App'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<Map<String, int>> _getDatabaseStats() async {
    try {
      final database = ref.read(databaseProvider);

      final projectCount = await (database.select(database.projects).get())
          .then((list) => list.length);
      final expenseCount = await (database.select(database.expenses).get())
          .then((list) => list.length);
      final incomeCount = await (database.select(database.income).get()).then(
        (list) => list.length,
      );
      final paymentCount = await (database.select(database.payments).get())
          .then((list) => list.length);
      final todoCount = await (database.select(database.todoItems).get()).then(
        (list) => list.length,
      );
      final shoppingListCount =
          await (database.select(database.shoppingLists).get()).then(
            (list) => list.length,
          );
      final shoppingListItemCount =
          await (database.select(database.shoppingListItems).get()).then(
            (list) => list.length,
          );
      final messageRuleCount =
          await (database.select(database.messageRules).get()).then(
            (list) => list.length,
          );
      final parsedMessageCount =
          await (database.select(database.parsedMessages).get()).then(
            (list) => list.length,
          );

      return {
        'Projects': projectCount,
        'Expenses': expenseCount,
        'Income': incomeCount,
        'Payments': paymentCount,
        'Todos': todoCount,
        'Shopping Lists': shoppingListCount,
        'Shopping Items': shoppingListItemCount,
        'Message Rules': messageRuleCount,
        'Parsed Messages': parsedMessageCount,
      };
    } catch (e) {
      return {'Error': 0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database Management')),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Deleting database...'),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Database Location Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Database Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_databasePath != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: SelectableText(
                              _databasePath!,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _copyPathToClipboard,
                                  icon: const Icon(Icons.copy, size: 18),
                                  label: const Text('Copy Path'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder<bool>(
                            future: _checkDatabaseExists(),
                            builder: (context, snapshot) {
                              final exists = snapshot.data ?? false;
                              return Row(
                                children: [
                                  Icon(
                                    exists ? Icons.check_circle : Icons.error,
                                    color: exists ? Colors.green : Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    exists
                                        ? 'Database file exists'
                                        : 'Database file not found',
                                    style: TextStyle(
                                      color: exists ? Colors.green : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          FutureBuilder<String>(
                            future: _getDatabaseSize(),
                            builder: (context, snapshot) {
                              return Text(
                                'Size: ${snapshot.data ?? "Loading..."}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              );
                            },
                          ),
                        ] else
                          const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Database Info Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Database Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Schema Version', '4'),
                        _buildInfoRow('Database Name', 'billkeep.sqlite'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Database Stats Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Database Statistics',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => setState(() {}),
                              tooltip: 'Refresh stats',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FutureBuilder<Map<String, int>>(
                          future: _getDatabaseStats(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Error loading stats: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }

                            final stats = snapshot.data ?? {};

                            if (stats.isEmpty) {
                              return const Text('No data available');
                            }

                            return Column(
                              children: stats.entries.map((entry) {
                                return _buildInfoRow(
                                  entry.key,
                                  '${entry.value} records',
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Danger Zone Section
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Danger Zone',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'These actions are irreversible. Make sure you understand what you\'re doing before proceeding.',
                          style: TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 16),

                        // Manual deletion instructions
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: Colors.blue.shade700,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Manual Deletion',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'For the most reliable reinitialization:\n'
                                '1. Copy the database path above\n'
                                '2. Close the app completely\n'
                                '3. Delete the file manually using a file manager\n'
                                '4. Reopen the app\n\n'
                                'This ensures a clean restart with migrations.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _reinitializeDatabase,
                            icon: const Icon(Icons.restore),
                            label: const Text(
                              'Auto Reinitialize (Experimental)',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'What auto reinitialize does:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '• Closes database connection\n'
                                '• Deletes billkeep.sqlite and auxiliary files\n'
                                '• Closes the app\n'
                                '• On restart, creates fresh database with migrations',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

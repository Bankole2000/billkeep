import 'package:billkeep/database/database.dart';
import 'package:billkeep/screens/sms/sms_rules_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/providers/sms_provider.dart';
import 'package:billkeep/providers/project_provider.dart';
import 'package:billkeep/utils/currency_helper.dart';

class SmsImportScreen extends ConsumerStatefulWidget {
  const SmsImportScreen({super.key});

  @override
  ConsumerState<SmsImportScreen> createState() => _SmsImportScreenState();
}

class _SmsImportScreenState extends ConsumerState<SmsImportScreen> {
  bool _isLoading = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final hasPermission = true;
    // final hasPermission = await ref
    //     .read(smsRepositoryProvider)
    //     .hasSmsPermissions();
    setState(() => _hasPermission = hasPermission);
  }

  Future<void> _requestPermissions() async {
    final granted = true;
    // final granted = await ref
    //     .read(smsRepositoryProvider)
    //     .requestSmsPermissions();
    setState(() => _hasPermission = granted);

    if (granted) {
      _scanMessages();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SMS permission is required for auto-import'),
          ),
        );
      }
    }
  }

  Future<void> _scanMessages() async {
    setState(() => _isLoading = true);

    try {
      // await ref.read(smsRepositoryProvider).readRecentSms(daysBack: 30);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('SMS scan complete')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _setupDefaultRules() async {
    // await ref.read(smsRepositoryProvider).createDefaultRules();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Default rules created')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final parsedMessagesAsync = ref.watch(parsedMessagesProvider);
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      // In the AppBar of SmsImportScreen, add an actions button:
      appBar: AppBar(
        title: const Text('SMS Auto-Import'),
        actions: [
          IconButton(
            icon: const Icon(Icons.rule),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SmsRulesScreen()),
              );
            },
            tooltip: 'Manage Rules',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _hasPermission ? Icons.check_circle : Icons.warning,
                        color: _hasPermission ? Colors.green : Colors.orange,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _hasPermission
                                  ? 'SMS Access Granted'
                                  : 'SMS Access Required',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _hasPermission
                                  ? 'Auto-import is enabled'
                                  : 'Grant permission to scan bank SMS',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!_hasPermission) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _requestPermissions,
                      icon: const Icon(Icons.lock_open),
                      label: const Text('Grant Permission'),
                    ),
                  ],
                  if (_hasPermission) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _scanMessages,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.refresh),
                            label: Text(
                              _isLoading ? 'Scanning...' : 'Scan SMS',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _setupDefaultRules,
                          icon: const Icon(Icons.rule),
                          label: const Text('Setup Rules'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Parsed messages list
          Expanded(
            child: parsedMessagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No pending transactions',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        if (_hasPermission) ...[
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _scanMessages,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Scan for SMS'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _ParsedMessageCard(
                      message: message,
                      projects: projectsAsync,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Error loading messages')),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParsedMessageCard extends ConsumerStatefulWidget {
  final ParsedMessage message;
  final AsyncValue<List<Project>> projects;

  const _ParsedMessageCard({required this.message, required this.projects});

  @override
  ConsumerState<_ParsedMessageCard> createState() => _ParsedMessageCardState();
}

class _ParsedMessageCardState extends ConsumerState<_ParsedMessageCard> {
  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    _selectedProjectId = widget.message.projectId;
  }

  @override
  Widget build(BuildContext context) {
    final isDebit = widget.message.transactionType == 'DEBIT';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDebit
                ? Colors.red.withValues(alpha: 256 / 10)
                : Colors.green.withValues(alpha: 256 / 10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isDebit ? Icons.arrow_upward : Icons.arrow_downward,
            color: isDebit ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          CurrencyHelper.formatAmount(widget.message.amount),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDebit ? Colors.red : Colors.green,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.message.description ?? 'Transaction'),
            Text(
              '${widget.message.sender} • ${widget.message.messageDate.toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Original Message:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.message.rawMessage,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),

                // Project selector
                widget.projects.when(
                  data: (projects) {
                    if (projects.isEmpty) {
                      return const Text('No projects available');
                    }

                    return DropdownButtonFormField<String>(
                      initialValue: _selectedProjectId,
                      decoration: const InputDecoration(
                        labelText: 'Assign to Project',
                        border: OutlineInputBorder(),
                      ),
                      items: projects.map((project) {
                        return DropdownMenuItem(
                          value: project.id,
                          child: Text(project.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedProjectId = value);
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('Error loading projects'),
                ),

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          // await ref
                          //     .read(smsRepositoryProvider)
                          //     .dismissParsedMessage(widget.message.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Message dismissed'),
                              ),
                            );
                          }
                        },
                        child: const Text('Dismiss'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _selectedProjectId == null
                            ? null
                            : () async {
                                // await ref
                                //     .read(smsRepositoryProvider)
                                //     .confirmParsedMessage(
                                //       messageId: widget.message.id,
                                //       projectId: _selectedProjectId!,
                                //       createRecord: true,
                                //     );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isDebit
                                            ? 'Expense created'
                                            : 'Income created',
                                      ),
                                    ),
                                  );
                                }
                              },
                        child: const Text('Confirm & Create'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

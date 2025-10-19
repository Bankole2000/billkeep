import 'package:billkeep/providers/sms_provider.dart';
import 'package:billkeep/screens/sms/rule_builder_screen.dart';
import 'package:billkeep/screens/sms/test_rule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';

class SmsRulesScreen extends ConsumerStatefulWidget {
  const SmsRulesScreen({super.key});

  @override
  ConsumerState<SmsRulesScreen> createState() => _SmsRulesScreenState();
}

class _SmsRulesScreenState extends ConsumerState<SmsRulesScreen> {
  bool _isLoading = false;

  Future<void> _setupDefaultRules() async {
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(smsRepositoryProvider);

      // Default Nigerian bank SMS rules
      final defaultRules = [
        // GTBank
        {
          'name': 'GTBank Debit',
          'sender': 'GTBank',
          'pattern': r'Acct:.*?debited.*?Amt:.*?NGN([\d,]+\.\d{2})',
          'amountPattern': r'NGN([\d,]+\.\d{2})',
          'descriptionPattern': r'Desc:\s*([^\n]+)',
          'type': 'DEBIT',
        },
        {
          'name': 'GTBank Credit',
          'sender': 'GTBank',
          'pattern': r'Acct:.*?credited.*?Amt:.*?NGN([\d,]+\.\d{2})',
          'amountPattern': r'NGN([\d,]+\.\d{2})',
          'descriptionPattern': r'Desc:\s*([^\n]+)',
          'type': 'CREDIT',
        },

        // Access Bank
        {
          'name': 'Access Bank Debit',
          'sender': 'AccessBank',
          'pattern': r'Debit.*?Amount:.*?NGN([\d,]+\.\d{2})',
          'amountPattern': r'NGN([\d,]+\.\d{2})',
          'descriptionPattern': r'Desc:\s*([^\n]+)',
          'type': 'DEBIT',
        },
        {
          'name': 'Access Bank Credit',
          'sender': 'AccessBank',
          'pattern': r'Credit.*?Amount:.*?NGN([\d,]+\.\d{2})',
          'amountPattern': r'NGN([\d,]+\.\d{2})',
          'descriptionPattern': r'Desc:\s*([^\n]+)',
          'type': 'CREDIT',
        },

        // First Bank
        {
          'name': 'First Bank Debit',
          'sender': 'FirstBank',
          'pattern': r'Your.*?account.*?debited.*?NGN([\d,]+\.\d{2})',
          'amountPattern': r'NGN([\d,]+\.\d{2})',
          'descriptionPattern': r'Transaction:\s*([^\n]+)',
          'type': 'DEBIT',
        },
        {
          'name': 'First Bank Credit',
          'sender': 'FirstBank',
          'pattern': r'Your.*?account.*?credited.*?NGN([\d,]+\.\d{2})',
          'amountPattern': r'NGN([\d,]+\.\d{2})',
          'descriptionPattern': r'Transaction:\s*([^\n]+)',
          'type': 'CREDIT',
        },

        // Zenith Bank
        {
          'name': 'Zenith Bank Debit',
          'sender': 'ZenithBank',
          'pattern': r'Debit.*?NGN([\d,]+\.\d{2})',
          'amountPattern': r'NGN([\d,]+\.\d{2})',
          'descriptionPattern': r'Narration:\s*([^\n]+)',
          'type': 'DEBIT',
        },
        {
          'name': 'Zenith Bank Credit',
          'sender': 'ZenithBank',
          'pattern': r'Credit.*?NGN([\d,]+\.\d{2})',
          'amountPattern': r'NGN([\d,]+\.\d{2})',
          'descriptionPattern': r'Narration:\s*([^\n]+)',
          'type': 'CREDIT',
        },

        // UBA
        {
          'name': 'UBA Debit',
          'sender': 'UBA',
          'pattern': r'Debit.*?Amount.*?NGN([\d,]+\.\d{2})',
          'amountPattern': r'NGN([\d,]+\.\d{2})',
          'descriptionPattern': r'Details:\s*([^\n]+)',
          'type': 'DEBIT',
        },
        {
          'name': 'UBA Credit',
          'sender': 'UBA',
          'pattern': r'Credit.*?Amount.*?NGN([\d,]+\.\d{2})',
          'amountPattern': r'NGN([\d,]+\.\d{2})',
          'descriptionPattern': r'Details:\s*([^\n]+)',
          'type': 'CREDIT',
        },

        // Generic patterns (fallback)
        {
          'name': 'Generic Debit',
          'sender': '',
          'pattern': r'(?:debit|debited|DR).*?(?:NGN|₦)\s*([\d,]+\.?\d{0,2})',
          'amountPattern': r'(?:NGN|₦)\s*([\d,]+\.?\d{0,2})',
          'descriptionPattern':
              r'(?:desc|description|details|narration):\s*([^\n]+)',
          'type': 'DEBIT',
        },
        {
          'name': 'Generic Credit',
          'sender': '',
          'pattern': r'(?:credit|credited|CR).*?(?:NGN|₦)\s*([\d,]+\.?\d{0,2})',
          'amountPattern': r'(?:NGN|₦)\s*([\d,]+\.?\d{0,2})',
          'descriptionPattern':
              r'(?:desc|description|details|narration):\s*([^\n]+)',
          'type': 'CREDIT',
        },
      ];

      for (final rule in defaultRules) {
        await repo.createMessageRule(
          name: rule['name'] as String,
          type: 'SMS',
          sender: rule['sender'] as String,
          pattern: rule['pattern'] as String,
          amountPattern: rule['amountPattern'] as String,
          descriptionPattern: rule['descriptionPattern'],
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${defaultRules.length} default rules created'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating rules: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteRule(String ruleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Rule?'),
        content: const Text(
          'This will permanently delete this SMS parsing rule.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(smsRepositoryProvider).deleteMessageRule(ruleId);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Rule deleted')));
      }
    }
  }

  Future<void> _toggleRuleActive(MessageRule rule) async {
    await ref
        .read(smsRepositoryProvider)
        .updateMessageRule(ruleId: rule.id, isActive: !rule.isActive);
  }

  @override
  Widget build(BuildContext context) {
    final rulesAsync = ref.watch(messageRulesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Import Rules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.science),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TestRuleScreen()),
              );
            },
            tooltip: 'Test Rule',
          ),
          // In the empty state (when rules.isEmpty):
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RuleBuilderScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.build),
                label: const Text('Rule Builder (Easy)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _showAddRuleDialog(),
                icon: const Icon(Icons.code),
                label: const Text('Advanced (Regex)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),

          // In the header section (when rules exist), replace the single button with:
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RuleBuilderScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.build),
                  label: const Text('Rule Builder'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showAddRuleDialog(),
                  icon: const Icon(Icons.code),
                  label: const Text('Advanced'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: rulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (rules) {
          if (rules.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.rule, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No SMS rules configured',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _setupDefaultRules,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download),
                    label: const Text('Setup Default Rules (Nigerian Banks)'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _showAddRuleDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Custom Rule'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Header with action buttons
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade50,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${rules.length} rules configured',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _isLoading ? null : _setupDefaultRules,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Reset to Defaults'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showAddRuleDialog(),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Custom Rule'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Rules list
              Expanded(
                child: ListView.builder(
                  itemCount: rules.length,
                  itemBuilder: (context, index) {
                    final rule = rules[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: Switch(
                          value: rule.isActive,
                          onChanged: (_) => _toggleRuleActive(rule),
                        ),
                        title: Text(
                          rule.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: rule.isActive ? Colors.black : Colors.grey,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            if (rule.sender.isNotEmpty)
                              Text('Sender: ${rule.sender}'),
                            Text(
                              'Type: ${rule.type}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditRuleDialog(rule),
                              tooltip: 'Edit rule',
                            ),
                            IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () => _showRuleDetails(rule),
                              tooltip: 'View details',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteRule(rule.id),
                              tooltip: 'Delete rule',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      // Also add a floating action button for extra visibility
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRuleDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Rule'),
      ),
    );
  }

  void _showRuleDetails(MessageRule rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(rule.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Type', rule.type),
              _buildDetailRow(
                'Sender',
                rule.sender.isEmpty ? '(any)' : rule.sender,
              ),
              _buildDetailRow('Active', rule.isActive ? 'Yes' : 'No'),
              const Divider(),
              const Text(
                'Patterns:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildPatternRow('Message Pattern', rule.pattern),
              _buildPatternRow('Amount Pattern', rule.amountPattern),
              if (rule.descriptionPattern != null)
                _buildPatternRow(
                  'Description Pattern',
                  rule.descriptionPattern!,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildPatternRow(String label, String pattern) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: SelectableText(
              pattern,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddRuleDialog() {
    final nameController = TextEditingController();
    final senderController = TextEditingController();
    final patternController = TextEditingController();
    final amountPatternController = TextEditingController();
    final descriptionPatternController = TextEditingController();
    String selectedType = 'SMS';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Rule'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Rule Name',
                  hintText: 'e.g., My Bank Debit',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: senderController,
                decoration: const InputDecoration(
                  labelText: 'Sender (optional)',
                  hintText: 'e.g., MyBank',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: patternController,
                decoration: const InputDecoration(
                  labelText: 'Message Pattern (regex)',
                  hintText: r'e.g., Debit.*NGN([\d,]+)',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountPatternController,
                decoration: const InputDecoration(
                  labelText: 'Amount Pattern (regex)',
                  hintText: r'e.g., NGN([\d,]+\.\d{2})',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionPatternController,
                decoration: const InputDecoration(
                  labelText: 'Description Pattern (optional)',
                  hintText: r'e.g., Desc:\s*([^\n]+)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty ||
                  patternController.text.trim().isEmpty ||
                  amountPatternController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill required fields'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              await ref
                  .read(smsRepositoryProvider)
                  .createMessageRule(
                    name: nameController.text.trim(),
                    type: selectedType,
                    sender: senderController.text.trim(),
                    pattern: patternController.text.trim(),
                    amountPattern: amountPatternController.text.trim(),
                    descriptionPattern:
                        descriptionPatternController.text.trim().isEmpty
                        ? null
                        : descriptionPatternController.text.trim(),
                  );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Rule created')));
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditRuleDialog(MessageRule rule) {
    final nameController = TextEditingController(text: rule.name);
    final senderController = TextEditingController(text: rule.sender);
    final patternController = TextEditingController(text: rule.pattern);
    final amountPatternController = TextEditingController(
      text: rule.amountPattern,
    );
    final descriptionPatternController = TextEditingController(
      text: rule.descriptionPattern ?? '',
    );
    String selectedType = rule.type;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Rule'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Rule Name',
                  hintText: 'e.g., My Bank Debit',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: senderController,
                decoration: const InputDecoration(
                  labelText: 'Sender',
                  hintText: 'e.g., GTBANK',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: patternController,
                decoration: const InputDecoration(
                  labelText: 'Message Pattern (regex)',
                  hintText: r'e.g., DR Amt:([\d,]+)',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountPatternController,
                decoration: const InputDecoration(
                  labelText: 'Amount Pattern (regex)',
                  hintText: r'e.g., DR Amt:([\d,]+\.?\d{0,2})',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionPatternController,
                decoration: const InputDecoration(
                  labelText: 'Description Pattern (optional)',
                  hintText: r'e.g., NIP/CR/([^\n]+)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty ||
                  patternController.text.trim().isEmpty ||
                  amountPatternController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill required fields'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              await ref
                  .read(smsRepositoryProvider)
                  .updateMessageRuleComplete(
                    ruleId: rule.id,
                    name: nameController.text.trim(),
                    sender: senderController.text.trim(),
                    pattern: patternController.text.trim(),
                    amountPattern: amountPatternController.text.trim(),
                    descriptionPattern:
                        descriptionPatternController.text.trim().isEmpty
                        ? null
                        : descriptionPatternController.text.trim(),
                  );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rule updated'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../providers/sms_provider.dart';

class TestRuleScreen extends ConsumerStatefulWidget {
  const TestRuleScreen({super.key});

  @override
  ConsumerState<TestRuleScreen> createState() => _TestRuleScreenState();
}

class _TestRuleScreenState extends ConsumerState<TestRuleScreen> {
  final _smsController = TextEditingController();
  final _senderController = TextEditingController();

  MessageRule? _selectedRule;
  Map<String, dynamic>? _testResult;
  bool _isTesting = false;

  @override
  void dispose() {
    _smsController.dispose();
    _senderController.dispose();
    super.dispose();
  }

  Future<void> _testRule() async {
    if (_smsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an SMS message to test'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    try {
      final smsText = _smsController.text.trim();
      final sender = _senderController.text.trim();

      if (_selectedRule != null) {
        // Test specific rule
        final result = await ref
            .read(smsRepositoryProvider)
            .testRuleMatch(
              rule: _selectedRule!,
              smsText: smsText,
              sender: sender,
            );
        setState(() => _testResult = result);
      } else {
        // Test against all active rules
        final rules = await ref
            .read(smsRepositoryProvider)
            .getActiveMessageRules();

        for (final rule in rules) {
          final result = await ref
              .read(smsRepositoryProvider)
              .testRuleMatch(rule: rule, smsText: smsText, sender: sender);

          if (result['matched'] == true) {
            setState(() {
              _testResult = result;
              _selectedRule = rule;
            });
            return;
          }
        }

        // No rule matched
        setState(() {
          _testResult = {
            'matched': false,
            'message': 'No active rule matched this SMS',
          };
        });
      }
    } catch (e) {
      setState(() {
        _testResult = {'matched': false, 'error': e.toString()};
      });
    } finally {
      setState(() => _isTesting = false);
    }
  }

  void _clearTest() {
    setState(() {
      _smsController.clear();
      _senderController.clear();
      _selectedRule = null;
      _testResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rulesAsync = ref.watch(messageRulesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test SMS Rule'),
        actions: [
          if (_testResult != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearTest,
              tooltip: 'Clear',
            ),
        ],
      ),
      body: rulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (rules) {
          if (rules.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No rules configured. Please setup rules first.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructions
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'How to Test',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '1. Paste an SMS message below\n'
                          '2. Enter the sender name (optional)\n'
                          '3. Select a specific rule or test all\n'
                          '4. Tap "Test Rule" to see what gets extracted',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sender input
                TextField(
                  controller: _senderController,
                  decoration: const InputDecoration(
                    labelText: 'Sender (Optional)',
                    hintText: 'e.g., GTBANK',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),

                // SMS input
                TextField(
                  controller: _smsController,
                  decoration: const InputDecoration(
                    labelText: 'SMS Message',
                    hintText: 'Paste your SMS here...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 8,
                ),
                const SizedBox(height: 16),

                // Rule selector
                DropdownButtonFormField<MessageRule?>(
                  value: _selectedRule,
                  decoration: const InputDecoration(
                    labelText: 'Test Against Rule',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.rule),
                  ),
                  items: [
                    const DropdownMenuItem<MessageRule?>(
                      value: null,
                      child: Text('All Active Rules (Auto-detect)'),
                    ),
                    ...rules.where((r) => r.isActive).map((rule) {
                      return DropdownMenuItem<MessageRule>(
                        value: rule,
                        child: Text(rule.name),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRule = value;
                      _testResult = null;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Test button
                ElevatedButton.icon(
                  onPressed: _isTesting ? null : _testRule,
                  icon: _isTesting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(_isTesting ? 'Testing...' : 'Test Rule'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),

                // Test results
                if (_testResult != null) _buildTestResults(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTestResults() {
    final matched = _testResult!['matched'] == true;

    return Card(
      color: matched ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  matched ? Icons.check_circle : Icons.error,
                  color: matched ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  matched ? 'Match Found!' : 'No Match',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: matched
                        ? Colors.green.shade900
                        : Colors.red.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (matched) ...[
              if (_testResult!['ruleName'] != null)
                _buildResultRow('Rule', _testResult!['ruleName']),
              if (_testResult!['transactionType'] != null)
                _buildResultRow(
                  'Transaction Type',
                  _testResult!['transactionType'],
                  icon: _testResult!['transactionType'] == 'DEBIT'
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  iconColor: _testResult!['transactionType'] == 'DEBIT'
                      ? Colors.red
                      : Colors.green,
                ),
              if (_testResult!['amount'] != null)
                _buildResultRow(
                  'Amount',
                  _testResult!['amount'],
                  icon: Icons.attach_money,
                ),
              if (_testResult!['description'] != null)
                _buildResultRow(
                  'Description',
                  _testResult!['description'],
                  icon: Icons.description,
                ),
              const Divider(height: 24),
              const Text(
                'Raw Extracted Data:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  _testResult.toString(),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            ] else ...[
              if (_testResult!['message'] != null)
                Text(
                  _testResult!['message'],
                  style: TextStyle(color: Colors.red.shade900),
                ),
              if (_testResult!['error'] != null)
                Text(
                  'Error: ${_testResult!['error']}',
                  style: TextStyle(color: Colors.red.shade900),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
    String label,
    String value, {
    IconData? icon,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: iconColor ?? Colors.grey),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

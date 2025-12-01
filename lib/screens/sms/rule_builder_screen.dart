import 'package:billkeep/providers/sms_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RuleBuilderScreen extends ConsumerStatefulWidget {
  const RuleBuilderScreen({super.key});

  @override
  ConsumerState<RuleBuilderScreen> createState() => _RuleBuilderScreenState();
}

class _RuleBuilderScreenState extends ConsumerState<RuleBuilderScreen> {
  final _formKey = GlobalKey<FormState>();

  // Step 1: Basic Info
  final _ruleNameController = TextEditingController();
  final _senderController = TextEditingController();
  String _transactionType = 'DEBIT';

  // Step 2: Sample SMS
  final _sampleSmsController = TextEditingController();

  // Step 3: Amount Extraction
  String _amountPrefix = '';
  String _amountFormat = 'with_commas'; // 'with_commas' or 'no_commas'
  bool _amountHasDecimals = true;

  // Step 4: Description Extraction
  bool _extractDescription = false;
  String _descriptionPrefix = '';
  String _descriptionEnd = 'newline'; // 'newline', 'space', 'custom'
  final _customDescriptionEndController = TextEditingController();

  // Generated patterns
  String? _generatedPattern;
  String? _generatedAmountPattern;
  String? _generatedDescriptionPattern;

  // Preview
  Map<String, dynamic>? _previewResult;
  bool _isTesting = false;

  int _currentStep = 0;

  @override
  void dispose() {
    _ruleNameController.dispose();
    _senderController.dispose();
    _sampleSmsController.dispose();
    _customDescriptionEndController.dispose();
    super.dispose();
  }

  void _generatePatterns() {
    // Generate amount pattern
    String amountPattern;
    if (_amountFormat == 'with_commas') {
      if (_amountHasDecimals) {
        amountPattern = r'([\d,]+\.\d{2})';
      } else {
        amountPattern = r'([\d,]+)';
      }
    } else {
      if (_amountHasDecimals) {
        amountPattern = r'(\d+\.\d{2})';
      } else {
        amountPattern = r'(\d+)';
      }
    }

    if (_amountPrefix.isNotEmpty) {
      final escapedPrefix = RegExp.escape(_amountPrefix);
      _generatedAmountPattern = '$escapedPrefix\\s*$amountPattern';
    } else {
      _generatedAmountPattern = amountPattern;
    }

    // Generate description pattern
    if (_extractDescription && _descriptionPrefix.isNotEmpty) {
      final escapedPrefix = RegExp.escape(_descriptionPrefix);
      String endPattern;

      switch (_descriptionEnd) {
        case 'newline':
          endPattern = r'([^\n]+)';
          break;
        case 'space':
          endPattern = r'(\S+)';
          break;
        case 'custom':
          final escapedEnd = RegExp.escape(
            _customDescriptionEndController.text,
          );
          endPattern = '([^$escapedEnd]+)';
          break;
        default:
          endPattern = r'([^\n]+)';
      }

      _generatedDescriptionPattern = '$escapedPrefix\\s*$endPattern';
    }

    // Generate main pattern (must match transaction type and amount)
    final typeKeyword = _transactionType == 'DEBIT'
        ? r'(?:debit|DR|debited)'
        : r'(?:credit|CR|credited)';

    _generatedPattern = '.*$typeKeyword.*$_generatedAmountPattern';
  }

  Future<void> _testGeneratedRule() async {
    if (_sampleSmsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a sample SMS to test'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _generatePatterns();

    setState(() => _isTesting = true);

    try {
      final smsText = _sampleSmsController.text.trim();
      final sender = _senderController.text.trim();

      // Test main pattern
      final mainRegex = RegExp(_generatedPattern!, caseSensitive: false);
      if (!mainRegex.hasMatch(smsText)) {
        setState(() {
          _previewResult = {
            'matched': false,
            'message':
                'SMS does not match the transaction type and amount pattern',
          };
        });
        return;
      }

      // Test amount extraction
      final amountRegex = RegExp(
        _generatedAmountPattern!,
        caseSensitive: false,
      );
      final amountMatch = amountRegex.firstMatch(smsText);

      if (amountMatch == null || amountMatch.groupCount < 1) {
        setState(() {
          _previewResult = {
            'matched': false,
            'message': 'Could not extract amount from SMS',
          };
        });
        return;
      }

      final amountStr = amountMatch.group(1)?.replaceAll(',', '') ?? '0';

      // Test description extraction
      String? description;
      if (_extractDescription && _generatedDescriptionPattern != null) {
        final descRegex = RegExp(
          _generatedDescriptionPattern!,
          caseSensitive: false,
        );
        final descMatch = descRegex.firstMatch(smsText);
        description = descMatch?.group(1)?.trim();
      }

      setState(() {
        _previewResult = {
          'matched': true,
          'amount': amountStr,
          'description': description ?? 'No description extracted',
          'transactionType': _transactionType,
          'sender': sender,
        };
      });
    } catch (e) {
      setState(() {
        _previewResult = {'matched': false, 'error': e.toString()};
      });
    } finally {
      setState(() => _isTesting = false);
    }
  }

  Future<void> _saveRule() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_previewResult == null || _previewResult!['matched'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please test the rule successfully before saving'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    _generatePatterns();

    try {
      // await ref
      //     .read(smsRepositoryProvider)
      //     .createMessageRule(
      //       name: _ruleNameController.text.trim(),
      //       type: 'SMS',
      //       sender: _senderController.text.trim(),
      //       pattern: _generatedPattern!,
      //       amountPattern: _generatedAmountPattern!,
      //       descriptionPattern: _generatedDescriptionPattern,
      //     );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rule created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating rule: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rule Builder')),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 4) {
              setState(() => _currentStep++);
            } else {
              _saveRule();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          onStepTapped: (step) => setState(() => _currentStep = step),
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  if (_currentStep < 4)
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Continue'),
                    )
                  else
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Save Rule'),
                    ),
                  const SizedBox(width: 8),
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                ],
              ),
            );
          },
          steps: [
            // Step 1: Basic Info
            Step(
              title: const Text('Basic Information'),
              content: Column(
                children: [
                  TextFormField(
                    controller: _ruleNameController,
                    decoration: const InputDecoration(
                      labelText: 'Rule Name',
                      hintText: 'e.g., My Bank Debit Alerts',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a rule name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _senderController,
                    decoration: const InputDecoration(
                      labelText: 'SMS Sender Name',
                      hintText: 'e.g., GTBANK',
                      helperText: 'Leave empty to match any sender',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _transactionType,
                    decoration: const InputDecoration(
                      labelText: 'Transaction Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'DEBIT',
                        child: Text('Debit (Money Out)'),
                      ),
                      DropdownMenuItem(
                        value: 'CREDIT',
                        child: Text('Credit (Money In)'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _transactionType = value!);
                    },
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),

            // Step 2: Sample SMS
            Step(
              title: const Text('Sample SMS'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Paste a sample SMS from your bank. This helps us understand the format.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _sampleSmsController,
                    decoration: const InputDecoration(
                      labelText: 'Sample SMS Message',
                      hintText: 'Paste your bank SMS here...',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 8,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a sample SMS';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),

            // Step 3: Amount Configuration
            Step(
              title: const Text('Amount Extraction'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How does the amount appear in your SMS?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _amountPrefix,
                    decoration: const InputDecoration(
                      labelText: 'Text Before Amount',
                      hintText: 'e.g., DR Amt: or Amount: or NGN',
                      helperText: 'What text comes right before the amount?',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => _amountPrefix = value),
                  ),
                  const SizedBox(height: 16),
                  const Text('Amount Format:', style: TextStyle(fontSize: 12)),
                  RadioListTile<String>(
                    title: const Text('With commas (e.g., 1,000.00)'),
                    value: 'with_commas',
                    groupValue: _amountFormat,
                    onChanged: (value) =>
                        setState(() => _amountFormat = value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Without commas (e.g., 1000.00)'),
                    value: 'no_commas',
                    groupValue: _amountFormat,
                    onChanged: (value) =>
                        setState(() => _amountFormat = value!),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('Amount has decimal places'),
                    subtitle: const Text('e.g., 1,000.00 vs 1,000'),
                    value: _amountHasDecimals,
                    onChanged: (value) =>
                        setState(() => _amountHasDecimals = value!),
                  ),
                ],
              ),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            ),

            // Step 4: Description Configuration
            Step(
              title: const Text('Description Extraction'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    title: const Text('Extract transaction description'),
                    subtitle: const Text(
                      'Get details like merchant name, transfer info, etc.',
                    ),
                    value: _extractDescription,
                    onChanged: (value) =>
                        setState(() => _extractDescription = value!),
                  ),
                  if (_extractDescription) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _descriptionPrefix,
                      decoration: const InputDecoration(
                        labelText: 'Text Before Description',
                        hintText: 'e.g., Desc: or Details: or NIP CR/',
                        helperText: 'What text comes before the description?',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          setState(() => _descriptionPrefix = value),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description ends at:',
                      style: TextStyle(fontSize: 12),
                    ),
                    RadioListTile<String>(
                      title: const Text('End of line / Next line'),
                      value: 'newline',
                      groupValue: _descriptionEnd,
                      onChanged: (value) =>
                          setState(() => _descriptionEnd = value!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Next space'),
                      value: 'space',
                      groupValue: _descriptionEnd,
                      onChanged: (value) =>
                          setState(() => _descriptionEnd = value!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Custom character'),
                      value: 'custom',
                      groupValue: _descriptionEnd,
                      onChanged: (value) =>
                          setState(() => _descriptionEnd = value!),
                    ),
                    if (_descriptionEnd == 'custom')
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 8),
                        child: TextFormField(
                          controller: _customDescriptionEndController,
                          decoration: const InputDecoration(
                            labelText: 'End Character',
                            hintText: 'e.g., /',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
            ),

            // Step 5: Test & Save
            Step(
              title: const Text('Test & Save'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Test your rule',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Click the button below to test if your rule correctly extracts data from the sample SMS.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isTesting ? null : _testGeneratedRule,
                    icon: _isTesting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(_isTesting ? 'Testing...' : 'Test Rule'),
                  ),
                  const SizedBox(height: 16),
                  if (_previewResult != null) _buildPreview(),
                  const SizedBox(height: 16),
                  if (_generatedPattern != null) ...[
                    ExpansionTile(
                      title: const Text('Generated Patterns (Advanced)'),
                      children: [
                        _buildPatternDisplay(
                          'Main Pattern',
                          _generatedPattern!,
                        ),
                        _buildPatternDisplay(
                          'Amount Pattern',
                          _generatedAmountPattern!,
                        ),
                        if (_generatedDescriptionPattern != null)
                          _buildPatternDisplay(
                            'Description Pattern',
                            _generatedDescriptionPattern!,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
              isActive: _currentStep >= 4,
              state: _currentStep > 4 ? StepState.complete : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    final matched = _previewResult!['matched'] == true;

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
                  matched ? 'Success!' : 'Failed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: matched
                        ? Colors.green.shade900
                        : Colors.red.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (matched) ...[
              _buildPreviewRow('Amount', _previewResult!['amount']),
              _buildPreviewRow('Description', _previewResult!['description']),
              _buildPreviewRow('Type', _previewResult!['transactionType']),
            ] else ...[
              Text(
                _previewResult!['message'] ??
                    _previewResult!['error'] ??
                    'Unknown error',
                style: TextStyle(color: Colors.red.shade900),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildPatternDisplay(String label, String pattern) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 4),
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
}

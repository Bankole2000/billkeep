import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/project_provider.dart';
import '../../database/database.dart';
import '../../utils/currency_helper.dart';

class BudgetForm extends ConsumerStatefulWidget {
  final Project project;

  const BudgetForm({super.key, required this.project});

  @override
  ConsumerState<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends ConsumerState<BudgetForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _budgetType = 'ONE_TIME';
  String? _budgetFrequency;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill if budget exists
    if (widget.project.budgetAmount != null) {
      _amountController.text = (widget.project.budgetAmount! / 100)
          .toStringAsFixed(2);
      _budgetType = widget.project.budgetType ?? 'ONE_TIME';
      _budgetFrequency = widget.project.budgetFrequency;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveBudget() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await ref
            .read(projectRepositoryProvider)
            .updateProjectBudget(
              projectId: widget.project.id,
              budgetAmount: CurrencyHelper.dollarsToCents(
                _amountController.text.trim(),
              ),
              budgetType: _budgetType,
              budgetFrequency: _budgetFrequency,
            );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Budget updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Budget'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Budget Amount',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _budgetType,
              decoration: const InputDecoration(
                labelText: 'Budget Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'ONE_TIME',
                  child: Text('One-time (Total Pool)'),
                ),
                DropdownMenuItem(value: 'RECURRING', child: Text('Recurring')),
              ],
              onChanged: (value) {
                setState(() {
                  _budgetType = value!;
                  if (_budgetType == 'ONE_TIME') {
                    _budgetFrequency = null;
                  } else if (_budgetFrequency == null) {
                    _budgetFrequency = 'MONTHLY';
                  }
                });
              },
            ),
            const SizedBox(height: 16),

            if (_budgetType == 'RECURRING')
              DropdownButtonFormField<String>(
                value: _budgetFrequency,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'WEEKLY', child: Text('Weekly')),
                  DropdownMenuItem(value: 'MONTHLY', child: Text('Monthly')),
                ],
                onChanged: (value) {
                  setState(() => _budgetFrequency = value);
                },
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
          onPressed: _isLoading ? null : _saveBudget,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}

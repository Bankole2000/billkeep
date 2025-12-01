import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/providers/income_provider.dart';

class IncomeForm extends ConsumerStatefulWidget {
  final String projectId;

  const IncomeForm({super.key, required this.projectId});

  @override
  ConsumerState<IncomeForm> createState() => _IncomeFormState();
}

class _IncomeFormState extends ConsumerState<IncomeForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _invoiceController = TextEditingController();
  final _notesController = TextEditingController();

  String _type = 'ONE_TIME';
  String? _frequency;
  DateTime _dateReceived = DateTime.now();
  bool _createInitialPayment = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _invoiceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveIncome() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // await ref
        //     .read(incomeRepositoryProvider)
        //     .createIncome(
        //       projectId: widget.projectId,
        //       description: _descriptionController.text.trim(),
        //       amount: _amountController.text.trim(),
        //       type: _type,
        //       startDate: _dateReceived,
        //       invoiceNumber: _invoiceController.text.trim().isEmpty
        //           ? null
        //           : _invoiceController.text.trim(),
        //       notes: _notesController.text.trim().isEmpty
        //           ? null
        //           : _notesController.text.trim(),
        //       createInitialPayment: _type == 'RECURRING'
        //           ? _createInitialPayment
        //           : true,
        //     );

        if (mounted) Navigator.pop(context);
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
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
              prefixText: '\$ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            initialValue: _type,
            decoration: const InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'ONE_TIME', child: Text('One-time')),
              DropdownMenuItem(value: 'RECURRING', child: Text('Recurring')),
            ],
            onChanged: (value) {
              setState(() {
                _type = value!;
                if (_type == 'ONE_TIME') {
                  _frequency = null;
                  _createInitialPayment = true;
                } else {
                  _frequency ??= 'MONTHLY';
                }
              });
            },
          ),
          if (_type == 'RECURRING') const SizedBox(height: 16),

          if (_type == 'RECURRING')
            DropdownButtonFormField<String>(
              initialValue: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'MONTHLY', child: Text('Monthly')),
                DropdownMenuItem(value: 'YEARLY', child: Text('Yearly')),
              ],
              onChanged: (value) {
                setState(() => _frequency = value);
              },
            ),
          if (_type == 'RECURRING') const SizedBox(height: 16),

          if (_type == 'RECURRING')
            CheckboxListTile(
              title: const Text('Record first payment now'),
              subtitle: const Text('Create initial payment record'),
              value: _createInitialPayment,
              onChanged: (value) {
                setState(() => _createInitialPayment = value ?? false);
              },
            ),
          const SizedBox(height: 16),

          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: const Text('Date Received'),
            subtitle: Text(_dateReceived.toString().split(' ')[0]),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _dateReceived,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) setState(() => _dateReceived = date);
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _invoiceController,
            decoration: const InputDecoration(
              labelText: 'Invoice Number (Optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isLoading ? null : _saveIncome,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Add Income'),
          ),
        ],
      ),
    );
  }
}

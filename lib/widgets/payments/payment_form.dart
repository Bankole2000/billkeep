import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/providers/expense_provider.dart';
import 'package:billkeep/database/database.dart';

class PaymentForm extends ConsumerStatefulWidget {
  final Expense expense;

  const PaymentForm({super.key, required this.expense});

  @override
  ConsumerState<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends ConsumerState<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _paymentDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with expected amount
    _amountController.text = (widget.expense.expectedAmount / 100)
        .toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _savePayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // await ref
        //     .read(expenseRepositoryProvider)
        //     .recordPayment(
        //       expenseId: widget.expense.id,
        //       actualAmount: _amountController.text.trim(),
        //       paymentDate: _paymentDate,
        //       notes: _notesController.text.trim().isEmpty
        //           ? null
        //           : _notesController.text.trim(),
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
          Text('Recording payment for: ${widget.expense.name}'),
          const SizedBox(height: 16),

          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount Paid',
              border: OutlineInputBorder(),
              prefixText: '\$ ',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Enter amount';
              if (double.tryParse(value) == null) return 'Invalid number';
              return null;
            },
          ),
          const SizedBox(height: 16),

          ListTile(
            title: const Text('Payment Date'),
            subtitle: Text(_paymentDate.toString().split(' ')[0]),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _paymentDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) setState(() => _paymentDate = date);
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isLoading ? null : _savePayment,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Record Payment'),
          ),
        ],
      ),
    );
  }
}

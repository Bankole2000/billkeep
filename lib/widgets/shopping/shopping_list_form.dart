import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/providers/shopping_list_provider.dart';
import 'package:billkeep/providers/expense_provider.dart';

class ShoppingListForm extends ConsumerStatefulWidget {
  final String projectId;

  const ShoppingListForm({super.key, required this.projectId});

  @override
  ConsumerState<ShoppingListForm> createState() => _ShoppingListFormState();
}

class _ShoppingListFormState extends ConsumerState<ShoppingListForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _trackAsExpense = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveShoppingList() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        String? expenseId;

        // Create expense if tracking is enabled
        // if (_trackAsExpense) {
        //   expenseId = await ref
        //       .read(expenseRepositoryProvider)
        //       .createExpense(
        //         projectId: widget.projectId,
        //         name: 'Shopping List: ${_nameController.text.trim()}',
        //         amount: '0', // Will be calculated from items
        //         type: 'ONE_TIME',
        //         createInitialPayment: false, // Don't create initial payment
        //       );
        // }

        // Create shopping list with linked expense
        await ref
            .read(shoppingListRepositoryProvider)
            .createShoppingList(
              projectId: widget.projectId,
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              linkedExpenseId: expenseId,
            );

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
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Shopping List Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          CheckboxListTile(
            title: const Text('Track as project expense'),
            subtitle: const Text('Items will be recorded as payments'),
            value: _trackAsExpense,
            onChanged: (value) {
              setState(() => _trackAsExpense = value ?? false);
            },
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isLoading ? null : _saveShoppingList,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Create Shopping List'),
          ),
        ],
      ),
    );
  }
}

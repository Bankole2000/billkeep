import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/todo_provider.dart';
import '../../providers/shopping_list_provider.dart';
import '../../utils/currency_helper.dart';

class TodoForm extends ConsumerStatefulWidget {
  final String projectId;

  const TodoForm({super.key, required this.projectId});

  @override
  ConsumerState<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends ConsumerState<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  bool _hasFinancialAttachment = false;
  String _attachmentType = 'direct'; // 'direct' or 'shopping_list'
  String _expenseType = 'ONE_TIME';
  String? _frequency;
  String? _selectedShoppingListId;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await ref
            .read(todoRepositoryProvider)
            .createTodo(
              projectId: widget.projectId,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              directExpenseAmount:
                  _hasFinancialAttachment && _attachmentType == 'direct'
                  ? CurrencyHelper.dollarsToCents(_amountController.text.trim())
                  : null,
              directExpenseType:
                  _hasFinancialAttachment && _attachmentType == 'direct'
                  ? _expenseType
                  : null,
              directExpenseFrequency:
                  _hasFinancialAttachment &&
                      _attachmentType == 'direct' &&
                      _expenseType == 'RECURRING'
                  ? _frequency
                  : null,
              linkedShoppingListId:
                  _hasFinancialAttachment && _attachmentType == 'shopping_list'
                  ? _selectedShoppingListId
                  : null,
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
    final shoppingListsAsync = ref.watch(
      projectShoppingListsProvider(widget.projectId),
    );

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Todo Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a title';
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

          // Financial attachment section
          CheckboxListTile(
            title: const Text('Add financial attachment'),
            subtitle: const Text('Link expense or shopping list'),
            value: _hasFinancialAttachment,
            onChanged: (value) {
              setState(() => _hasFinancialAttachment = value ?? false);
            },
          ),

          if (_hasFinancialAttachment) ...[
            const SizedBox(height: 16),

            // Attachment type selector
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'direct', label: Text('Direct Expense')),
                ButtonSegment(
                  value: 'shopping_list',
                  label: Text('Shopping List'),
                ),
              ],
              selected: {_attachmentType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() => _attachmentType = newSelection.first);
              },
            ),
            const SizedBox(height: 16),

            // Direct expense fields
            if (_attachmentType == 'direct') ...[
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (_hasFinancialAttachment && _attachmentType == 'direct') {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _expenseType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'ONE_TIME', child: Text('One-time')),
                  DropdownMenuItem(
                    value: 'RECURRING',
                    child: Text('Recurring'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _expenseType = value!;
                    if (_expenseType == 'ONE_TIME') {
                      _frequency = null;
                    } else {
                      _frequency ??= 'MONTHLY';
                    }
                  });
                },
              ),
              const SizedBox(height: 16),

              if (_expenseType == 'RECURRING')
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
            ],

            // Shopping list selector
            if (_attachmentType == 'shopping_list')
              shoppingListsAsync.when(
                data: (shoppingLists) {
                  if (shoppingLists.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('No shopping lists available'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Navigate to create shopping list
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Create shopping list first'),
                                  ),
                                );
                              },
                              child: const Text('Create Shopping List'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return DropdownButtonFormField<String>(
                    initialValue: _selectedShoppingListId,
                    decoration: const InputDecoration(
                      labelText: 'Select Shopping List',
                      border: OutlineInputBorder(),
                    ),
                    items: shoppingLists.map((list) {
                      return DropdownMenuItem(
                        value: list.id,
                        child: Text(list.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedShoppingListId = value);
                    },
                    validator: (value) {
                      if (_hasFinancialAttachment &&
                          _attachmentType == 'shopping_list' &&
                          value == null) {
                        return 'Please select a shopping list';
                      }
                      return null;
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error loading shopping lists'),
              ),
          ],

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isLoading ? null : _saveTodo,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Add Todo'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/todo_provider.dart';
import 'package:billkeep/utils/currency_helper.dart';

/// Show add subtask dialog
void showAddSubtaskDialog(
  BuildContext context,
  WidgetRef ref,
  TodoItem parentTodo,
) {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  bool hasExpense = false;

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Add Subtask'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Subtask Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Has expense'),
                value: hasExpense,
                onChanged: (value) {
                  setState(() => hasExpense = value ?? false);
                },
              ),
              if (hasExpense) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ],
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
              if (titleController.text.trim().isEmpty) return;

              // await ref.read(todoRepositoryProvider).createTodo(
              //       projectId: parentTodo.projectId,
              //       title: titleController.text.trim(),
              //       parentTodoId: parentTodo.id,
              //       directExpenseAmount:
              //           hasExpense && amountController.text.trim().isNotEmpty
              //               ? CurrencyHelper.dollarsToCents(
              //                   amountController.text.trim(),
              //                 )
              //               : null,
              //       directExpenseType: hasExpense ? 'ONE_TIME' : null,
              //     );

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ),
  );
}

/// Show edit todo dialog
void showEditTodoDialog(BuildContext context, WidgetRef ref, TodoItem todo) {
  final titleController = TextEditingController(text: todo.title);
  final descriptionController = TextEditingController(text: todo.description);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Todo Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (titleController.text.trim().isEmpty) return;

            // await ref.read(todoRepositoryProvider).updateTodo(
            //       todoId: todo.id,
            //       title: titleController.text.trim(),
            //       description: descriptionController.text.trim().isEmpty
            //           ? null
            //           : descriptionController.text.trim(),
            //     );

            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Todo updated')));
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

/// Show delete todo confirmation dialog
void showDeleteTodoConfirmation(
  BuildContext context,
  WidgetRef ref,
  String todoId,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Todo?'),
      content: const Text(
        'This will permanently delete the todo, its subtasks, and any linked expenses/payments.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            // await ref.read(todoRepositoryProvider).deleteTodo(todoId);
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Todo deleted')));
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

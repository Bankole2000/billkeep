import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/widgets/expenses/expense_form.dart';

class AddExpenseScreen extends ConsumerWidget {
  final String projectId;

  const AddExpenseScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ExpenseForm(projectId: projectId),
    );
  }
}

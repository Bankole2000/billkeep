import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/expense_provider.dart';
import 'package:billkeep/providers/income_provider.dart';
import 'package:billkeep/widgets/expenses/expense_list_item.dart';
import 'package:billkeep/widgets/common/project_speed_dial.dart';
import 'package:billkeep/widgets/income/income_list_item.dart';

final financesSegmentProvider = StateProvider<int>((ref) => 0);

class FinancesScreen extends ConsumerWidget {
  final Project project;

  const FinancesScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSegment = ref.watch(financesSegmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${project.name} - Finances'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Segmented control
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  label: Text('Expenses'),
                  icon: Icon(Icons.money_off),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('Income'),
                  icon: Icon(Icons.attach_money),
                ),
              ],
              selected: {selectedSegment},
              onSelectionChanged: (Set<int> newSelection) {
                ref.read(financesSegmentProvider.notifier).state =
                    newSelection.first;
              },
            ),
          ),

          // Content based on segment
          Expanded(
            child: selectedSegment == 0
                ? _ExpensesView(projectId: project.id)
                : _IncomeView(projectId: project.id),
          ),
        ],
      ),
      floatingActionButton: ProjectSpeedDial(projectId: project.id),
    );
  }
}

// Expenses view
class _ExpensesView extends ConsumerWidget {
  final String projectId;

  const _ExpensesView({required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(projectExpensesProvider(projectId));

    return expensesAsync.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return const Center(
            child: Text('No expenses yet. Tap + to add one.'),
          );
        }

        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return ExpenseListItem(expense: expense);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading expenses')),
    );
  }
}

// Income view
class _IncomeView extends ConsumerWidget {
  final String projectId;

  const _IncomeView({required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeAsync = ref.watch(projectIncomeProvider(projectId));

    return incomeAsync.when(
      data: (incomeList) {
        if (incomeList.isEmpty) {
          return const Center(child: Text('No income yet. Tap + to add one.'));
        }

        return ListView.builder(
          itemCount: incomeList.length,
          itemBuilder: (context, index) {
            final income = incomeList[index];
            return IncomeListItem(income: income);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading income')),
    );
  }
}

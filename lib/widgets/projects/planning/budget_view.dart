import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/income_provider.dart';
import '../../../providers/budget_provider.dart';
import '../../../utils/currency_helper.dart';
import '../budget_form.dart';

/// Budget view for project planning screen
class BudgetView extends ConsumerWidget {
  final Project project;

  const BudgetView({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetAsync = ref.watch(activeProjectBudgetProvider(project.id));
    final expensesAsync = ref.watch(projectExpensesProvider(project.id));
    final incomeAsync = ref.watch(projectIncomeProvider(project.id));

    return budgetAsync.when(
      data: (budget) {
        // If no budget set
        if (budget == null) {
          return _NoBudgetState(project: project);
        }

        // Budget exists - show tracking
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Budget summary card
            _BudgetSummaryCard(budget: budget, project: project),
            const SizedBox(height: 16),

            // Spending vs Budget
            _SpendingCard(
              expensesAsync: expensesAsync,
              budgetAmount: budget.limitAmount / 100,
            ),
            const SizedBox(height: 16),

            // Income vs Budget (for context)
            _IncomeCard(incomeAsync: incomeAsync),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading budget: $error'),
      ),
    );
  }
}

/// Widget shown when no budget is set
class _NoBudgetState extends StatelessWidget {
  final Project project;

  const _NoBudgetState({required this.project});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_balance, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No budget set for this project'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => BudgetForm(project: project),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Set Budget'),
          ),
        ],
      ),
    );
  }
}

/// Budget summary card showing budget details
class _BudgetSummaryCard extends StatelessWidget {
  final Budget budget;
  final Project project;

  const _BudgetSummaryCard({required this.budget, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budget.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => BudgetForm(project: project),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              CurrencyHelper.formatAmount(budget.limitAmount),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              '${budget.startDate.toString().split(' ')[0]} - ${budget.endDate.toString().split(' ')[0]}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card showing spending progress against budget
class _SpendingCard extends ConsumerWidget {
  final AsyncValue<List<Expense>> expensesAsync;
  final double budgetAmount;

  const _SpendingCard({
    required this.expensesAsync,
    required this.budgetAmount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return expensesAsync.when(
      data: (expenses) {
        // Calculate total spending
        double totalSpent = 0;
        for (final expense in expenses.where((e) => e.isActive)) {
          totalSpent += expense.expectedAmount / 100;
        }

        final remaining = budgetAmount - totalSpent;
        final percentUsed = (totalSpent / budgetAmount * 100).clamp(0, 100);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Spending',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percentUsed / 100,
                    minHeight: 20,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentUsed > 100
                          ? Colors.red
                          : percentUsed > 80
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Spent',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '\$${totalSpent.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Remaining',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '\$${remaining.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: remaining < 0 ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
                  '${percentUsed.toStringAsFixed(1)}% of budget used',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading expenses')),
    );
  }
}

/// Card showing income information
class _IncomeCard extends ConsumerWidget {
  final AsyncValue<List<IncomeData>> incomeAsync;

  const _IncomeCard({required this.incomeAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return incomeAsync.when(
      data: (incomeList) {
        final totalIncome = incomeList.fold<double>(
          0,
          (sum, inc) => sum + (inc.expectedAmount / 100),
        );

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Income',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Expected:'),
                    Text(
                      '\$${totalIncome.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/expense_provider.dart';
import '../../providers/income_provider.dart';
import '../../database/database.dart';

class ProjectSummaryCard extends ConsumerWidget {
  final Project project;

  const ProjectSummaryCard({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(projectExpensesProvider(project.id));
    final incomeAsync = ref.watch(projectIncomeProvider(project.id));

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            expensesAsync.when(
              data: (expenses) {
                // Calculate total expenses (all active)
                double totalExpenses = 0;
                for (final expense in expenses.where((e) => e.isActive)) {
                  totalExpenses += expense.expectedAmount / 100;
                }

                // Calculate monthly recurring for reference
                double monthlyExpected = 0;
                for (final expense in expenses.where((e) => e.isActive)) {
                  final amount = expense.expectedAmount / 100;
                  if (expense.type == 'RECURRING') {
                    if (expense.frequency == 'MONTHLY') {
                      monthlyExpected += amount;
                    } else if (expense.frequency == 'YEARLY') {
                      monthlyExpected += amount / 12;
                    }
                  }
                }

                return incomeAsync.when(
                  data: (incomeList) {
                    final totalIncome = incomeList.fold<double>(
                      0,
                      (sum, inc) => sum + (inc.expectedAmount / 100),
                    );
                    final profit = totalIncome - totalExpenses;

                    return Column(
                      children: [
                        _SummaryRow(
                          label: 'Total Income',
                          value: '\$${totalIncome.toStringAsFixed(2)}',
                          color: Colors.green,
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Total Expenses',
                          value: '\$${totalExpenses.toStringAsFixed(2)}',
                          color: Colors.red,
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Monthly Burn:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '\$${monthlyExpected.toStringAsFixed(2)}/mo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 24),
                        _SummaryRow(
                          label: 'Net Profit',
                          value: '\$${profit.toStringAsFixed(2)}',
                          color: profit >= 0 ? Colors.green : Colors.red,
                          isLarge: true,
                        ),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('Error loading income'),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading expenses'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isLarge;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 18 : 16,
            fontWeight: isLarge ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 28 : 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

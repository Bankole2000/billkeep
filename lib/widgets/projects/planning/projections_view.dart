import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/income_provider.dart';
import '../../../providers/planning_calculations_provider.dart';
import 'statistic_widgets.dart';

/// Projections view for project planning screen
class ProjectionsView extends ConsumerWidget {
  final Project project;

  const ProjectionsView({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(projectExpensesProvider(project.id));
    final incomeAsync = ref.watch(projectIncomeProvider(project.id));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Time period selector
        _ProjectionPeriodSelector(),
        const SizedBox(height: 16),

        // Expenses projection
        _ExpenseProjectionCard(expensesAsync: expensesAsync),
        const SizedBox(height: 16),

        // Income projection
        _IncomeProjectionCard(incomeAsync: incomeAsync),
        const SizedBox(height: 16),

        // Net projection (Income - Expenses)
        _NetProjectionCard(
          expensesAsync: expensesAsync,
          incomeAsync: incomeAsync,
        ),
      ],
    );
  }
}

/// Widget for selecting projection period
class _ProjectionPeriodSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Projection Period',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 3, label: Text('3 Months')),
                ButtonSegment(value: 6, label: Text('6 Months')),
                ButtonSegment(value: 12, label: Text('12 Months')),
              ],
              selected: {6}, // Default 6 months
              onSelectionChanged: (Set<int> newSelection) {
                // TODO: Update projection period
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Card showing expense projections
class _ExpenseProjectionCard extends ConsumerWidget {
  final AsyncValue<List<Expense>> expensesAsync;

  const _ExpenseProjectionCard({required this.expensesAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculations = ref.watch(planningCalculationsProvider);

    return expensesAsync.when(
      data: (expenses) {
        final monthlyRecurring = calculations.calculateMonthlyRecurring(expenses);
        final yearlyRecurring = calculations.calculateYearlyRecurring(expenses);
        final oneTime = calculations.calculateOneTime(expenses);

        final projection3Months =
            (monthlyRecurring * 3) + (yearlyRecurring * 0.25) + oneTime;
        final projection6Months =
            (monthlyRecurring * 6) + (yearlyRecurring * 0.5) + oneTime;
        final projection12Months =
            (monthlyRecurring * 12) + yearlyRecurring + oneTime;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expense Projections',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),

                ProjectionRow(
                  label: '3 Months',
                  amount: projection3Months,
                  color: Colors.red,
                ),
                const Divider(),
                ProjectionRow(
                  label: '6 Months',
                  amount: projection6Months,
                  color: Colors.red,
                ),
                const Divider(),
                ProjectionRow(
                  label: '12 Months',
                  amount: projection12Months,
                  color: Colors.red,
                ),

                const SizedBox(height: 16),
                const Text(
                  'Breakdown:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Monthly recurring: \$${monthlyRecurring.toStringAsFixed(2)}/month',
                ),
                Text(
                  'Yearly recurring: \$${yearlyRecurring.toStringAsFixed(2)}/year',
                ),
                Text('One-time expenses: \$${oneTime.toStringAsFixed(2)}'),
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

/// Card showing income projections
class _IncomeProjectionCard extends ConsumerWidget {
  final AsyncValue<List<IncomeData>> incomeAsync;

  const _IncomeProjectionCard({required this.incomeAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculations = ref.watch(planningCalculationsProvider);

    return incomeAsync.when(
      data: (incomeList) {
        final monthlyRecurring = calculations.calculateMonthlyRecurringIncome(
          incomeList,
        );
        final yearlyRecurring = calculations.calculateYearlyRecurringIncome(
          incomeList,
        );
        final oneTime = calculations.calculateOneTimeIncome(incomeList);

        final projection3Months =
            (monthlyRecurring * 3) + (yearlyRecurring * 0.25) + oneTime;
        final projection6Months =
            (monthlyRecurring * 6) + (yearlyRecurring * 0.5) + oneTime;
        final projection12Months =
            (monthlyRecurring * 12) + yearlyRecurring + oneTime;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Income Projections',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),

                ProjectionRow(
                  label: '3 Months',
                  amount: projection3Months,
                  color: Colors.green,
                ),
                const Divider(),
                ProjectionRow(
                  label: '6 Months',
                  amount: projection6Months,
                  color: Colors.green,
                ),
                const Divider(),
                ProjectionRow(
                  label: '12 Months',
                  amount: projection12Months,
                  color: Colors.green,
                ),

                const SizedBox(height: 16),
                const Text(
                  'Breakdown:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Monthly recurring: \$${monthlyRecurring.toStringAsFixed(2)}/month',
                ),
                Text(
                  'Yearly recurring: \$${yearlyRecurring.toStringAsFixed(2)}/year',
                ),
                Text('One-time income: \$${oneTime.toStringAsFixed(2)}'),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading income')),
    );
  }
}

/// Card showing net profit/loss projection
class _NetProjectionCard extends ConsumerWidget {
  final AsyncValue<List<Expense>> expensesAsync;
  final AsyncValue<List<IncomeData>> incomeAsync;

  const _NetProjectionCard({
    required this.expensesAsync,
    required this.incomeAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculations = ref.watch(planningCalculationsProvider);

    return expensesAsync.when(
      data: (expenses) {
        return incomeAsync.when(
          data: (incomeList) {
            final result3 = calculations.calculateProjections(
              expenses: expenses,
              income: incomeList,
              months: 3,
            );
            final result6 = calculations.calculateProjections(
              expenses: expenses,
              income: incomeList,
              months: 6,
            );
            final result12 = calculations.calculateProjections(
              expenses: expenses,
              income: incomeList,
              months: 12,
            );

            return Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Net Profit/Loss Projection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ProjectionRow(
                      label: '3 Months',
                      amount: result3.netProfit,
                      color: result3.netProfit >= 0 ? Colors.green : Colors.red,
                      showSign: true,
                    ),
                    const Divider(),
                    ProjectionRow(
                      label: '6 Months',
                      amount: result6.netProfit,
                      color: result6.netProfit >= 0 ? Colors.green : Colors.red,
                      showSign: true,
                    ),
                    const Divider(),
                    ProjectionRow(
                      label: '12 Months',
                      amount: result12.netProfit,
                      color: result12.netProfit >= 0 ? Colors.green : Colors.red,
                      showSign: true,
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

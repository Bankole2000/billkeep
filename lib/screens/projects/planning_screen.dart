import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../providers/expense_provider.dart';
import '../../providers/income_provider.dart';
import '../../utils/currency_helper.dart';
import '../../widgets/projects/budget_form.dart';
import 'package:fl_chart/fl_chart.dart';

final planningSegmentProvider = StateProvider<int>((ref) => 0);

class PlanningScreen extends ConsumerWidget {
  final Project project;

  const PlanningScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSegment = ref.watch(planningSegmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${project.name} - Planning'),
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
                  label: Text('Budget'),
                  icon: Icon(Icons.account_balance),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('Projections'),
                  icon: Icon(Icons.trending_up),
                ),
                ButtonSegment(
                  value: 2,
                  label: Text('Analytics'),
                  icon: Icon(Icons.analytics),
                ),
              ],
              selected: {selectedSegment},
              onSelectionChanged: (Set<int> newSelection) {
                ref.read(planningSegmentProvider.notifier).state =
                    newSelection.first;
              },
            ),
          ),

          // Content based on segment
          Expanded(
            child: [
              _BudgetView(project: project),
              _ProjectionsView(project: project),
              _AnalyticsView(project: project),
            ][selectedSegment],
          ),
        ],
      ),
    );
  }
}

// Budget view placeholder
class _BudgetView extends ConsumerWidget {
  final Project project;

  const _BudgetView({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(projectExpensesProvider(project.id));
    final incomeAsync = ref.watch(projectIncomeProvider(project.id));

    // If no budget set
    if (project.budgetAmount == null) {
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

    // Budget exists - show tracking
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Budget summary card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Budget',
                      style: TextStyle(
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
                  CurrencyHelper.formatAmount(project.budgetAmount!),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  '${project.budgetType}${project.budgetFrequency != null ? " - ${project.budgetFrequency}" : ""}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Spending vs Budget
        expensesAsync.when(
          data: (expenses) {
            // Calculate total spending
            double totalSpent = 0;
            for (final expense in expenses.where((e) => e.isActive)) {
              totalSpent += expense.expectedAmount / 100;
            }

            final budget = project.budgetAmount! / 100;
            final remaining = budget - totalSpent;
            final percentUsed = (totalSpent / budget * 100).clamp(0, 100);

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
                                color: remaining < 0
                                    ? Colors.red
                                    : Colors.green,
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
        ),

        const SizedBox(height: 16),

        // Income vs Budget (for context)
        incomeAsync.when(
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
        ),
      ],
    );
  }
}

// Projections view placeholder
class _ProjectionsView extends ConsumerWidget {
  final Project project;

  const _ProjectionsView({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(projectExpensesProvider(project.id));
    final incomeAsync = ref.watch(projectIncomeProvider(project.id));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Time period selector
        Card(
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
        ),

        const SizedBox(height: 16),

        // Expenses projection
        expensesAsync.when(
          data: (expenses) {
            final monthlyRecurring = _calculateMonthlyRecurring(expenses);
            final yearlyRecurring = _calculateYearlyRecurring(expenses);
            final oneTime = _calculateOneTime(expenses);

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

                    _ProjectionRow(
                      label: '3 Months',
                      amount: projection3Months,
                      color: Colors.red,
                    ),
                    const Divider(),
                    _ProjectionRow(
                      label: '6 Months',
                      amount: projection6Months,
                      color: Colors.red,
                    ),
                    const Divider(),
                    _ProjectionRow(
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
        ),

        const SizedBox(height: 16),

        // Income projection
        incomeAsync.when(
          data: (incomeList) {
            final monthlyRecurring = _calculateMonthlyRecurringIncome(
              incomeList,
            );
            final yearlyRecurring = _calculateYearlyRecurringIncome(incomeList);
            final oneTime = _calculateOneTimeIncome(incomeList);

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

                    _ProjectionRow(
                      label: '3 Months',
                      amount: projection3Months,
                      color: Colors.green,
                    ),
                    const Divider(),
                    _ProjectionRow(
                      label: '6 Months',
                      amount: projection6Months,
                      color: Colors.green,
                    ),
                    const Divider(),
                    _ProjectionRow(
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
        ),

        const SizedBox(height: 16),

        // Net projection (Income - Expenses)
        expensesAsync.when(
          data: (expenses) {
            return incomeAsync.when(
              data: (incomeList) {
                final expenseMonthly = _calculateMonthlyRecurring(expenses);
                final expenseYearly = _calculateYearlyRecurring(expenses);
                final expenseOneTime = _calculateOneTime(expenses);

                final incomeMonthly = _calculateMonthlyRecurringIncome(
                  incomeList,
                );
                final incomeYearly = _calculateYearlyRecurringIncome(
                  incomeList,
                );
                final incomeOneTime = _calculateOneTimeIncome(incomeList);

                final netExpense3 =
                    (expenseMonthly * 3) +
                    (expenseYearly * 0.25) +
                    expenseOneTime;
                final netIncome3 =
                    (incomeMonthly * 3) + (incomeYearly * 0.25) + incomeOneTime;
                final net3 = netIncome3 - netExpense3;

                final netExpense6 =
                    (expenseMonthly * 6) +
                    (expenseYearly * 0.5) +
                    expenseOneTime;
                final netIncome6 =
                    (incomeMonthly * 6) + (incomeYearly * 0.5) + incomeOneTime;
                final net6 = netIncome6 - netExpense6;

                final netExpense12 =
                    (expenseMonthly * 12) + expenseYearly + expenseOneTime;
                final netIncome12 =
                    (incomeMonthly * 12) + incomeYearly + incomeOneTime;
                final net12 = netIncome12 - netExpense12;

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

                        _ProjectionRow(
                          label: '3 Months',
                          amount: net3,
                          color: net3 >= 0 ? Colors.green : Colors.red,
                          showSign: true,
                        ),
                        const Divider(),
                        _ProjectionRow(
                          label: '6 Months',
                          amount: net6,
                          color: net6 >= 0 ? Colors.green : Colors.red,
                          showSign: true,
                        ),
                        const Divider(),
                        _ProjectionRow(
                          label: '12 Months',
                          amount: net12,
                          color: net12 >= 0 ? Colors.green : Colors.red,
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
        ),
      ],
    );
  }

  // Helper methods for calculations
  double _calculateMonthlyRecurring(List<Expense> expenses) {
    return expenses
        .where(
          (e) =>
              e.type == 'RECURRING' && e.frequency == 'MONTHLY' && e.isActive,
        )
        .fold(0.0, (sum, e) => sum + (e.expectedAmount / 100));
  }

  double _calculateYearlyRecurring(List<Expense> expenses) {
    return expenses
        .where(
          (e) => e.type == 'RECURRING' && e.frequency == 'YEARLY' && e.isActive,
        )
        .fold(0.0, (sum, e) => sum + (e.expectedAmount / 100));
  }

  double _calculateOneTime(List<Expense> expenses) {
    return expenses
        .where((e) => e.type == 'ONE_TIME')
        .fold(0.0, (sum, e) => sum + (e.expectedAmount / 100));
  }

  double _calculateMonthlyRecurringIncome(List<IncomeData> incomeList) {
    return incomeList
        .where(
          (i) =>
              i.type == 'RECURRING' && i.frequency == 'MONTHLY' && i.isActive,
        )
        .fold(0.0, (sum, i) => sum + (i.expectedAmount / 100));
  }

  double _calculateYearlyRecurringIncome(List<IncomeData> incomeList) {
    return incomeList
        .where(
          (i) => i.type == 'RECURRING' && i.frequency == 'YEARLY' && i.isActive,
        )
        .fold(0.0, (sum, i) => sum + (i.expectedAmount / 100));
  }

  double _calculateOneTimeIncome(List<IncomeData> incomeList) {
    return incomeList
        .where((i) => i.type == 'ONE_TIME')
        .fold(0.0, (sum, i) => sum + (i.expectedAmount / 100));
  }
}

// Helper widget for projection rows
class _ProjectionRow extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool showSign;

  const _ProjectionRow({
    required this.label,
    required this.amount,
    required this.color,
    this.showSign = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          '${showSign && amount >= 0 ? "+" : ""}\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Analytics view placeholder

// ... existing imports ...

// Update _AnalyticsView class with charts:
class _AnalyticsView extends ConsumerWidget {
  final Project project;

  const _AnalyticsView({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(projectExpensesProvider(project.id));
    final incomeAsync = ref.watch(projectIncomeProvider(project.id));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overview summary (keep existing)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                expensesAsync.when(
                  data: (expenses) {
                    return incomeAsync.when(
                      data: (incomeList) {
                        final totalExpenses = expenses.fold<double>(
                          0,
                          (sum, e) => sum + (e.expectedAmount / 100),
                        );
                        final totalIncome = incomeList.fold<double>(
                          0,
                          (sum, i) => sum + (i.expectedAmount / 100),
                        );
                        final netProfit = totalIncome - totalExpenses;

                        return Column(
                          children: [
                            _AnalyticRow(
                              label: 'Total Expenses',
                              value: '\$${totalExpenses.toStringAsFixed(2)}',
                              color: Colors.red,
                            ),
                            const SizedBox(height: 8),
                            _AnalyticRow(
                              label: 'Total Income',
                              value: '\$${totalIncome.toStringAsFixed(2)}',
                              color: Colors.green,
                            ),
                            const Divider(height: 24),
                            _AnalyticRow(
                              label: 'Net Profit',
                              value: '\$${netProfit.toStringAsFixed(2)}',
                              color: netProfit >= 0 ? Colors.green : Colors.red,
                              isLarge: true,
                            ),
                          ],
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('Error loading income'),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) =>
                      const Center(child: Text('Error loading expenses')),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Income vs Expenses Bar Chart
        expensesAsync.when(
          data: (expenses) {
            return incomeAsync.when(
              data: (incomeList) {
                final totalExpenses = expenses.fold<double>(
                  0,
                  (sum, e) => sum + (e.expectedAmount / 100),
                );
                final totalIncome = incomeList.fold<double>(
                  0,
                  (sum, i) => sum + (i.expectedAmount / 100),
                );

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Income vs Expenses',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY:
                                  (totalIncome > totalExpenses
                                      ? totalIncome
                                      : totalExpenses) *
                                  1.2,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return const Text('Income');
                                        case 1:
                                          return const Text('Expenses');
                                        default:
                                          return const Text('');
                                      }
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return Text('\$${value.toInt()}');
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(show: true),
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      toY: totalIncome,
                                      color: Colors.green,
                                      width: 40,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      toY: totalExpenses,
                                      color: Colors.red,
                                      width: 40,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
        ),

        const SizedBox(height: 16),

        // Expense Type Pie Chart
        expensesAsync.when(
          data: (expenses) {
            final recurringAmount = expenses
                .where((e) => e.type == 'RECURRING' && e.isActive)
                .fold(0.0, (sum, e) => sum + (e.expectedAmount / 100));

            final oneTimeAmount = expenses
                .where((e) => e.type == 'ONE_TIME')
                .fold(0.0, (sum, e) => sum + (e.expectedAmount / 100));

            final totalAmount = recurringAmount + oneTimeAmount;

            if (totalAmount == 0) {
              return const SizedBox.shrink();
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expense Distribution',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.orange,
                              value: recurringAmount,
                              title:
                                  '${(recurringAmount / totalAmount * 100).toStringAsFixed(1)}%',
                              radius: 100,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              color: Colors.blue,
                              value: oneTimeAmount,
                              title:
                                  '${(oneTimeAmount / totalAmount * 100).toStringAsFixed(1)}%',
                              radius: 100,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LegendItem(
                          color: Colors.orange,
                          label:
                              'Recurring (\$${recurringAmount.toStringAsFixed(2)})',
                        ),
                        const SizedBox(width: 24),
                        _LegendItem(
                          color: Colors.blue,
                          label:
                              'One-time (\$${oneTimeAmount.toStringAsFixed(2)})',
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
        ),

        const SizedBox(height: 16),

        // Keep existing breakdown cards and health indicator
        expensesAsync.when(
          data: (expenses) {
            final recurring = expenses
                .where((e) => e.type == 'RECURRING' && e.isActive)
                .length;
            final oneTime = expenses.where((e) => e.type == 'ONE_TIME').length;
            final inactive = expenses.where((e) => !e.isActive).length;

            final monthlyRecurring = expenses
                .where(
                  (e) =>
                      e.type == 'RECURRING' &&
                      e.frequency == 'MONTHLY' &&
                      e.isActive,
                )
                .fold(0.0, (sum, e) => sum + (e.expectedAmount / 100));

            final yearlyRecurring = expenses
                .where(
                  (e) =>
                      e.type == 'RECURRING' &&
                      e.frequency == 'YEARLY' &&
                      e.isActive,
                )
                .fold(0.0, (sum, e) => sum + (e.expectedAmount / 100));

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expense Breakdown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatCard(
                          label: 'Recurring',
                          value: recurring.toString(),
                          color: Colors.orange,
                        ),
                        _StatCard(
                          label: 'One-time',
                          value: oneTime.toString(),
                          color: Colors.blue,
                        ),
                        _StatCard(
                          label: 'Inactive',
                          value: inactive.toString(),
                          color: Colors.grey,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),

                    _AnalyticRow(
                      label: 'Monthly Burn Rate',
                      value:
                          '\$${(monthlyRecurring + (yearlyRecurring / 12)).toStringAsFixed(2)}/mo',
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Error loading expenses')),
        ),

        const SizedBox(height: 16),

        // Project health indicator (keep existing)
        expensesAsync.when(
          data: (expenses) {
            return incomeAsync.when(
              data: (incomeList) {
                final monthlyExpenses = expenses
                    .where(
                      (e) =>
                          e.type == 'RECURRING' &&
                          e.frequency == 'MONTHLY' &&
                          e.isActive,
                    )
                    .fold(0.0, (sum, e) => sum + (e.expectedAmount / 100));

                final monthlyIncome = incomeList
                    .where(
                      (i) =>
                          i.type == 'RECURRING' &&
                          i.frequency == 'MONTHLY' &&
                          i.isActive,
                    )
                    .fold(0.0, (sum, i) => sum + (i.expectedAmount / 100));

                final monthlyNet = monthlyIncome - monthlyExpenses;
                final isHealthy = monthlyNet >= 0;

                return Card(
                  color: isHealthy ? Colors.green.shade50 : Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          isHealthy ? Icons.trending_up : Icons.trending_down,
                          size: 48,
                          color: isHealthy ? Colors.green : Colors.red,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isHealthy
                              ? 'Project is Profitable'
                              : 'Project Needs Attention',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isHealthy ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Monthly Net: \$${monthlyNet.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
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
        ),
      ],
    );
  }
}

// Add legend widget
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

// Helper widgets
class _AnalyticRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isLarge;

  const _AnalyticRow({
    required this.label,
    required this.value,
    this.color,
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
            fontSize: isLarge ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

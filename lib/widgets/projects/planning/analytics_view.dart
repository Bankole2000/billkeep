import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/income_provider.dart';
import 'statistic_widgets.dart';

/// Analytics view for project planning screen
class AnalyticsView extends ConsumerWidget {
  final Project project;

  const AnalyticsView({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(projectExpensesProvider(project.id));
    final incomeAsync = ref.watch(projectIncomeProvider(project.id));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overview summary
        _OverviewCard(expensesAsync: expensesAsync, incomeAsync: incomeAsync),
        const SizedBox(height: 16),

        // Income vs Expenses Bar Chart
        _IncomeVsExpensesChart(
          expensesAsync: expensesAsync,
          incomeAsync: incomeAsync,
        ),
        const SizedBox(height: 16),

        // Expense Type Pie Chart
        _ExpenseDistributionChart(expensesAsync: expensesAsync),
        const SizedBox(height: 16),

        // Expense breakdown card
        _ExpenseBreakdownCard(expensesAsync: expensesAsync),
        const SizedBox(height: 16),

        // Project health indicator
        _ProjectHealthCard(
          expensesAsync: expensesAsync,
          incomeAsync: incomeAsync,
        ),
      ],
    );
  }
}

/// Overview summary card
class _OverviewCard extends ConsumerWidget {
  final AsyncValue<List<Expense>> expensesAsync;
  final AsyncValue<List<IncomeData>> incomeAsync;

  const _OverviewCard({
    required this.expensesAsync,
    required this.incomeAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
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
                        AnalyticRow(
                          label: 'Total Expenses',
                          value: '\$${totalExpenses.toStringAsFixed(2)}',
                          color: Colors.red,
                        ),
                        const SizedBox(height: 8),
                        AnalyticRow(
                          label: 'Total Income',
                          value: '\$${totalIncome.toStringAsFixed(2)}',
                          color: Colors.green,
                        ),
                        const Divider(height: 24),
                        AnalyticRow(
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
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Error loading expenses')),
            ),
          ],
        ),
      ),
    );
  }
}

/// Income vs Expenses bar chart
class _IncomeVsExpensesChart extends ConsumerWidget {
  final AsyncValue<List<Expense>> expensesAsync;
  final AsyncValue<List<IncomeData>> incomeAsync;

  const _IncomeVsExpensesChart({
    required this.expensesAsync,
    required this.incomeAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return expensesAsync.when(
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
                          maxY: (totalIncome > totalExpenses
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
    );
  }
}

/// Expense distribution pie chart
class _ExpenseDistributionChart extends ConsumerWidget {
  final AsyncValue<List<Expense>> expensesAsync;

  const _ExpenseDistributionChart({required this.expensesAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return expensesAsync.when(
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
                    LegendItem(
                      color: Colors.orange,
                      label:
                          'Recurring (\$${recurringAmount.toStringAsFixed(2)})',
                    ),
                    const SizedBox(width: 24),
                    LegendItem(
                      color: Colors.blue,
                      label: 'One-time (\$${oneTimeAmount.toStringAsFixed(2)})',
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

/// Expense breakdown card
class _ExpenseBreakdownCard extends ConsumerWidget {
  final AsyncValue<List<Expense>> expensesAsync;

  const _ExpenseBreakdownCard({required this.expensesAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return expensesAsync.when(
      data: (expenses) {
        final recurring =
            expenses.where((e) => e.type == 'RECURRING' && e.isActive).length;
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
                    StatCard(
                      label: 'Recurring',
                      value: recurring.toString(),
                      color: Colors.orange,
                    ),
                    StatCard(
                      label: 'One-time',
                      value: oneTime.toString(),
                      color: Colors.blue,
                    ),
                    StatCard(
                      label: 'Inactive',
                      value: inactive.toString(),
                      color: Colors.grey,
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),

                AnalyticRow(
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
    );
  }
}

/// Project health indicator card
class _ProjectHealthCard extends ConsumerWidget {
  final AsyncValue<List<Expense>> expensesAsync;
  final AsyncValue<List<IncomeData>> incomeAsync;

  const _ProjectHealthCard({
    required this.expensesAsync,
    required this.incomeAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return expensesAsync.when(
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
    );
  }
}

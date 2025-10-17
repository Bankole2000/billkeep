import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../providers/recurring_expense_provider.dart';
import '../../utils/currency_helper.dart';
import 'package:intl/intl.dart';

class UpcomingPaymentsScreen extends ConsumerStatefulWidget {
  const UpcomingPaymentsScreen({super.key});

  @override
  ConsumerState<UpcomingPaymentsScreen> createState() =>
      _UpcomingPaymentsScreenState();
}

class _UpcomingPaymentsScreenState
    extends ConsumerState<UpcomingPaymentsScreen> {
  int _selectedDays = 7;
  bool _isProcessing = false;

  Future<void> _processRecurringPayments() async {
    setState(() => _isProcessing = true);

    try {
      final service = ref.read(recurringExpenseServiceProvider);

      // Process expenses
      final expensePayments = await service.processRecurringExpenses();

      // Process income
      final incomePayments = await service.processRecurringIncome();

      final totalCreated = expensePayments.length + incomePayments.length;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Created $totalCreated auto-payments'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh the data
        ref.invalidate(upcomingRenewalsProvider);
        ref.invalidate(upcomingIncomeProvider);
        ref.invalidate(autoPendingSummaryProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final upcomingExpenses = ref.watch(upcomingRenewalsProvider(_selectedDays));
    final upcomingIncome = ref.watch(upcomingIncomeProvider(_selectedDays));
    final pendingSummary = ref.watch(autoPendingSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Payments'),
        actions: [
          IconButton(
            icon: _isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isProcessing ? null : _processRecurringPayments,
            tooltip: 'Process Due Payments',
          ),
        ],
      ),
      body: Column(
        children: [
          // Time range selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const Text('Show payments due in:'),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: _selectedDays,
                  items: const [
                    DropdownMenuItem(value: 7, child: Text('7 days')),
                    DropdownMenuItem(value: 14, child: Text('14 days')),
                    DropdownMenuItem(value: 30, child: Text('30 days')),
                    DropdownMenuItem(value: 60, child: Text('60 days')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedDays = value!);
                  },
                ),
              ],
            ),
          ),

          // Auto-pending summary
          pendingSummary.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, stack) => const SizedBox.shrink(),
            data: (summary) {
              final expenseCount = summary['expenseCount'] as int;
              final incomeCount = summary['incomeCount'] as int;

              if (expenseCount == 0 && incomeCount == 0) {
                return const SizedBox.shrink();
              }

              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.pending_actions,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pending Auto-Payments',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (expenseCount > 0)
                      Text(
                        '$expenseCount expense payment(s) awaiting verification',
                      ),
                    if (incomeCount > 0)
                      Text(
                        '$incomeCount income payment(s) awaiting verification',
                      ),
                    const SizedBox(height: 8),
                    const Text(
                      'These were auto-created from recurring items. Please verify them.',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Upcoming Expenses
                upcomingExpenses.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text('Error: $error'),
                  data: (expenses) {
                    if (expenses.isEmpty) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No upcoming expenses in this period'),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upcoming Expenses (${expenses.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...expenses.map(
                          (expense) => _buildExpenseCard(expense),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Upcoming Income
                upcomingIncome.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text('Error: $error'),
                  data: (incomeList) {
                    if (incomeList.isEmpty) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No upcoming income in this period'),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upcoming Income (${incomeList.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...incomeList.map((income) => _buildIncomeCard(income)),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(Expense expense) {
    final daysUntil = expense.nextRenewalDate!
        .difference(DateTime.now())
        .inDays;
    final isOverdue = daysUntil < 0;
    final isDueToday = daysUntil == 0;

    Color cardColor = Colors.white;
    if (isOverdue)
      cardColor = Colors.red.shade50;
    else if (isDueToday)
      cardColor = Colors.orange.shade50;
    else if (daysUntil <= 3)
      cardColor = Colors.yellow.shade50;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOverdue ? Colors.red : Colors.orange,
          child: const Icon(Icons.arrow_upward, color: Colors.white),
        ),
        title: Text(
          expense.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CurrencyHelper.formatAmount(
                expense.expectedAmount,
                symbol: expense.currency,
              ),
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              _getDueDateText(expense.nextRenewalDate!),
              style: TextStyle(
                color: isOverdue ? Colors.red : Colors.grey,
                fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            expense.frequency ?? 'RECURRING',
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeCard(IncomeData income) {
    final daysUntil = income.nextExpectedDate!
        .difference(DateTime.now())
        .inDays;
    final isOverdue = daysUntil < 0;
    final isDueToday = daysUntil == 0;

    Color cardColor = Colors.white;
    if (isOverdue)
      cardColor = Colors.orange.shade50;
    else if (isDueToday)
      cardColor = Colors.green.shade50;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: const Icon(Icons.arrow_downward, color: Colors.white),
        ),
        title: Text(
          income.description,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CurrencyHelper.formatAmount(
                income.expectedAmount,
                symbol: income.currency,
              ),
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              _getDueDateText(income.nextExpectedDate!),
              style: TextStyle(color: isOverdue ? Colors.orange : Colors.grey),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(
            income.frequency ?? 'RECURRING',
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }

  String _getDueDateText(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return 'Overdue by ${-difference} day(s)';
    } else if (difference == 0) {
      return 'Due today!';
    } else if (difference == 1) {
      return 'Due tomorrow';
    } else {
      return 'Due in $difference days (${DateFormat('MMM dd').format(date)})';
    }
  }
}

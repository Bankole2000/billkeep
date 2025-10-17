import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../services/recurring_expense_service.dart';

// Provider for database
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Provider for recurring expense service
final recurringExpenseServiceProvider = Provider<RecurringExpenseService>((
  ref,
) {
  final database = ref.watch(databaseProvider);
  return RecurringExpenseService(database);
});

// Provider to trigger processing
final processRecurringExpensesProvider = FutureProvider<List<Payment>>((
  ref,
) async {
  final service = ref.watch(recurringExpenseServiceProvider);
  return await service.processRecurringExpenses();
});

// Provider for upcoming renewals
final upcomingRenewalsProvider = FutureProvider.family<List<Expense>, int>((
  ref,
  days,
) async {
  final service = ref.watch(recurringExpenseServiceProvider);
  return await service.getUpcomingRenewals(daysAhead: days);
});

// Provider for upcoming income
final upcomingIncomeProvider = FutureProvider.family<List<IncomeData>, int>((
  ref,
  days,
) async {
  final service = ref.watch(recurringExpenseServiceProvider);
  return await service.getUpcomingIncome(daysAhead: days);
});

// Provider for auto-pending summary
final autoPendingSummaryProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final service = ref.watch(recurringExpenseServiceProvider);
  return await service.getAutoPendingSummary();
});

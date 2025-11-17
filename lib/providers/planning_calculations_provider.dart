import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';

/// Provider for financial projection calculations
class PlanningCalculations {
  // Expense calculations
  double calculateMonthlyRecurring(List<Expense> expenses) {
    return expenses
        .where(
          (e) =>
              e.type == 'RECURRING' && e.frequency == 'MONTHLY' && e.isActive,
        )
        .fold(0.0, (sum, e) => sum + (e.expectedAmount / 100));
  }

  double calculateYearlyRecurring(List<Expense> expenses) {
    return expenses
        .where(
          (e) => e.type == 'RECURRING' && e.frequency == 'YEARLY' && e.isActive,
        )
        .fold(0.0, (sum, e) => sum + (e.expectedAmount / 100));
  }

  double calculateOneTime(List<Expense> expenses) {
    return expenses
        .where((e) => e.type == 'ONE_TIME')
        .fold(0.0, (sum, e) => sum + (e.expectedAmount / 100));
  }

  // Income calculations
  double calculateMonthlyRecurringIncome(List<IncomeData> incomeList) {
    return incomeList
        .where(
          (i) =>
              i.type == 'RECURRING' && i.frequency == 'MONTHLY' && i.isActive,
        )
        .fold(0.0, (sum, i) => sum + (i.expectedAmount / 100));
  }

  double calculateYearlyRecurringIncome(List<IncomeData> incomeList) {
    return incomeList
        .where(
          (i) => i.type == 'RECURRING' && i.frequency == 'YEARLY' && i.isActive,
        )
        .fold(0.0, (sum, i) => sum + (i.expectedAmount / 100));
  }

  double calculateOneTimeIncome(List<IncomeData> incomeList) {
    return incomeList
        .where((i) => i.type == 'ONE_TIME')
        .fold(0.0, (sum, i) => sum + (i.expectedAmount / 100));
  }

  // Projection calculations
  ProjectionResult calculateProjections({
    required List<Expense> expenses,
    required List<IncomeData> income,
    required int months,
  }) {
    final expenseMonthly = calculateMonthlyRecurring(expenses);
    final expenseYearly = calculateYearlyRecurring(expenses);
    final expenseOneTime = calculateOneTime(expenses);

    final incomeMonthly = calculateMonthlyRecurringIncome(income);
    final incomeYearly = calculateYearlyRecurringIncome(income);
    final incomeOneTime = calculateOneTimeIncome(income);

    final yearlyMultiplier = months / 12;

    final totalExpense = (expenseMonthly * months) +
        (expenseYearly * yearlyMultiplier) +
        expenseOneTime;
    final totalIncome = (incomeMonthly * months) +
        (incomeYearly * yearlyMultiplier) +
        incomeOneTime;

    return ProjectionResult(
      totalExpense: totalExpense,
      totalIncome: totalIncome,
      netProfit: totalIncome - totalExpense,
      monthlyExpense: expenseMonthly,
      yearlyExpense: expenseYearly,
      oneTimeExpense: expenseOneTime,
      monthlyIncome: incomeMonthly,
      yearlyIncome: incomeYearly,
      oneTimeIncome: incomeOneTime,
    );
  }
}

/// Result of projection calculations
class ProjectionResult {
  final double totalExpense;
  final double totalIncome;
  final double netProfit;
  final double monthlyExpense;
  final double yearlyExpense;
  final double oneTimeExpense;
  final double monthlyIncome;
  final double yearlyIncome;
  final double oneTimeIncome;

  ProjectionResult({
    required this.totalExpense,
    required this.totalIncome,
    required this.netProfit,
    required this.monthlyExpense,
    required this.yearlyExpense,
    required this.oneTimeExpense,
    required this.monthlyIncome,
    required this.yearlyIncome,
    required this.oneTimeIncome,
  });
}

/// Provider for planning calculations service
final planningCalculationsProvider = Provider<PlanningCalculations>((ref) {
  return PlanningCalculations();
});

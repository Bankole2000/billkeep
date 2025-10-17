import 'package:billkeep/utils/id_generator.dart';
import 'package:flutter/foundation.dart';
import '../database/database.dart';
import 'package:drift/drift.dart' as drift;

class RecurringExpenseService {
  final AppDatabase _database;

  RecurringExpenseService(this._database);

  /// Process all recurring expenses that are due
  Future<List<Payment>> processRecurringExpenses() async {
    final now = DateTime.now();
    final createdPayments = <Payment>[];

    try {
      // Get all active recurring expenses
      final recurringExpenses =
          await (_database.select(_database.expenses)
                ..where((e) => e.type.equals('RECURRING'))
                ..where((e) => e.isActive.equals(true)))
              .get();

      for (final expense in recurringExpenses) {
        if (expense.nextRenewalDate == null) continue;

        // Check if renewal date has passed
        if (expense.nextRenewalDate!.isBefore(now) ||
            _isSameDay(expense.nextRenewalDate!, now)) {
          // Create payment for this expense
          final payment = await _createPaymentForExpense(expense);
          createdPayments.add(payment);

          // Update next renewal date
          await _updateNextRenewalDate(expense);
        }
      }

      debugPrint('Processed ${createdPayments.length} recurring expenses');
      return createdPayments;
    } catch (e) {
      debugPrint('Error processing recurring expenses: $e');
      return createdPayments;
    }
  }

  /// Create a payment record for a recurring expense
  Future<Payment> _createPaymentForExpense(Expense expense) async {
    final paymentId = IdGenerator.tempPayment();

    await _database
        .into(_database.payments)
        .insert(
          PaymentsCompanion(
            id: drift.Value(paymentId),
            paymentType: const drift.Value('DEBIT'),
            expenseId: drift.Value(expense.id),
            actualAmount: drift.Value(expense.expectedAmount),
            currency: drift.Value(expense.currency),
            paymentDate: drift.Value(expense.nextRenewalDate ?? DateTime.now()),
            source: const drift.Value('AUTO'),
            verified: const drift.Value(
              false,
            ), // Mark as unverified for user review
            notes: const drift.Value('Auto-created from recurring expense'),
          ),
        );

    final payment = await (_database.select(
      _database.payments,
    )..where((p) => p.id.equals(paymentId))).getSingle();

    return payment;
  }

  /// Update the next renewal date based on frequency
  Future<void> _updateNextRenewalDate(Expense expense) async {
    if (expense.nextRenewalDate == null || expense.frequency == null) return;

    DateTime newRenewalDate;

    switch (expense.frequency) {
      case 'WEEKLY':
        newRenewalDate = expense.nextRenewalDate!.add(const Duration(days: 7));
        break;
      case 'MONTHLY':
        newRenewalDate = DateTime(
          expense.nextRenewalDate!.year,
          expense.nextRenewalDate!.month + 1,
          expense.nextRenewalDate!.day,
        );
        break;
      case 'QUARTERLY':
        newRenewalDate = DateTime(
          expense.nextRenewalDate!.year,
          expense.nextRenewalDate!.month + 3,
          expense.nextRenewalDate!.day,
        );
        break;
      case 'YEARLY':
        newRenewalDate = DateTime(
          expense.nextRenewalDate!.year + 1,
          expense.nextRenewalDate!.month,
          expense.nextRenewalDate!.day,
        );
        break;
      default:
        return;
    }

    await (_database.update(
      _database.expenses,
    )..where((e) => e.id.equals(expense.id))).write(
      ExpensesCompanion(
        nextRenewalDate: drift.Value(newRenewalDate),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  /// Check for upcoming renewals within the specified days
  Future<List<Expense>> getUpcomingRenewals({int daysAhead = 7}) async {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: daysAhead));

    final upcomingExpenses =
        await (_database.select(_database.expenses)
              ..where((e) => e.type.equals('RECURRING'))
              ..where((e) => e.isActive.equals(true))
              ..where(
                (e) => e.nextRenewalDate.isSmallerOrEqualValue(futureDate),
              )
              ..where((e) => e.nextRenewalDate.isBiggerOrEqualValue(now))
              ..orderBy([(e) => drift.OrderingTerm.asc(e.nextRenewalDate)]))
            .get();

    return upcomingExpenses;
  }

  /// Get upcoming income
  Future<List<IncomeData>> getUpcomingIncome({int daysAhead = 7}) async {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: daysAhead));

    final upcomingIncome =
        await (_database.select(_database.income)
              ..where((i) => i.type.equals('RECURRING'))
              ..where((i) => i.isActive.equals(true))
              ..where(
                (i) => i.nextExpectedDate.isSmallerOrEqualValue(futureDate),
              )
              ..where((i) => i.nextExpectedDate.isBiggerOrEqualValue(now))
              ..orderBy([(i) => drift.OrderingTerm.asc(i.nextExpectedDate)]))
            .get();

    return upcomingIncome;
  }

  /// Process recurring income (similar to expenses)
  Future<List<Payment>> processRecurringIncome() async {
    final now = DateTime.now();
    final createdPayments = <Payment>[];

    try {
      final recurringIncome =
          await (_database.select(_database.income)
                ..where((i) => i.type.equals('RECURRING'))
                ..where((i) => i.isActive.equals(true)))
              .get();

      for (final income in recurringIncome) {
        if (income.nextExpectedDate == null) continue;

        if (income.nextExpectedDate!.isBefore(now) ||
            _isSameDay(income.nextExpectedDate!, now)) {
          final payment = await _createPaymentForIncome(income);
          createdPayments.add(payment);
          await _updateNextIncomeDate(income);
        }
      }

      debugPrint('Processed ${createdPayments.length} recurring income');
      return createdPayments;
    } catch (e) {
      debugPrint('Error processing recurring income: $e');
      return createdPayments;
    }
  }

  Future<Payment> _createPaymentForIncome(IncomeData income) async {
    final paymentId = IdGenerator.tempPayment();

    await _database
        .into(_database.payments)
        .insert(
          PaymentsCompanion(
            id: drift.Value(paymentId),
            paymentType: const drift.Value('CREDIT'),
            incomeId: drift.Value(income.id),
            actualAmount: drift.Value(income.expectedAmount),
            currency: drift.Value(income.currency),
            paymentDate: drift.Value(income.nextExpectedDate ?? DateTime.now()),
            source: const drift.Value('AUTO'),
            verified: const drift.Value(false),
            notes: const drift.Value('Auto-created from recurring income'),
          ),
        );

    final payment = await (_database.select(
      _database.payments,
    )..where((p) => p.id.equals(paymentId))).getSingle();

    return payment;
  }

  Future<void> _updateNextIncomeDate(IncomeData income) async {
    if (income.nextExpectedDate == null || income.frequency == null) return;

    DateTime newDate;

    switch (income.frequency) {
      case 'WEEKLY':
        newDate = income.nextExpectedDate!.add(const Duration(days: 7));
        break;
      case 'MONTHLY':
        newDate = DateTime(
          income.nextExpectedDate!.year,
          income.nextExpectedDate!.month + 1,
          income.nextExpectedDate!.day,
        );
        break;
      case 'QUARTERLY':
        newDate = DateTime(
          income.nextExpectedDate!.year,
          income.nextExpectedDate!.month + 3,
          income.nextExpectedDate!.day,
        );
        break;
      case 'YEARLY':
        newDate = DateTime(
          income.nextExpectedDate!.year + 1,
          income.nextExpectedDate!.month,
          income.nextExpectedDate!.day,
        );
        break;
      default:
        return;
    }

    await (_database.update(
      _database.income,
    )..where((i) => i.id.equals(income.id))).write(
      IncomeCompanion(
        nextExpectedDate: drift.Value(newDate),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get summary of pending auto-created payments
  Future<Map<String, dynamic>> getAutoPendingSummary() async {
    final pendingPayments =
        await (_database.select(_database.payments)
              ..where((p) => p.source.equals('AUTO'))
              ..where((p) => p.verified.equals(false)))
            .get();

    int expenseCount = 0;
    int incomeCount = 0;
    int totalExpenseAmount = 0;
    int totalIncomeAmount = 0;

    for (final payment in pendingPayments) {
      if (payment.paymentType == 'DEBIT') {
        expenseCount++;
        totalExpenseAmount += payment.actualAmount;
      } else {
        incomeCount++;
        totalIncomeAmount += payment.actualAmount;
      }
    }

    return {
      'expenseCount': expenseCount,
      'incomeCount': incomeCount,
      'totalExpenseAmount': totalExpenseAmount,
      'totalIncomeAmount': totalIncomeAmount,
      'payments': pendingPayments,
    };
  }
}

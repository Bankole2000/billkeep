import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/expense_model.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/currency_helper.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:drift/drift.dart';

class ExpenseRepository {
  final AppDatabase _database;

  ExpenseRepository(this._database);

  /// Create a new expense using ExpenseModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final expense = ExpenseModel(
  ///   projectId: projectId,
  ///   name: 'Rent',
  ///   expectedAmount: 150000,
  ///   walletId: walletId,
  ///   categoryId: categoryId,
  ///   currency: 'USD',
  ///   startDate: DateTime.now(),
  ///   frequency: TransactionRecurrence.monthly,
  /// );
  /// final id = await repository.createExpense(expense, createInitialPayment: true);
  /// ```
  Future<String> createExpense(
    ExpenseModel newExpense, {
    bool createInitialPayment = true,
  }) async {
    final tempExpenseId = IdGenerator.tempExpense();

    try {
      // Create expense
      await _database.createExpense(
        newExpense.toCompanion(tempId: tempExpenseId),
      );

      // For one-time expenses, create the payment immediately
      if (createInitialPayment) {
        await _database.createPayment(
          PaymentsCompanion(
            id: Value(IdGenerator.tempPayment()),
            tempId: Value(IdGenerator.tempPayment()),
            paymentType: const Value('DEBIT'), // Expense = DEBIT
            expenseId: Value(tempExpenseId),
            currency: Value(newExpense.currency!),
            actualAmount: Value(newExpense.expectedAmount!),
            paymentDate: Value(newExpense.startDate!),
            source: const Value('MANUAL'),
            verified: const Value(true),
            isSynced: const Value(false),
          ),
        );
      }
    } catch (e) {
      print('Error creating expense: $e');
      rethrow;
    }

    return tempExpenseId;
  }

  Future<String> recordPayment({
    required String expenseId,
    required String actualAmount,
    required DateTime paymentDate,
    String source = 'MANUAL',
    bool verified = true,
    String? notes,
  }) async {
    final tempPaymentId = IdGenerator.tempPayment();

    await _database.createPayment(
      PaymentsCompanion(
        id: Value(tempPaymentId),
        tempId: Value(tempPaymentId),
        paymentType: const Value('DEBIT'),
        expenseId: Value(expenseId),
        actualAmount: Value(CurrencyHelper.dollarsToCents(actualAmount)),
        paymentDate: Value(paymentDate),
        source: Value(source),
        verified: Value(verified),
        notes: Value(notes),
        isSynced: const Value(false),
      ),
    );

    return tempPaymentId;
  }

  Stream<List<Expense>> watchProjectExpenses(String projectId) {
    return (_database.select(
      _database.expenses,
    )..where((e) => e.projectId.equals(projectId))).watch();
  }

  Stream<List<Payment>> watchExpensePayments(String expenseId) {
    return (_database.select(
      _database.payments,
    )..where((p) => p.expenseId.equals(expenseId))).watch();
  }

  Future<double> calculateMonthlyTotal(String projectId) async {
    final expenses =
        await (_database.select(_database.expenses)..where(
              (e) => e.projectId.equals(projectId) & e.isActive.equals(true),
            ))
            .get();

    double total = 0;
    for (final expense in expenses) {
      final amount =
          double.tryParse((expense.expectedAmount / 100).toString()) ?? 0;

      if (expense.type == 'ONE_TIME') {
        continue;
      } else if (expense.frequency == 'MONTHLY') {
        total += amount;
      } else if (expense.frequency == 'YEARLY') {
        total += amount / 12;
      }
    }

    return total;
  }

  // Calculate actual spend from payments
  Future<double> calculateActualSpend(
    String projectId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final expenses = await (_database.select(
      _database.expenses,
    )..where((e) => e.projectId.equals(projectId))).get();

    double total = 0;
    for (final expense in expenses) {
      var query = _database.select(_database.payments)
        ..where((p) => p.expenseId.equals(expense.id));

      if (startDate != null) {
        query = query
          ..where((p) => p.paymentDate.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query = query
          ..where((p) => p.paymentDate.isSmallerOrEqualValue(endDate));
      }

      final expensePayments = await query.get();
      for (final payment in expensePayments) {
        total += double.tryParse((payment.actualAmount / 100).toString()) ?? 0;
      }
    }

    return total;
  }

  /// Update expense using ExpenseModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final updated = currentExpense.copyWith(name: 'New Name', expectedAmount: 5000);
  /// await repository.updateExpense(updated);
  /// ```
  Future<String> updateExpense(ExpenseModel updatedExpense) async {
    if (updatedExpense.id == null) {
      throw ArgumentError('Cannot update expense without an ID');
    }

    try {
      await (_database.update(
        _database.expenses,
      )..where((e) => e.id.equals(updatedExpense.id!))).write(
        updatedExpense.toCompanion(isSynced: false, updatedAt: DateTime.now()),
      );
    } catch (e) {
      print('Error updating expense: $e');
      rethrow;
    }
    return updatedExpense.id!;
  }

  Future<void> deleteExpense(String expenseId) async {
    // Payments will be cascade deleted due to foreign key
    await (_database.delete(
      _database.expenses,
    )..where((e) => e.id.equals(expenseId))).go();
  }

  Future<void> toggleExpenseActive(String expenseId, bool isActive) async {
    await (_database.update(_database.expenses)
          ..where((e) => e.id.equals(expenseId)))
        .write(ExpensesCompanion(isActive: Value(isActive)));
  }

  Future<void> updatePayment({
    required String paymentId,
    required String actualAmount,
    required DateTime paymentDate,
    String? notes,
  }) async {
    await (_database.update(
      _database.payments,
    )..where((p) => p.id.equals(paymentId))).write(
      PaymentsCompanion(
        actualAmount: Value(CurrencyHelper.dollarsToCents(actualAmount)),
        paymentDate: Value(paymentDate),
        notes: Value(notes),
      ),
    );
  }

  Future<void> deletePayment(String paymentId) async {
    await (_database.delete(
      _database.payments,
    )..where((p) => p.id.equals(paymentId))).go();
  }
}

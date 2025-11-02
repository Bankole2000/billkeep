import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/date_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:billkeep/utils/currency_helper.dart';
import 'package:billkeep/providers/database_provider.dart';

final projectExpensesProvider = StreamProviderFamily<List<Expense>, String>((
  ref,
  projectId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.expenses,
  )..where((e) => e.projectId.equals(projectId))).watch();
});

final expensePaymentsProvider = StreamProviderFamily<List<Payment>, String>((
  ref,
  expenseId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.payments,
  )..where((p) => p.expenseId.equals(expenseId))).watch();
});

final expenseRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return ExpenseRepository(database);
});

class ExpenseRepository {
  final AppDatabase _database;

  ExpenseRepository(this._database);

  Future<String> createExpense({
    required String projectId,
    required String name,
    required String amount,
    required String walletId, // NEW: Wallet
    required String categoryId, // NEW: Category
    String? merchantId, // NEW: Merchant
    required String currency, // NEW: Currency
    required DateTime startDate, // For recurring expenses
    required TransactionRecurrence frequency,
    bool createInitialPayment = true,
    // required String type,
    String? notes,
    TransactionSource? source,
  }) async {
    final tempExpenseId = IdGenerator.tempExpense();
    final now = startDate;

    DateTime? nextRenewal;
    String type = 'ONE_TIME';
    if (frequency != TransactionRecurrence.never) {
      type = 'RECURRING';
      nextRenewal = frequency.calculateNextDueDate(startDate);
    }
    // if (type == 'RECURRING' && frequency != null) {
    //   if (frequency == 'MONTHLY') {
    //     nextRenewal = DateTime(now.year, now.month + 1, now.day);
    //   } else if (frequency == 'YEARLY') {
    //     nextRenewal = DateTime(now.year + 1, now.month, now.day);
    //   }
    // }
    // Create expense
    await _database.createExpense(
      ExpensesCompanion(
        id: Value(tempExpenseId),
        tempId: Value(tempExpenseId),
        projectId: Value(projectId),
        name: Value(name),
        currency: Value(currency),
        expectedAmount: Value(CurrencyHelper.dollarsToCents(amount)),
        type: Value(type),
        frequency: Value(frequency.name),
        startDate: Value(now),
        nextRenewalDate: Value(nextRenewal),
        categoryId: Value(categoryId),
        notes: Value(notes),
        isSynced: const Value(false),
      ),
    );

    // For one-time expenses, create the payment immediately
    if (createInitialPayment) {
      await _database.createPayment(
        PaymentsCompanion(
          id: Value(IdGenerator.tempPayment()),
          tempId: Value(IdGenerator.tempPayment()),
          paymentType: const Value('DEBIT'), // Expense = DEBIT
          expenseId: Value(tempExpenseId),
          currency: Value(currency),
          actualAmount: Value(CurrencyHelper.dollarsToCents(amount)),
          paymentDate: Value(now),
          source: const Value('MANUAL'),
          verified: const Value(true),
          isSynced: const Value(false),
        ),
      );
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

  Future<void> updateExpense({
    required String expenseId,
    required String name,
    required String amount,
    required String type,
    String? frequency,
    String? categoryId,
    String? notes,
  }) async {
    await (_database.update(
      _database.expenses,
    )..where((e) => e.id.equals(expenseId))).write(
      ExpensesCompanion(
        name: Value(name),
        expectedAmount: Value(CurrencyHelper.dollarsToCents(amount)),
        type: Value(type),
        frequency: Value(frequency),
        categoryId: Value(categoryId),
        notes: Value(notes),
      ),
    );
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

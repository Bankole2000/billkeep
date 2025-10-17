import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../utils/id_generator.dart';
import '../utils/currency_helper.dart';
import 'database_provider.dart';

final projectIncomeProvider = StreamProviderFamily<List<IncomeData>, String>((
  ref,
  projectId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.income,
  )..where((i) => i.projectId.equals(projectId))).watch();
});

final incomePaymentsProvider = StreamProviderFamily<List<Payment>, String>((
  ref,
  incomeId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.payments,
  )..where((p) => p.incomeId.equals(incomeId))).watch();
});

final incomeRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return IncomeRepository(database);
});

class IncomeRepository {
  final AppDatabase _database;

  IncomeRepository(this._database);

  Future<String> createIncome({
    required String projectId,
    required String description,
    required String amount,
    required String type, // 'ONE_TIME' or 'RECURRING'
    DateTime? startDate, // For recurring income
    String? frequency, // 'MONTHLY' or 'YEARLY'
    String? invoiceNumber,
    String? categoryId, // NEW: Category
    String? notes,
    bool createInitialPayment = true, // For one-time income
  }) async {
    final tempId = IdGenerator.tempIncome();
    final now = startDate ?? DateTime.now();

    DateTime? nextExpected;
    if (type == 'RECURRING' && frequency != null) {
      if (frequency == 'MONTHLY') {
        nextExpected = DateTime(now.year, now.month + 1, now.day);
      } else if (frequency == 'YEARLY') {
        nextExpected = DateTime(now.year + 1, now.month, now.day);
      }
    }

    // Create income record
    await _database
        .into(_database.income)
        .insert(
          IncomeCompanion(
            id: Value(tempId),
            tempId: Value(tempId),
            projectId: Value(projectId),
            description: Value(description),
            expectedAmount: Value(CurrencyHelper.dollarsToCents(amount)),
            type: Value(type),
            frequency: Value(frequency),
            startDate: Value(startDate ?? now),
            nextExpectedDate: Value(nextExpected),
            categoryId: Value(categoryId),
            invoiceNumber: Value(invoiceNumber),
            notes: Value(notes),
            isSynced: const Value(false),
          ),
        );

    // For one-time income, create the payment immediately if requested
    if (createInitialPayment) {
      await recordPayment(
        incomeId: tempId,
        actualAmount: amount,
        paymentDate: now,
      );
    }

    return tempId;
  }

  Future<String> recordPayment({
    required String incomeId,
    required String actualAmount,
    required DateTime paymentDate,
    String source = 'MANUAL',
    bool verified = true,
    String? notes,
  }) async {
    final tempPaymentId = IdGenerator.tempPayment();

    await _database
        .into(_database.payments)
        .insert(
          PaymentsCompanion(
            id: Value(tempPaymentId),
            tempId: Value(tempPaymentId),
            paymentType: const Value('CREDIT'), // Income = CREDIT
            incomeId: Value(incomeId),
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

  Stream<List<IncomeData>> watchProjectIncome(String projectId) {
    return (_database.select(
      _database.income,
    )..where((i) => i.projectId.equals(projectId))).watch();
  }

  Stream<List<Payment>> watchIncomePayments(String incomeId) {
    return (_database.select(
      _database.payments,
    )..where((p) => p.incomeId.equals(incomeId))).watch();
  }

  Future<double> calculateTotalIncome(String projectId) async {
    final incomeList = await (_database.select(
      _database.income,
    )..where((i) => i.projectId.equals(projectId))).get();

    return incomeList.fold<double>(
      0,
      (sum, income) => sum + (income.expectedAmount / 100),
    );
  }

  Future<void> updateIncome({
    required String incomeId,
    required String description,
    required String amount,
    required String type,
    String? frequency,
    String? invoiceNumber,
    String? categoryId,
    String? notes,
  }) async {
    await (_database.update(
      _database.income,
    )..where((i) => i.id.equals(incomeId))).write(
      IncomeCompanion(
        description: Value(description),
        expectedAmount: Value(CurrencyHelper.dollarsToCents(amount)),
        type: Value(type),
        frequency: Value(frequency),
        categoryId: Value(categoryId),
        invoiceNumber: Value(invoiceNumber),
        notes: Value(notes),
      ),
    );
  }

  Future<void> deleteIncome(String incomeId) async {
    // Payments will be cascade deleted due to foreign key
    await (_database.delete(
      _database.income,
    )..where((i) => i.id.equals(incomeId))).go();
  }

  Future<void> toggleIncomeActive(String incomeId, bool isActive) async {
    await (_database.update(_database.income)
          ..where((i) => i.id.equals(incomeId)))
        .write(IncomeCompanion(isActive: Value(isActive)));
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

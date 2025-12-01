import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

import '../models/income_model.dart';
import '../utils/currency_helper.dart';
import '../utils/id_generator.dart';

class IncomeRepository {
  final AppDatabase _database;

  IncomeRepository(this._database);

  /// Create a new income using IncomeModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final income = IncomeModel(
  ///   projectId: projectId,
  ///   description: 'Salary',
  ///   expectedAmount: 500000,
  ///   type: 'RECURRING',
  ///   frequency: 'MONTHLY',
  ///   startDate: DateTime.now(),
  /// );
  /// final id = await repository.createIncome(income, createInitialPayment: true);
  /// ```
  Future<String> createIncome(
    IncomeModel newIncome, {
    bool createInitialPayment = true,
  }) async {
    final tempId = IdGenerator.tempIncome();

    try {
      // Create income record
      await _database
          .into(_database.income)
          .insert(newIncome.toCompanion(tempId: tempId));

      // For one-time income, create the payment immediately if requested
      if (createInitialPayment) {
        await recordPayment(
          incomeId: tempId,
          actualAmount: (newIncome.expectedAmount! / 100).toStringAsFixed(2),
          paymentDate: newIncome.startDate!,
        );
      }
    } catch (e) {
      print('Error creating income: $e');
      rethrow;
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

  /// Update income using IncomeModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final updated = currentIncome.copyWith(description: 'Updated', expectedAmount: 10000);
  /// await repository.updateIncome(updated);
  /// ```
  Future<String> updateIncome(IncomeModel updatedIncome) async {
    if (updatedIncome.id == null) {
      throw ArgumentError('Cannot update income without an ID');
    }

    try {
      await (_database.update(
        _database.income,
      )..where((i) => i.id.equals(updatedIncome.id!))).write(
        updatedIncome.toCompanion(isSynced: false, updatedAt: DateTime.now()),
      );
    } catch (e) {
      print('Error updating income: $e');
      rethrow;
    }
    return updatedIncome.id!;
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

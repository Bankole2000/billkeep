import 'package:drift/drift.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/utils/exceptions.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:billkeep/services/expense_service.dart';
import 'base_sync_service.dart';

/// Synchronization service for Expenses
///
/// Handles bidirectional sync between local Drift database and remote API
class ExpenseSyncService extends BaseSyncService {
  final AppDatabase _database;
  final ExpenseService _apiService;

  ExpenseSyncService({
    required AppDatabase database,
    ExpenseService? apiService,
  }) : _database = database,
       _apiService = apiService ?? ExpenseService();

  @override
  Future<void> syncEntity(String tempId) async {
    // Check if already synced
    if (!IdGenerator.isTemporaryId(tempId)) {
      return; // Already has canonical ID
    }

    // Get the local expense
    final localExpense = await (_database.select(
      _database.expenses,
    )..where((e) => e.id.equals(tempId))).getSingleOrNull();

    if (localExpense == null) {
      throw NotFoundException(
        'Expense with temp ID $tempId not found',
        'The expense you are trying to sync does not exist',
      );
    }

    // Check if it's already synced
    if (localExpense.isSynced) {
      return;
    }

    // Send to API
    try {
      final apiExpense = await _apiService.createExpense(
        projectId: localExpense.projectId,
        name: localExpense.name,
        expectedAmount: localExpense.expectedAmount,
        currency: localExpense.currency,
        type: localExpense.type,
        frequency: localExpense.frequency,
        startDate: localExpense.startDate,
        nextRenewalDate: localExpense.nextRenewalDate,
        categoryId: localExpense.categoryId,
        merchantId: localExpense.merchantId,
        contactId: localExpense.contactId,
        walletId: localExpense.walletId,
        investmentId: localExpense.investmentId,
        goalId: localExpense.goalId,
        reminderId: localExpense.reminderId,
        source: localExpense.source,
        notes: localExpense.notes,
        isActive: localExpense.isActive,
      );

      // Update local database with canonical ID
      await _updateExpenseWithCanonicalId(
        tempId: tempId,
        canonicalId: apiExpense.id,
      );
    } on AppException catch (e) {
      throw SyncException(
        'Failed to sync expense: ${e.message}',
        e.getUserMessage(),
      );
    }
  }

  @override
  Future<List<String>> getUnsyncedEntityIds() async {
    final unsyncedExpenses = await (_database.select(
      _database.expenses,
    )..where((e) => e.isSynced.equals(false))).get();

    return unsyncedExpenses.map((e) => e.id).toList();
  }

  @override
  Future<void> pullFromServer({String? projectId}) async {
    try {
      // Fetch expenses from API
      final apiExpenses = await _apiService.getAllExpenses(
        projectId: projectId,
      );

      // For each API expense, update or insert in local database
      for (final apiExpense in apiExpenses) {
        final existingExpense = await (_database.select(
          _database.expenses,
        )..where((e) => e.id.equals(apiExpense.id))).getSingleOrNull();

        if (existingExpense != null) {
          // Update existing
          await (_database.update(
            _database.expenses,
          )..where((e) => e.id.equals(apiExpense.id))).write(
            ExpensesCompanion(
              name: Value(apiExpense.name),
              expectedAmount: Value(apiExpense.expectedAmount),
              currency: Value(apiExpense.currency),
              type: Value(apiExpense.type),
              frequency: Value(apiExpense.frequency),
              startDate: Value(apiExpense.startDate),
              nextRenewalDate: Value(apiExpense.nextRenewalDate),
              categoryId: Value(apiExpense.categoryId),
              merchantId: Value(apiExpense.merchantId),
              notes: Value(apiExpense.notes),
              isActive: Value(apiExpense.isActive),
              isSynced: const Value(true),
            ),
          );
        } else {
          // Insert new
          await _database
              .into(_database.expenses)
              .insert(
                ExpensesCompanion(
                  id: Value(apiExpense.id),
                  projectId: Value(apiExpense.projectId),
                  name: Value(apiExpense.name),
                  expectedAmount: Value(apiExpense.expectedAmount),
                  currency: Value(apiExpense.currency),
                  type: Value(apiExpense.type),
                  frequency: Value(apiExpense.frequency),
                  startDate: Value(apiExpense.startDate),
                  nextRenewalDate: Value(apiExpense.nextRenewalDate),
                  categoryId: Value(apiExpense.categoryId),
                  merchantId: Value(apiExpense.merchantId),
                  notes: Value(apiExpense.notes),
                  isActive: Value(apiExpense.isActive),
                  isSynced: const Value(true),
                ),
              );
        }
      }
    } on AppException catch (e) {
      throw SyncException(
        'Failed to pull expenses from server: ${e.message}',
        e.getUserMessage(),
      );
    }
  }

  /// Perform bidirectional sync for a specific project
  Future<SyncResult> syncProjectExpenses(String projectId) async {
    if (!await isOnline()) {
      return SyncResult.failure('No internet connection');
    }

    try {
      // Get unsynced expenses for this project
      final unsyncedExpenses =
          await (_database.select(_database.expenses)..where(
                (e) => e.projectId.equals(projectId) & e.isSynced.equals(false),
              ))
              .get();

      int successCount = 0;
      int failureCount = 0;
      final errors = <String, String>{};

      // Push unsynced expenses
      for (final expense in unsyncedExpenses) {
        try {
          await syncEntity(expense.id);
          successCount++;
        } catch (e) {
          failureCount++;
          errors[expense.id] = e.toString();
        }
      }

      // Pull latest from server
      await pullFromServer(projectId: projectId);

      if (failureCount == 0) {
        return SyncResult.success(successCount);
      } else {
        return SyncResult.partial(successCount, failureCount, errors);
      }
    } catch (e) {
      return SyncResult.failure(e.toString());
    }
  }

  /// Update expense with canonical ID after successful sync
  Future<void> _updateExpenseWithCanonicalId({
    required String tempId,
    required String canonicalId,
  }) async {
    // Map the IDs
    await _database.mapId(
      tempId: tempId,
      canonicalId: canonicalId,
      resourceType: 'expense',
    );

    // Update expense with canonical ID
    await (_database.update(
      _database.expenses,
    )..where((e) => e.id.equals(tempId))).write(
      ExpensesCompanion(id: Value(canonicalId), isSynced: const Value(true)),
    );
  }

  /// Delete an expense both locally and on server
  Future<void> deleteExpense(String expenseId) async {
    // Delete from server if it's a canonical ID
    if (!IdGenerator.isTemporaryId(expenseId) && await isOnline()) {
      try {
        await _apiService.deleteExpense(expenseId);
      } on AppException catch (e) {
        throw SyncException(
          'Failed to delete expense from server: ${e.message}',
          e.getUserMessage(),
        );
      }
    }

    // Delete from local database
    await (_database.delete(
      _database.expenses,
    )..where((e) => e.id.equals(expenseId))).go();
  }
}

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/expense_model.dart';
import 'package:billkeep/services/api_client.dart';
import 'package:billkeep/utils/exceptions.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'base_sync_service.dart';

/// Synchronization service for Expenses
///
/// Handles bidirectional sync between local Drift database and remote API
/// Makes DIRECT API calls (not through ExpenseService) to avoid double-writing
class ExpenseSyncService extends BaseSyncService {
  final AppDatabase _database;
  final Dio _dio;

  ExpenseSyncService({required AppDatabase database, Dio? dio})
    : _database = database,
      _dio = dio ?? ApiClient().dio;

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

    // Send to API directly (not through ExpenseService to avoid double-writing)
    try {
      final response = await _dio.post(
        '/expenses/records',
        data: {
          'projectId': localExpense.projectId,
          'name': localExpense.name,
          'expectedAmount': localExpense.expectedAmount,
          'currency': localExpense.currency,
          'type': localExpense.type,
          'frequency': localExpense.frequency,
          'startDate': localExpense.startDate.toIso8601String(),
          'nextRenewalDate': localExpense.nextRenewalDate?.toIso8601String(),
          'categoryId': localExpense.categoryId,
          'merchantId': localExpense.merchantId,
          'contactId': localExpense.contactId,
          'walletId': localExpense.walletId,
          'investmentId': localExpense.investmentId,
          'goalId': localExpense.goalId,
          'reminderId': localExpense.reminderId,
          'source': localExpense.source,
          'notes': localExpense.notes,
          'isActive': localExpense.isActive,
        },
      );

      final apiExpense = ExpenseModel.fromJson(response.data);

      // Update local database with canonical ID
      await _updateExpenseWithCanonicalId(
        tempId: tempId,
        canonicalId: apiExpense.id!,
      );
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      throw SyncException(
        'Failed to sync expense: $message',
        'Unable to sync expense. Will retry later.',
      );
    } catch (e) {
      throw SyncException(
        'Failed to sync expense: ${e.toString()}',
        'Unable to sync expense. Will retry later.',
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
      // Fetch expenses from API directly
      final queryParams = projectId != null ? {'projectId': projectId} : null;
      final response = await _dio.get(
        '/expenses/records',
        queryParameters: queryParams,
      );

      List<ExpenseModel> apiExpenses;
      if (response.data is List) {
        apiExpenses = (response.data as List)
            .map((item) => ExpenseModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.data is Map && response.data['items'] != null) {
        apiExpenses = (response.data['items'] as List)
            .map((item) => ExpenseModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        apiExpenses = [];
      }

      // For each API expense, update or insert in local database
      for (final apiExpense in apiExpenses) {
        final existingExpense = await (_database.select(
          _database.expenses,
        )..where((e) => e.id.equals(apiExpense.id!))).getSingleOrNull();

        if (existingExpense != null) {
          // Update existing
          await (_database.update(
            _database.expenses,
          )..where((e) => e.id.equals(apiExpense.id!))).write(
            ExpensesCompanion(
              name: Value(apiExpense.name!),
              expectedAmount: Value(apiExpense.expectedAmount!),
              currency: Value(apiExpense.currency!),
              type: Value(apiExpense.type!),
              frequency: Value(apiExpense.frequency),
              startDate: Value(apiExpense.startDate!),
              nextRenewalDate: Value(apiExpense.nextRenewalDate),
              // categoryId: Value(apiExpense.categoryId!),
              // merchantId: Value(apiExpense.merchantId!),
              notes: Value(apiExpense.notes),
              isActive: Value(apiExpense.isActive!),
              isSynced: const Value(true),
            ),
          );
        } else {
          // Insert new
          await _database
              .into(_database.expenses)
              .insert(
                ExpensesCompanion(
                  id: Value(apiExpense.id!),
                  // projectId: Value(apiExpense.projectId!),
                  name: Value(apiExpense.name!),
                  expectedAmount: Value(apiExpense.expectedAmount!),
                  currency: Value(apiExpense.currency!),
                  type: Value(apiExpense.type!),
                  frequency: Value(apiExpense.frequency!),
                  startDate: Value(apiExpense.startDate!),
                  nextRenewalDate: Value(apiExpense.nextRenewalDate!),
                  // categoryId: Value(apiExpense.categoryId!),
                  // merchantId: Value(apiExpense.merchantId!),
                  notes: Value(apiExpense.notes!),
                  isActive: Value(apiExpense.isActive!),
                  isSynced: const Value(true),
                ),
              );
        }
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      throw SyncException(
        'Failed to pull expenses from server: $message',
        'Unable to fetch expenses from server.',
      );
    } catch (e) {
      throw SyncException(
        'Failed to pull expenses from server: ${e.toString()}',
        'Unable to fetch expenses from server.',
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
        await _dio.delete('/expenses/records/$expenseId');
      } on DioException catch (e) {
        final message =
            e.response?.data?['message'] ?? e.message ?? 'Unknown error';
        throw SyncException(
          'Failed to delete expense from server: $message',
          'Unable to delete expense from server.',
        );
      }
    }

    // Delete from local database
    await (_database.delete(
      _database.expenses,
    )..where((e) => e.id.equals(expenseId))).go();
  }
}

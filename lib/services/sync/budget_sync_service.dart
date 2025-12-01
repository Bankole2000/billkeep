import 'package:billkeep/repositories/budget_repository.dart';
import 'package:dio/dio.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/budget_provider.dart';
import 'package:billkeep/services/api_client.dart';
import 'package:billkeep/utils/exceptions.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'base_sync_service.dart';

/// Synchronization service for Budgets
///
/// Handles bidirectional sync between local Drift database and remote API
/// Makes DIRECT API calls (not through BudgetService) to avoid double-writing
///
/// NOTE: This is a template. Adjust field mappings based on your Budget model.
class BudgetSyncService extends BaseSyncService {
  final AppDatabase _database;
  final BudgetRepository _repository;
  final Dio _dio;

  BudgetSyncService({
    required AppDatabase database,
    required BudgetRepository repository,
    Dio? dio,
  }) : _database = database,
       _repository = repository,
       _dio = dio ?? ApiClient().dio;

  @override
  Future<void> syncEntity(String tempId) async {
    if (!IdGenerator.isTemporaryId(tempId)) {
      return;
    }

    // TODO: Implement budget sync
    // 1. Get local budget from database
    // 2. Send to API via _dio.post('/budgets/records', data: {...})
    // 3. Update local with canonical ID

    throw UnimplementedError(
      'Budget sync not yet implemented - adjust field mappings',
    );
  }

  @override
  Future<List<String>> getUnsyncedEntityIds() async {
    // TODO: Query database for unsynced budgets
    // return (_database.select(_database.budgets)
    //   ..where((b) => b.isSynced.equals(false))).get()
    //   .then((budgets) => budgets.map((b) => b.id).toList());

    return [];
  }

  @override
  Future<void> pullFromServer() async {
    // TODO: Implement pull from server
    // 1. Fetch from API via _dio.get('/budgets/records')
    // 2. Update/insert in local database

    throw UnimplementedError(
      'Budget pull not yet implemented - adjust field mappings',
    );
  }
}

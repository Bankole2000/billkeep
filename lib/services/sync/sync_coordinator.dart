import 'package:dio/dio.dart';
import '../../database/database.dart';
import '../../providers/project_provider.dart';
import '../../services/api_client.dart';
import 'project_sync_service.dart';
import 'expense_sync_service.dart';
import 'base_sync_service.dart';

/// Master coordinator for all sync operations
///
/// This class orchestrates syncing across all entity types and provides
/// a single entry point for sync operations throughout the app
class SyncCoordinator {
  final AppDatabase _database;
  final ProjectRepository _projectRepository;
  final Dio _dio;
  late final ProjectSyncService projectSync;
  late final ExpenseSyncService expenseSync;

  SyncCoordinator({
    required AppDatabase database,
    required ProjectRepository projectRepository,
    Dio? dio,
  })  : _database = database,
        _projectRepository = projectRepository,
        _dio = dio ?? ApiClient().dio {
    projectSync = ProjectSyncService(
      database: _database,
      repository: _projectRepository,
      dio: _dio,
    );
    expenseSync = ExpenseSyncService(database: _database);
  }

  /// Sync all entities across the entire app
  ///
  /// This performs a complete bidirectional sync of all data:
  /// 1. Projects
  /// 2. Expenses
  /// 3. Other entities (can be added)
  ///
  /// Returns an aggregated result of all sync operations
  Future<AggregatedSyncResult> syncAll() async {
    final results = <String, SyncResult>{};

    // Sync projects first (parent entities)
    results['projects'] = await projectSync.performFullSync();

    // Sync expenses
    results['expenses'] = await expenseSync.syncAll();

    // TODO: Add more entity syncs here
    // results['incomes'] = await incomeSync.syncAll();
    // results['payments'] = await paymentSync.syncAll();
    // etc.

    return AggregatedSyncResult(results);
  }

  /// Sync only a specific project and its related data
  ///
  /// This is useful for syncing a single project's data without
  /// syncing the entire app
  Future<AggregatedSyncResult> syncProject(String projectId) async {
    final results = <String, SyncResult>{};

    // Sync the project itself
    try {
      await projectSync.syncEntity(projectId);
      results['project'] = SyncResult.success(1);
    } catch (e) {
      results['project'] = SyncResult.failure(e.toString());
    }

    // Sync project's expenses
    results['expenses'] = await expenseSync.syncProjectExpenses(projectId);

    // TODO: Add more related entity syncs
    // results['incomes'] = await incomeSync.syncProjectIncomes(projectId);
    // etc.

    return AggregatedSyncResult(results);
  }

  /// Pull all data from server (refresh)
  ///
  /// This fetches the latest data from the server and updates the local database
  /// Useful for manual refresh or when app comes online
  Future<void> pullAllFromServer() async {
    await projectSync.pullFromServer();
    // await expenseSync.pullFromServer(); // Note: might need project filter
    // TODO: Add more pulls
  }

  /// Push all unsynced local changes to server
  ///
  /// This syncs all local changes that haven't been sent to the server yet
  /// Useful for background sync or when connection is restored
  Future<AggregatedSyncResult> pushAllToServer() async {
    final results = <String, SyncResult>{};

    results['projects'] = await projectSync.syncAll();
    results['expenses'] = await expenseSync.syncAll();
    // TODO: Add more pushes

    return AggregatedSyncResult(results);
  }

  /// Check if there are any unsynced changes
  Future<bool> hasUnsyncedChanges() async {
    final projectIds = await projectSync.getUnsyncedEntityIds();
    final expenseIds = await expenseSync.getUnsyncedEntityIds();

    return projectIds.isNotEmpty || expenseIds.isNotEmpty;
  }

  /// Get count of unsynced entities by type
  Future<Map<String, int>> getUnsyncedCounts() async {
    final projectIds = await projectSync.getUnsyncedEntityIds();
    final expenseIds = await expenseSync.getUnsyncedEntityIds();

    return {
      'projects': projectIds.length,
      'expenses': expenseIds.length,
    };
  }
}

/// Aggregated result from multiple sync operations
class AggregatedSyncResult {
  final Map<String, SyncResult> results;

  AggregatedSyncResult(this.results);

  /// Check if all syncs were successful
  bool get isFullSuccess => results.values.every((r) => r.isSuccess);

  /// Check if any sync failed completely
  bool get hasFailures => results.values.any((r) => r.isFailure);

  /// Check if there were any partial successes
  bool get hasPartialSync => results.values.any((r) => r.isPartial);

  /// Get total number of successfully synced items
  int get totalSuccessCount =>
      results.values.fold(0, (sum, r) => sum + r.successCount);

  /// Get total number of failed items
  int get totalFailureCount =>
      results.values.fold(0, (sum, r) => sum + r.failureCount);

  /// Get a summary message
  String get summary {
    if (isFullSuccess) {
      return 'All synced successfully ($totalSuccessCount items)';
    } else if (hasFailures) {
      return 'Sync completed with errors: $totalSuccessCount succeeded, $totalFailureCount failed';
    } else {
      return 'Sync in progress';
    }
  }

  /// Get detailed breakdown by entity type
  String get detailedSummary {
    final buffer = StringBuffer();
    buffer.writeln('Sync Results:');
    for (final entry in results.entries) {
      buffer.writeln('  ${entry.key}: ${entry.value}');
    }
    return buffer.toString();
  }

  @override
  String toString() => summary;
}

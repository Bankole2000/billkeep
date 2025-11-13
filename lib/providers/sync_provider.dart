import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync/sync_coordinator.dart';
import 'database_provider.dart';

/// Provider for the sync coordinator
final syncCoordinatorProvider = Provider<SyncCoordinator>((ref) {
  final database = ref.watch(databaseProvider);
  return SyncCoordinator(database);
});

/// Provider to track unsynced changes count
final unsyncedCountsProvider = FutureProvider<Map<String, int>>((ref) async {
  final coordinator = ref.watch(syncCoordinatorProvider);
  return await coordinator.getUnsyncedCounts();
});

/// Provider to check if there are any unsynced changes
final hasUnsyncedChangesProvider = FutureProvider<bool>((ref) async {
  final coordinator = ref.watch(syncCoordinatorProvider);
  return await coordinator.hasUnsyncedChanges();
});

/// State notifier for managing sync state
class SyncStateNotifier extends StateNotifier<SyncState> {
  final SyncCoordinator _coordinator;

  SyncStateNotifier(this._coordinator) : super(const SyncState.idle());

  /// Perform a full sync of all data
  Future<void> syncAll() async {
    state = const SyncState.syncing();

    try {
      final result = await _coordinator.syncAll();

      if (result.isFullSuccess) {
        state = SyncState.success(
          message: result.summary,
          timestamp: DateTime.now(),
        );
      } else if (result.hasFailures) {
        state = SyncState.error(
          message: result.summary,
          details: result.detailedSummary,
        );
      } else {
        state = SyncState.partial(
          message: result.summary,
          successCount: result.totalSuccessCount,
          failureCount: result.totalFailureCount,
        );
      }
    } catch (e) {
      state = SyncState.error(
        message: 'Sync failed',
        details: e.toString(),
      );
    }
  }

  /// Sync a specific project
  Future<void> syncProject(String projectId) async {
    state = const SyncState.syncing();

    try {
      final result = await _coordinator.syncProject(projectId);

      if (result.isFullSuccess) {
        state = SyncState.success(
          message: 'Project synced successfully',
          timestamp: DateTime.now(),
        );
      } else {
        state = SyncState.error(
          message: 'Project sync failed',
          details: result.detailedSummary,
        );
      }
    } catch (e) {
      state = SyncState.error(
        message: 'Project sync failed',
        details: e.toString(),
      );
    }
  }

  /// Pull latest data from server
  Future<void> refresh() async {
    state = const SyncState.syncing();

    try {
      await _coordinator.pullAllFromServer();
      state = SyncState.success(
        message: 'Data refreshed successfully',
        timestamp: DateTime.now(),
      );
    } catch (e) {
      state = SyncState.error(
        message: 'Refresh failed',
        details: e.toString(),
      );
    }
  }

  /// Push unsynced changes to server
  Future<void> pushChanges() async {
    state = const SyncState.syncing();

    try {
      final result = await _coordinator.pushAllToServer();

      if (result.isFullSuccess) {
        state = SyncState.success(
          message: 'Changes pushed successfully',
          timestamp: DateTime.now(),
        );
      } else {
        state = SyncState.error(
          message: 'Push failed',
          details: result.detailedSummary,
        );
      }
    } catch (e) {
      state = SyncState.error(
        message: 'Push failed',
        details: e.toString(),
      );
    }
  }

  /// Reset sync state to idle
  void reset() {
    state = const SyncState.idle();
  }
}

/// Provider for sync state management
final syncStateProvider =
    StateNotifierProvider<SyncStateNotifier, SyncState>((ref) {
  final coordinator = ref.watch(syncCoordinatorProvider);
  return SyncStateNotifier(coordinator);
});

/// Sync state representation
class SyncState {
  final SyncStatus status;
  final String? message;
  final String? details;
  final DateTime? timestamp;
  final int successCount;
  final int failureCount;

  const SyncState({
    required this.status,
    this.message,
    this.details,
    this.timestamp,
    this.successCount = 0,
    this.failureCount = 0,
  });

  const SyncState.idle()
      : status = SyncStatus.idle,
        message = null,
        details = null,
        timestamp = null,
        successCount = 0,
        failureCount = 0;

  const SyncState.syncing()
      : status = SyncStatus.syncing,
        message = 'Syncing...',
        details = null,
        timestamp = null,
        successCount = 0,
        failureCount = 0;

  const SyncState.success({
    required String message,
    required DateTime timestamp,
  })  : status = SyncStatus.success,
        message = message,
        details = null,
        timestamp = timestamp,
        successCount = 0,
        failureCount = 0;

  const SyncState.error({
    required String message,
    String? details,
  })  : status = SyncStatus.error,
        message = message,
        details = details,
        timestamp = null,
        successCount = 0,
        failureCount = 0;

  const SyncState.partial({
    required String message,
    required int successCount,
    required int failureCount,
  })  : status = SyncStatus.partial,
        message = message,
        details = null,
        timestamp = null,
        successCount = successCount,
        failureCount = failureCount;

  bool get isIdle => status == SyncStatus.idle;
  bool get isSyncing => status == SyncStatus.syncing;
  bool get isSuccess => status == SyncStatus.success;
  bool get isError => status == SyncStatus.error;
  bool get isPartial => status == SyncStatus.partial;
}

enum SyncStatus {
  idle,
  syncing,
  success,
  error,
  partial,
}

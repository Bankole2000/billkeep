import '../../utils/exceptions.dart';

/// Base class for synchronization services
///
/// Handles the coordination between local database (offline-first) and remote API
/// Each entity should have its own sync service extending this base class
abstract class BaseSyncService {
  /// Sync a single unsynced entity to the server
  ///
  /// This method should:
  /// 1. Get the local entity by temp ID
  /// 2. Transform it to API format
  /// 3. Send to server
  /// 4. Update local entity with canonical ID
  /// 5. Mark as synced
  Future<void> syncEntity(String tempId);

  /// Sync all unsynced entities of this type
  ///
  /// Called during app startup or manual sync
  Future<SyncResult> syncAll() async {
    try {
      final unsyncedIds = await getUnsyncedEntityIds();

      if (unsyncedIds.isEmpty) {
        return SyncResult.success(0);
      }

      int successCount = 0;
      int failureCount = 0;
      final errors = <String, String>{};

      for (final id in unsyncedIds) {
        try {
          await syncEntity(id);
          successCount++;
        } catch (e) {
          failureCount++;
          errors[id] = e.toString();
        }
      }

      if (failureCount == 0) {
        return SyncResult.success(successCount);
      } else {
        return SyncResult.partial(successCount, failureCount, errors);
      }
    } catch (e) {
      return SyncResult.failure(e.toString());
    }
  }

  /// Pull latest data from server and update local database
  ///
  /// This is the opposite of syncAll - it fetches from server and updates local
  Future<void> pullFromServer();

  /// Get list of temp IDs that need to be synced
  Future<List<String>> getUnsyncedEntityIds();

  /// Check if device is online
  Future<bool> isOnline() async {
    // TODO: Implement proper connectivity check
    // For now, always return true
    return true;
  }
}

/// Result of a sync operation
class SyncResult {
  final SyncStatus status;
  final int successCount;
  final int failureCount;
  final String? errorMessage;
  final Map<String, String>? entityErrors;

  SyncResult._({
    required this.status,
    this.successCount = 0,
    this.failureCount = 0,
    this.errorMessage,
    this.entityErrors,
  });

  factory SyncResult.success(int count) {
    return SyncResult._(
      status: SyncStatus.success,
      successCount: count,
    );
  }

  factory SyncResult.partial(
    int successCount,
    int failureCount,
    Map<String, String> errors,
  ) {
    return SyncResult._(
      status: SyncStatus.partial,
      successCount: successCount,
      failureCount: failureCount,
      entityErrors: errors,
    );
  }

  factory SyncResult.failure(String error) {
    return SyncResult._(
      status: SyncStatus.failure,
      errorMessage: error,
    );
  }

  bool get isSuccess => status == SyncStatus.success;
  bool get isPartial => status == SyncStatus.partial;
  bool get isFailure => status == SyncStatus.failure;
  bool get hasErrors => isPartial || isFailure;

  @override
  String toString() {
    switch (status) {
      case SyncStatus.success:
        return 'Sync successful: $successCount items synced';
      case SyncStatus.partial:
        return 'Partial sync: $successCount succeeded, $failureCount failed';
      case SyncStatus.failure:
        return 'Sync failed: $errorMessage';
    }
  }
}

enum SyncStatus {
  success,
  partial,
  failure,
}

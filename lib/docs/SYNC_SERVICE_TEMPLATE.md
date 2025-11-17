# Sync Service Template

This document provides templates for creating sync services for new entities.

---

## When to Create a Sync Service

Create a sync service for any entity that:
1. Needs to be available offline
2. Should sync with the backend when online
3. Requires conflict resolution between devices

---

## Files Needed

For each entity (e.g., `Todo`), you need:

1. **Service** - `lib/services/todo_service.dart` (handles local + API)
2. **Repository** - `lib/providers/todo_provider.dart` (handles Drift DB)
3. **Sync Service** - `lib/services/sync/todo_sync_service.dart` (handles batch sync)
4. **Model** - `lib/models/todo_model.dart` (data model)

---

## Template 1: Entity Service (Local-First)

**File**: `lib/services/{entity}_service.dart`

```dart
import '../models/{entity}_model.dart';
import '../providers/{entity}_provider.dart';
import '../utils/connectivity_helper.dart';
import 'base_api_service.dart';

class {Entity}Service extends BaseApiService {
  final {Entity}Repository _repository;

  {Entity}Service(this._repository);

  /// Create a new {entity}
  ///
  /// Local-first approach:
  /// 1. Create in local DB first with temp ID
  /// 2. Check connectivity and send to backend if online
  /// 3. Realtime sync will update with canonical ID when backend confirms
  Future<{Entity}Model> create{Entity}({
    required String name,
    // Add other required fields
  }) async {
    // 1. Create in local database first (optimistic)
    final tempId = await _repository.create{Entity}(
      name: name,
      // Map parameters to repository method
    );

    // 2. Check connectivity and send to backend if online
    final isOnline = await ConnectivityHelper.hasInternetConnection();

    if (isOnline) {
      try {
        final api{Entity} = await executeRequest<{Entity}Model>(
          request: () => dio.post(
            '/{entities}/records',
            data: {
              'name': name,
              // Add all fields
            },
          ),
          parser: (data) => {Entity}Model.fromJson(data),
        );

        return api{Entity};
      } catch (e) {
        // If API fails, return local {entity}
        print('API call failed, {entity} saved locally: $e');

        final local{Entity} = await _repository.get{Entity}(tempId);
        if (local{Entity} != null) {
          return {Entity}Model(
            id: local{Entity}.id,
            name: local{Entity}.name,
            // Map all fields
          );
        }
        rethrow;
      }
    } else {
      // Offline: return local {entity}
      final local{Entity} = await _repository.get{Entity}(tempId);
      if (local{Entity} != null) {
        return {Entity}Model(
          id: local{Entity}.id,
          name: local{Entity}.name,
          // Map all fields
        );
      }
      throw Exception('Failed to create {entity} locally');
    }
  }

  /// Get all {entities}
  Future<List<{Entity}Model>> getAll{Entities}() async {
    return executeListRequest<{Entity}Model>(
      request: () => dio.get('/{entities}/records'),
      itemParser: (json) => {Entity}Model.fromJson(json),
    );
  }

  /// Update an existing {entity}
  Future<{Entity}Model> update{Entity}({
    required String id,
    String? name,
    // Add other fields
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    // Add other fields

    return executeRequest<{Entity}Model>(
      request: () => dio.patch('/{entities}/records/$id', data: data),
      parser: (data) => {Entity}Model.fromJson(data),
    );
  }

  /// Delete a {entity}
  Future<void> delete{Entity}(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/{entities}/records/$id'),
    );
  }
}
```

---

## Template 2: Sync Service

**File**: `lib/services/sync/{entity}_sync_service.dart`

```dart
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import '../../database/database.dart';
import '../../models/{entity}_model.dart';
import '../../providers/{entity}_provider.dart';
import '../../services/api_client.dart';
import '../../utils/exceptions.dart';
import '../../utils/id_generator.dart';
import 'base_sync_service.dart';

/// Synchronization service for {Entities}
///
/// Handles bidirectional sync between local Drift database and remote API
/// Makes DIRECT API calls (not through {Entity}Service) to avoid double-writing
class {Entity}SyncService extends BaseSyncService {
  final AppDatabase _database;
  final {Entity}Repository _repository;
  final Dio _dio;

  {Entity}SyncService({
    required AppDatabase database,
    required {Entity}Repository repository,
    Dio? dio,
  })  : _database = database,
        _repository = repository,
        _dio = dio ?? ApiClient().dio;

  @override
  Future<void> syncEntity(String tempId) async {
    // Check if already synced
    if (!IdGenerator.isTemporaryId(tempId)) {
      return; // Already has canonical ID
    }

    // Get the local {entity}
    final local{Entity} = await (_database.select(
      _database.{entities},
    )..where((t) => t.id.equals(tempId))).getSingleOrNull();

    if (local{Entity} == null) {
      throw NotFoundException(
        '{Entity} with temp ID $tempId not found',
        'The {entity} you are trying to sync does not exist',
      );
    }

    // Check if it's already synced
    if (local{Entity}.isSynced) {
      return;
    }

    // Send to API directly (not through {Entity}Service to avoid double-writing)
    try {
      final response = await _dio.post(
        '/{entities}/records',
        data: {
          'name': local{Entity}.name,
          // Add all required fields
        },
      );

      final api{Entity} = {Entity}.fromJson(response.data);

      // Update local database with canonical ID
      await _update{Entity}WithCanonicalId(
        tempId: tempId,
        canonicalId: api{Entity}.id,
      );
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      throw SyncException(
        'Failed to sync {entity}: $message',
        'Unable to sync {entity}. Will retry later.',
      );
    } catch (e) {
      throw SyncException(
        'Failed to sync {entity}: ${e.toString()}',
        'Unable to sync {entity}. Will retry later.',
      );
    }
  }

  @override
  Future<List<String>> getUnsyncedEntityIds() async {
    final unsynced{Entities} = await (_database.select(
      _database.{entities},
    )..where((t) => t.isSynced.equals(false))).get();

    return unsynced{Entities}.map((t) => t.id).toList();
  }

  @override
  Future<void> pullFromServer() async {
    try {
      // Fetch all {entities} from API directly
      final response = await _dio.get('/{entities}/records');

      List<{Entity}> api{Entities};
      if (response.data is List) {
        api{Entities} = (response.data as List)
            .map((item) => {Entity}.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.data is Map && response.data['items'] != null) {
        api{Entities} = (response.data['items'] as List)
            .map((item) => {Entity}.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        api{Entities} = [];
      }

      // For each API {entity}, update or insert in local database
      for (final api{Entity} in api{Entities}) {
        final existing{Entity} = await (_database.select(
          _database.{entities},
        )..where((t) => t.id.equals(api{Entity}.id))).getSingleOrNull();

        if (existing{Entity} != null) {
          // Update existing
          await (_database.update(
            _database.{entities},
          )..where((t) => t.id.equals(api{Entity}.id))).write(
            {Entities}Companion(
              name: Value(api{Entity}.name),
              // Add other fields
              isSynced: const Value(true),
            ),
          );
        } else {
          // Insert new
          await _database
              .into(_database.{entities})
              .insert(
                {Entities}Companion(
                  id: Value(api{Entity}.id),
                  name: Value(api{Entity}.name),
                  // Add required fields with defaults
                  isSynced: const Value(true),
                ),
              );
        }
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      throw SyncException(
        'Failed to pull {entities} from server: $message',
        'Unable to fetch {entities} from server.',
      );
    } catch (e) {
      throw SyncException(
        'Failed to pull {entities} from server: ${e.toString()}',
        'Unable to fetch {entities} from server.',
      );
    }
  }

  /// Perform bidirectional sync
  Future<SyncResult> performFullSync() async {
    if (!await isOnline()) {
      return SyncResult.failure('No internet connection');
    }

    try {
      // First push local changes
      final pushResult = await syncAll();

      // Then pull from server
      await pullFromServer();

      return pushResult;
    } catch (e) {
      return SyncResult.failure(e.toString());
    }
  }

  /// Update a {entity} with its canonical ID after successful sync
  Future<void> _update{Entity}WithCanonicalId({
    required String tempId,
    required String canonicalId,
  }) async {
    // Map the IDs
    await _database.mapId(
      tempId: tempId,
      canonicalId: canonicalId,
      resourceType: '{entity}',
    );

    // Update {entity} with canonical ID
    await (_database.update(
      _database.{entities},
    )..where((t) => t.id.equals(tempId))).write(
      {Entities}Companion(
        id: Value(canonicalId),
        isSynced: const Value(true),
      ),
    );
  }

  /// Delete a {entity} both locally and on server
  Future<void> delete{Entity}(String {entity}Id) async {
    // Delete from server if it's a canonical ID
    if (!IdGenerator.isTemporaryId({entity}Id) && await isOnline()) {
      try {
        await _dio.delete('/{entities}/records/${entity}Id');
      } on DioException catch (e) {
        final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
        throw SyncException(
          'Failed to delete {entity} from server: $message',
          'Unable to delete {entity} from server.',
        );
      }
    }

    // Delete from local database
    await (_database.delete(
      _database.{entities},
    )..where((t) => t.id.equals({entity}Id))).go();
  }

  /// Update a {entity} both locally and on server
  Future<void> update{Entity}({
    required String {entity}Id,
    required String name,
    // Add other fields
  }) async {
    // Update locally first (offline-first approach)
    await (_database.update(
      _database.{entities},
    )..where((t) => t.id.equals({entity}Id))).write(
      {Entities}Companion(
        name: Value(name),
        // Add other fields
        isSynced: const Value(false), // Mark as needing sync
      ),
    );

    // If online and has canonical ID, sync immediately
    if (!IdGenerator.isTemporaryId({entity}Id) && await isOnline()) {
      try {
        await _dio.patch(
          '/{entities}/records/${entity}Id',
          data: {
            'name': name,
            // Add other fields
          },
        );

        // Mark as synced
        await (_database.update(_database.{entities})
              ..where((t) => t.id.equals({entity}Id)))
            .write(const {Entities}Companion(isSynced: Value(true)));
      } on DioException catch (e) {
        final message = e.response?.data?['message'] ?? e.message ?? 'Unknown error';
        // Failed to sync, but local update succeeded
        throw SyncException(
          'Updated locally but failed to sync: $message',
          'Changes saved locally and will sync when connection is available',
        );
      }
    }
  }
}
```

---

## Template 3: Add to SyncCoordinator

**File**: `lib/services/sync/sync_coordinator.dart`

```dart
// Add to imports
import '{entity}_sync_service.dart';

// Add to class fields
late final {Entity}SyncService {entity}Sync;

// Add to constructor
SyncCoordinator({
  required AppDatabase database,
  required ProjectRepository projectRepository,
  required {Entity}Repository {entity}Repository, // Add this
  Dio? dio,
})  : _database = database,
      _projectRepository = projectRepository,
      _{entity}Repository = {entity}Repository, // Add this
      _dio = dio ?? ApiClient().dio {
  // ... existing code ...

  {entity}Sync = {Entity}SyncService(
    database: _database,
    repository: _{entity}Repository,
    dio: _dio,
  );
}

// Update syncAll method
Future<AggregatedSyncResult> syncAll() async {
  final results = <String, SyncResult>{};

  results['projects'] = await projectSync.performFullSync();
  results['expenses'] = await expenseSync.syncAll();
  results['{entities}'] = await {entity}Sync.syncAll(); // Add this

  return AggregatedSyncResult(results);
}
```

---

## Template 4: Add Provider

**File**: `lib/providers/service_providers.dart`

```dart
// Add to imports
import '../services/{entity}_service.dart';
import '{entity}_provider.dart';

// Add service provider
final {entity}ServiceProvider = Provider<{Entity}Service>((ref) {
  final repository = ref.watch({entity}RepositoryProvider);
  return {Entity}Service(repository);
});

// Update syncCoordinatorProvider
final syncCoordinatorProvider = Provider<SyncCoordinator>((ref) {
  final database = ref.watch(databaseProvider);
  final projectRepository = ref.watch(projectRepositoryProvider);
  final {entity}Repository = ref.watch({entity}RepositoryProvider); // Add this

  return SyncCoordinator(
    database: database,
    projectRepository: projectRepository,
    {entity}Repository: {entity}Repository, // Add this
  );
});
```

---

## Checklist for New Sync Service

- [ ] Create/update entity service with local-first logic
- [ ] Create repository if it doesn't exist
- [ ] Create sync service extending BaseSyncService
- [ ] Add sync service to SyncCoordinator
- [ ] Add service provider
- [ ] Update syncCoordinator provider with new repository
- [ ] Add to RealtimeSyncService for SSE updates (optional)
- [ ] Test offline create → online sync flow
- [ ] Test pull from server
- [ ] Test delete sync

---

## Example: Creating TodoSyncService

Replace all instances of:
- `{Entity}` → `Todo`
- `{entity}` → `todo`
- `{Entities}` → `Todos`
- `{entities}` → `todos`

Follow the templates above and you'll have a complete sync service!

---

**Last Updated:** 2025-01-15

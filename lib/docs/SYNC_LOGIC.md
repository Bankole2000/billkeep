# Sync Architecture Documentation

## Overview

This document explains how the synchronization system works in BillKeep, including the offline-first approach and how local database changes sync with the remote backend.

---

## The Sync Architecture

The app uses **TWO complementary sync systems** working together:

1. **Batch/Manual Sync System** (Existing)
2. **Realtime Sync System** (New)

---

## 1. Batch/Manual Sync System

### Components

**Files:**
- `lib/services/sync/base_sync_service.dart` - Base class for sync services
- `lib/services/sync/project_sync_service.dart` - Project syncing
- `lib/services/sync/expense_sync_service.dart` - Expense syncing
- `lib/services/sync/sync_coordinator.dart` - Orchestrates all sync operations

### Architecture

```
┌─────────────────────────────────────────────┐
│         SyncCoordinator                     │
│  (Master orchestrator for batch sync)       │
└─────────────┬───────────────────────────────┘
              │
      ┌───────┴────────┐
      ▼                ▼
┌──────────────┐  ┌──────────────┐
│ ProjectSync  │  │ ExpenseSync  │
│   Service    │  │   Service    │
└──────────────┘  └──────────────┘
```

### Purpose

- **Batch sync** of unsynced items
- **Manual sync** when user requests refresh
- **Background sync** when app comes online
- **Initial sync** when app starts

### Flow

1. **Push**: Find all unsynced local items (isSynced=false) → Send to backend → Update with canonical ID
2. **Pull**: Fetch all items from backend → Update/insert into local DB
3. **Full Sync**: Push first, then Pull

### When to Use

- App startup (sync everything)
- User manually triggers refresh
- App comes back online after being offline
- Periodic background sync

---

## 2. Realtime Sync System

### Components

**Files:**
- `lib/services/sync/realtime_sync_service.dart` - Listens to SSE events
- `lib/services/pocketbase_realtime_service.dart` - SSE connection manager

### Architecture

```
┌──────────────────────────────────────────┐
│      PocketBase Backend (SSE)            │
└────────────┬─────────────────────────────┘
             │ (Server-Sent Events)
             │ "wallet created!"
             │ "project updated!"
             ▼
┌──────────────────────────────────────────┐
│    PocketBaseRealtimeService             │
│    (SSE Connection Manager)              │
└────────────┬─────────────────────────────┘
             │
             ▼
┌──────────────────────────────────────────┐
│    RealtimeSyncService                   │
│    (Event Handler)                       │
└────────────┬─────────────────────────────┘
             │
    ┌────────┴────────┐
    ▼                 ▼
┌─────────┐      ┌─────────┐
│ Wallet  │      │ Project │
│  Repo   │      │  Repo   │
└─────────┘      └─────────┘
    │                 │
    ▼                 ▼
┌──────────────────────────┐
│    Local Drift DB        │
└──────────────────────────┘
```

### Purpose

- **Live updates** from backend
- **Multi-device sync** (changes from other clients)
- **Canonical ID mapping** (tempId → real ID)
- **Instant sync** without waiting for batch

### Flow

1. Backend broadcasts SSE event: "wallet created with ID abc123"
2. RealtimeSyncService receives event
3. Finds matching local tempId wallet (by name/data)
4. Updates: `temp_wallet_456` → `abc123` + `isSynced=true`

### When to Use

- Always running in background while app is active
- Instant updates from other devices/sessions
- Confirms backend accepted our optimistic creates

---

## Complete Flow: Online vs Offline Scenarios

### Scenario 1: Creating a Project While ONLINE

```
USER CREATES PROJECT (ONLINE)
        │
        ▼
┌─────────────────────────────────────────┐
│  ProjectService.createProject()         │
│  1. Write to local DB (temp_123)        │
│  2. Check connectivity → ONLINE ✅       │
│  3. POST to backend                     │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│  Backend responds                       │
│  { id: "real_abc_456", ... }            │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│  SSE Event Broadcast                    │
│  "project created: real_abc_456"        │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│  RealtimeSyncService                    │
│  1. Receives event                      │
│  2. Finds temp_123 in local DB          │
│  3. Updates: temp_123 → real_abc_456    │
│  4. Sets isSynced = true                │
└─────────────────────────────────────────┘
          │
          ▼
    SYNCED! ✅
```

### Scenario 2: Creating a Project While OFFLINE

```
USER CREATES PROJECT (OFFLINE)
        │
        ▼
┌─────────────────────────────────────────┐
│  ProjectService.createProject()         │
│  1. Write to local DB (temp_123)        │
│  2. Check connectivity → OFFLINE ❌      │
│  3. Return local project                │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│  Local DB State:                        │
│  - ID: temp_123                         │
│  - isSynced: false                      │
│  - User sees project in UI ✅            │
└─────────────────────────────────────────┘

═══════════ TIME PASSES ═══════════════

┌─────────────────────────────────────────┐
│  Device Comes Back Online               │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│  SyncCoordinator.pushAllToServer()      │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│  ProjectSyncService.syncAll()           │
│  1. Find unsynced (isSynced=false)      │
│  2. Found: temp_123                     │
└─────────┬───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│  ProjectSyncService.syncEntity()        │
│  1. Get local project (temp_123)        │
│  2. POST to backend                     │
│  3. Backend responds: real_abc_456      │
│  4. Update: temp_123 → real_abc_456     │
│  5. Set isSynced = true                 │
└─────────────────────────────────────────┘
          │
          ▼
    SYNCED! ✅
```

---

## Component Responsibilities

| Component | Purpose | When It Runs |
|-----------|---------|--------------|
| **ProjectService** | Optimistic create (local + API if online) | When user creates project |
| **ProjectSyncService** | Retry failed/offline creates | When back online, app startup, manual sync |
| **RealtimeSyncService** | Handle updates from other devices | Always (when app is running) |
| **SyncCoordinator** | Orchestrate all sync operations | App startup, connectivity restored, manual refresh |

---

## Key Differences Between Sync Systems

| Feature | Batch Sync (Old) | Realtime Sync (New) |
|---------|------------------|---------------------|
| **Trigger** | Manual/Periodic | Automatic (SSE) |
| **Speed** | Slow (batch) | Instant |
| **Direction** | Bidirectional | Server → Client |
| **Use Case** | Bulk sync, offline recovery | Live updates |
| **Connection** | HTTP REST | Server-Sent Events |
| **When** | On-demand | Always listening |

---

## Data Flow: Temporary ID to Canonical ID Mapping

### Why Temporary IDs?

When creating records offline, we need to:
1. Give the record an ID immediately (for UI and foreign keys)
2. Replace it with the real backend ID later

### Temporary ID Format

```dart
// From lib/utils/id_generator.dart
"temp_wallet_1234567890"
"temp_project_1234567890"
"temp_expense_1234567890"
```

### ID Mapping Table

The `id_mappings` table tracks temp → canonical translations:

```sql
CREATE TABLE id_mappings (
  temp_id TEXT PRIMARY KEY,
  canonical_id TEXT,
  resource_type TEXT,
  created_at DATETIME
);
```

### Mapping Flow

```
1. Create with temp ID:
   Local DB: { id: "temp_proj_123", name: "My Project" }

2. Send to backend:
   POST /projects → { id: "abc456", name: "My Project" }

3. Map IDs:
   INSERT INTO id_mappings VALUES (
     'temp_proj_123',
     'abc456',
     'project',
     NOW()
   )

4. Update local record:
   UPDATE projects
   SET id = 'abc456', isSynced = true
   WHERE id = 'temp_proj_123'

5. Update foreign keys:
   Any expenses with projectId = 'temp_proj_123'
   are automatically updated to 'abc456'
```

---

## Current Issue: Double-Writing

### The Problem

`ProjectSyncService.syncEntity()` calls `ProjectService.createProject()`, which:

1. Writes to local DB ❌ (already exists!)
2. Sends to API ✅ (needed)

This creates **double-writing** and potential conflicts.

### The Solution

**Option 1: Separate API-only service**

```dart
class ProjectApiService {
  // ONLY makes API calls, NO local DB writes
  Future<Project> createProject(...) async {
    return executeRequest<Project>(
      request: () => dio.post('/projects/records', ...),
      parser: (data) => Project.fromJson(data),
    );
  }
}
```

Then:
- `ProjectService` uses `ProjectRepository` + `ProjectApiService`
- `ProjectSyncService` uses only `ProjectApiService`

**Option 2: Add flag to service**

```dart
class ProjectService {
  Future<Project> createProject({
    required String name,
    bool writeLocal = true, // <-- Add flag
  }) async {
    if (writeLocal) {
      // Write to local DB
    }

    // Send to API
  }
}
```

**Option 3: Direct API calls in sync service (Recommended)**

```dart
// In ProjectSyncService
class ProjectSyncService {
  final AppDatabase _database;
  final Dio _dio; // Direct API access

  Future<void> syncEntity(String tempId) async {
    final localProject = await _getLocalProject(tempId);

    // Call API DIRECTLY (not through ProjectService)
    final response = await _dio.post('/projects/records', data: {...});
    final apiProject = Project.fromJson(response.data);

    // Update local DB with canonical ID
    await _updateProjectWithCanonicalId(
      tempId: tempId,
      canonicalId: apiProject.id,
    );
  }
}
```

---

## Usage Guide

### Starting Realtime Sync

```dart
// In app initialization (after login)
final realtimeSyncService = ref.read(realtimeSyncServiceProvider);
await realtimeSyncService.startSync();
```

### Manual Sync

```dart
// Sync all unsynced items
final syncCoordinator = SyncCoordinator(database);
final result = await syncCoordinator.pushAllToServer();

if (result.isFullSuccess) {
  print('All synced: ${result.totalSuccessCount} items');
} else {
  print('Partial sync: ${result.totalSuccessCount} succeeded, ${result.totalFailureCount} failed');
}
```

### Check for Unsynced Items

```dart
final syncCoordinator = SyncCoordinator(database);

// Check if any unsynced
final hasUnsynced = await syncCoordinator.hasUnsyncedChanges();

// Get counts by type
final counts = await syncCoordinator.getUnsyncedCounts();
print('Unsynced projects: ${counts['projects']}');
print('Unsynced expenses: ${counts['expenses']}');
```

### Pulling Latest from Server

```dart
// Refresh all data from server
final syncCoordinator = SyncCoordinator(database);
await syncCoordinator.pullAllFromServer();
```

---

## Best Practices

### 1. Always Check isSynced Status

```dart
// When displaying data
if (!project.isSynced) {
  // Show "syncing..." indicator
}
```

### 2. Handle Sync Errors Gracefully

```dart
try {
  await syncCoordinator.pushAllToServer();
} catch (e) {
  // Don't block UI, data is saved locally
  // Will retry on next sync
  showSnackbar('Changes saved locally, will sync when online');
}
```

### 3. Periodic Background Sync

```dart
// In app lifecycle
Timer.periodic(Duration(minutes: 15), (timer) async {
  if (await ConnectivityHelper.hasInternetConnection()) {
    await syncCoordinator.pushAllToServer();
  }
});
```

### 4. Sync on Connectivity Change

```dart
// Listen to connectivity changes
connectivity.onConnectivityChanged.listen((result) async {
  if (result != ConnectivityResult.none) {
    // Just came back online
    await syncCoordinator.pushAllToServer();
  }
});
```

---

## Troubleshooting

### Items Not Syncing

**Check:**
1. Is `isSynced` set to `false`?
2. Is the device online?
3. Is the backend reachable?
4. Check logs for sync errors

### Duplicate Records

**Cause:** Creating same item multiple times while offline

**Solution:** Implement deduplication in sync service based on unique fields

### Temp IDs Not Replaced

**Check:**
1. Is RealtimeSyncService running?
2. Is SSE connection active?
3. Check backend is broadcasting events

---

## Future Improvements

1. **Conflict Resolution**: Handle cases where same record is edited on multiple devices
2. **Retry Logic**: Exponential backoff for failed syncs
3. **Partial Updates**: PATCH instead of full object updates
4. **Delta Sync**: Only sync changed fields
5. **Compression**: Compress large sync payloads
6. **Offline Queue UI**: Show user what's pending sync

---

## Related Files

- `lib/services/wallet_service.dart` - Wallet service with local-first logic
- `lib/services/project_service.dart` - Project service with local-first logic
- `lib/providers/service_providers.dart` - Riverpod providers for services
- `lib/utils/connectivity_helper.dart` - Network connectivity checker
- `lib/utils/id_generator.dart` - Temporary ID generator
- `lib/database/database.dart` - Drift database schema

---

**Last Updated:** 2025-01-15
**Author:** Development Team

# BillKeep Refactoring Guide

This document explains the architectural improvements made to the BillKeep codebase and how to use them.

## Table of Contents

1. [Overview](#overview)
2. [Base API Service](#base-api-service)
3. [Custom Exception Hierarchy](#custom-exception-hierarchy)
4. [Sync Layer](#sync-layer)
5. [Logging Service](#logging-service)
6. [App Configuration](#app-configuration)
7. [Usage Examples](#usage-examples)

---

## Overview

The refactoring focused on:
- ✅ Eliminating ~1,600+ lines of duplicate code
- ✅ Standardizing error handling
- ✅ Creating a proper sync layer for offline-first functionality
- ✅ Centralizing configuration
- ✅ Adding comprehensive logging

---

## Base API Service

### Location
`lib/services/base_api_service.dart`

### Purpose
Provides common functionality for all API services, including:
- HTTP request execution
- Response parsing
- Error handling
- Exception conversion

### How to Use

#### Creating a New Service

```dart
import '../models/my_model.dart';
import 'base_api_service.dart';

class MyService extends BaseApiService {
  // Single object response
  Future<MyModel> getItem(String id) async {
    return executeRequest<MyModel>(
      request: () => dio.get('/items/$id'),
      parser: (data) => MyModel.fromJson(data),
    );
  }

  // List response
  Future<List<MyModel>> getAllItems() async {
    return executeListRequest<MyModel>(
      request: () => dio.get('/items'),
      itemParser: (json) => MyModel.fromJson(json),
    );
  }

  // Void response (like DELETE)
  Future<void> deleteItem(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/items/$id'),
    );
  }
}
```

### Benefits
- No need to write try-catch blocks
- Automatic error conversion to custom exceptions
- Consistent error handling across all services
- Less boilerplate code

---

## Custom Exception Hierarchy

### Location
`lib/utils/exceptions.dart`

### Available Exceptions

```dart
AppException             // Base class
├── NetworkException     // Connection/timeout issues
├── AuthenticationException  // 401 errors
├── AuthorizationException   // 403 errors
├── NotFoundException    // 404 errors
├── ValidationException  // 400 errors
├── ConflictException    // 409 errors
├── ServerException      // 500+ errors
├── DatabaseException    // Local DB errors
├── SyncException        // Sync failures
└── BusinessLogicException   // Business rule violations
```

### How to Use

#### Catching Specific Exceptions

```dart
try {
  await myService.createItem(data);
} on AuthenticationException catch (e) {
  // User needs to log in again
  showLoginScreen();
} on ValidationException catch (e) {
  // Show field-level errors
  showFieldErrors(e.fieldErrors);
} on NetworkException catch (e) {
  // Show "check connection" message
  showSnackBar(e.getUserMessage());
} on AppException catch (e) {
  // Handle any other app exception
  showError(e.getUserMessage());
}
```

#### Throwing Exceptions

```dart
if (amount <= 0) {
  throw ValidationException(
    'Amount must be positive', // Technical message (for logs)
    'Please enter an amount greater than zero', // User message
  );
}
```

#### User-Friendly Messages

Every exception has two messages:
- `message`: Technical details for logging
- `userMessage`: Friendly message for users

```dart
try {
  await expenseSync.syncEntity(expenseId);
} on SyncException catch (e) {
  // Log technical details
  LoggingService.error(e.message);

  // Show user-friendly message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.getUserMessage())),
  );
}
```

---

## Sync Layer

### Architecture

```
┌─────────────────────────────────────┐
│         UI Layer                     │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│    SyncCoordinator                   │  ← Master orchestrator
│    (lib/services/sync/)              │
└──────────────┬──────────────────────┘
               │
      ┌────────┴────────┐
      │                 │
┌─────▼─────┐   ┌──────▼────────┐
│ Project   │   │ Expense       │
│ SyncService│   │ SyncService  │
└─────┬─────┘   └──────┬────────┘
      │                │
  ┌───┴────┐      ┌────┴───┐
  │ API    │      │ Local  │
  │Service │      │Database│
  └────────┘      └────────┘
```

### Key Components

#### 1. BaseSyncService
Base class for all sync services

```dart
abstract class BaseSyncService {
  Future<void> syncEntity(String tempId);
  Future<SyncResult> syncAll();
  Future<void> pullFromServer();
  Future<List<String>> getUnsyncedEntityIds();
}
```

#### 2. ProjectSyncService
Handles project synchronization

```dart
final projectSync = ProjectSyncService(database: database);

// Sync a single project
await projectSync.syncEntity(projectId);

// Sync all unsynced projects
final result = await projectSync.syncAll();

// Full bidirectional sync
final result = await projectSync.performFullSync();

// Pull latest from server
await projectSync.pullFromServer();

// Update project (offline-first)
await projectSync.updateProject(
  projectId: id,
  name: 'Updated Name',
  description: 'New description',
);

// Delete project (syncs to server if online)
await projectSync.deleteProject(projectId);
```

#### 3. SyncCoordinator
Orchestrates all entity syncs

```dart
final coordinator = SyncCoordinator(database);

// Sync everything
final result = await coordinator.syncAll();
print(result.summary); // "All synced successfully (15 items)"

// Sync specific project
final result = await coordinator.syncProject(projectId);

// Pull all from server (refresh)
await coordinator.pullAllFromServer();

// Push all unsynced changes
final result = await coordinator.pushAllToServer();

// Check for unsynced changes
final hasChanges = await coordinator.hasUnsyncedChanges();

// Get counts by entity type
final counts = await coordinator.getUnsyncedCounts();
// {projects: 2, expenses: 5}
```

### Using Sync with Riverpod

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sync_provider.dart';

class MySyncButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncStateProvider);

    return ElevatedButton(
      onPressed: syncState.isSyncing
          ? null
          : () => ref.read(syncStateProvider.notifier).syncAll(),
      child: syncState.isSyncing
          ? CircularProgressIndicator()
          : Text('Sync All'),
    );
  }
}
```

### Sync Indicators

```dart
class SyncIndicator extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unsyncedAsync = ref.watch(unsyncedCountsProvider);

    return unsyncedAsync.when(
      data: (counts) {
        final total = counts.values.fold(0, (sum, count) => sum + count);
        if (total == 0) {
          return Icon(Icons.cloud_done, color: Colors.green);
        }
        return Badge(
          label: Text('$total'),
          child: Icon(Icons.cloud_upload),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (_, __) => Icon(Icons.cloud_off, color: Colors.red),
    );
  }
}
```

### Automatic Background Sync

```dart
class BackgroundSyncService {
  final SyncCoordinator _coordinator;
  Timer? _timer;

  void startPeriodicSync({Duration interval = const Duration(minutes: 15)}) {
    _timer = Timer.periodic(interval, (_) async {
      if (await _coordinator.hasUnsyncedChanges()) {
        LoggingService.info('Starting background sync');
        final result = await _coordinator.pushAllToServer();
        LoggingService.info('Background sync completed: ${result.summary}');
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }
}
```

---

## Logging Service

### Location
`lib/services/logging_service.dart`

### Log Levels

```dart
LoggingService.debug()    // Detailed debugging info (dev only)
LoggingService.info()     // General information
LoggingService.warning()  // Non-critical issues
LoggingService.error()    // Errors that don't crash app
LoggingService.critical() // Severe errors
```

### Usage Examples

#### Basic Logging

```dart
// Simple message
LoggingService.info('User logged in');

// With tag
LoggingService.debug('Processing payment', tag: 'Payment');

// With data
LoggingService.info('Order created', data: {
  'orderId': '123',
  'amount': 99.99,
});
```

#### Error Logging

```dart
try {
  await processPayment();
} catch (e, stackTrace) {
  LoggingService.error(
    'Payment processing failed',
    error: e,
    stackTrace: stackTrace,
    tag: 'Payment',
  );
}
```

#### Exception Logging

```dart
// Automatic log level based on exception type
try {
  await syncProject();
} catch (e, stackTrace) {
  LoggingService.exception(e, stackTrace: stackTrace, context: 'Project sync');
}

// Or use extension
try {
  await syncProject();
} catch (e, stackTrace) {
  e.log(stackTrace: stackTrace, context: 'Project sync');
}
```

#### Specialized Logging

```dart
// Network requests
LoggingService.networkRequest('POST', '/api/projects', body: data);

// Network responses
LoggingService.networkResponse(200, '/api/projects', duration: Duration(milliseconds: 250));

// Database operations
LoggingService.database('INSERT', table: 'projects', data: project);

// Sync operations
LoggingService.sync('Syncing projects', entity: 'Project');

// User actions (for analytics)
LoggingService.userAction('button_clicked', properties: {
  'button_id': 'create_project',
  'screen': 'home',
});
```

#### Configuration

```dart
void main() {
  // Configure logging on app startup
  LoggingService.instance.configure(
    enabled: true,
    debugOnly: false, // Log in all environments
  );

  runApp(MyApp());
}
```

---

## App Configuration

### Location
`lib/config/app_config.dart`

### Features

- Environment-based configuration
- Support for compile-time constants
- Feature flags
- Easy to extend

### Usage

#### Accessing Configuration

```dart
// API Configuration
print(AppConfig.apiBaseUrl); // http://localhost:8090/api/collections
print(AppConfig.apiTimeout);  // 30 seconds

// Environment checks
if (AppConfig.isDevelopment) {
  print('Running in development mode');
}

// Feature flags
if (AppConfig.enableAnalytics) {
  sendAnalyticsEvent();
}
```

#### Environment Variables

Set at compile time using `--dart-define`:

```bash
# Development (default)
flutter run

# Staging
flutter run --dart-define=API_BASE_URL=https://staging-api.billkeep.com

# Production
flutter run --dart-define=API_BASE_URL=https://api.billkeep.com \
            --dart-define=ENABLE_ANALYTICS=true \
            --dart-define=ENABLE_CRASH_REPORTING=true
```

#### Debug Configuration

```dart
void main() {
  if (AppConfig.isDevelopment) {
    AppConfig.printConfig();
    // Prints:
    // === App Configuration ===
    // Environment: development
    // API Base URL: http://localhost:8090/api/collections
    // API Timeout: 30s
    // Analytics: false
    // ... etc
  }

  runApp(MyApp());
}
```

---

## Usage Examples

### Complete Example: Creating and Syncing a Project

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateProjectScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createAndSyncProject() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // 1. Create project locally (offline-first)
      final projectRepo = ref.read(projectRepositoryProvider);
      final tempId = await projectRepo.createProject(
        name: _nameController.text,
        description: null,
        iconType: 'emoji',
        emoji: '📊',
        isArchived: false,
      );

      LoggingService.info('Project created locally', data: {'id': tempId});

      // 2. Sync to server
      final syncCoordinator = ref.read(syncCoordinatorProvider);

      try {
        await syncCoordinator.projectSync.syncEntity(tempId);
        LoggingService.info('Project synced successfully');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Project created and synced!')),
          );
          Navigator.pop(context);
        }
      } on NetworkException catch (e) {
        // Offline - that's okay, it will sync later
        LoggingService.warning('Project created offline: ${e.message}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Project created. Will sync when online.')),
          );
          Navigator.pop(context);
        }
      } on SyncException catch (e) {
        // Sync failed - data is still saved locally
        LoggingService.error('Sync failed: ${e.message}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.getUserMessage())),
          );
        }
      }
    } on DatabaseException catch (e) {
      LoggingService.error('Failed to create project locally', error: e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create project')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Project')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Project Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _createAndSyncProject,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Create Project'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Complete Example: Sync Status Widget

```dart
class SyncStatusWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncStateProvider);
    final unsyncedAsync = ref.watch(unsyncedCountsProvider);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sync Status', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),

            // Current sync state
            _buildSyncState(syncState),

            SizedBox(height: 8),

            // Unsynced counts
            unsyncedAsync.when(
              data: (counts) => _buildUnsyncedCounts(counts),
              loading: () => CircularProgressIndicator(),
              error: (_, __) => Text('Error loading sync status'),
            ),

            SizedBox(height: 16),

            // Sync button
            ElevatedButton.icon(
              onPressed: syncState.isSyncing
                  ? null
                  : () => ref.read(syncStateProvider.notifier).syncAll(),
              icon: Icon(Icons.sync),
              label: Text(syncState.isSyncing ? 'Syncing...' : 'Sync Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncState(SyncState state) {
    IconData icon;
    Color color;
    String text;

    if (state.isSyncing) {
      icon = Icons.sync;
      color = Colors.blue;
      text = 'Syncing...';
    } else if (state.isSuccess) {
      icon = Icons.check_circle;
      color = Colors.green;
      text = state.message ?? 'Synced';
    } else if (state.isError) {
      icon = Icons.error;
      color = Colors.red;
      text = state.message ?? 'Sync failed';
    } else {
      icon = Icons.cloud_done;
      color = Colors.grey;
      text = 'Ready to sync';
    }

    return Row(
      children: [
        Icon(icon, color: color),
        SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _buildUnsyncedCounts(Map<String, int> counts) {
    final total = counts.values.fold(0, (sum, count) => sum + count);

    if (total == 0) {
      return Text('All data synced ✓', style: TextStyle(color: Colors.green));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Unsynced changes: $total'),
        ...counts.entries.map((e) => Text('  ${e.key}: ${e.value}')),
      ],
    );
  }
}
```

---

## Migration Guide

### For Existing Code

#### 1. Update Service Calls

**Before:**
```dart
try {
  final response = await _apiClient.dio.post('/projects', data: {...});
  return Project.fromJson(response.data);
} catch (e) {
  throw 'Failed to create project';
}
```

**After:**
```dart
try {
  return await projectService.createProject(...);
} on AppException catch (e) {
  LoggingService.error('Failed to create project', error: e);
  showSnackBar(e.getUserMessage());
}
```

#### 2. Use Sync Services Instead of Direct API Calls

**Before:**
```dart
// Create locally
await projectRepo.createProject(...);

// Separately sync (maybe never happens)
// ???
```

**After:**
```dart
// Create locally
final tempId = await projectRepo.createProject(...);

// Sync automatically
await syncCoordinator.projectSync.syncEntity(tempId);
```

#### 3. Replace Print Statements

**Before:**
```dart
print('Creating project: $name');
print('Error: $e');
```

**After:**
```dart
LoggingService.info('Creating project', data: {'name': name});
LoggingService.error('Project creation failed', error: e);
```

---

## Best Practices

### 1. Offline-First Approach

Always save locally first, then sync:

```dart
// ✅ Good
final id = await localRepo.create(...);
await syncService.syncEntity(id);

// ❌ Bad
final id = await apiService.create(...);
await localRepo.create(...);
```

### 2. Handle Sync Failures Gracefully

```dart
try {
  await syncService.syncEntity(id);
} on NetworkException {
  // User is offline - that's okay
  showMessage('Changes will sync when you\'re back online');
} on SyncException catch (e) {
  // Actual sync error - log and notify
  LoggingService.error('Sync failed', error: e);
  showError(e.getUserMessage());
}
```

### 3. Use Appropriate Log Levels

```dart
LoggingService.debug()   // Temporary debugging
LoggingService.info()    // Normal operations
LoggingService.warning() // Unexpected but handled
LoggingService.error()   // Errors affecting functionality
LoggingService.critical()// Errors that might crash app
```

### 4. Leverage Type Safety

```dart
// ✅ Good - catches errors at compile time
try {
  await projectService.createProject(...);
} on ValidationException catch (e) {
  // Handle validation errors
} on NetworkException catch (e) {
  // Handle network errors
}

// ❌ Bad - catches everything
try {
  await projectService.createProject(...);
} catch (e) {
  // What kind of error is this?
}
```

---

## Summary

### What Was Achieved

1. **~1,600 lines of code eliminated** through base classes
2. **Consistent error handling** via custom exceptions
3. **Proper offline-first sync** via sync layer
4. **Centralized logging** for debugging and monitoring
5. **Environment-aware configuration** for deployments

### Code Quality Improvements

- More maintainable
- More testable
- More scalable
- More consistent
- Better error messages
- Easier debugging

### Next Steps

Consider implementing:
- Additional sync services (Income, Payment, etc.)
- Conflict resolution for sync
- File-based logging
- Firebase Crashlytics integration
- Firebase Analytics integration
- Connection monitoring
- Sync queue with retry logic

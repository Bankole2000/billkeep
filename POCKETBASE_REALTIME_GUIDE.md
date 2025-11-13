# PocketBase Realtime Integration Guide

This guide explains how to use PocketBase's real-time capabilities with SSE (Server-Sent Events) in your Flutter app for automatic data synchronization.

## Table of Contents

1. [Overview](#overview)
2. [How It Works](#how-it-works)
3. [Setup & Configuration](#setup--configuration)
4. [Usage Examples](#usage-examples)
5. [UI Components](#ui-components)
6. [Best Practices](#best-practices)
7. [Troubleshooting](#troubleshooting)

---

## Overview

### What is PocketBase Realtime?

PocketBase provides real-time database subscriptions using **Server-Sent Events (SSE)**. When data changes on the server (create, update, or delete), your Flutter app is automatically notified and can update the local database immediately.

### Benefits

- ✅ **Instant updates** - No polling, no delays
- ✅ **Multi-device sync** - Changes from one device appear on others instantly
- ✅ **Collaborative features** - Multiple users can work on the same data
- ✅ **Battery efficient** - SSE is more efficient than WebSockets or polling
- ✅ **Automatic reconnection** - Handles network interruptions gracefully

### Architecture

```
┌──────────────┐              ┌──────────────┐
│   Device A   │              │   Device B   │
│              │              │              │
│  User adds   │              │  Sees new    │
│  project ────┼──────┐       │◄─ project    │
└──────────────┘      │       └──────────────┘
                      ├──┐
                      ▼  │
              ┌────────────────┐
              │   PocketBase   │
              │     Server     │
              └────────────────┘
                      │  │
                      │  └─── SSE Stream ────┐
                      │                      │
                      ▼                      ▼
              ┌──────────────┐      ┌──────────────┐
              │   Device C   │      │   Device D   │
              │              │      │              │
              │  Updates ◄───┤      │  Updates ◄───┤
              │  instantly   │      │  instantly   │
              └──────────────┘      └──────────────┘
```

---

## How It Works

### Server-Sent Events (SSE)

SSE is a standard for pushing updates from server to client over HTTP:

1. **Client opens SSE connection** to PocketBase
2. **Server keeps connection alive** and sends updates
3. **Client receives events** in real-time
4. **Auto-reconnects** if connection is lost

### Event Flow

```dart
// 1. Start listening
realtimeService.initialize();
realtimeService.subscribe('projects');

// 2. Server sends event when data changes
{
  "action": "create",  // or "update" or "delete"
  "collection": "projects",
  "record": {
    "id": "abc123",
    "name": "New Project",
    ...
  }
}

// 3. App updates local database automatically
database.insert(project);

// 4. UI updates reactively (via Drift streams)
StreamProvider watches database and rebuilds widgets
```

---

## Setup & Configuration

### 1. Prerequisites

Make sure these are in your `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0  # For SSE client
  flutter_riverpod: ^2.4.0
  drift: ^2.14.0
```

### 2. PocketBase Server Setup

Your PocketBase server needs real-time enabled (it's on by default). The endpoint is:

```
GET /api/realtime?collection={collection_name}
```

### 3. Initialize on App Start

In your `main.dart` or after user logs in:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    // Start realtime sync after user is authenticated
    // (Usually in your login success handler)
    Future.microtask(() {
      ref.read(realtimeSyncProvider.notifier).startListening();
    });
  }

  @override
  void dispose() {
    // Stop realtime sync when app closes
    ref.read(realtimeSyncProvider.notifier).stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
```

### 4. Start Listening After Login

```dart
// In your login success handler
Future<void> onLoginSuccess() async {
  // Save token
  await ApiClient.saveToken(token);

  // Start realtime sync
  await ref.read(realtimeSyncProvider.notifier).startListening();

  // Navigate to home
  Navigator.pushReplacement(context, MaterialPageRoute(
    builder: (_) => HomeScreen(),
  ));
}
```

### 5. Stop Listening on Logout

```dart
Future<void> onLogout() async {
  // Stop realtime sync
  ref.read(realtimeSyncProvider.notifier).stopListening();

  // Clear token
  await ApiClient.clearToken();

  // Navigate to login
  Navigator.pushReplacement(context, MaterialPageRoute(
    builder: (_) => LoginScreen(),
  ));
}
```

---

## Usage Examples

### Example 1: Basic Subscription

Subscribe to a collection and handle events manually:

```dart
import '../services/pocketbase_realtime_service.dart';

final realtimeService = PocketBaseRealtimeService();

// Initialize
await realtimeService.initialize();

// Subscribe to projects
realtimeService.subscribe('projects').listen((event) {
  print('Action: ${event.action}');
  print('Record ID: ${event.recordId}');

  if (event.isCreate) {
    print('New project created: ${event.record!['name']}');
  } else if (event.isUpdate) {
    print('Project updated: ${event.record!['name']}');
  } else if (event.isDelete) {
    print('Project deleted: ${event.recordId}');
  }
});
```

### Example 2: Subscribe to Specific Record

Listen to changes for a single record:

```dart
// Subscribe to a specific project
realtimeService.subscribe('projects', recordId: 'proj123').listen((event) {
  if (event.isUpdate) {
    print('This specific project was updated');
    // Refresh UI
  }
});
```

### Example 3: Using with Riverpod (Recommended)

The app already includes a Riverpod provider that handles everything:

```dart
class ProjectListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get realtime status
    final realtimeState = ref.watch(realtimeSyncProvider);

    // Projects automatically update via Drift streams + realtime
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
        actions: [
          // Show realtime status
          RealtimeStatusIndicator(),
        ],
      ),
      body: projectsAsync.when(
        data: (projects) => ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(projects[index].name),
              // This will automatically update when another
              // device creates/updates/deletes a project!
            );
          },
        ),
        loading: () => CircularProgressIndicator(),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }
}
```

### Example 4: Manual Start/Stop

```dart
class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realtimeState = ref.watch(realtimeSyncProvider);

    return Switch(
      value: realtimeState.isConnected,
      onChanged: (enabled) {
        if (enabled) {
          ref.read(realtimeSyncProvider.notifier).startListening();
        } else {
          ref.read(realtimeSyncProvider.notifier).stopListening();
        }
      },
    );
  }
}
```

---

## UI Components

### 1. Realtime Status Indicator

Shows connection status in your app bar:

```dart
AppBar(
  title: Text('My App'),
  actions: [
    RealtimeStatusIndicator(), // Shows green dot when connected
  ],
)
```

**Variants:**

```dart
// With label
RealtimeStatusIndicator(showLabel: true)  // "Live"

// Compact (just icon)
RealtimeStatusIndicator(compact: true)
```

### 2. Connection Banner

Shows a banner when connection is lost:

```dart
Scaffold(
  appBar: AppBar(...),
  body: Column(
    children: [
      RealtimeConnectionBanner(), // Shows only when disconnected
      Expanded(child: YourContent()),
    ],
  ),
)
```

### 3. Toggle Button

Button to manually start/stop realtime sync:

```dart
AppBar(
  actions: [
    RealtimeSyncButton(), // Toggle realtime on/off
  ],
)
```

### 4. Status Card

Detailed status for settings/debug screens:

```dart
// In your settings screen
RealtimeStatusCard()
```

Shows:
- Connection status
- Active collections
- Connection duration
- Start/Stop button

---

## Best Practices

### 1. Start After Authentication

```dart
// ✅ Good
await login();
await ref.read(realtimeSyncProvider.notifier).startListening();

// ❌ Bad - will fail without auth token
await ref.read(realtimeSyncProvider.notifier).startListening();
await login();
```

### 2. Stop on Logout

```dart
Future<void> logout() async {
  // Stop realtime first
  ref.read(realtimeSyncProvider.notifier).stopListening();

  // Then clear auth
  await ApiClient.clearToken();
}
```

### 3. Handle Connection Loss Gracefully

```dart
final realtimeState = ref.watch(realtimeSyncProvider);

if (realtimeState.hasError) {
  // App still works, just not live
  showSnackBar('Real-time updates temporarily unavailable');
}

// Your UI continues to work with local data
```

### 4. Combine with Manual Sync

```dart
// Realtime for instant updates
ref.read(realtimeSyncProvider.notifier).startListening();

// Manual sync as backup/initial load
await ref.read(syncCoordinatorProvider).syncAll();
```

### 5. Battery Considerations

Realtime uses an open HTTP connection, which can affect battery:

```dart
// Option 1: Allow users to disable it
Settings(
  child: Switch(
    label: 'Real-time sync',
    value: realtimeEnabled,
    subtitle: 'May affect battery life',
  ),
)

// Option 2: Auto-disable when battery is low
if (batteryLevel < 20) {
  ref.read(realtimeSyncProvider.notifier).stopListening();
}

// Option 3: Only enable for important screens
@override
void initState() {
  ref.read(realtimeSyncProvider.notifier).startListening();
}

@override
void dispose() {
  ref.read(realtimeSyncProvider.notifier).stopListening();
  super.dispose();
}
```

---

## Troubleshooting

### Connection Not Establishing

**Check:**

1. **Auth token is valid**
   ```dart
   final token = await ApiClient.getToken();
   print('Token: $token'); // Should not be null
   ```

2. **PocketBase server is running**
   ```bash
   # Check if server is accessible
   curl http://localhost:8090/api/health
   ```

3. **Correct base URL**
   ```dart
   print(AppConfig.apiBaseUrl); // Should point to your PocketBase server
   ```

### Events Not Received

**Check:**

1. **Collection name is correct**
   ```dart
   // ✅ Correct
   realtimeService.subscribe('projects')

   // ❌ Wrong - doesn't match PocketBase collection
   realtimeService.subscribe('project')
   ```

2. **User has read permissions**
   - In PocketBase admin, check collection rules
   - User must have read access to receive updates

3. **Check logs**
   ```dart
   LoggingService.debug('Subscribed to projects');
   // Look for connection errors
   ```

### Frequent Disconnects

**Possible causes:**

1. **Network issues** - Check connection stability
2. **Token expiration** - Refresh token periodically
3. **Server restarts** - Normal, will auto-reconnect

**Solution:** The service auto-reconnects after 5 seconds

### High Battery Usage

**Solutions:**

1. **Selective subscriptions**
   ```dart
   // Instead of subscribing to all collections
   // Only subscribe when viewing relevant screens
   ```

2. **Manual toggle**
   ```dart
   // Let users disable realtime in settings
   ```

3. **Adaptive behavior**
   ```dart
   // Disable on low battery or background
   ```

---

## Advanced Usage

### Custom Event Handlers

```dart
class CustomRealtimeHandler extends RealtimeSyncNotifier {
  @override
  void _handleProjectUpsert(Map<String, dynamic> data) {
    // Custom logic before updating database
    LoggingService.info('Custom project handler', data: data);

    // Call parent
    super._handleProjectUpsert(data);

    // Custom logic after
    _notifyUser('Project updated!');
  }
}
```

### Filtering Events

```dart
realtimeService.subscribe('projects').listen((event) {
  // Only handle events for active projects
  if (event.record?['status'] == 'active') {
    handleProjectUpdate(event);
  }
});
```

### Optimistic Updates with Realtime Confirmation

```dart
// 1. Update UI immediately (optimistic)
setState(() {
  project.name = newName;
});

// 2. Save to local database
await projectRepo.updateProject(...);

// 3. Send to server
await projectService.updateProject(...);

// 4. Realtime confirms the change
// (If it fails, realtime won't send event, and you can rollback)
```

---

## Summary

### Quick Start Checklist

- [x] Install dependencies (`http` package)
- [x] Initialize realtime after login
- [x] Add `RealtimeStatusIndicator` to your app bar
- [x] Stop realtime on logout
- [x] Handle connection loss gracefully
- [x] Test with multiple devices

### Key Files

- `lib/services/pocketbase_realtime_service.dart` - Core SSE service
- `lib/providers/realtime_provider.dart` - Riverpod integration
- `lib/widgets/common/realtime_status_indicator.dart` - UI components

### Benefits You Get

✅ Instant multi-device sync
✅ Collaborative features ready
✅ No polling overhead
✅ Automatic reconnection
✅ Battery efficient
✅ Production ready

---

## Next Steps

1. **Test with multiple devices**
   - Open app on two devices
   - Create a project on one
   - Watch it appear instantly on the other

2. **Add more collections**
   - Expenses, Incomes, Payments, etc.
   - Follow the pattern in `realtime_provider.dart`

3. **Customize UI**
   - Add your own realtime indicators
   - Show toast notifications on updates

4. **Monitor performance**
   - Use LoggingService to track events
   - Monitor battery usage
   - Check network traffic

Happy coding! 🚀

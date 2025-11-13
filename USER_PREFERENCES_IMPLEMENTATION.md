# User Preferences Implementation

This document describes the user preferences system implemented in BillKeep.

## Overview

The user preferences system provides:
- **Local storage** using SharedPreferences for offline access
- **Backend synchronization** via API for cross-device sync
- **Riverpod integration** for reactive state management
- **Automatic loading** during app initialization

## Files Created/Modified

### New Files

1. **`lib/services/user_preferences_service.dart`**
   - Core service managing both local storage and backend API
   - Handles CRUD operations for user preferences
   - Provides sync methods (to backend, from backend, full sync)

2. **`lib/providers/user_preferences_provider.dart`**
   - Riverpod providers for all preference values
   - `loadPreferencesProvider` - FutureProvider that loads preferences on startup
   - Individual StateProviders for each preference type
   - `UserPreferencesNotifier` for managing preferences with auto-save

3. **`lib/examples/user_preferences_example.dart`**
   - Example widget demonstrating usage
   - Shows how to read/write preferences
   - Demonstrates sync functionality

### Modified Files

1. **`lib/main.dart`**
   - Added import for `user_preferences_provider.dart`
   - Added `await ref.read(loadPreferencesProvider.future)` in `_initializeApp()`
   - Loads preferences during app initialization

2. **`lib/providers/currency_provider.dart`**
   - Added import for `user_preferences_provider.dart`
   - Added `defaultCurrencyObjectProvider` to get the Currency object based on user's default preference

## Available Preferences

The following preferences are available:

| Preference | Type | Default | Description |
|------------|------|---------|-------------|
| `defaultCurrency` | String | 'USD' | User's default currency code |
| `themeMode` | String | 'system' | Theme mode (light/dark/system) |
| `language` | String | 'en' | App language code |
| `notificationsEnabled` | bool | true | Push notifications enabled |
| `biometricEnabled` | bool | false | Biometric authentication enabled |
| `autoBackupEnabled` | bool | false | Automatic backup enabled |
| `budgetAlertEnabled` | bool | true | Budget alerts enabled |
| `expenseReminderEnabled` | bool | false | Expense reminders enabled |
| `dateFormat` | String | 'MM/dd/yyyy' | Date format preference |
| `timeFormat` | String | '12h' | Time format (12h/24h) |

## Usage Examples

### Reading Preferences

```dart
// Using Riverpod providers
final defaultCurrency = ref.watch(defaultCurrencyProvider);
final themeMode = ref.watch(themeModeProvider);
final notificationsEnabled = ref.watch(notificationsEnabledProvider);

// Get the full Currency object based on default preference
final currencyObject = ref.watch(defaultCurrencyObjectProvider);
```

### Updating Preferences

```dart
// Update provider state
ref.read(defaultCurrencyProvider.notifier).state = 'EUR';

// Also save to SharedPreferences
await ref.read(userPreferencesServiceProvider).setDefaultCurrency('EUR');

// Or use the UserPreferencesNotifier for automatic save
final prefsNotifier = ref.read(userPreferencesNotifierProvider.notifier);
await prefsNotifier.setDefaultCurrency('EUR');
```

### Syncing with Backend

```dart
final prefsNotifier = ref.read(userPreferencesNotifierProvider.notifier);

// Sync local preferences to backend
await prefsNotifier.syncToBackend(userId);

// Sync backend preferences to local
await prefsNotifier.syncFromBackend(userId);

// Full bidirectional sync
await prefsNotifier.performFullSync(userId);
```

### During App Initialization

Preferences are automatically loaded during app startup in `main.dart`:

```dart
Future<void> _initializeApp() async {
  // ... other initialization code ...

  // Load user preferences from SharedPreferences into Riverpod providers
  await ref.read(loadPreferencesProvider.future);

  // ... rest of initialization ...
}
```

## Backend API Endpoints

The service expects the following API endpoints:

- `GET /user_preferences/records?filter=user="userId"` - Fetch user preferences
- `POST /user_preferences/records` - Create new preferences
- `PATCH /user_preferences/records/{recordId}` - Update preferences
- `DELETE /user_preferences/records/{recordId}` - Delete preferences

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         App Startup                         │
│  (main.dart - _initializeApp loads preferences into state)  │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                  Riverpod State Providers                   │
│   (user_preferences_provider.dart - reactive state)         │
│   - defaultCurrencyProvider                                 │
│   - themeModeProvider                                       │
│   - languageProvider, etc.                                  │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              UserPreferencesService                         │
│   (user_preferences_service.dart)                           │
│   ┌─────────────────────┬─────────────────────┐            │
│   │  SharedPreferences  │      ApiClient      │            │
│   │  (Local Storage)    │   (Backend Sync)    │            │
│   └─────────────────────┴─────────────────────┘            │
└─────────────────────────────────────────────────────────────┘
```

## Best Practices

1. **Always save to both provider and SharedPreferences** when updating preferences
2. **Use the UserPreferencesNotifier** for automatic save functionality
3. **Sync with backend** after significant preference changes
4. **Handle sync errors gracefully** - local preferences remain even if sync fails
5. **Validate userId** before syncing to ensure proper user data isolation

## Future Enhancements

- Add conflict resolution for sync conflicts
- Implement offline queue for failed syncs
- Add preference change listeners/callbacks
- Support for user-specific preference schemas
- Preference versioning for migration support

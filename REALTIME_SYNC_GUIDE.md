# 🔄 Simple Realtime Sync Implementation Guide

## 🎯 Goal
Implement realtime sync directly in each service with proper subscription management.

---

## ✅ Solution Pattern

### **1. Service with Realtime Sync**

```dart
import 'package:pocketbase/pocketbase.dart';
import '../config/app_config.dart';

class YourService extends BaseApiService {
  final YourRepository _repository;
  
  // PocketBase instance
  late final PocketBase _pb;
  
  // Track subscriptions to prevent duplicates
  final Map<String, UnsubscribeFunc> _subscriptions = {};
  
  YourService(this._repository) {
    _pb = PocketBase(AppConfig.pocketbaseUrl);
    _setupRealtimeSync();
  }

  /// Setup realtime sync - only subscribes once
  void _setupRealtimeSync() {
    if (_subscriptions.containsKey('your_collection')) {
      print('ℹ️ Already subscribed to your_collection');
      return;
    }

    try {
      _pb.collection('your_collection').subscribe('*', (event) async {
        final unsubscribe = await _pb.collection('your_collection')
            .subscribe('*', _handleRealtimeUpdate);
        
        _subscriptions['your_collection'] = unsubscribe;
        print('✅ Subscribed to your_collection');
      });
    } catch (e) {
      print('⚠️ Realtime sync setup failed: $e');
      // Non-critical - app still works
    }
  }

  /// Handle realtime updates
  void _handleRealtimeUpdate(RecordSubscriptionEvent event) {
    print('🔄 ${event.action} ${event.record?.id}');

    try {
      switch (event.action) {
        case 'create':
        case 'update':
          if (event.record != null) {
            _syncFromBackend(event.record!);
          }
          break;
        case 'delete':
          if (event.record != null) {
            _handleDelete(event.record!);
          }
          break;
      }
    } catch (e) {
      print('❌ Error handling update: $e');
    }
  }

  /// Sync data from backend to local DB
  Future<void> _syncFromBackend(RecordModel record) async {
    final canonicalId = record.id;
    final tempId = record.getStringValue('tempId');
    
    // Your sync logic here
    // Update local DB with canonical ID
  }

  /// Handle deletion
  Future<void> _handleDelete(RecordModel record) async {
    await _repository.delete(record.id);
  }

  /// Dispose and cleanup subscriptions
  void dispose() {
    print('🗑️ Disposing service - ${_subscriptions.length} subscriptions');
    
    for (final unsubscribe in _subscriptions.values) {
      unsubscribe();
    }
    _subscriptions.clear();
  }
}
```

---

## 📦 Provider with Proper Disposal

```dart
final yourServiceProvider = Provider.autoDispose((ref) {
  final repository = ref.watch(yourRepositoryProvider);
  final service = YourService(repository);
  
  // Cleanup when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});
```

---

## 🎨 Complete Examples

### **WalletService**

```dart
class WalletService extends BaseApiService {
  final WalletRepository _repository;
  late final PocketBase _pb;
  final Map<String, UnsubscribeFunc> _subscriptions = {};

  WalletService(this._repository) {
    _pb = PocketBase(AppConfig.pocketbaseUrl);
    _initRealtimeSync();
  }

  Future<void> _initRealtimeSync() async {
    if (_subscriptions.containsKey('wallets')) return;

    try {
      final unsubscribe = await _pb
          .collection('wallets')
          .subscribe('*', _handleWalletUpdate);
      
      _subscriptions['wallets'] = unsubscribe;
      print('✅ Wallet realtime sync active');
    } catch (e) {
      print('⚠️ Wallet sync failed: $e');
    }
  }

  void _handleWalletUpdate(RecordSubscriptionEvent e) {
    switch (e.action) {
      case 'create':
      case 'update':
        if (e.record != null) _syncWallet(e.record!);
        break;
      case 'delete':
        if (e.record != null) _repository.deleteWallet(e.record!.id);
        break;
    }
  }

  Future<void> _syncWallet(RecordModel record) async {
    final canonicalId = record.id;
    final tempId = record.getStringValue('tempId');
    
    final local = await _repository.getWalletByTempId(tempId);
    if (local != null && local.id != canonicalId) {
      await _repository.updateWalletId(
        oldId: local.id,
        newId: canonicalId,
      );
      print('✅ Wallet synced: $tempId → $canonicalId');
    }
  }

  void dispose() {
    for (final unsubscribe in _subscriptions.values) {
      unsubscribe();
    }
    _subscriptions.clear();
  }
}
```

### **Provider**

```dart
final walletServiceProvider = Provider.autoDispose((ref) {
  final repository = ref.watch(walletRepositoryProvider);
  final service = WalletService(repository);
  
  ref.onDispose(() => service.dispose());
  
  return service;
});
```

---

## 🛡️ Safety Checklist

### ✅ Prevents Multiple Subscriptions
- Track subscriptions in Map
- Check before subscribing
- Each collection subscribed only once

### ✅ Proper Cleanup
- Store UnsubscribeFunc for each subscription
- Call all unsubscribe functions in dispose()
- Use Provider.autoDispose + ref.onDispose()

### ✅ Error Handling
- Try-catch around subscribe()
- Non-blocking if realtime fails
- App works without realtime

---

## 📊 Benefits

| Aspect | Value |
|--------|-------|
| **Simplicity** | ✅ Direct, easy to understand |
| **Safety** | ✅ Proper disposal, no leaks |
| **Prevention** | ✅ No duplicate subscriptions |
| **Auto-start** | ✅ Works on service creation |
| **Auto-stop** | ✅ Cleans up automatically |
| **Lines of code** | ~30 per service |

---

## 🚀 Implementation Steps

1. **Add to each service:**
   - PocketBase instance
   - Subscriptions Map
   - _setupRealtimeSync() method
   - dispose() method

2. **Update providers:**
   - Use Provider.autoDispose
   - Add ref.onDispose(service.dispose)

3. **Remove old infrastructure:**
   - Delete lib/services/sync/ folder
   - Remove RealtimeSyncService
   - Remove SyncCoordinator

4. **Test:**
   - Create record → Check console for sync
   - Restart app → Should auto-subscribe
   - Check for memory leaks

---

## 🧪 Testing

```dart
// Check active subscriptions
print('Active subscriptions: ${service._subscriptions.length}');

// Verify no duplicates
service._setupRealtimeSync();  // Should print "Already subscribed"

// Test disposal
service.dispose();
print('After dispose: ${service._subscriptions.length}');  // Should be 0
```

---

## 📝 Services to Update

- [ ] wallet_service.dart
- [ ] project_service.dart
- [ ] currency_service.dart  
- [ ] expense_service.dart (if exists)
- [ ] transaction_service.dart (if exists)
- [ ] category_service.dart (if exists)

---

**Simple, safe, and effective! 🎉**

import 'package:billkeep/database/database.dart';
import 'package:billkeep/repositories/wallet_repository.dart';
import 'package:billkeep/services/api_client.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:billkeep/models/wallet_model.dart';
import 'package:billkeep/utils/connectivity_helper.dart';
import 'base_api_service.dart';

class WalletService extends BaseApiService {
  final WalletRepository _repository;

  WalletService(this._repository) {
    _setupRealtimeSync();
  }

  /// Setup realtime sync for wallets collection
  void _setupRealtimeSync() {
    subscribeToCollection('wallets', _handleWalletUpdate);
  }

  /// Handle realtime updates from PocketBase
  void _handleWalletUpdate(RecordSubscriptionEvent event) async {
    print('🔄 Wallet ${event.action}: ${event.record?.id}');
    final user = await ApiClient.getUser();
    if (event.record?.user == null) {
      print('Event data is not for a user');
      return;
    }
    if (event.record?.user != user?.id) {
      print('Event is not for this user');
      return;
    }
    try {
      switch (event.action) {
        case 'create':
        case 'update':
          if (event.record != null) {
            _syncWalletFromBackend(event.record!, event.action);
          }
          break;
        case 'delete':
          if (event.record != null) {
            _repository.deleteWallet(event.record!.id);
          }
          break;
      }
    } catch (e) {
      print('❌ Error handling wallet update: $e');
    }
  }

  /// Sync wallet from backend to local DB
  Future<void> _syncWalletFromBackend(RecordModel record, String action) async {
    try {
      final canonicalId = record.id;
      final tempId = record.getStringValue('tempId');

      print('📥 Syncing wallet: tempId=$tempId → canonicalId=$canonicalId');
      // TODO: handle realtime event
      // Find local wallet by tempId
      final localWallet = await _repository.getWalletByTempId(tempId: tempId);
      if (action == 'create') {
        if (localWallet != null && localWallet.id != canonicalId) {
          // Update with canonical ID from server
          await _repository.updateWalletWithCanonicalId(
            tempId: tempId,
            canonicalId: canonicalId,
          );
          print('✅ Wallet synced successfully');
        }
        if (localWallet == null) {
          final newWallet = WalletModel.fromJson(
            record as Map<String, dynamic>,
          );
          await _repository.createWallet(newWallet);
        }
      }
    } catch (e) {
      print('⚠️ Error syncing wallet: $e');
    }
  }

  /// Create a new wallet
  ///
  /// Local-first approach:
  /// 1. Create in local database first (optimistic update)
  /// 2. Sync with backend if online
  /// 3. Realtime sync will update with canonical ID when backend confirms
  Future<WalletModel> createWallet(WalletModel newWalletData) async {
    // 1. Create in local database first (optimistic)
    final tempId = await _repository.createWallet(newWalletData);

    // 2. Check connectivity and send to backend if online
    final isOnline = await ConnectivityHelper.hasInternetConnection();

    if (isOnline) {
      try {
        final apiWallet = await executeRequest<WalletModel>(
          request: () => dio.post(
            '/wallets/records',
            data: newWalletData.toJson()..['tempId'] = tempId,
          ),
          parser: (data) => WalletModel.fromJson(data),
        );

        // Realtime sync service will handle updating local DB with canonical ID
        return apiWallet;
      } catch (e) {
        // Mark it for later sync
        print('API call failed, wallet saved locally: $e');
      }
    }

    // Return local wallet (offline or API failed)
    final localWallet = await _repository.getWalletByTempId(tempId: tempId);
    if (localWallet != null) {
      return WalletModel.fromDrift(localWallet);
    }

    throw Exception('Failed to create wallet locally');
  }

  /// Get all wallets (local-first)
  ///
  /// Reads from local database for instant results.
  /// Background sync keeps data fresh via realtime updates.
  Future<List<WalletModel>> getAllWallets({
    String? walletType,
    String? currency,
    bool? isGlobal,
  }) async {
    // Read from local database (fast, works offline)
    List<Wallet> wallets = await _repository.getAllWallets();

    // Apply filters if specified
    if (walletType != null) {
      wallets = wallets.where((w) => w.walletType == walletType).toList();
    }
    if (currency != null) {
      wallets = wallets.where((w) => w.currency == currency).toList();
    }
    if (isGlobal != null) {
      wallets = wallets.where((w) => w.isGlobal == isGlobal).toList();
    }

    // Convert to models
    return wallets.map((w) => WalletModel.fromDrift(w)).toList();
  }

  /// Get a single wallet by ID (local-first)
  ///
  /// Reads from local database for instant results.
  Future<WalletModel?> getWalletById(String id) async {
    final wallet = await _repository.getWallet(id);
    return wallet != null ? WalletModel.fromDrift(wallet) : null;
  }

  /// Update an existing wallet (local-first)
  ///
  /// Local-first approach:
  /// 1. Update local database first (optimistic update)
  /// 2. Sync with backend if online
  /// 3. Realtime sync will handle conflicts if any
  Future<WalletModel> updateWallet(WalletModel updatedWallet) async {
    // Validate that wallet has an ID
    if (updatedWallet.id == null) {
      throw ArgumentError('Cannot update wallet without an ID');
    }

    // 1. Update local database first (optimistic) - clean and simple!
    await _repository.updateWallet(updatedWallet);

    // 2. Check connectivity and send to backend if online
    final isOnline = await ConnectivityHelper.hasInternetConnection();

    if (isOnline) {
      try {
        final apiWallet = await executeRequest<WalletModel>(
          request: () => dio.put(
            '/wallets/records/${updatedWallet.id}',
            data: updatedWallet.toJson(),
          ),
          parser: (data) => WalletModel.fromJson(data),
        );

        // Realtime sync will handle any conflicts
        return apiWallet;
      } catch (e) {
        print('API call failed, wallet updated locally: $e');
      }
    }

    // Return updated local wallet (offline or API failed)
    final localWallet = await _repository.getWallet(updatedWallet.id!);
    if (localWallet != null) {
      return WalletModel.fromDrift(localWallet);
    }

    throw Exception('Failed to retrieve updated wallet from local database');
  }

  /// Delete a wallet (local-first)
  ///
  /// Local-first approach:
  /// 1. Delete from local database first
  /// 2. Sync deletion with backend if online
  /// 3. Realtime sync will handle confirmation
  Future<void> deleteWallet(String id) async {
    // 1. Delete from local database first
    await _repository.deleteWallet(id);

    // 2. Check connectivity and send to backend if online
    final isOnline = await ConnectivityHelper.hasInternetConnection();

    if (isOnline) {
      try {
        await executeVoidRequest(
          request: () => dio.delete('/wallets/records/$id'),
        );
        print('✅ Wallet deleted from backend');
      } catch (e) {
        // Local delete succeeded, but API failed
        // Mark for deletion sync later if needed
        print('⚠️ Wallet deleted locally, backend sync failed: $e');
      }
    } else {
      print('📴 Wallet deleted locally (offline)');
    }
  }
}

extension on RecordModel? {
  String? get user => null;
}

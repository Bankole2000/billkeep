import 'package:billkeep/database/database.dart';
import '../models/wallet_model.dart';
import '../providers/wallet_provider.dart';
import '../utils/connectivity_helper.dart';
import 'base_api_service.dart';

class WalletService extends BaseApiService {
  final WalletRepository _repository;

  WalletService(this._repository);
  /// Create a new wallet
  ///
  /// Local-first approach:
  /// 1. Create in local DB first with temp ID
  /// 2. Check connectivity and send to backend if online
  /// 3. Realtime sync will update with canonical ID when backend confirms
  Future<WalletModel> createWallet({
    required String name,
    required String userId,
    required String walletType,
    required Currency currency,
    required int balance,
    String? imageUrl,
    String? providerId,
    String? localImagePath,
    bool? isGlobal,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
  }) async {
    // 1. Create in local database first (optimistic)
    final tempId = await _repository.createWallet(
      name: name,
      walletType: walletType,
      currency: currency.code,
      balance: balance.toString(),
      providerId: providerId,
      imageUrl: imageUrl,
      localImagePath: localImagePath,
      isGlobal: isGlobal ?? true,
      iconCodePoint: iconCodePoint,
      iconEmoji: iconEmoji,
      iconType: iconType,
      color: color,
    );

    // 2. Check connectivity and send to backend if online
    final isOnline = await ConnectivityHelper.hasInternetConnection();

    if (isOnline) {
      try {
        final apiWallet = await executeRequest<WalletModel>(
          request: () => dio.post(
            '/wallets/records',
            data: {
              'name': name,
              'walletType': walletType,
              'currency': currency.code,
              'balance': balance,
              'imageUrl': imageUrl,
              'providerId': providerId,
              'localImagePath': localImagePath,
              'isGlobal': isGlobal,
              'iconCodePoint': iconCodePoint,
              'iconEmoji': iconEmoji,
              'iconType': iconType,
              'color': color,
              'user': userId,
            },
          ),
          parser: (data) => WalletModel.fromJson(data),
        );

        // Note: Realtime sync service will handle updating local DB with canonical ID
        // But we return the API response immediately
        return apiWallet;
      } catch (e) {
        // If API fails, we still have local copy
        // Mark it for later sync
        print('API call failed, wallet saved locally: $e');

        // Get the local wallet to return
        final localWallet = await _repository.getWallet(tempId);
        if (localWallet != null) {
          return WalletModel(
            id: localWallet.id,
            name: localWallet.name,
            walletType: localWallet.walletType,
            currency: localWallet.currency,
            balance: localWallet.balance,
            imageUrl: localWallet.imageUrl,
            providerId: localWallet.providerId,
            localImagePath: localWallet.localImagePath,
            isGlobal: localWallet.isGlobal,
            iconCodePoint: localWallet.iconCodePoint,
            iconEmoji: localWallet.iconEmoji,
            iconType: localWallet.iconType,
            color: localWallet.color,
            tempId: localWallet.tempId,
            isSynced: localWallet.isSynced,
            createdAt: localWallet.createdAt,
            updatedAt: localWallet.updatedAt,
          );
        }
        rethrow;
      }
    } else {
      // Offline: return local wallet
      final localWallet = await _repository.getWallet(tempId);
      if (localWallet != null) {
        return WalletModel(
          id: localWallet.id,
          name: localWallet.name,
          walletType: localWallet.walletType,
          currency: localWallet.currency,
          balance: localWallet.balance,
          imageUrl: localWallet.imageUrl,
          providerId: localWallet.providerId,
          localImagePath: localWallet.localImagePath,
          isGlobal: localWallet.isGlobal,
          iconCodePoint: localWallet.iconCodePoint,
          iconEmoji: localWallet.iconEmoji,
          iconType: localWallet.iconType,
          color: localWallet.color,
          tempId: localWallet.tempId,
          isSynced: localWallet.isSynced,
          createdAt: localWallet.createdAt,
          updatedAt: localWallet.updatedAt,
        );
      }
      throw Exception('Failed to create wallet locally');
    }
  }

  /// Get all wallets
  Future<List<WalletModel>> getAllWallets({
    String? walletType,
    String? currency,
    bool? isGlobal,
    int? page,
    int? limit,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (walletType != null) queryParameters['walletType'] = walletType;
    if (currency != null) queryParameters['currency'] = currency;
    if (isGlobal != null) queryParameters['isGlobal'] = isGlobal;
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;

    return executeListRequest<WalletModel>(
      request: () => dio.get(
        '/wallets',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => WalletModel.fromJson(json),
    );
  }

  /// Get a single wallet by ID
  Future<WalletModel> getWalletById(String id) async {
    return executeRequest<WalletModel>(
      request: () => dio.get('/wallets/$id'),
      parser: (data) => WalletModel.fromJson(data),
    );
  }

  /// Update an existing wallet
  Future<WalletModel> updateWallet({
    required String id,
    String? name,
    String? walletType,
    String? currency,
    int? balance,
    String? imageUrl,
    String? providerId,
    String? localImagePath,
    bool? isGlobal,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (walletType != null) data['walletType'] = walletType;
    if (currency != null) data['currency'] = currency;
    if (balance != null) data['balance'] = balance;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (providerId != null) data['providerId'] = providerId;
    if (localImagePath != null) data['localImagePath'] = localImagePath;
    if (isGlobal != null) data['isGlobal'] = isGlobal;
    if (iconCodePoint != null) data['iconCodePoint'] = iconCodePoint;
    if (iconEmoji != null) data['iconEmoji'] = iconEmoji;
    if (iconType != null) data['iconType'] = iconType;
    if (color != null) data['color'] = color;

    return executeRequest<WalletModel>(
      request: () => dio.put('/wallets/$id', data: data),
      parser: (data) => WalletModel.fromJson(data),
    );
  }

  /// Delete a wallet
  Future<void> deleteWallet(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/wallets/$id'),
    );
  }
}

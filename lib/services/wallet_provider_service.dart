import '../models/wallet_provider_model.dart';
import 'base_api_service.dart';

class WalletProviderService extends BaseApiService {
  /// Create a new wallet provider
  Future<WalletProviderModel> createWalletProvider({
    required String name,
    String? description,
    String? imageUrl,
    String? localImagePath,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    String? websiteUrl,
    bool? isFiatBank,
    bool? isCrypto,
    bool? isMobileMoney,
    bool? isCreditCard,
    bool? isDefault,
  }) async {
    return executeRequest<WalletProviderModel>(
      request: () => dio.post(
        '/wallet-providers',
        data: {
          'name': name,
          'description': description,
          'imageUrl': imageUrl,
          'localImagePath': localImagePath,
          'iconCodePoint': iconCodePoint,
          'iconEmoji': iconEmoji,
          'iconType': iconType,
          'color': color,
          'websiteUrl': websiteUrl,
          'isFiatBank': isFiatBank,
          'isCrypto': isCrypto,
          'isMobileMoney': isMobileMoney,
          'isCreditCard': isCreditCard,
          'isDefault': isDefault,
        },
      ),
      parser: (data) => WalletProviderModel.fromJson(data),
    );
  }

  /// Get all wallet providers
  Future<List<WalletProviderModel>> getAllWalletProviders({
    bool? isFiatBank,
    bool? isCrypto,
    bool? isMobileMoney,
    bool? isCreditCard,
    bool? isDefault,
    int? page,
    int? limit,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (isFiatBank != null) queryParameters['isFiatBank'] = isFiatBank;
    if (isCrypto != null) queryParameters['isCrypto'] = isCrypto;
    if (isMobileMoney != null) {
      queryParameters['isMobileMoney'] = isMobileMoney;
    }
    if (isCreditCard != null) queryParameters['isCreditCard'] = isCreditCard;
    if (isDefault != null) queryParameters['isDefault'] = isDefault;
    if (page != null) queryParameters['page'] = page;
    if (limit != null) queryParameters['limit'] = limit;

    return executeListRequest<WalletProviderModel>(
      request: () => dio.get(
        '/wallet-providers',
        queryParameters: queryParameters,
      ),
      itemParser: (json) => WalletProviderModel.fromJson(json),
    );
  }

  /// Get a single wallet provider by ID
  Future<WalletProviderModel> getWalletProviderById(String id) async {
    return executeRequest<WalletProviderModel>(
      request: () => dio.get('/wallet-providers/$id'),
      parser: (data) => WalletProviderModel.fromJson(data),
    );
  }

  /// Update an existing wallet provider
  Future<WalletProviderModel> updateWalletProvider({
    required String id,
    String? name,
    String? description,
    String? imageUrl,
    String? localImagePath,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    String? websiteUrl,
    bool? isFiatBank,
    bool? isCrypto,
    bool? isMobileMoney,
    bool? isCreditCard,
    bool? isDefault,
  }) async {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (localImagePath != null) data['localImagePath'] = localImagePath;
    if (iconCodePoint != null) data['iconCodePoint'] = iconCodePoint;
    if (iconEmoji != null) data['iconEmoji'] = iconEmoji;
    if (iconType != null) data['iconType'] = iconType;
    if (color != null) data['color'] = color;
    if (websiteUrl != null) data['websiteUrl'] = websiteUrl;
    if (isFiatBank != null) data['isFiatBank'] = isFiatBank;
    if (isCrypto != null) data['isCrypto'] = isCrypto;
    if (isMobileMoney != null) data['isMobileMoney'] = isMobileMoney;
    if (isCreditCard != null) data['isCreditCard'] = isCreditCard;
    if (isDefault != null) data['isDefault'] = isDefault;

    return executeRequest<WalletProviderModel>(
      request: () => dio.put('/wallet-providers/$id', data: data),
      parser: (data) => WalletProviderModel.fromJson(data),
    );
  }

  /// Delete a wallet provider
  Future<void> deleteWalletProvider(String id) async {
    return executeVoidRequest(
      request: () => dio.delete('/wallet-providers/$id'),
    );
  }
}

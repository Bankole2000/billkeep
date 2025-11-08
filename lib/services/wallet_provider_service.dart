import 'package:dio/dio.dart';
import '../models/wallet_provider_model.dart';
import 'api_client.dart';

class WalletProviderService {
  final ApiClient _apiClient;

  WalletProviderService() : _apiClient = ApiClient();

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
    try {
      final response = await _apiClient.dio.post(
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
      );

      return WalletProviderModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
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
    try {
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

      final response = await _apiClient.dio.get(
        '/wallet-providers',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((provider) => WalletProviderModel.fromJson(provider))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((provider) => WalletProviderModel.fromJson(provider))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single wallet provider by ID
  Future<WalletProviderModel> getWalletProviderById(String id) async {
    try {
      final response = await _apiClient.dio.get('/wallet-providers/$id');
      return WalletProviderModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
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
    try {
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

      final response =
          await _apiClient.dio.put('/wallet-providers/$id', data: data);
      return WalletProviderModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a wallet provider
  Future<void> deleteWalletProvider(String id) async {
    try {
      await _apiClient.dio.delete('/wallet-providers/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle DioException and return appropriate error message
  String _handleError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      switch (statusCode) {
        case 400:
          return data['message'] ?? 'Bad request';
        case 401:
          return data['message'] ?? 'Unauthorized';
        case 403:
          return data['message'] ?? 'Forbidden';
        case 404:
          return data['message'] ?? 'Wallet provider not found';
        case 409:
          return data['message'] ?? 'Conflict';
        case 500:
          return 'Internal server error';
        default:
          return data['message'] ?? 'An error occurred';
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection';
    } else {
      return error.message ?? 'An unexpected error occurred';
    }
  }
}

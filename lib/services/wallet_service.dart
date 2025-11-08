import 'package:dio/dio.dart';
import '../models/wallet_model.dart';
import 'api_client.dart';

class WalletService {
  final ApiClient _apiClient;

  WalletService() : _apiClient = ApiClient();

  /// Create a new wallet
  Future<WalletModel> createWallet({
    required String name,
    required String walletType,
    required String currency,
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
    try {
      final response = await _apiClient.dio.post(
        '/wallets',
        data: {
          'name': name,
          'walletType': walletType,
          'currency': currency,
          'balance': balance,
          'imageUrl': imageUrl,
          'providerId': providerId,
          'localImagePath': localImagePath,
          'isGlobal': isGlobal,
          'iconCodePoint': iconCodePoint,
          'iconEmoji': iconEmoji,
          'iconType': iconType,
          'color': color,
        },
      );

      return WalletModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
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
    try {
      final queryParameters = <String, dynamic>{};

      if (walletType != null) queryParameters['walletType'] = walletType;
      if (currency != null) queryParameters['currency'] = currency;
      if (isGlobal != null) queryParameters['isGlobal'] = isGlobal;
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _apiClient.dio.get(
        '/wallets',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((wallet) => WalletModel.fromJson(wallet))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((wallet) => WalletModel.fromJson(wallet))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single wallet by ID
  Future<WalletModel> getWalletById(String id) async {
    try {
      final response = await _apiClient.dio.get('/wallets/$id');
      return WalletModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
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
    try {
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

      final response = await _apiClient.dio.put('/wallets/$id', data: data);
      return WalletModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a wallet
  Future<void> deleteWallet(String id) async {
    try {
      await _apiClient.dio.delete('/wallets/$id');
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
          return data['message'] ?? 'Wallet not found';
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

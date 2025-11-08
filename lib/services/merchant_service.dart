import 'package:dio/dio.dart';
import '../models/merchant_model.dart';
import 'api_client.dart';

class MerchantService {
  final ApiClient _apiClient;

  MerchantService() : _apiClient = ApiClient();

  /// Create a new merchant
  Future<MerchantModel> createMerchant({
    required String name,
    String? description,
    String? website,
    String? imageUrl,
    String? localImagePath,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    bool? isDefault,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/merchants',
        data: {
          'name': name,
          'description': description,
          'website': website,
          'imageUrl': imageUrl,
          'localImagePath': localImagePath,
          'iconCodePoint': iconCodePoint,
          'iconEmoji': iconEmoji,
          'iconType': iconType,
          'color': color,
          'isDefault': isDefault,
        },
      );

      return MerchantModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all merchants
  Future<List<MerchantModel>> getAllMerchants({
    bool? isDefault,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (isDefault != null) queryParameters['isDefault'] = isDefault;
      if (page != null) queryParameters['page'] = page;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _apiClient.dio.get(
        '/merchants',
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((merchant) => MerchantModel.fromJson(merchant))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((merchant) => MerchantModel.fromJson(merchant))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a single merchant by ID
  Future<MerchantModel> getMerchantById(String id) async {
    try {
      final response = await _apiClient.dio.get('/merchants/$id');
      return MerchantModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update an existing merchant
  Future<MerchantModel> updateMerchant({
    required String id,
    String? name,
    String? description,
    String? website,
    String? imageUrl,
    String? localImagePath,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    bool? isDefault,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (website != null) data['website'] = website;
      if (imageUrl != null) data['imageUrl'] = imageUrl;
      if (localImagePath != null) data['localImagePath'] = localImagePath;
      if (iconCodePoint != null) data['iconCodePoint'] = iconCodePoint;
      if (iconEmoji != null) data['iconEmoji'] = iconEmoji;
      if (iconType != null) data['iconType'] = iconType;
      if (color != null) data['color'] = color;
      if (isDefault != null) data['isDefault'] = isDefault;

      final response = await _apiClient.dio.put('/merchants/$id', data: data);
      return MerchantModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a merchant
  Future<void> deleteMerchant(String id) async {
    try {
      await _apiClient.dio.delete('/merchants/$id');
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
          return data['message'] ?? 'Merchant not found';
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

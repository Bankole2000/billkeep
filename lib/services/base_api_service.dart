import 'package:dio/dio.dart';
import 'api_client.dart';
import '../utils/exceptions.dart';

/// Base service class providing common API functionality and error handling
/// All API service classes should extend this to avoid code duplication
abstract class BaseApiService {
  final ApiClient _apiClient = ApiClient();

  /// Get the Dio instance for making requests
  Dio get dio => _apiClient.dio;

  /// Execute a request and parse the response
  ///
  /// This method handles DioExceptions and converts them to custom exceptions
  ///
  /// Usage:
  /// ```dart
  /// final result = await executeRequest<MyModel>(
  ///   request: () => dio.get('/endpoint'),
  ///   parser: (data) => MyModel.fromJson(data),
  /// );
  /// ```
  Future<T> executeRequest<T>({
    required Future<Response> Function() request,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await request();
      return parser(response.data);
    } on DioException catch (e) {
      throw _convertToAppException(e);
    }
  }

  /// Execute a request that returns a list
  ///
  /// Handles different response formats (direct list or nested in 'data' field)
  Future<List<T>> executeListRequest<T>({
    required Future<Response> Function() request,
    required T Function(Map<String, dynamic> json) itemParser,
  }) async {
    try {
      final response = await request();

      if (response.data is List) {
        return (response.data as List)
            .map((item) => itemParser(item as Map<String, dynamic>))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((item) => itemParser(item as Map<String, dynamic>))
            .toList();
      } else if (response.data is Map && response.data['items'] != null) {
        return (response.data['items'] as List)
            .map((item) => itemParser(item as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw _convertToAppException(e);
    }
  }

  /// Execute a request that doesn't return data (like DELETE)
  Future<void> executeVoidRequest({
    required Future<Response> Function() request,
  }) async {
    try {
      await request();
    } on DioException catch (e) {
      throw _convertToAppException(e);
    }
  }

  /// Convert DioException to appropriate AppException
  AppException _convertToAppException(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;
      final message = (data is Map) ? (data['message'] as String?) : null;

      switch (statusCode) {
        case 400:
          return ValidationException(
            message ?? 'Bad request',
            'Please check your input and try again',
          );
        case 401:
          return AuthenticationException(
            message ?? 'Unauthorized',
            'Please log in again',
          );
        case 403:
          return AuthorizationException(
            message ?? 'Forbidden',
            'You do not have permission to perform this action',
          );
        case 404:
          return NotFoundException(
            message ?? 'Resource not found',
            'The requested resource could not be found',
          );
        case 409:
          return ConflictException(
            message ?? 'Conflict',
            'This resource already exists or conflicts with existing data',
          );
        case 500:
        case 502:
        case 503:
          return ServerException(
            message ?? 'Internal server error',
            'Something went wrong on our end. Please try again later',
          );
        default:
          return NetworkException(
            message ?? 'An error occurred',
            'An unexpected error occurred. Please try again',
          );
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return NetworkException(
        'Connection timeout',
        'The request took too long. Please check your connection and try again',
      );
    } else if (error.type == DioExceptionType.connectionError) {
      return NetworkException(
        'No internet connection',
        'Please check your internet connection and try again',
      );
    } else {
      return NetworkException(
        error.message ?? 'An unexpected error occurred',
        'Something went wrong. Please try again',
      );
    }
  }
}

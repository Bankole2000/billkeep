import 'package:dio/dio.dart';
import 'package:pocketbase/pocketbase.dart';
import 'api_client.dart';
import '../config/app_config.dart';
import '../utils/exceptions.dart';

/// Base service class providing common API functionality and error handling
/// All API service classes should extend this to avoid code duplication
///
/// Now includes PocketBase realtime subscription management:
/// - Prevents duplicate subscriptions
/// - Proper cleanup on dispose
/// - Easy to use in child services
abstract class BaseApiService {
  final ApiClient _apiClient = ApiClient();
  late final PocketBase _pb;

  /// Track active subscriptions to prevent duplicates and enable cleanup
  final Map<String, UnsubscribeFunc> _subscriptions = {};
  bool _isDisposed = false;

  BaseApiService() {
    _pb = PocketBase(AppConfig.pocketbaseUrl);
  }

  /// Get the Dio instance for making requests
  Dio get dio => _apiClient.dio;

  /// Get the PocketBase instance for realtime subscriptions
  PocketBase get pb => _pb;

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

  // ========================================
  // REALTIME SUBSCRIPTION MANAGEMENT
  // ========================================

  /// Subscribe to a PocketBase collection
  ///
  /// Automatically prevents duplicate subscriptions
  /// Returns Future<bool> - true if subscribed, false if already subscribed
  ///
  /// Usage in child service:
  /// ```dart
  /// subscribeToCollection('wallets', _handleWalletUpdate);
  /// ```
  Future<bool> subscribeToCollection(
    String collectionName,
    void Function(RecordSubscriptionEvent) onEvent, {
    String? recordId,
  }) async {
    if (_isDisposed) {
      print('⚠️ Cannot subscribe - service is disposed');
      return false;
    }

    final subscriptionKey = recordId != null
        ? '$collectionName:$recordId'
        : collectionName;

    // Check if already subscribed
    if (_subscriptions.containsKey(subscriptionKey)) {
      print('ℹ️ Already subscribed to $subscriptionKey');
      return false;
    }

    try {
      // Subscribe and store the unsubscribe function
      final unsubscribe = await (recordId != null
          ? _pb.collection(collectionName).subscribe(recordId, onEvent)
          : _pb.collection(collectionName).subscribe('*', onEvent));

      _subscriptions[subscriptionKey] = unsubscribe;
      print('✅ Subscribed to $subscriptionKey');
      return true;
    } catch (e) {
      print('❌ Failed to subscribe to $subscriptionKey: $e');
      return false;
    }
  }

  /// Unsubscribe from a specific collection
  void unsubscribeFromCollection(String collectionName, {String? recordId}) {
    final subscriptionKey = recordId != null
        ? '$collectionName:$recordId'
        : collectionName;

    final unsubscribe = _subscriptions.remove(subscriptionKey);
    if (unsubscribe != null) {
      unsubscribe();
      print('🔌 Unsubscribed from $subscriptionKey');
    }
  }

  /// Check if currently subscribed to a collection
  bool isSubscribedTo(String collectionName, {String? recordId}) {
    final subscriptionKey = recordId != null
        ? '$collectionName:$recordId'
        : collectionName;
    return _subscriptions.containsKey(subscriptionKey);
  }

  /// Get count of active subscriptions
  int get activeSubscriptions => _subscriptions.length;

  /// Dispose of all subscriptions and cleanup
  ///
  /// IMPORTANT: Call this in provider's onDispose
  void dispose() {
    if (_isDisposed) return;

    print('🗑️ Disposing service with ${_subscriptions.length} subscriptions');

    for (final unsubscribe in _subscriptions.values) {
      unsubscribe();
    }
    _subscriptions.clear();
    _isDisposed = true;
  }

  /// Check if service is disposed
  bool get isDisposed => _isDisposed;
}

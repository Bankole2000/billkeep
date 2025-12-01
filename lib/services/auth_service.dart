import 'package:billkeep/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:billkeep/models/user_model.dart';
import 'package:pocketbase/pocketbase.dart';
import 'api_client.dart';
import 'base_api_service.dart';

class AuthService extends BaseApiService {
  final UserRepository _repository;
  final void Function(UserModel?) onUserSynced;

  AuthService(this._repository, {required this.onUserSynced}) : super() {
    print('AuthService initialized');
    _initializeRealtimeSubscription();
  }

  /// Initialize realtime subscription for user updates
  void _initializeRealtimeSubscription() {
    subscribeToCollection('users', _handleUserEvent);
  }

  /// Handle realtime user events from PocketBase
  void _handleUserEvent(RecordSubscriptionEvent e) {
    print('Realtime update for users: ${e.record.toString()}');
    // TODO: Check if event is relevant to current user
    try {
      switch (e.action) {
        case 'update':
          // Handle user updates
          if (e.record != null) {
            _syncUserFromBackend(e.record!, e.action);
          }
          break;
        case 'delete':
          // Handle user deletions
          if (e.record != null) {
            _repository.getUserById(e.record!.id).then((user) {
              if (user != null) {
                print('User deleted: ${user.id} - ${user.email}');
                // Additional cleanup if necessary
                _repository.deleteUser(user.id!);
              }
            });
          }
          break;
        default:
          break;
      }
    } catch (e) {
      print('❌ Error handling user update: $e');
    }
  }

  /// Sync user from backend to local DB
  Future<void> _syncUserFromBackend(RecordModel record, String action) async {
    try {
      final canonicalId = record.id;

      final localUser = await _repository.getUserById(canonicalId);
      final remoteUser = UserModel.fromJson(record.toJson());
      if (localUser == null) {
        // User does not exist locally, create it
        print('📥 Creating new user from backend: $canonicalId');
        // await _repository.createUser(remoteUser);
        // Notify via callback
        onUserSynced.call(remoteUser);
      } else if (!localUser.isEqualTo(remoteUser)) {
        // User exists but data differs, update it
        print('🔄 Updating user from backend: $canonicalId');
        final mergedUser = localUser.merge(remoteUser);
        await _repository.updateUser(mergedUser);
        // Notify via callback
        onUserSynced.call(mergedUser);
      } else {
        print('ℹ️ User is already up-to-date: $canonicalId');
      }
    } catch (e) {
      print('❌ Error syncing user from backend: $e');
    }
  }

  // Dispose is now handled by BaseApiService
  // No need to override unless you need additional cleanup

  /// Sign up a new user with email, username, and password
  Future<UserModel> signup({
    required UserModel newUser,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/users/records',
        data: newUser.toJson()
          ..['password'] = password
          ..['passwordConfirm'] = password,
      );

      final createdUser = UserModel.fromJson(response.data);

      final localUserId = await _repository.createUser(createdUser);

      final savedUser = await _repository.getUserById(localUserId);

      onUserSynced.call(savedUser!);

      return savedUser!;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Login an existing user
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/users/auth-with-password',
        data: {'identity': email, 'password': password},
      );

      final authResponse = AuthResponse.fromJson(response.data);
      print(authResponse);
      print('✅ User logged in: ${authResponse.user.id}');

      // Save token and user data to secure storage
      await ApiClient.saveToken(authResponse.token);
      await ApiClient.saveUser(authResponse.user);
      onUserSynced.call(authResponse.user);

      return authResponse;
    } on DioException catch (e) {
      print(e);
      throw _handleError(e);
    }
  }

  /// Verify user's email address
  Future<bool> verifyEmail(UserModel user, String verificationCode) async {
    // Implement email verification logic if needed
    if (verificationCode == '123456') {
      return true;
    }
    // TODO: Implement verification api call logic
    return false;
  }

  //
  Future<void> resendVerificationEmail(String email) async {
    try {
      await dio.post('/users/request-verification', data: {'email': email});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    try {
      // Call logout endpoint if needed
      await dio.post('/auth/logout');
    } on DioException catch (e) {
      // Continue with logout even if API call fails
      print('Logout API error: ${e.message}');
    } finally {
      // Always clear the token and user data
      await ApiClient.clearToken();
      await ApiClient.clearUser();
      onUserSynced.call(null);
    }
  }

  /// Get current user profile
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get('/users/auth-refresh');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await ApiClient.isAuthenticated();
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
          return data['message'] ?? 'Not found';
        case 409:
          return data['message'] ?? 'Conflict - resource already exists';
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

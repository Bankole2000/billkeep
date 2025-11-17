import 'package:dio/dio.dart';
import 'package:billkeep/models/user_model.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService() : _apiClient = ApiClient();

  /// Sign up a new user with email, username, and password
  Future<SignupResponse> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/users/records',
        data: {
          'email': email,
          'name': username,
          'password': password,
          'passwordConfirm': password,
          'verified': false,
          'emailVisibility': true,
        },
      );

      final signupResponse = SignupResponse.fromJson(response.data);

      // Login after signup to get token and save user
      await login(email: email, password: password);

      return signupResponse;
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
      final response = await _apiClient.dio.post(
        '/users/auth-with-password',
        data: {'identity': email, 'password': password},
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Save token and user data to secure storage
      await ApiClient.saveToken(authResponse.token);
      await ApiClient.saveUser(authResponse.user);

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    try {
      // Call logout endpoint if needed
      await _apiClient.dio.post('/auth/logout');
    } on DioException catch (e) {
      // Continue with logout even if API call fails
      print('Logout API error: ${e.message}');
    } finally {
      // Always clear the token and user data
      await ApiClient.clearToken();
      await ApiClient.clearUser();
    }
  }

  /// Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get('/auth/me');
      return User.fromJson(response.data);
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

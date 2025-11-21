import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';
import '../models/user_model.dart';

/// Singleton API client for making HTTP requests
///
/// Handles authentication, token management, and request/response interceptors
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  late final Dio dio;

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String userIdKey = 'user_id';

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: Duration(seconds: AppConfig.apiTimeout),
        receiveTimeout: Duration(seconds: AppConfig.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor to attach token to requests
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from shared preferences
          // final prefs = await SharedPreferences.getInstance();
          // final token = prefs.getString(tokenKey);
          final token = await _secureStorage.read(key: tokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 unauthorized errors
          if (error.response?.statusCode == 401) {
            // Clear token on unauthorized
            // final prefs = await SharedPreferences.getInstance();
            // await prefs.remove(tokenKey);
            await _secureStorage.delete(key: tokenKey);
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Save token to shared preferences
  static Future<void> saveToken(String token) async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString(tokenKey, token);
    await _secureStorage.write(key: tokenKey, value: token);
  }

  // Get token from shared preferences
  static Future<String?> getToken() async {
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString(tokenKey);
    return await _secureStorage.read(key: tokenKey);
  }

  // Clear token from shared preferences
  static Future<void> clearToken() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove(tokenKey);
    await _secureStorage.delete(key: tokenKey);
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Save user data to secure storage
  static Future<void> saveUser(UserModel user) async {
    await _secureStorage.write(key: userKey, value: jsonEncode(user.toJson()));
  }

  // Get user data from secure storage
  static Future<UserModel?> getUser() async {
    final userData = await _secureStorage.read(key: userKey);
    if (userData != null && userData.isNotEmpty) {
      try {
        return UserModel.fromJson(jsonDecode(userData));
      } catch (e) {
        // If there's an error parsing the user data, return null
        return null;
      }
    }
    return null;
  }

  // Clear user data from secure storage
  static Future<void> clearUser() async {
    await _secureStorage.delete(key: userKey);
  }
}

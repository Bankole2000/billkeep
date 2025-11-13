import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  late final Dio dio;

  static const String baseUrl = 'http://localhost:8090/api/collections';
  static const String tokenKey = 'auth_token';

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
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
          print(token);
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
}

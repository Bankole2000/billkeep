import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';

/// Notifier for managing the current user state
///
/// Handles loading user from secure storage on app start,
/// updating user state on login, and clearing on logout
class CurrentUserNotifier extends StateNotifier<User?> {
  CurrentUserNotifier() : super(null) {
    // Load user from storage when notifier is created
    _loadUser();
  }

  /// Load user from secure storage
  Future<void> _loadUser() async {
    final user = await ApiClient.getUser();
    if (user != null) {
      state = user;
    }
  }

  /// Set the current user and save to secure storage
  Future<void> setUser(User user) async {
    await ApiClient.saveUser(user);
    state = user;
  }

  /// Clear the current user from state and secure storage
  Future<void> clearUser() async {
    await ApiClient.clearUser();
    state = null;
  }

  /// Refresh user data from the backend
  Future<void> refreshUser() async {
    try {
      final authService = AuthService();
      final user = await authService.getCurrentUser();
      await setUser(user);
    } catch (e) {
      // If refresh fails, keep the current user state
      print('Failed to refresh user: $e');
    }
  }
}

/// Provider for the current logged-in user
///
/// Usage:
/// - To read: `ref.watch(currentUserProvider)`
/// - To update: `ref.read(currentUserProvider.notifier).setUser(user)`
/// - To clear: `ref.read(currentUserProvider.notifier).clearUser()`
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
  return CurrentUserNotifier();
});

/// Provider to check if a user is logged in
///
/// Returns true if there's a current user, false otherwise
final isLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// Provider for the current user's ID
///
/// Returns the user ID if logged in, null otherwise
final currentUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id;
});

/// Provider for auth service
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

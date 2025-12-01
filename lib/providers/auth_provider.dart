import 'package:billkeep/providers/database_provider.dart';
import 'package:billkeep/providers/local/user_provider.dart';
import 'package:billkeep/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/services/auth_service.dart';

// Export the CurrentUserProvider from local for convenience
export 'package:billkeep/providers/local/user_provider.dart';

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
/// Uses autoDispose to properly clean up PocketBase subscriptions
final authServiceProvider = Provider.autoDispose<AuthService>((ref) {
  final database = ref.watch(databaseProvider);
  final repository = UserRepository(database);

  final authService = AuthService(
    repository,
    onUserSynced: (user) {
      // Update the current user state when synced from backend
      if (user == null) {
        ref.read(currentUserProvider.notifier).clearUser();
        return;
      }
      ref.read(currentUserProvider.notifier).setUser(user);
    },
  );

  // Dispose the auth service when the provider is disposed
  ref.onDispose(() {
    authService.dispose();
  });

  return authService;
});

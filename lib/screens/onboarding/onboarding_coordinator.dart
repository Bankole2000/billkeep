import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/services/auth_service.dart';

/// Coordinator to manage onboarding flow
/// This determines which screen to show based on authentication state
class OnboardingCoordinator extends ConsumerStatefulWidget {
  const OnboardingCoordinator({super.key});

  @override
  ConsumerState<OnboardingCoordinator> createState() => _OnboardingCoordinatorState();
}

class _OnboardingCoordinatorState extends ConsumerState<OnboardingCoordinator> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isAuth = await _authService.isAuthenticated();
      setState(() {
        _isLoading = false;
      });

      if (isAuth) {
        // TODO: Optionally refresh user data here
        // TODO: sync local database with server data
        // TODO: fetch user settings/preferences
        // TODO: set default configurations based on user preferences
        // User is already authenticated, go to main screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      } else {
        // TODO: Empty shared preferences of any residual data
        // User is not authenticated, show welcome screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/onboarding/welcome');
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show welcome screen on error
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding/welcome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'BillKeep',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 48),
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

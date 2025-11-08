import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

/// Coordinator to manage onboarding flow
/// This determines which screen to show based on authentication state
class OnboardingCoordinator extends StatefulWidget {
  const OnboardingCoordinator({super.key});

  @override
  State<OnboardingCoordinator> createState() => _OnboardingCoordinatorState();
}

class _OnboardingCoordinatorState extends State<OnboardingCoordinator> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isAuth = await _authService.isAuthenticated();
      setState(() {
        _isLoading = false;
      });

      if (isAuth) {
        // User is already authenticated, go to main screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      } else {
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

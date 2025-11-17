import 'package:flutter/material.dart';

/// Header widget for authentication screens
///
/// Displays the app logo, name, and a contextual subtitle
class AuthHeader extends StatelessWidget {
  final bool isLogin;

  const AuthHeader({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),

        // Logo
        Icon(
          Icons.account_balance_wallet,
          size: 80,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 16),

        // App Name
        Text(
          'BillKeep',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          isLogin ? 'Welcome back!' : 'Create your account',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

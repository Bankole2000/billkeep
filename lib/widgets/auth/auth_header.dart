import 'package:billkeep/providers/ui_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Header widget for authentication screens
///
/// Displays the app logo, name, and a contextual subtitle
class AuthHeader extends ConsumerWidget {
  final bool isLogin;

  const AuthHeader({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.read(appColorsProvider);
    return Column(
      children: [
        const SizedBox(height: 40),

        // Logo
        Icon(
          Icons.account_balance_wallet,
          size: 80,
          color: colors.text,
        ),
        const SizedBox(height: 16),

        // App Name
        Text(
          'BillKeep',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colors.text,
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

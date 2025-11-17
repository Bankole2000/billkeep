import 'package:flutter/material.dart';

/// Toggle widget for switching between login and signup modes
class AuthToggle extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggle;

  const AuthToggle({
    super.key,
    required this.isLogin,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? "Don't have an account? " : 'Already have an account? ',
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: onToggle,
          child: Text(
            isLogin ? 'Sign Up' : 'Login',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

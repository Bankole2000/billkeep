import 'package:flutter/material.dart';

/// Header section for email verification screen
class VerificationHeader extends StatelessWidget {
  final String email;

  const VerificationHeader({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Icon(
          Icons.mark_email_unread_outlined,
          size: 100,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 24),
        const Text(
          'Verify Your Email',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'We\'ve sent a 6-digit verification code to:',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          email,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

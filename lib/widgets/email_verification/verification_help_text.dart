import 'package:flutter/material.dart';

/// Help text for verification screen
class VerificationHelpText extends StatelessWidget {
  const VerificationHelpText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Didn\'t receive the code?',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '• Check your spam folder\n• Make sure the email address is correct\n• Wait a few minutes and try resending',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

/// Info box with instructions for email verification
class VerificationInfoBox extends StatelessWidget {
  const VerificationInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700]),
          const SizedBox(height: 8),
          Text(
            'Please enter the 6-digit verification code from your email below.',
            style: TextStyle(fontSize: 14, color: Colors.blue[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

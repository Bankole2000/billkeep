import 'package:flutter/material.dart';

/// Biometric authentication button (Face ID, Touch ID, Fingerprint)
class BiometricAuthButton extends StatelessWidget {
  final String biometricType;
  final VoidCallback onPressed;
  final bool isLoading;

  const BiometricAuthButton({
    super.key,
    required this.biometricType,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.fingerprint),
          label: Text('Login with $biometricType'),
        ),
        const SizedBox(height: 20),

        // Divider with "OR"
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

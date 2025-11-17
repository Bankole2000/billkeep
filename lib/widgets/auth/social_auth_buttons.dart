import 'dart:io';
import 'package:flutter/material.dart';

/// Social authentication buttons (Google, Apple)
class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onAppleSignIn;
  final bool isLoading;

  const SocialAuthButtons({
    super.key,
    this.onGoogleSignIn,
    this.onAppleSignIn,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Sign In
        if (onGoogleSignIn != null)
          _buildSocialButton(
            context: context,
            onPressed: onGoogleSignIn!,
            icon: Icons.g_mobiledata,
            label: 'Continue with Google',
            color: Colors.white,
            textColor: Colors.black87,
          ),

        if (onGoogleSignIn != null) const SizedBox(height: 12),

        // Apple Sign In (iOS only)
        if (Platform.isIOS && onAppleSignIn != null)
          _buildSocialButton(
            context: context,
            onPressed: onAppleSignIn!,
            icon: Icons.apple,
            label: 'Continue with Apple',
            color: Colors.black,
            textColor: Colors.white,
          ),

        if (Platform.isIOS && onAppleSignIn != null) const SizedBox(height: 20),

        // Divider with "OR"
        if (onGoogleSignIn != null || onAppleSignIn != null) ...[
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
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: textColor),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

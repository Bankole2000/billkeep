import 'package:flutter/material.dart';

/// Resend code button with countdown timer
class ResendCodeButton extends StatelessWidget {
  final bool canResend;
  final bool isVerifying;
  final int resendCountdown;
  final VoidCallback onPressed;

  const ResendCodeButton({
    super.key,
    required this.canResend,
    required this.isVerifying,
    required this.resendCountdown,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: canResend && !isVerifying ? onPressed : null,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.refresh),
      label: Text(
        canResend
            ? 'Resend Code'
            : 'Resend in $resendCountdown seconds',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

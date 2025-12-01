import 'package:flutter/material.dart';

/// Verify button with loading state
class VerificationButton extends StatelessWidget {
  final TextEditingController codeController;
  final bool isVerifying;
  final VoidCallback onPressed;

  const VerificationButton({
    super.key,
    required this.codeController,
    required this.isVerifying,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ValueListenableBuilder(
        valueListenable: codeController,
        builder: (context, value, _) {
          final isDisabled = isVerifying || value.text.length < 6;
          return ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isVerifying
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Verify Code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

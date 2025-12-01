import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Verification code input field
class VerificationCodeInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorMessage;
  final ValueChanged<String> onChanged;
  // final ValueChanged<String> onSubmitted;

  const VerificationCodeInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.errorMessage,
    required this.onChanged,
    // required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: errorMessage != null ? Colors.red : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 8,
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
        // onSubmitted: onSubmitted,
        decoration: const InputDecoration(
          hintText: '000000',
          hintStyle: TextStyle(color: Colors.grey, letterSpacing: 8),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          counterText: '',
        ),
      ),
    );
  }
}

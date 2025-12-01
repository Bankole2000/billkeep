import 'package:billkeep/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/services/auth_service.dart';
import 'package:billkeep/models/user_model.dart';
import 'package:billkeep/widgets/email_verification/verification_header.dart';
import 'package:billkeep/widgets/email_verification/verification_info_box.dart';
import 'package:billkeep/widgets/email_verification/verification_code_input.dart';
import 'package:billkeep/widgets/email_verification/verification_button.dart';
import 'package:billkeep/widgets/email_verification/verification_error_message.dart';
import 'package:billkeep/widgets/email_verification/resend_code_button.dart';
import 'package:billkeep/widgets/email_verification/verification_help_text.dart';

/// Refactored email verification screen with cleaner component structure
class EmailVerificationScreen extends ConsumerStatefulWidget {
  final UserModel user;
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.user,
    required this.email,
  });

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  late final AuthService _authService = ref.read(authServiceProvider);
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();

  bool _isVerifying = false;
  bool _canResend = true;
  int _resendCountdown = 60;
  Timer? _timer;
  String? _errorMessage;

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with email
              VerificationHeader(email: widget.email),

              const SizedBox(height: 32),

              Text('${widget.user.id}'),

              // Info box
              const VerificationInfoBox(),

              const SizedBox(height: 24),

              // Verification code input
              VerificationCodeInput(
                controller: _codeController,
                focusNode: _codeFocusNode,
                errorMessage: _errorMessage,
                onChanged: _handleCodeChanged,
                // onSubmitted: _handleCodeSubmitted,
              ),

              const SizedBox(height: 24),

              // Verify button
              VerificationButton(
                codeController: _codeController,
                isVerifying: _isVerifying,
                onPressed: _verifyCode,
              ),

              const SizedBox(height: 16),

              // Error message
              VerificationErrorMessage(errorMessage: _errorMessage),

              // Resend button
              ResendCodeButton(
                canResend: _canResend,
                isVerifying: _isVerifying,
                resendCountdown: _resendCountdown,
                onPressed: _resendVerificationEmail,
              ),

              const SizedBox(height: 24),

              // Help text
              const VerificationHelpText(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCodeChanged(String value) {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
    if (value.length == 6) {
      _codeFocusNode.unfocus();
    }
  }

  // void _handleCodeSubmitted(String value) {
  //   if (value.length == 6) {
  //     _verifyCode();
  //   }
  // }

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();

    if (code.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a valid 6-digit verification code';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      // TODO: Implement verification code API endpoint
      // final isVerified = await _authService.verifyEmailWithCode(code);

      // Placeholder API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate verification result - replace with actual API response
      final isVerified = await _authService.verifyEmail(widget.user, code);

      if (isVerified) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email verified successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          _navigateToNextScreen();
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid verification code. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to verify code. Please try again.';
      });
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (!_canResend) return;

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      // TODO: Implement resend verification email API endpoint
      // await _authService.resendVerificationEmail();

      // Placeholder API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent!'),
            backgroundColor: Colors.green,
          ),
        );

        // Start countdown
        setState(() {
          _canResend = false;
          _resendCountdown = 60;
        });

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _resendCountdown--;
            if (_resendCountdown == 0) {
              _canResend = true;
              timer.cancel();
            }
          });
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  void _navigateToNextScreen() {
    final user = ref.watch(currentUserProvider);
    print(user);
    Navigator.pushReplacementNamed(
      context,
      '/onboarding/config',
      arguments: {'user': user},
    );
  }
}

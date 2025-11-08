import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class EmailVerificationScreen extends StatefulWidget {
  final User user;
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.user,
    required this.email,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  // ignore: unused_field
  final AuthService _authService = AuthService();
  bool _isVerifying = false;
  bool _canResend = true;
  int _resendCountdown = 0;
  Timer? _timer;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startVerificationCheck() {
    // TODO: Implement automatic verification checking
    // This should periodically check if the email has been verified
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _checkVerificationStatus();
    });
  }

  Future<void> _checkVerificationStatus() async {
    try {
      // TODO: Implement email verification check API endpoint
      // final isVerified = await _authService.checkEmailVerification();

      // Placeholder - replace with actual API call
      // For now, this does nothing
    } catch (e) {
      // Silently fail - user can manually check
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
    // Navigate to initial configuration
    Navigator.pushReplacementNamed(
      context,
      '/onboarding/config',
      arguments: widget.user,
    );
  }

  void _skipVerification() {
    // Allow user to skip verification and continue
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skip Verification?'),
        content: const Text(
          'You can verify your email later from settings. Some features may be limited until you verify your email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToNextScreen();
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        actions: [
          TextButton(
            onPressed: _skipVerification,
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We\'ve sent a verification email to:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
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
                      'Please check your email and click the verification link to activate your account.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                    ],
                  ),
                ),

              // Resend button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed:
                      _canResend && !_isVerifying ? _resendVerificationEmail : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isVerifying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.refresh),
                  label: Text(
                    _canResend
                        ? 'Resend Verification Email'
                        : 'Resend in $_resendCountdown seconds',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Manual verification check button
              OutlinedButton(
                onPressed: () async {
                  await _checkVerificationStatus();
                  // TODO: If verified, navigate to next screen
                  // For now, show a message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Email not yet verified. Please check your inbox.',
                        ),
                      ),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'I\'ve Verified My Email',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),

              // Help text
              Text(
                'Didn\'t receive the email?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '• Check your spam folder\n• Make sure the email address is correct\n• Wait a few minutes and try resending',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

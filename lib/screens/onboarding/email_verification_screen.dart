import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:billkeep/services/auth_service.dart';
import 'package:billkeep/models/user_model.dart';

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
  final AuthService _authService = AuthService(); // Used in TODO API calls
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  bool _isVerifying = false;
  bool _canResend = true;
  int _resendCountdown = 0;
  Timer? _timer;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

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
      final isVerified = code == '123456'; // Placeholder for demo
      
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
                'We\'ve sent a 6-digit verification code to:',
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
                      'Please enter the 6-digit verification code from your email below.',
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

              // Verification code input
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _errorMessage != null ? Colors.red : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _codeController,
                  focusNode: _codeFocusNode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    if (_errorMessage != null) {
                      setState(() {
                        _errorMessage = null;
                      });
                    }
                    if (value.length == 6) {
                      _codeFocusNode.unfocus();
                    }
                  },
                  onSubmitted: (value) {
                    if (value.length == 6) {
                      _verifyCode();
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: '000000',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 8,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    counterText: '',
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Verify button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ValueListenableBuilder(
                  valueListenable: _codeController,
                  builder: (context, value, _) {
                    final isDisabled = _isVerifying || value.text.length < 6;
                  return 
                    ElevatedButton(
                    onPressed: isDisabled ? null : _verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isVerifying
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
                  }


                ),
              ),
              const SizedBox(height: 16),

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
              OutlinedButton.icon(
                onPressed: _canResend && !_isVerifying ? _resendVerificationEmail : null,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh),
                label: Text(
                  _canResend
                      ? 'Resend Code'
                      : 'Resend in $_resendCountdown seconds',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),

              // Help text
              Text(
                'Didn\'t receive the code?',
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

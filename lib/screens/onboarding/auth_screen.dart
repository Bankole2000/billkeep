import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:billkeep/services/auth_service.dart';
import 'package:billkeep/services/analytics_service.dart';
import 'package:billkeep/services/biometric_service.dart';
import 'package:billkeep/models/user_model.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();
  final AnalyticsService _analytics = AnalyticsService();
  final BiometricService _biometricService = BiometricService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _showBiometric = false;
  String _biometricType = '';

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _analytics.logAuthScreenViewed(isSignup: !_isLogin);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    final isAvailable = await _biometricService.isBiometricAvailable();
    if (isAvailable && _isLogin) {
      final description = await _biometricService.getBiometricTypeDescription();
      setState(() {
        _showBiometric = true;
        _biometricType = description;
      });
    }
  }

  Future<void> _handleBiometricAuth() async {
    _analytics.logBiometricAuthAttempt();

    final authenticated = await _biometricService.authenticate(
      localizedReason: 'Authenticate to sign in to BillKeep',
    );

    if (authenticated) {
      _analytics.logBiometricAuthSuccess();
      // TODO: Implement biometric login API endpoint
      // For now, just show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric authentication successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      _analytics.logBiometricAuthFailure(error: 'Authentication failed');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _analytics.logSignupAttempt(method: 'google');

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get authentication tokens for backend verification
      // ignore: unused_local_variable
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // TODO: Send Google tokens to backend
      // final response = await _authService.socialLogin(
      //   provider: 'google',
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      // Placeholder - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      _analytics.logSignupSuccess(method: 'google');

      if (mounted) {
        // For now, navigate to config screen with placeholder user
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/config',
          arguments: User(
            id: 'placeholder_google_id',
            username: googleUser.displayName ?? 'User',
            email: googleUser.email,
          ),
        );
      }
    } catch (e) {
      _analytics.logSignupFailure(method: 'google', error: e.toString());
      setState(() {
        _errorMessage = 'Google sign-in failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _analytics.logSignupAttempt(method: 'apple');

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // TODO: Send Apple credentials to backend
      // final response = await _authService.socialLogin(
      //   provider: 'apple',
      //   idToken: credential.identityToken,
      //   authorizationCode: credential.authorizationCode,
      // );

      // Placeholder - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      _analytics.logSignupSuccess(method: 'apple');

      if (mounted) {
        // For now, navigate to config screen with placeholder user
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/config',
          arguments: User(
            id: 'placeholder_apple_id',
            username: credential.givenName ?? 'User',
            email: credential.email ?? 'user@example.com',
          ),
        );
      }
    } catch (e) {
      _analytics.logSignupFailure(method: 'apple', error: e.toString());
      setState(() {
        _errorMessage = 'Apple sign-in failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isLogin && !_agreedToTerms) {
      setState(() {
        _errorMessage = 'Please agree to the Terms of Service and Privacy Policy';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isLogin) {
        _analytics.logLoginAttempt(method: 'email');

        // Login
        final response = await _authService.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        _analytics.logLoginSuccess(method: 'email');

        if (mounted) {
          // Existing user - go to main navigation
          Navigator.pushReplacementNamed(
            context,
            '/main',
            arguments: response.user,
          );
        }
      } else {
        _analytics.logSignupAttempt(method: 'email');

        // Signup
        final response = await _authService.signup(
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );

        _analytics.logSignupSuccess(method: 'email');

        if (mounted) {
          // New user - go to email verification first
          Navigator.pushReplacementNamed(
            context,
            '/onboarding/verify-email',
            arguments: {
              'user': response.user,
              'email': _emailController.text.trim(),
            },
          );
        }
      }
    } catch (e) {
      print(e);
      if (_isLogin) {
        _analytics.logLoginFailure(method: 'email', error: e.toString());
      } else {
        _analytics.logSignupFailure(method: 'email', error: e.toString());
      }

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
      _formKey.currentState?.reset();
      _agreedToTerms = false;
    });
    _analytics.logAuthScreenViewed(isSignup: !_isLogin);
    _checkBiometricAvailability();
  }

  Future<void> _launchURL(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch URL')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo or App Name
                Icon(
                  Icons.account_balance_wallet,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'BillKeep',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin ? 'Welcome back!' : 'Create your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Social login buttons
                if (!_isLogin) ...[
                  // TODO: Google login
                  // _buildSocialButton(
                  //   onPressed: _handleGoogleSignIn,
                  //   icon: 'assets/images/google_icon.png', // TODO: Add Google icon asset
                  //   label: 'Continue with Google',
                  //   color: Colors.white,
                  //   textColor: Colors.black87,
                  // ),
                  const SizedBox(height: 12),
                  // TODO: IOS login
                  // if (Platform.isIOS)
                  //   _buildSocialButton(
                  //     onPressed: _handleAppleSignIn,
                  //     icon: 'assets/images/apple_icon.png', // TODO: Add Apple icon asset
                  //     label: 'Continue with Apple',
                  //     color: Colors.black,
                  //     textColor: Colors.white,
                  //   ),
                  if (Platform.isIOS) const SizedBox(height: 20),
                  // Divider with "OR"
                  // Row(
                  //   children: [
                  //     Expanded(child: Divider(color: Colors.grey[300])),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 16),
                  //       child: Text(
                  //         'OR',
                  //         style: TextStyle(color: Colors.grey[600]),
                  //       ),
                  //     ),
                  //     Expanded(child: Divider(color: Colors.grey[300])),
                  //   ],
                  // ),
                  const SizedBox(height: 20),
                ],

                // Biometric auth button (login only)
                if (_isLogin && _showBiometric) ...[
                  // TODO: Biometric login
                  // OutlinedButton.icon(
                  //   onPressed: _handleBiometricAuth,
                  //   style: OutlinedButton.styleFrom(
                  //     minimumSize: const Size(double.infinity, 56),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //   ),
                  //   icon: const Icon(Icons.fingerprint),
                  //   label: Text('Login with $_biometricType'),
                  // ),
                  const SizedBox(height: 20),
                  // Divider with "OR" for Login
                  // Row(
                  //   children: [
                  //     Expanded(child: Divider(color: Colors.grey[300])),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 16),
                  //       child: Text(
                  //         'OR',
                  //         style: TextStyle(color: Colors.grey[600]),
                  //       ),
                  //     ),
                  //     Expanded(child: Divider(color: Colors.grey[300])),
                  //   ],
                  // ),
                  const SizedBox(height: 20),
                ],

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Username field (only for signup)
                      if (!_isLogin) ...[
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            if (value.length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (!_isLogin && value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Terms and privacy checkbox (signup only)
                      if (!_isLogin)
                        Row(
                          children: [
                            Checkbox(
                              value: _agreedToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreedToTerms = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          _analytics.logTermsOfServiceViewed();
                                          // TODO: Replace with your actual Terms URL
                                          _launchURL(
                                            'https://yourdomain.com/terms',
                                          );
                                        },
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          _analytics.logPrivacyPolicyViewed();
                                          // TODO: Replace with your actual Privacy Policy URL
                                          _launchURL(
                                            'https://yourdomain.com/privacy',
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 8),

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

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _isLogin ? 'Login' : 'Sign Up',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Forgot password (only for login)
                      if (_isLogin)
                        TextButton(
                          onPressed: () {
                            _analytics.logForgotPasswordViewed();
                            Navigator.pushNamed(
                              context,
                              '/onboarding/forgot-password',
                            );
                          },
                          child: const Text('Forgot password?'),
                        ),

                      const SizedBox(height: 24),

                      // Toggle between login and signup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin
                                ? "Don't have an account? "
                                : 'Already have an account? ',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: _toggleAuthMode,
                            child: Text(
                              _isLogin ? 'Sign Up' : 'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required String icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
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
            // Icon placeholder - replace with actual asset
            Icon(Icons.g_mobiledata, size: 24, color: textColor),
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

import 'package:billkeep/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:billkeep/services/auth_service.dart';
import 'package:billkeep/services/analytics_service.dart';
import 'package:billkeep/widgets/auth/auth_header.dart';
import 'package:billkeep/widgets/auth/login_form.dart';
import 'package:billkeep/widgets/auth/signup_form.dart';
import 'package:billkeep/widgets/auth/auth_toggle.dart';
import 'package:billkeep/widgets/auth/auth_error_message.dart';
import 'package:billkeep/widgets/auth/auth_submit_button.dart';

/// Refactored authentication screen with cleaner component structure
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = false;
  bool _isLoading = false;
  bool _agreedToTerms = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();
  final AnalyticsService _analytics = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _analytics.logAuthScreenViewed(isSignup: !_isLogin);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
        await _handleLogin();
      } else {
        await _handleSignup();
      }
    } catch (e) {
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

  Future<void> _handleLogin() async {
    _analytics.logLoginAttempt(method: 'email');

    final response = await _authService.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    _analytics.logLoginSuccess(method: 'email');

    // Update the user provider
    ref.read(currentUserProvider.notifier).setUser(response.user);

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/main',
        arguments: response.user,
      );
    }
  }

  Future<void> _handleSignup() async {
    _analytics.logSignupAttempt(method: 'email');

    final response = await _authService.signup(
      email: _emailController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    _analytics.logSignupSuccess(method: 'email');

    ref.read(currentUserProvider.notifier).setUser(response.user);
    print(response.user);
    if (mounted) {
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

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
      _formKey.currentState?.reset();
      _agreedToTerms = false;
    });
    _analytics.logAuthScreenViewed(isSignup: !_isLogin);
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

  void _handleForgotPassword() {
    _analytics.logForgotPasswordViewed();
    Navigator.pushNamed(context, '/onboarding/forgot-password');
  }

  void _handleViewTerms() {
    _analytics.logTermsOfServiceViewed();
    _launchURL('https://yourdomain.com/terms');
  }

  void _handleViewPrivacy() {
    _analytics.logPrivacyPolicyViewed();
    _launchURL('https://yourdomain.com/privacy');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with logo and title
                  AuthHeader(isLogin: _isLogin),

                  // Login or Signup form
                  if (_isLogin)
                    LoginForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      onForgotPassword: _handleForgotPassword,
                    )
                  else
                    SignupForm(
                      emailController: _emailController,
                      usernameController: _usernameController,
                      passwordController: _passwordController,
                      agreedToTerms: _agreedToTerms,
                      onTermsChanged: (value) {
                        setState(() => _agreedToTerms = value);
                      },
                      onViewTerms: _handleViewTerms,
                      onViewPrivacy: _handleViewPrivacy,
                    ),

                  const SizedBox(height: 8),

                  // Error message
                  AuthErrorMessage(errorMessage: _errorMessage),

                  // Submit button
                  AuthSubmitButton(
                    isLogin: _isLogin,
                    isLoading: _isLoading,
                    onPressed: _handleSubmit,
                  ),

                  const SizedBox(height: 24),

                  // Toggle between login and signup
                  AuthToggle(
                    isLogin: _isLogin,
                    onToggle: _toggleAuthMode,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

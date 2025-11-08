import 'package:billkeep/database/database.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Analytics service for tracking user events
/// This uses Firebase Analytics as the backend
/// NOTE: Firebase must be initialized in main.dart before using this service
/// If Firebase is not initialized, analytics will be disabled (no-op)
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  FirebaseAnalytics? _analytics;
  FirebaseAnalyticsObserver? _observer;
  bool _isEnabled = false;

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal() {
    _initializeAnalytics();
  }

  void _initializeAnalytics() {
    try {
      _analytics = FirebaseAnalytics.instance;
      _observer = FirebaseAnalyticsObserver(analytics: _analytics!);
      _isEnabled = true;
      if (kDebugMode) {
        print('Analytics: Firebase Analytics initialized successfully');
      }
    } catch (e) {
      _isEnabled = false;
      if (kDebugMode) {
        print('Analytics: Firebase not initialized. Analytics disabled. Error: $e');
      }
    }
  }

  /// Get the analytics observer for navigation tracking
  /// Returns null if Firebase is not initialized
  FirebaseAnalyticsObserver? get observer => _observer;

  /// Check if analytics is enabled
  bool get isEnabled => _isEnabled;

  /// Log custom event
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isEnabled || _analytics == null) {
      if (kDebugMode) {
        print('Analytics Event (disabled): $name ${parameters ?? ""}');
      }
      return;
    }

    try {
      await _analytics!.logEvent(
        name: name,
        parameters: parameters?.map((key, value) => MapEntry(key, value as Object)),
      );
      if (kDebugMode) {
        print('Analytics Event: $name ${parameters ?? ""}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Analytics Error: $e');
      }
    }
  }

  /// Set user property
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    if (!_isEnabled || _analytics == null) return;

    try {
      await _analytics!.setUserProperty(name: name, value: value);
    } catch (e) {
      if (kDebugMode) {
        print('Analytics Error: $e');
      }
    }
  }

  /// Set user ID
  Future<void> setUserId(String? userId) async {
    if (!_isEnabled || _analytics == null) return;

    try {
      await _analytics!.setUserId(id: userId);
    } catch (e) {
      if (kDebugMode) {
        print('Analytics Error: $e');
      }
    }
  }

  // Onboarding Events

  /// Log when user views welcome carousel
  Future<void> logOnboardingWelcomeViewed({int? slideIndex}) async {
    await logEvent(
      name: 'onboarding_welcome_viewed',
      parameters: {'slide_index': slideIndex},
    );
  }

  /// Log when user skips welcome carousel
  Future<void> logOnboardingWelcomeSkipped() async {
    await logEvent(name: 'onboarding_welcome_skipped');
  }

  /// Log when user completes welcome carousel
  Future<void> logOnboardingWelcomeCompleted() async {
    await logEvent(name: 'onboarding_welcome_completed');
  }

  /// Log when user views auth screen
  Future<void> logAuthScreenViewed({required bool isSignup}) async {
    await logEvent(
      name: 'auth_screen_viewed',
      parameters: {'mode': isSignup ? 'signup' : 'login'},
    );
  }

  /// Log signup attempt
  Future<void> logSignupAttempt({required String method}) async {
    await logEvent(
      name: 'signup_attempt',
      parameters: {'method': method}, // 'email', 'google', 'apple'
    );
  }

  /// Log signup success
  Future<void> logSignupSuccess({required String method}) async {
    await logEvent(
      name: 'signup_success',
      parameters: {'method': method},
    );
  }

  /// Log signup failure
  Future<void> logSignupFailure({
    required String method,
    required String error,
  }) async {
    await logEvent(
      name: 'signup_failure',
      parameters: {'method': method, 'error': error},
    );
  }

  /// Log login attempt
  Future<void> logLoginAttempt({required String method}) async {
    await logEvent(
      name: 'login_attempt',
      parameters: {'method': method},
    );
  }

  /// Log login success
  Future<void> logLoginSuccess({required String method}) async {
    await logEvent(
      name: 'login_success',
      parameters: {'method': method},
    );
  }

  /// Log login failure
  Future<void> logLoginFailure({
    required String method,
    required String error,
  }) async {
    await logEvent(
      name: 'login_failure',
      parameters: {'method': method, 'error': error},
    );
  }

  /// Log biometric auth attempt
  Future<void> logBiometricAuthAttempt() async {
    await logEvent(name: 'biometric_auth_attempt');
  }

  /// Log biometric auth success
  Future<void> logBiometricAuthSuccess() async {
    await logEvent(name: 'biometric_auth_success');
  }

  /// Log biometric auth failure
  Future<void> logBiometricAuthFailure({required String error}) async {
    await logEvent(
      name: 'biometric_auth_failure',
      parameters: {'error': error},
    );
  }

  /// Log when user views initial config screen
  Future<void> logInitialConfigViewed({required int step}) async {
    await logEvent(
      name: 'initial_config_viewed',
      parameters: {'step': step}, // 0: currency, 1: wallet, 2: project
    );
  }

  /// Log when user completes initial configuration
  Future<void> logInitialConfigCompleted({
    required Currency currency,
    required String walletType,
  }) async {
    await logEvent(
      name: 'initial_config_completed',
      parameters: {
        'currency': currency,
        'wallet_type': walletType,
      },
    );
  }

  /// Log when user skips initial configuration
  Future<void> logInitialConfigSkipped({required int step}) async {
    await logEvent(
      name: 'initial_config_skipped',
      parameters: {'step': step},
    );
  }

  /// Log when onboarding is fully completed
  Future<void> logOnboardingCompleted() async {
    await logEvent(name: 'onboarding_completed');
  }

  /// Log when user views forgot password screen
  Future<void> logForgotPasswordViewed() async {
    await logEvent(name: 'forgot_password_viewed');
  }

  /// Log when password reset email is sent
  Future<void> logPasswordResetEmailSent() async {
    await logEvent(name: 'password_reset_email_sent');
  }

  /// Log when user views email verification screen
  Future<void> logEmailVerificationViewed() async {
    await logEvent(name: 'email_verification_viewed');
  }

  /// Log when verification email is resent
  Future<void> logVerificationEmailResent() async {
    await logEvent(name: 'verification_email_resent');
  }

  /// Log when email is verified
  Future<void> logEmailVerified() async {
    await logEvent(name: 'email_verified');
  }

  /// Log when user views terms of service
  Future<void> logTermsOfServiceViewed() async {
    await logEvent(name: 'terms_of_service_viewed');
  }

  /// Log when user views privacy policy
  Future<void> logPrivacyPolicyViewed() async {
    await logEvent(name: 'privacy_policy_viewed');
  }
}

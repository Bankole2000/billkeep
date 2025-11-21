import 'dart:io';
import 'package:billkeep/providers/auth_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/providers/wallet_provider.dart';
import 'package:billkeep/services/auth_service.dart';
import 'package:billkeep/services/project_service.dart';
import 'package:billkeep/services/wallet_service.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/user_model.dart';
import 'package:billkeep/models/wallet_model.dart';
import 'package:billkeep/providers/currency_provider.dart';
import 'package:billkeep/providers/user_preferences_provider.dart';
import 'package:billkeep/services/analytics_service.dart';
import 'package:billkeep/services/user_preferences_service.dart';
import 'package:billkeep/providers/service_providers.dart';
import 'package:billkeep/utils/currency_country_mapping.dart';
import 'package:billkeep/utils/wallet_types.dart';
import 'package:billkeep/widgets/onboarding/currency_step.dart';
import 'package:billkeep/widgets/onboarding/project_step.dart';
import 'package:billkeep/widgets/onboarding/step_indicator.dart';
import 'package:billkeep/widgets/onboarding/wallet_step.dart';

/// Refactored initial configuration screen for onboarding
class InitialConfigScreen extends ConsumerStatefulWidget {
  final User user;

  const InitialConfigScreen({super.key, required this.user});

  @override
  ConsumerState<InitialConfigScreen> createState() =>
      _InitialConfigScreenState();
}

class _InitialConfigScreenState extends ConsumerState<InitialConfigScreen> {
  late WalletService _walletService;
  late ProjectService _projectService;
  late AuthService _authService;

  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  int _currentStep = 0;
  bool _isLoading = false;



  // Services (non-repository services)
  final AnalyticsService _analytics = AnalyticsService();
  final UserPreferencesService _preferencesService = UserPreferencesService();

  // Step 1: Currency selection
  Currency? _selectedCurrency;

  // Step 2: First wallet
  final _walletNameController = TextEditingController();
  WalletType? _walletType = WalletType.CASH;
  WalletProvider? _walletProvider;
  final _initialBalanceController = TextEditingController(text: '0.00');
  WalletModel? _createdWallet;

  // Step 3: First project
  final _projectNameController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  String? _selectedDefaultWalletId;

  static const _stepLabels = ['Currency', 'Wallet', 'Project'];

  @override
  void initState() {
    super.initState();
    _initializeDefaultValues();
    _suggestCurrency();
    print(_selectedCurrency);
    _analytics.logInitialConfigViewed(step: _currentStep);
  }

  void _initializeDefaultValues() {
    _walletNameController.text = '${widget.user.username}\'s Wallet';
    _projectNameController.text = '${widget.user.username}\'s Project';
    _projectDescriptionController.text =
        'This is ${widget.user.username}\'s first project.';
    _walletService = ref.read(walletServiceProvider);
    _projectService = ref.read(projectServiceProvider);
    _authService = ref.read(authServiceProvider);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _walletNameController.dispose();
    _initialBalanceController.dispose();
    _projectNameController.dispose();
    _projectDescriptionController.dispose();
    super.dispose();
  }

  void _suggestCurrency() async {
    try {
      final locale = Platform.localeName;
      final parts = locale.split('_');
      print('Locale parts: $parts');
      if (parts.length > 1) {
        final countryCode = parts[1];
        final currencyMap = currencyToCountryMapping.entries.firstWhere(
          (entry) => entry.value == countryCode,
          orElse: () => const MapEntry('USD', 'US'),
        );
        print('Mapped currency code: ${currencyMap.key}');
        final currencyAsync = ref.watch(currencyProvider(currencyMap.key));
        print('Suggested currency code: ${currencyMap.key}');
        currencyAsync.when(
          data: (currency) {
            print(currency);
            setState((){
              _selectedCurrency = currency;
            });
          },
          error: (_, __) => _setDefaultCurrency(),
          loading: _setDefaultCurrency,
        );
      } else {
        _setDefaultCurrency();
      }
    } catch (e) {
      _setDefaultCurrency();
    }
  }

  void _setDefaultCurrency() {
    setState(() {
      _selectedCurrency = Currency(id: 'USD', code: 'USD', name: 'US dollars', symbol: '\$', decimals: 2, isCrypto: false, isActive: true, tempId: IdGenerator.tempCurrency(), countryISO2: 'US');
    });
  }

  Future<void> _nextStep() async {
    setState(() => _isLoading = true);
    print('Moving to next step $_currentStep');
    try {
      switch (_currentStep) {
        case 0:
          await _handleCurrencyStep();
          break;
        case 1:
          await _handleWalletStep();
          break;
        case 2:
          await _completeSetup();
          return;
      }

      if (_currentStep < 2) {
        _moveToNextStep();
      }
    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleCurrencyStep() async {
    if (_selectedCurrency == null) {
      throw Exception('Please select a currency to continue.');
    }
    print(_selectedCurrency);
    await _preferencesService.setDefaultCurrency(_selectedCurrency!);
    await _preferencesService.syncToBackend(widget.user.id);
    ref.read(defaultCurrencyProvider.notifier).state = _selectedCurrency!;
    ref.read(defaultCurrencyCodeProvider.notifier).state = _selectedCurrency!.code;
  }

  Future<void> _handleWalletStep() async {
    if (_walletType == null || _walletNameController.text.trim().isEmpty) {
      throw Exception('Please enter wallet details to continue.');
    }

    final walletBalance = _initialBalanceController.text;
    print(walletBalance);
    print(_initialBalanceController.text);

    print(_selectedCurrency);
    print(widget.user.id);
    _createdWallet = await _walletService.createWallet(
      name: _walletNameController.text.trim(),
      userId: widget.user.id,
      walletType: _walletType!.name,
      providerId: _walletProvider?.id,
      currency: _selectedCurrency!,
      balance: walletBalance,
      imageUrl: _walletProvider?.imageUrl,
      localImagePath: _walletProvider?.localImagePath,
      isGlobal: true,
      iconCodePoint: _walletProvider?.iconCodePoint,
      iconEmoji: _walletProvider?.iconEmoji,
      iconType: _walletProvider?.iconType,
      color: _walletProvider?.color
    );

    // Set the created wallet as the default selected wallet for the project
    _selectedDefaultWalletId = _createdWallet?.id;
  }

  void _moveToNextStep() {
    setState(() => _currentStep++);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _analytics.logInitialConfigViewed(step: _currentStep);
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeSetup() async {
    // if (!_formKey.currentState!.validate()) {
    //   setState(() => _isLoading = false);
    //   return;
    // }

    print('Creating first project');

    // Get project service from provider
    final walletsAsync = ref.read(walletsProvider);

    walletsAsync.whenData((wallets) async {
      final defaultWallet = wallets[0];
      print(defaultWallet);
      final project = await _projectService.createProject(
        name: _projectNameController.text.trim(),
        description: _projectDescriptionController.text.trim().isEmpty
            ? null
            : _projectDescriptionController.text.trim(),
        defaultWallet: defaultWallet.id,
        userId: widget.user.id,
      );
      _analytics.logInitialConfigCompleted(
        currency: _selectedCurrency!,
        walletType: _walletType!.name,
      );
      if (mounted) {
        _showSuccess('Setup complete! Project "${project.name}" created.');
        _navigateToMain();
      }
    });
    // Create first project


  }

  void _skipSetup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skip Setup?'),
        content: const Text(
          'You can configure your currency, wallet, and project later from settings. Continue with default settings?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _analytics.logInitialConfigSkipped(step: _currentStep);
              _navigateToMain();
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }

  void _navigateToMain() {
    _analytics.logOnboardingCompleted();
    Navigator.pushReplacementNamed(context, '/main', arguments: widget.user);
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.read(appColorsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Your Account'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
        actions: [
          // TextButton(
          //   onPressed: _skipSetup,
          //   child: const Text('Skip'),
          // ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Progress indicator
              StepProgressBar(
                currentStep: _currentStep,
                stepLabels: _stepLabels,
              ),

              // Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CurrencyStep(
                      selectedCurrency: _selectedCurrency,
                      onCurrencySelected: (currency) { 
                        print(currency);
                        setState(() => _selectedCurrency = currency);
                      },
                    ),
                    WalletStep(
                      walletNameController: _walletNameController,
                      initialBalanceController: _initialBalanceController,
                      walletType: _walletType,
                      walletProvider: _walletProvider,
                      onWalletTypeChanged: (type) =>
                          setState(() => _walletType = type),
                      onWalletProviderChanged: (provider)
                          {
                            print(provider);
                            setState(() { 
                              _walletProvider = provider;
                            });
                          },
                    ),
                    ProjectStep(
                      projectNameController: _projectNameController,
                      projectDescriptionController:
                          _projectDescriptionController,
                      createdWallet: _createdWallet,
                      selectedWalletId: _selectedDefaultWalletId,
                      onWalletChanged: (String? walletId) {
                        print(walletId);
                        setState(() {
                          _selectedDefaultWalletId = walletId;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Action button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.text,
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
                            _currentStep == 2 ? 'Complete Setup' : 'Continue',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import '../../models/user_model.dart';
import '../../services/wallet_service.dart';
import '../../services/project_service.dart';
import '../../services/analytics_service.dart';

class InitialConfigScreen extends StatefulWidget {
  final User user;

  const InitialConfigScreen({
    super.key,
    required this.user,
  });

  @override
  State<InitialConfigScreen> createState() => _InitialConfigScreenState();
}

class _InitialConfigScreenState extends State<InitialConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  int _currentStep = 0;
  bool _isLoading = false;

  // Services
  final WalletService _walletService = WalletService();
  final ProjectService _projectService = ProjectService();
  final AnalyticsService _analytics = AnalyticsService();

  // Step 1: Currency selection
  String? _selectedCurrency;
  final Map<String, String> _currencies = {
    'USD': '\$ - US Dollar',
    'EUR': '€ - Euro',
    'GBP': '£ - British Pound',
    'JPY': '¥ - Japanese Yen',
    'CNY': '¥ - Chinese Yuan',
    'INR': '₹ - Indian Rupee',
    'CAD': '\$ - Canadian Dollar',
    'AUD': '\$ - Australian Dollar',
    'NGN': '₦ - Nigerian Naira',
    'ZAR': 'R - South African Rand',
    'BTC': '₿ - Bitcoin',
    'ETH': 'Ξ - Ethereum',
  };

  // Step 2: First wallet
  final _walletNameController = TextEditingController();
  String _walletType = 'cash';
  final _initialBalanceController = TextEditingController(text: '0');

  // Step 3: First project
  final _projectNameController = TextEditingController();
  final _projectDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _suggestCurrency();
    _analytics.logInitialConfigViewed(step: _currentStep);
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

  void _suggestCurrency() {
    try {
      // Get device locale
      final locale = Platform.localeName; // e.g., "en_US"
      final parts = locale.split('_');
      if (parts.length > 1) {
        final countryCode = parts[1];

        // Map country codes to currencies
        final currencyMap = {
          'US': 'USD',
          'GB': 'GBP',
          'EU': 'EUR',
          'JP': 'JPY',
          'CN': 'CNY',
          'IN': 'INR',
          'CA': 'CAD',
          'AU': 'AUD',
          'NG': 'NGN',
          'ZA': 'ZAR',
        };

        setState(() {
          _selectedCurrency = currencyMap[countryCode] ?? 'USD';
        });
      } else {
        setState(() {
          _selectedCurrency = 'USD';
        });
      }
    } catch (e) {
      setState(() {
        _selectedCurrency = 'USD';
      });
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _analytics.logInitialConfigViewed(step: _currentStep);
    } else {
      _completeSetup();
    }
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
    Navigator.pushReplacementNamed(
      context,
      '/main',
      arguments: widget.user,
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Step 1: Set currency preference
      // TODO: Implement currency preference API endpoint
      // For now, just store it locally in shared preferences
      // await _currencyService.setDefaultCurrency(_selectedCurrency!);

      // Step 2: Create first wallet
      final walletBalance = (double.tryParse(_initialBalanceController.text) ?? 0) * 100; // Convert to cents
      final wallet = await _walletService.createWallet(
        name: _walletNameController.text.trim(),
        walletType: _walletType,
        currency: _selectedCurrency!,
        balance: walletBalance.toInt(),
      );

      // Step 3: Create first project
      final project = await _projectService.createProject(
        name: _projectNameController.text.trim(),
        description: _projectDescriptionController.text.trim().isEmpty
            ? null
            : _projectDescriptionController.text.trim(),
      );

      // Log analytics
      _analytics.logInitialConfigCompleted(
        currency: _selectedCurrency!,
        walletType: _walletType,
      );

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Setup complete! Wallet "${wallet.name}" and project "${project.name}" created.',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to main navigation
        _navigateToMain();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          TextButton(
            onPressed: _skipSetup,
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    _buildStepIndicator(0, 'Currency'),
                    _buildStepConnector(0),
                    _buildStepIndicator(1, 'Wallet'),
                    _buildStepConnector(1),
                    _buildStepIndicator(2, 'Project'),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildCurrencyStep(),
                    _buildWalletStep(),
                    _buildProjectStep(),
                  ],
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _nextStep,
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

  Widget _buildStepIndicator(int step, String label) {
    final isActive = step == _currentStep;
    final isCompleted = step < _currentStep;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted || isActive
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300],
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      '${step + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(int step) {
    final isCompleted = step < _currentStep;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 32),
        color: isCompleted
            ? Theme.of(context).primaryColor
            : Colors.grey[300],
      ),
    );
  }

  Widget _buildCurrencyStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Your Currency',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This will be your default currency for tracking expenses and income.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Currency list
          ..._currencies.entries.map((entry) {
            return RadioListTile<String>(
              value: entry.key,
              groupValue: _selectedCurrency,
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value;
                });
              },
              title: Text(entry.value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWalletStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Your First Wallet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A wallet helps you track money in different accounts.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Wallet name
          TextFormField(
            controller: _walletNameController,
            decoration: InputDecoration(
              labelText: 'Wallet Name',
              hintText: 'e.g., Main Wallet, Cash, Bank Account',
              prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a wallet name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Wallet type
          DropdownButtonFormField<String>(
            value: _walletType,
            decoration: InputDecoration(
              labelText: 'Wallet Type',
              prefixIcon: const Icon(Icons.category_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'cash', child: Text('Cash')),
              DropdownMenuItem(value: 'bank', child: Text('Bank Account')),
              DropdownMenuItem(value: 'credit', child: Text('Credit Card')),
              DropdownMenuItem(value: 'crypto', child: Text('Crypto Wallet')),
              DropdownMenuItem(value: 'other', child: Text('Other')),
            ],
            onChanged: (value) {
              setState(() {
                _walletType = value!;
              });
            },
          ),
          const SizedBox(height: 16),

          // Initial balance
          TextFormField(
            controller: _initialBalanceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Initial Balance',
              prefixIcon: const Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an initial balance';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProjectStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Your First Project',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Projects help you organize expenses by different areas of your life.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Project name
          TextFormField(
            controller: _projectNameController,
            decoration: InputDecoration(
              labelText: 'Project Name',
              hintText: 'e.g., Personal, Business, Family',
              prefixIcon: const Icon(Icons.folder_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a project name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Project description
          TextFormField(
            controller: _projectDescriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'What will you use this project for?',
              prefixIcon: const Icon(Icons.description_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

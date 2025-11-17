import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/currency_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/providers/user_preferences_provider.dart';
import 'package:billkeep/screens/currencies/add_currency_screen.dart';

import 'package:billkeep/utils/currency_country_mapping.dart';
import 'package:billkeep/utils/wallet_types.dart';
import 'package:billkeep/widgets/currencies/currency_select_list.dart';
import 'package:billkeep/widgets/wallets/select_wallet_type_bottomsheet.dart';
import 'package:billkeep/widgets/wallets/wallet_provider_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../../models/user_model.dart';
import '../../services/wallet_service.dart';
import '../../services/project_service.dart';
import '../../services/analytics_service.dart';
import '../../services/user_preferences_service.dart';

class InitialConfigScreen extends ConsumerStatefulWidget {
  final User user;

  const InitialConfigScreen({super.key, required this.user});

  @override
  ConsumerState<InitialConfigScreen> createState() =>
      _InitialConfigScreenState();
}

class _InitialConfigScreenState extends ConsumerState<InitialConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  int _currentStep = 0;
  bool _isLoading = false;

  // Services
  final WalletService _walletService = WalletService();
  final ProjectService _projectService = ProjectService();
  final AnalyticsService _analytics = AnalyticsService();
  final UserPreferencesService _preferencesService = UserPreferencesService();

  // Step 1: Currency selection
  Currency? _selectedCurrency;

  // Step 2: First wallet
  final _walletNameController = TextEditingController();
  WalletType? _walletType = WalletType.CASH;
  WalletProvider? _walletProvider;
  final _initialBalanceController = TextEditingController(text: '0');

  // Step 3: First project
  final _projectNameController = TextEditingController();
  final _projectDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _suggestCurrency();
    _analytics.logInitialConfigViewed(step: _currentStep);
    if (widget.user != null) {
      _walletNameController.text = '${widget.user.username}\'s Wallet';
      _projectNameController.text = '${widget.user.username}\'s Project';
      _projectDescriptionController.text =
          'This is ${widget.user.username}\'s first project.';
    }
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

        final currencyMap = currencyToCountryMapping.entries.firstWhere(
          (entry) => entry.value == countryCode,
          orElse: () => const MapEntry('USD', 'US'),
        );

        final currencyAsync = ref.watch(currencyProvider(currencyMap.key));

        currencyAsync.when(
          data: (currency) => setState(() {
            _selectedCurrency = currency;
          }),
          error: (Object error, StackTrace stackTrace) {
            _selectedCurrency = Currency(
              code: 'USD',
              decimals: 2,
              isActive: true,
              isCrypto: false,
              name: 'US Dollars',
              symbol: '\$',
              countryISO2: 'US',
            );
          },
          loading: () {
            _selectedCurrency = Currency(
              code: 'USD',
              decimals: 2,
              isActive: true,
              isCrypto: false,
              name: 'US Dollars',
              symbol: '\$',
              countryISO2: 'US',
            );
          },
        );
      } else {
        setState(() {
          _selectedCurrency = Currency(
            code: 'USD',
            decimals: 2,
            isActive: true,
            isCrypto: false,
            name: 'US Dollars',
            symbol: '\$',
            countryISO2: 'US',
          );
        });
      }
    } catch (e) {
      setState(() {
        _selectedCurrency = Currency(
          code: 'USD',
          decimals: 2,
          isActive: true,
          isCrypto: false,
          name: 'US Dollars',
          symbol: '\$',
          countryISO2: 'US',
        );
      });
    }
  }

  void _selectCustomCurrency() async {
    final result = await Navigator.of(
      context,
    ).push(CupertinoModalPopupRoute(builder: (context) => AddCurrencyScreen()));
    if (result != null && result is Currency) {
      setState(() {
        _selectedCurrency = result;
      });
    }
  }

  void _nextStep() async {
    setState(() {
      _isLoading = true;
    });
    if (_currentStep == 0) {
      if (_selectedCurrency == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a currency to continue.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        // Save currency locally using SharedPreferences
        await _preferencesService.setDefaultCurrency(_selectedCurrency!.code);

        // Save currency to backend
        await _preferencesService.syncToBackend(widget.user.id);

        ref.read(defaultCurrencyProvider.notifier).state =
            _selectedCurrency!.code;
        // Move to next step
        setState(() {
          _currentStep++;
          _isLoading = false;
        });
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _analytics.logInitialConfigViewed(step: _currentStep);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save currency: ${e.toString()}'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    if (_currentStep == 1) {
      if (_walletType == null || _walletNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter wallet details to continue.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      try {
        final walletBalance =
            (double.tryParse(_initialBalanceController.text) ?? 0) *
            100; // Convert to cents
        final wallet = await _walletService.createWallet(
          name: _walletNameController.text.trim(),
          userId: widget.user.id,
          walletType: _walletType!.name,
          providerId: _walletProvider?.id,
          currency: _selectedCurrency!,
          balance: walletBalance.toInt(),
        );
        setState(() {
          _isLoading = false;
          _currentStep++;
          _pageController.animateToPage(
            _currentStep,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          _analytics.logInitialConfigViewed(step: _currentStep);
        });
        return;
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create wallet: ${e.toString()}'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
      }
    }
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
    Navigator.pushReplacementNamed(context, '/main', arguments: widget.user);
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
      final walletBalance =
          (double.tryParse(_initialBalanceController.text) ?? 0) *
          100; // Convert to cents
      final wallet = await _walletService.createWallet(
        name: _walletNameController.text.trim(),
        userId: widget.user.id,
        walletType: _walletType!.name,
        providerId: _walletProvider?.id,
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
        walletType: _walletType!.name,
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
        actions: [TextButton(onPressed: _skipSetup, child: const Text('Skip'))],
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
        color: isCompleted ? Theme.of(context).primaryColor : Colors.grey[300],
      ),
    );
  }

  Widget _buildCurrencyStep() {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    final filteredCurrencies = ref.watch(filteredCurrenciesProvider);
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.text),
        actionsIconTheme: IconThemeData(color: colors.text),
        title: Text('Select Currency', style: TextStyle(color: colors.text)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: CupertinoSearchTextField(
              backgroundColor: const Color(0xFFE0E0E0),
              placeholder: 'Search by name, code, or symbol',
              placeholderStyle: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 20,
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                CupertinoIcons.search,
                color: Colors.blueAccent,
              ),
              suffixIcon: const Icon(
                CupertinoIcons.xmark_circle_fill,
                color: Colors.redAccent,
              ),
              onChanged: (value) {
                ref.read(currencySearchQueryProvider.notifier).state = value;
              },
            ),
          ),
        ),
        actions: [
          if (_selectedCurrency != null)
            Text(_selectedCurrency!.code, style: TextStyle(fontSize: 24)),
          SizedBox(width: 10),
          if (_selectedCurrency != null)
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: ClipOval(
                child: _selectedCurrency!.isCrypto
                    ? Transform.translate(
                        offset: Platform.isIOS ? Offset(4, -1) : Offset(-1, -3),
                        child: Text(
                          _selectedCurrency!.countryISO2!,
                          style: TextStyle(fontSize: 25),
                        ),
                      )
                    : CountryFlag.fromCountryCode(
                        _selectedCurrency!.countryISO2!,
                        // width: 50,
                        // height: 50,
                      ),
              ),
            ),
          SizedBox(width: 10),
          IconButton(onPressed: _selectCustomCurrency, icon: Icon(Icons.add)),
          SizedBox(width: 20),
        ],
      ),
      body: CurrencyList(
        selectedCurrency: _selectedCurrency,
        currencies: filteredCurrencies,
        onCurrencySelected: (currency) {
          ref.read(currencySearchQueryProvider.notifier).state = '';
          setState(() {
            _selectedCurrency = currency;
          });
        },
      ),
    );

    // SingleChildScrollView(
    //   padding: const EdgeInsets.all(24.0),
    //   child:
    //   Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Text(
    //         'Choose Your Currency',
    //         style: TextStyle(
    //           fontSize: 24,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //       const SizedBox(height: 8),
    //       Text(
    //         'This will be your default currency for tracking expenses and income.',
    //         style: TextStyle(
    //           fontSize: 14,
    //           color: Colors.grey[600],
    //         ),
    //       ),
    //       const SizedBox(height: 24),

    //       // Currency list
    //       ..._currencies.entries.map((entry) {
    //         return RadioListTile<String>(
    //           value: entry.key,
    //           groupValue: _selectedCurrency,
    //           onChanged: (value) {
    //             setState(() {
    //               _selectedCurrency = value;
    //             });
    //           },
    //           title: Text(entry.value),
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //         );
    //       }),
    //     ],
    //   ),

    // );
  }

  Widget _buildWalletStep() {
    // return AddWalletScreen(isInOnboarding: true);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Your First Wallet',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'A wallet helps you track money in different accounts.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Wallet name
          TextFormField(
            controller: _walletNameController,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Wallet Name',
              hintText: 'e.g., Main Wallet, Cash, Bank Account',
              prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
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
          WalletTypeDropdown(
            selectedType: _walletType,
            onChanged: (value) {
              setState(() {
                _walletType = value;
              });
            },
          ),

          // DropdownButtonFormField<String>(
          //   value: _walletType,
          //   decoration: InputDecoration(
          //     labelText: 'Wallet Type',
          //     prefixIcon: const Icon(Icons.category_outlined),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //   ),
          //   items: const [
          //     DropdownMenuItem(value: 'cash', child: Text('Cash')),
          //     DropdownMenuItem(value: 'bank', child: Text('Bank Account')),
          //     DropdownMenuItem(value: 'credit', child: Text('Credit Card')),
          //     DropdownMenuItem(value: 'crypto', child: Text('Crypto Wallet')),
          //     DropdownMenuItem(value: 'other', child: Text('Other')),
          //   ],
          //   onChanged: (value) {
          //     setState(() {
          //       _walletType = value!;
          //     });
          //   },
          // ),
          const SizedBox(height: 16),

          // Initial balance
          TextFormField(
            controller: _initialBalanceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Initial Balance',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  top: 11.0,
                  left: 12.0,
                  right: 4.0,
                ),
                child: DefaultCurrencyDisplay(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
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
          const SizedBox(height: 16),
          if (_walletType != null && _walletType != WalletType.CASH)
            WalletProviderDropdown(
              onChanged: (provider) {
                // Handle provider selection if needed
                setState(() {
                  _walletProvider = provider;
                });
              },
              selectedWalletType: _walletType!,
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Projects help you organize expenses by different areas of your life.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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

class DefaultCurrencyDisplay extends ConsumerWidget {
  const DefaultCurrencyDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyAsync = ref.watch(defaultCurrencyObjectProvider);

    return currencyAsync.when(
      data: (currency) {
        if (currency == null) return const Text('?');
        return Text('${currency.code} - ${currency.symbol}');
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text('Error: $err'),
    );
  }
}

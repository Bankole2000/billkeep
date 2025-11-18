import 'dart:io';
import 'package:billkeep/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/bank_provider.dart';
import 'package:billkeep/providers/currency_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/providers/wallet_provider.dart';
import 'package:billkeep/utils/app_colors.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/currency_helper.dart';
import 'package:billkeep/utils/validators.dart';
import 'package:billkeep/utils/wallet_types.dart';
import 'package:billkeep/widgets/wallets/form/currency_balance_section.dart';
import 'package:billkeep/widgets/wallets/form/wallet_name_section.dart';
import 'package:billkeep/widgets/wallets/form/wallet_provider_section.dart';
import 'package:billkeep/widgets/wallets/form/appearance_section.dart';
import 'package:billkeep/widgets/wallets/select_wallet_type_bottomsheet.dart';

/// Refactored wallet form screen with extracted sections
class AddWalletScreen extends ConsumerStatefulWidget {
  const AddWalletScreen({super.key, this.wallet, this.isInOnboarding = false});

  final Wallet? wallet;
  final bool isInOnboarding;

  @override
  ConsumerState<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends ConsumerState<AddWalletScreen> {
  // Form state
  WalletType? _selectedWalletType;
  Currency? _selectedCurrency;
  WalletProvider? _selectedWalletProvider;
  bool _useProviderAppearance = false;

  // Controllers
  late TextEditingController _amountController;
  late TextEditingController _nameController;
  final TextEditingController _imageUrlController = TextEditingController();

  // Appearance state
  Color? _selectedColor;
  IconData? _selectedIcon = Icons.account_balance;
  String? _selectedEmoji = '💳';
  File? _localImageFile;
  IconSelectionType _selectedSegment = IconSelectionType.emoji;

  // Form state
  String? walletId;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _nameController = TextEditingController();

    // Initialize from existing wallet
    if (widget.wallet != null) {
      _initializeFromWallet(widget.wallet!);
    } else {
      _initializeNewWallet();
    }
  }

  void _initializeFromWallet(Wallet wallet) {
    walletId = wallet.id;
    _amountController.text = CurrencyHelper.centsToDollars(wallet.balance);
    _nameController.text = wallet.name;
    _selectedWalletType = WalletTypes.stringToEnum(wallet.walletType);

    if (wallet.iconType == IconSelectionType.image.name ||
        wallet.iconType == 'localImage') {
      _selectedSegment = IconSelectionType.image;
      if (wallet.localImagePath != null) {
        _localImageFile = File(wallet.localImagePath!);
      }
      _imageUrlController.text =
          wallet.imageUrl ?? 'https://picsum.photos/200/300';
    }

    if (wallet.iconCodePoint != null) {
      _selectedIcon = IconData(
        wallet.iconCodePoint!,
        fontFamily: 'MaterialIcons',
      );
    }
    _selectedEmoji = wallet.iconEmoji ?? '💳';
  }

  void _initializeNewWallet() {
    _amountController.text = '0';
    _nameController.text = '';
    _imageUrlController.text = 'https://picsum.photos/200/300';
    _selectedWalletType = WalletType.CASH;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeCurrency();
    _initializeWalletProvider();
    _initializeColor();
  }

  void _initializeCurrency() {
    if (_selectedCurrency != null) return;

    final currenciesAsync = ref.read(allCurrenciesProvider);
    currenciesAsync.whenData((currencies) {
      final defaultCode = widget.wallet?.currency ?? 'USD';
      final currency = currencies.firstWhere(
        (c) => c.code == defaultCode,
        orElse: () => currencies.firstWhere((c) => c.code == 'USD'),
      );
      setState(() => _selectedCurrency = currency);
    });
  }

  void _initializeWalletProvider() {
    if (_selectedWalletProvider != null) return;
    if (widget.wallet?.providerId == null) return;

    final providersAsync = ref.read(allWalletProvidersProvider);
    providersAsync.whenData((providers) {
      final provider = providers.firstWhere(
        (wp) => wp.id == widget.wallet!.providerId,
        orElse: () => providers.first,
      );
      setState(() => _selectedWalletProvider = provider);
    });
  }

  void _initializeColor() {
    if (_selectedColor != null) return;

    if (widget.wallet?.color != null) {
      setState(() {
        _selectedColor = HexColor.fromHex('#${widget.wallet!.color}');
      });
    } else {
      setState(() {
        _selectedColor = ref.read(appColorsProvider).textMute;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveWallet() async {
    if (_selectedWalletType == null) {
      _showError('Please Select Wallet type');
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final iconType = _determineIconType();

      final result = walletId == null
          ? await _createWallet(iconType)
          : await _updateWallet(iconType);

      if (mounted) {
        _showSuccess('Wallet ${walletId == null ? 'created' : 'updated'}');
        Navigator.pop(context, result);
      }
    } catch (e) {
      if (mounted) {
        _showError('Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _determineIconType() {
    if (_useProviderAppearance && _selectedWalletProvider != null) {
      final providerIconType = _selectedWalletProvider!.iconType;
      final providerImageUrl = _selectedWalletProvider!.imageUrl;

      if (providerIconType == IconSelectionType.image.name) {
        return Validators.isValidUrl(providerImageUrl ?? '')
            ? IconSelectionType.image.name
            : 'localImage';
      }
      return providerIconType;
    }

    if (_selectedSegment == IconSelectionType.image) {
      return Validators.isValidUrl(_imageUrlController.text)
          ? IconSelectionType.image.name
          : 'localImage';
    }

    return _selectedSegment.name;
  }

  Future<dynamic> _createWallet(String iconType) async {
    final userId = ref.read(currentUserIdProvider);
    if(userId == null) {
      throw Exception('User not logged in');
    }
    return await ref.read(walletRepositoryProvider).createWallet(
          name: _nameController.text.trim(),
          userId: userId!,
          walletType: _selectedWalletType!.name,
          currency: _selectedCurrency!.code,
          balance: _amountController.text.replaceAll(',', ''),
          providerId: _selectedWalletProvider?.id,
          imageUrl: _useProviderAppearance
              ? _selectedWalletProvider?.imageUrl
              : _imageUrlController.text,
          localImagePath: _useProviderAppearance
              ? _selectedWalletProvider?.localImagePath
              : _localImageFile?.path,
          iconEmoji: _useProviderAppearance
              ? _selectedWalletProvider?.iconEmoji
              : _selectedEmoji,
          iconCodePoint: _useProviderAppearance
              ? _selectedWalletProvider?.iconCodePoint
              : _selectedIcon?.codePoint,
          iconType: iconType,
          color: _selectedColor?.toHexString(),
          isGlobal: true,
        );
  }

  Future<dynamic> _updateWallet(String iconType) async {
    return await ref.read(walletRepositoryProvider).updateWallet(
          walletId: walletId!,
          name: _nameController.text.trim(),
          walletType: _selectedWalletType!.name,
          currency: _selectedCurrency!.code,
          balance: _amountController.text.replaceAll(',', ''),
          providerId: _selectedWalletProvider?.id,
          imageUrl: _useProviderAppearance
              ? _selectedWalletProvider?.imageUrl
              : _imageUrlController.text,
          localImagePath: _useProviderAppearance
              ? _selectedWalletProvider?.localImagePath
              : _localImageFile?.path,
          iconEmoji: _useProviderAppearance
              ? _selectedWalletProvider?.iconEmoji
              : _selectedEmoji,
          iconCodePoint: _useProviderAppearance
              ? _selectedWalletProvider?.iconCodePoint
              : _selectedIcon?.codePoint,
          iconType: iconType,
          color: _selectedColor?.toHexString(),
          isGlobal: true,
        );
  }

  void _showError(String message) {
    final colors = ref.read(appColorsProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SelectableText(message),
        backgroundColor: colors.fire,
      ),
    );
  }

  void _showSuccess(String message) {
    final colors = ref.read(appColorsProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors.navy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.text),
        actionsIconTheme: IconThemeData(color: colors.text),
        title: Text(
          '${walletId == null ? 'New' : 'Edit'} Wallet',
          style: TextStyle(color: colors.text),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: WalletTypeDropdown(
                selectedType: _selectedWalletType,
                onChanged: (value) => setState(() => _selectedWalletType = value),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Currency and balance
                CurrencyBalanceSection(
                  amountController: _amountController,
                  selectedCurrency: _selectedCurrency,
                  onCurrencySelected: (currency) =>
                      setState(() => _selectedCurrency = currency),
                ),
                Divider(height: 1, color: colors.textMute),

                // Wallet name
                WalletNameSection(nameController: _nameController),

                // Wallet provider
                WalletProviderSection(
                  selectedWalletType: _selectedWalletType,
                  selectedWalletProvider: _selectedWalletProvider,
                  useProviderAppearance: _useProviderAppearance,
                  onProviderSelected: (provider) =>
                      setState(() => _selectedWalletProvider = provider),
                  onUseProviderAppearanceChanged: (value) =>
                      setState(() => _useProviderAppearance = value),
                ),

                // Appearance
                AppearanceSection(
                  useProviderAppearance: _useProviderAppearance,
                  selectedSegment: _selectedSegment,
                  selectedIcon: _selectedIcon,
                  selectedEmoji: _selectedEmoji,
                  selectedColor: _selectedColor,
                  imageUrlController: _imageUrlController,
                  localImageFile: _localImageFile,
                  onSegmentChanged: (segment) =>
                      setState(() => _selectedSegment = segment),
                  onIconSelected: (icon) =>
                      setState(() => _selectedIcon = icon),
                  onEmojiSelected: (emoji) =>
                      setState(() => _selectedEmoji = emoji),
                  onColorChanged: (color) =>
                      setState(() => _selectedColor = color),
                  onLocalImageChanged: (file) =>
                      setState(() => _localImageFile = file),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: widget.isInOnboarding
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveWallet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeColor,
                    foregroundColor: colors.textInverse,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'SAVE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
    );
  }
}

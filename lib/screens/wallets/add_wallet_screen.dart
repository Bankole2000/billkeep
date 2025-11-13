import 'dart:io';

import 'package:billkeep/database/database.dart';
import 'package:billkeep/main.dart' as main;
import 'package:billkeep/providers/bank_provider.dart';
import 'package:billkeep/providers/currency_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/providers/wallet_provider.dart';
import 'package:billkeep/screens/camera/camera_screen.dart';
import 'package:billkeep/screens/currencies/currency_select_screen.dart';
import 'package:billkeep/screens/wallets/providers/select_wallet_provider_screen.dart';
import 'package:billkeep/utils/app_colors.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/currency_helper.dart';
import 'package:billkeep/utils/image_helpers.dart';
import 'package:billkeep/utils/validators.dart';
import 'package:billkeep/utils/wallet_types.dart';
import 'package:billkeep/widgets/common/color_picker_widget.dart';
import 'package:billkeep/widgets/common/dynamic_avatar.dart';
import 'package:billkeep/widgets/common/emoji_picker_widget.dart';
import 'package:billkeep/widgets/common/icon_picker_widget.dart';
import 'package:billkeep/widgets/common/sliding_segment_control_label.dart';
import 'package:billkeep/widgets/wallets/select_wallet_type_bottomsheet.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddWalletScreen extends ConsumerStatefulWidget {
  const AddWalletScreen({super.key, this.wallet, this.isInOnboarding = false});

  final Wallet? wallet;
  final bool isInOnboarding;

  @override
  ConsumerState<AddWalletScreen> createState() => _AddWalletScreenState();
}

class MenuItem {
  final String value;
  final String label;
  final IconData icon;
  final String description;

  MenuItem(this.value, this.label, this.icon, this.description);
}

class _AddWalletScreenState extends ConsumerState<AddWalletScreen> {
  WalletType? _selectedWalletType;
  Currency? _selectedCurrency;
  late TextEditingController _amountController;
  late TextEditingController _nameController;
  WalletProvider? _selectedWalletProvider;
  bool _useProviderAppearance = false;

  final TextEditingController _imageUrlController = TextEditingController();
  Color? _selectedColor;
  IconData? _selectedIcon = Icons.account_balance;
  String? _selectedEmoji = '💳';
  File? _localImageFile;
  final ImagePicker _picker = ImagePicker();
  final bool? _isArchived = false;
  bool? _isLoading = false;

  IconSelectionType _selectedSegment = IconSelectionType.emoji;
  String? walletId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _nameController = TextEditingController();

    // Basic initialization that doesn't require ref
    if (widget.wallet != null) {
      walletId = widget.wallet!.id;
      _amountController.text = CurrencyHelper.centsToDollars(
        widget.wallet!.balance,
      );
      _nameController.text = widget.wallet!.name;
      _selectedWalletType = WalletTypes.stringToEnum(widget.wallet!.walletType);

      if (widget.wallet?.iconType == IconSelectionType.image.name ||
          widget.wallet?.iconType == 'localImage') {
        _selectedSegment = IconSelectionType.image;
        if (widget.wallet?.localImagePath != null) {
          _localImageFile = File(widget.wallet!.localImagePath!);
        }
        _imageUrlController.text =
            widget.wallet?.imageUrl ?? 'https://picsum.photos/200/300';
      }

      if (widget.wallet!.iconCodePoint != null) {
        _selectedIcon = IconData(
          widget.wallet!.iconCodePoint!,
          fontFamily: 'MaterialIcons',
        );
      }
      _selectedEmoji = widget.wallet!.iconEmoji ?? '💳';
    } else {
      _amountController.text = '0';
      _nameController.text = '';
      _imageUrlController.text = 'https://picsum.photos/200/300';
      _selectedWalletType = WalletType.CASH;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize values that depend on providers
    if (widget.wallet != null) {
      // Get currency from provider
      final currenciesAsync = ref.read(allCurrenciesProvider);
      currenciesAsync.whenData((currencies) {
        final currency = currencies.firstWhere(
          (c) => c.code == widget.wallet?.currency,
          orElse: () => currencies.firstWhere((c) => c.code == 'USD'),
        );
        if (_selectedCurrency == null) {
          setState(() {
            _selectedCurrency = currency;
          });
        }
      });

      // Get wallet provider from provider
      if (widget.wallet!.providerId != null) {
        final providersAsync = ref.read(allWalletProvidersProvider);
        providersAsync.whenData((providers) {
          final provider = providers.firstWhere(
            (wp) => wp.id == widget.wallet!.providerId,
            orElse: () => providers.first,
          );
          if (_selectedWalletProvider == null) {
            setState(() {
              _selectedWalletProvider = provider;
            });
          }
        });
      }

      // Get color
      if (_selectedColor == null && widget.wallet!.color != null) {
        setState(() {
          _selectedColor = HexColor.fromHex('#${widget.wallet!.color}');
        });
      } else if (_selectedColor == null) {
        setState(() {
          _selectedColor = ref.read(appColorsProvider).textMute;
        });
      }
    } else {
      // For new wallets, set default currency
      if (_selectedCurrency == null) {
        final currenciesAsync = ref.read(allCurrenciesProvider);
        currenciesAsync.whenData((currencies) {
          final currency = currencies.firstWhere(
            (c) => c.code == 'USD',
            orElse: () => currencies.first,
          );
          setState(() {
            _selectedCurrency = currency;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _selectCurrency() async {
    final result = await Navigator.of(context).push<Currency>(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => CurrencySelectScreen(),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedCurrency = result;
      });
    }
  }

  void _selectWalletProvider() async {
    final result = await Navigator.of(context).push<WalletProvider>(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) =>
            WalletProviderSelectScreen(walletType: _selectedWalletType),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedWalletProvider = result;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _localImageFile = File(image.path);
          _imageUrlController.text = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    // Check if cameras are available
    if (main.cameras.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No camera available on this device'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Navigate to camera screen and wait for result
    final XFile? photo = await Navigator.push<XFile>(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: main.cameras.first),
      ),
    );

    if (photo != null) {
      setState(() {
        _localImageFile = File(photo.path);

        _imageUrlController.text = photo.path;
      });
    }
  }

  void _pasteUrl() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final pastedText = clipboardData?.text;
    if (pastedText != null && Validators.isValidUrl(pastedText)) {
      setState(() {
        _imageUrlController.text = pastedText;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Image url in Clipboard'),
          backgroundColor: ref.read(appColorsProvider).fire,
        ),
      );
    }
  }

  void _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: _imageUrlController.text));
  }

  void _saveWallet() async {
    // TODO: check for default currency
    if (_selectedWalletType == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please Select Wallet type'),
            backgroundColor: ref.read(appColorsProvider).fire,
          ),
        );
      }
      return;
    }
    if (_formKey.currentState!.validate()) {
      if (mounted) {
        setState(() => _isLoading = true);
      }
      String iconType = '';
      if (_useProviderAppearance && _selectedWalletProvider != null) {
        iconType =
            _selectedWalletProvider!.iconType == IconSelectionType.image.name &&
                Validators.isValidUrl(_selectedWalletProvider!.imageUrl!)
            ? IconSelectionType.image.name
            : _selectedWalletProvider!.iconType ==
                      IconSelectionType.image.name &&
                  !Validators.isValidUrl(_selectedWalletProvider!.imageUrl!)
            ? 'localImage'
            : _selectedWalletProvider!.iconType;
        _imageUrlController.text = _selectedWalletProvider!.imageUrl ?? '';
        _selectedEmoji = _selectedWalletProvider!.iconEmoji;
      } else {
        iconType =
            _selectedSegment == IconSelectionType.image &&
                Validators.isValidUrl(_imageUrlController.text)
            ? IconSelectionType.image.name
            : _selectedSegment == IconSelectionType.image &&
                  Validators.isValidUrl(_imageUrlController.text)
            ? 'localImage'
            : _selectedSegment.name;
      }
      try {
        final result = walletId == null
            ? await ref
                  .read(walletRepositoryProvider)
                  .createWallet(
                    name: _nameController.text.trim(),
                    walletType: _selectedWalletType!.name,
                    currency: _selectedCurrency!.code,
                    balance: _amountController.text.replaceAll(',', ''),
                    providerId: _selectedWalletProvider?.id,
                    imageUrl: _imageUrlController.text,
                    localImagePath: _useProviderAppearance
                        ? _selectedWalletProvider!.localImagePath
                        : _localImageFile?.path,
                    iconEmoji: _selectedEmoji,
                    iconCodePoint: _useProviderAppearance
                        ? _selectedWalletProvider!.iconCodePoint
                        : _selectedIcon?.codePoint,
                    iconType: iconType,
                    color: _selectedColor?.toHexString(),
                    isGlobal: true,
                  )
            : await ref
                  .read(walletRepositoryProvider)
                  .updateWallet(
                    walletId: walletId!,
                    name: _nameController.text.trim(),
                    walletType: _selectedWalletType!.name,
                    currency: _selectedCurrency!.code,
                    balance: _amountController.text.replaceAll(',', ''),

                    providerId: _selectedWalletProvider?.id,
                    imageUrl: _imageUrlController.text,
                    localImagePath: _useProviderAppearance
                        ? _selectedWalletProvider!.localImagePath
                        : _localImageFile?.path,
                    iconEmoji: _selectedEmoji,
                    iconCodePoint: _useProviderAppearance
                        ? _selectedWalletProvider!.iconCodePoint
                        : _selectedIcon?.codePoint,
                    iconType: iconType,
                    color: _selectedColor?.toHexString(),
                    isGlobal: true,
                  );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Success: Wallet ${walletId == null ? 'created' : 'updated'}',
              ),
              backgroundColor: ref.read(appColorsProvider).navy,
            ),
          );
          Navigator.pop(context, result);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: SelectableText('Error: $e'),
              backgroundColor: ref.read(appColorsProvider).fire,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return Scaffold(
      // backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.text),
        actionsIconTheme: IconThemeData(color: colors.text),
        title: Text(
          '${walletId == null ? 'New' : 'Edit'} Wallet',
          style: TextStyle(color: colors.text),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: WalletTypeDropdown(
                  selectedType: _selectedWalletType,
                  onChanged: (WalletType? value) {
                    setState(() {
                      _selectedWalletType = value;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - ((100 as num)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    top: 20,
                    left: 20,
                    bottom: 0,
                  ),
                  child: Text('Currency & Starting Balance'),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _selectCurrency,
                        label: Text(
                          _selectedCurrency != null
                              ? _selectedCurrency!.symbol
                              : '₦',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: colors.text,
                          ),
                        ),
                        icon: Icon(Icons.chevron_right),
                        iconAlignment: IconAlignment.end,
                      ),
                      // const Spacer(),
                      Expanded(
                        child: TextFormField(
                          // textDirection: TextDirection.rtl,
                          // initialValue: _amountController.toString(),
                          controller: _amountController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                            CurrencyInputFormatter(
                              thousandSeparator: ThousandSeparator.Comma,
                            ),
                          ],
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: TextStyle(
                            fontSize: 44, // large font size
                            fontWeight: FontWeight.w600,
                            color: colors.text,
                          ),
                          decoration: InputDecoration(
                            border:
                                InputBorder.none, // removes underline/borders
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: '0.00',
                            hintStyle: TextStyle(
                              fontSize: 50,
                              color: colors.text,
                            ),
                            contentPadding:
                                EdgeInsets.zero, // keeps alignment tight
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: colors.textMute),

                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Material(
                    // elevation: 5,
                    // elevation: _isFocused ? 4.0 : 0.0,
                    child: ListTile(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        left: 10,
                        right: 20,
                      ),
                      visualDensity: VisualDensity(vertical: 0.1),
                      trailing: Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Icon(
                          Icons.edit_sharp,
                          size: 30,
                          color: colors.textMute,
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsetsGeometry.only(top: 0, left: 10),
                        child: Text('Wallet Name', textAlign: TextAlign.start),
                      ),
                      subtitle: CupertinoTextFormFieldRow(
                        // focusNode: _focusNode,
                        controller: _nameController,
                        style: TextStyle(fontSize: 30),
                        padding: EdgeInsets.all(0),
                        placeholder: 'Required',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a wallet name';
                          }
                          return null;
                        },
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),

                if ((_selectedWalletType != WalletType.CASH &&
                    _selectedWalletType != null))
                  Divider(height: 1),
                if ((_selectedWalletType != WalletType.CASH &&
                    _selectedWalletType != null))
                  Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: 20,
                      top: 10,
                      bottom: 0,
                    ),
                    child: Text('Wallet Provider'),
                  ),

                AnimatedSize(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: SizedBox(
                    height:
                        _selectedWalletType == WalletType.CASH ||
                            _selectedWalletType == null
                        ? 0
                        : null,
                    child: ListTile(
                      dense: true,
                      leading: _selectedWalletProvider == null
                          ? DynamicAvatar(icon: Icons.account_balance, size: 44)
                          : DynamicAvatar(
                              icon:
                                  _selectedWalletProvider?.iconType ==
                                      IconSelectionType.icon.name
                                  ? IconData(
                                      _selectedWalletProvider!.iconCodePoint!,
                                      fontFamily: 'MaterialIcons',
                                    )
                                  : null,
                              emoji:
                                  _selectedWalletProvider?.iconType ==
                                      IconSelectionType.emoji.name
                                  ? _selectedWalletProvider?.iconEmoji
                                  : null,
                              image:
                                  _selectedWalletProvider?.iconType ==
                                          IconSelectionType.image.name ||
                                      _selectedWalletProvider?.iconType == null
                                  ? (_selectedWalletProvider?.localImagePath !=
                                            null
                                        ? FileImage(
                                            File(
                                              _selectedWalletProvider!
                                                  .localImagePath!,
                                            ),
                                          )
                                        : _selectedWalletProvider!.imageUrl !=
                                              null
                                        ? cachedImageProvider(
                                            _selectedWalletProvider!.imageUrl!,
                                          )
                                        : null)
                                  : null,
                              size: 44,
                              color: _selectedWalletProvider?.color != null
                                  ? HexColor.fromHex(
                                      _selectedWalletProvider!.color!,
                                    )
                                  : null,
                            ),
                      visualDensity: _selectedWalletProvider == null
                          ? VisualDensity(vertical: 2)
                          : null,
                      title: _selectedWalletProvider != null
                          ? Text(_selectedWalletProvider!.name)
                          : Text('Select Provider'),
                      subtitle: _selectedWalletProvider != null
                          ? Text(_selectedWalletProvider!.description!)
                          : null,
                      onTap: _selectWalletProvider,
                    ),
                  ),
                ),
                Divider(height: 1),

                ClipRect(
                  child: AnimatedSize(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: SizedBox(
                      height:
                          _selectedWalletType == WalletType.CASH ||
                              _selectedWalletType == null
                          ? 0
                          : null,
                      child: SwitchListTile(
                        value: _useProviderAppearance,
                        onChanged: (isChecked) {
                          setState(() {
                            _useProviderAppearance = isChecked;
                          });
                        },
                        title: Text('Use Provider Appearance'),
                        subtitle: Text(
                          'Use provider appearance as the wallet appearance',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),

                if (!_useProviderAppearance)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    child: Material(
                      // elevation: 5,
                      // elevation: _isFocused ? 4.0 : 0.0,
                      child: ListTile(
                        tileColor: colors.surface,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        contentPadding: EdgeInsets.only(
                          top: 0,
                          left: 10,
                          right: 20,
                        ),
                        visualDensity: VisualDensity(vertical: 0.1),
                        title: Padding(
                          padding: EdgeInsetsGeometry.only(
                            top: 0,
                            left: 8,
                            bottom: 10,
                          ),
                          child: Text(
                            'Appearance',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: colors.text),
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          // children: [],
                          children: [
                            SizedBox(width: 4),
                            DynamicAvatar(
                              emojiOffset: Platform.isIOS
                                  ? Offset(11, 6)
                                  : Offset(7, 5),
                              icon: _selectedSegment == IconSelectionType.icon
                                  ? _selectedIcon
                                  : null,
                              emoji: _selectedSegment == IconSelectionType.emoji
                                  ? _selectedEmoji
                                  : null,
                              image: _selectedSegment == IconSelectionType.image
                                  ? (_localImageFile != null
                                        ? FileImage(_localImageFile!)
                                        : _imageUrlController.text
                                              .trim()
                                              .isNotEmpty
                                        ? cachedImageProvider(_imageUrlController.text)
                                        : null)
                                  : null,
                              size: 50,
                              color: _selectedColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CustomSlidingSegmentedControl<IconSelectionType>(
                                // isStretch: true,
                                initialValue: _selectedSegment,
                                children: {
                                  IconSelectionType
                                      .icon: SlidingSegmentControlLabel(
                                    isActive:
                                        _selectedSegment ==
                                        IconSelectionType.icon,
                                    label: 'Icon',
                                    icon:
                                        iconSelectionTypeIcons[IconSelectionType
                                            .icon]!,
                                    activeColor: colors.fire,
                                  ),
                                  IconSelectionType
                                      .emoji: SlidingSegmentControlLabel(
                                    icon:
                                        iconSelectionTypeIcons[IconSelectionType
                                            .emoji]!,
                                    label: 'Emoji',
                                    isActive:
                                        _selectedSegment ==
                                        IconSelectionType.emoji,
                                    activeColor: colors.wave,
                                  ),
                                  IconSelectionType
                                      .image: SlidingSegmentControlLabel(
                                    icon:
                                        iconSelectionTypeIcons[IconSelectionType
                                            .image]!,
                                    label: 'Image',
                                    isActive:
                                        _selectedSegment ==
                                        IconSelectionType.image,
                                    activeColor: colors.water,
                                  ),
                                },
                                onValueChanged: (value) {
                                  setState(() {
                                    _selectedSegment = value;
                                  });
                                },
                                innerPadding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                thumbDecoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            ColorSelectorButton(
                              selectedColor: _selectedColor,
                              onColorChanged: (color) {
                                setState(() {
                                  _selectedColor = color;
                                });
                              },
                              pickerType: ColorPickerType.block,
                            ),
                          ],
                        ),
                        onTap: () {},
                        minTileHeight: 10,
                      ),
                    ),
                  ),
                if (!_useProviderAppearance) Divider(height: 1),
                if (_selectedSegment == IconSelectionType.icon &&
                    !_useProviderAppearance)
                  IconPickerWidget(
                    onIconSelected: (icon) {
                      setState(() {
                        _selectedIcon = icon;
                      });
                    },
                  ),
                if (_selectedSegment == IconSelectionType.emoji &&
                    !_useProviderAppearance)
                  EmojiPickerWidget(
                    onEmojiSelected: (emoji) {
                      setState(() {
                        _selectedEmoji = emoji;
                      });
                    },
                  ),
                if (_selectedSegment == IconSelectionType.image &&
                    !_useProviderAppearance)
                  ListTile(
                    // leading: AppImage(height: 50, width: 50),
                    title: Row(
                      children: [
                        Expanded(
                          child: CupertinoTextFormFieldRow(
                            controller: _imageUrlController,
                            // initialValue: _imageUrl,
                            padding: EdgeInsets.all(0),
                            prefix: Text(
                              'Url: ',
                              style: TextStyle(color: colors.textMute),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _copyToClipboard(_imageUrlController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('ImageURL Copied to Clipboard'),
                                backgroundColor: colors.navy,
                              ),
                            );
                          },
                          icon: Icon(Icons.copy),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: EdgeInsetsGeometry.only(top: 8, bottom: 16),
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _pickImageFromGallery,
                            label: Text('Gallery'),
                            icon: Icon(Icons.image),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: activeColor,
                              foregroundColor: colors.textInverse,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: _takePhoto,
                            label: Text('Camera'),
                            icon: Icon(Icons.camera_alt),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: activeColor,
                              foregroundColor: colors.textInverse,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: _pasteUrl,
                            label: Text('Url'),
                            icon: Icon(Icons.link),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: activeColor,
                              foregroundColor: colors.textInverse,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Divider(height: 1),
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
                  onPressed: _saveWallet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeColor,
                    foregroundColor: colors.textInverse,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'SAVE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
    );
  }
}

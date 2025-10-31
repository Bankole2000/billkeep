import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/currencies/currency_select_screen.dart';
import 'package:billkeep/screens/wallets/providers/select_wallet_provider_screen.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/wallet_types.dart';
import 'package:billkeep/widgets/common/dynamic_avatar.dart';
import 'package:billkeep/widgets/common/sliding_segment_control_label.dart';
import 'package:billkeep/widgets/wallets/select_wallet_type_bottomsheet.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWalletScreen extends ConsumerStatefulWidget {
  const AddWalletScreen({super.key, this.wallet});

  final Wallet? wallet;

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
  late TextEditingController amountController;
  var enteredName = '';
  WalletProvider? _selectedWalletProvider;

  IconSelectionType _selectedSegment = IconSelectionType.emoji;
  String? merchantId;
  final _formKey = GlobalKey<FormState>();
  var enteredDescription = '';
  var enteredWebsite = '';
  var imageUrl = '';

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _selectCurrency() async {
    final result = await Navigator.of(context).push<Currency>(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => CurrencySelectScreen(),
      ),
    );
    print(result);
    if (result != null) {
      setState(() {
        _selectedCurrency = result;
      });
    }
  }

  void _selectWalletProvider() async {
    final result = await Navigator.of(context).push<Currency>(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => WalletProviderSelectScreen(),
      ),
    );
    print(result);
    if (result != null) {
      setState(() {
        _selectedCurrency = result;
      });
    }
  }

  void _saveWallet() async {
    // TODO: check currency
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return Scaffold(
      // backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: activeColor,
        iconTheme: IconThemeData(color: colors.textInverse),
        actionsIconTheme: IconThemeData(color: colors.textInverse),
        title: Text(
          '${merchantId == null ? 'New' : 'Edit'} Wallet',
          style: TextStyle(color: colors.textInverse),
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

            // CupertinoSearchTextField(
            //   backgroundColor: const Color(0xFFE0E0E0),
            //   controller: searchTextController,
            //   placeholder: 'Search',
            //   placeholderStyle: const TextStyle(
            //     color: Color(0xFF9E9E9E), // 🔹 Placeholder color
            //     fontSize: 20,
            //   ),
            //   style: const TextStyle(
            //     color: Colors.black, // 🔹 Input text color
            //     fontSize: 20,
            //     fontWeight: FontWeight.w500,
            //   ),
            //   prefixIcon: const Icon(
            //     CupertinoIcons.search,
            //     color: Colors.blueAccent, // 🔹 Icon color
            //   ),
            //   suffixIcon: const Icon(
            //     CupertinoIcons.xmark_circle_fill,
            //     color: Colors.redAccent, // 🔹 Clear button color
            //   ),
            //   onChanged: (value) {
            //     // handle search
            //   },
            // ),
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
                          // initialValue: amount.toString(),
                          controller: amountController,
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
                            // prefixText: '₦', // or '$', '€', etc.
                            // prefixStyle: const TextStyle(
                            //   fontSize: 50,
                            //   fontWeight: FontWeight.w600,
                            //   color: Colors.black,
                            // ),
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
                        initialValue: enteredName,
                        style: TextStyle(fontSize: 36),
                        padding: EdgeInsets.all(0),
                        placeholder: 'Required',
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),
                Divider(height: 1),
                SizedBox(height: 20),
                Divider(height: 1),
                ListTile(
                  leading: DynamicAvatar(icon: Icons.account_balance),
                  title: Text('Select Provider'),
                  onTap: _selectWalletProvider,
                ),
                Divider(height: 1),

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
                          Icons.edit_note,
                          size: 24,
                          color: colors.textMute,
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsetsGeometry.only(top: 0, left: 8),
                        child: Text('Description', textAlign: TextAlign.start),
                      ),
                      subtitle: CupertinoTextFormFieldRow(
                        // focusNode: _focusNode,
                        initialValue: enteredDescription,
                        style: TextStyle(fontSize: 20),
                        padding: EdgeInsets.all(0),
                        placeholder: 'Optional',
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),
                Divider(height: 1),
                SizedBox(height: 20),

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
                          Icons.link,
                          size: 24,
                          color: colors.textMute,
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsetsGeometry.only(top: 0, left: 8),
                        child: Text('Website Url', textAlign: TextAlign.start),
                      ),
                      subtitle: CupertinoTextFormFieldRow(
                        // focusNode: _focusNode,
                        initialValue: enteredWebsite,
                        style: TextStyle(fontSize: 20),
                        padding: EdgeInsets.all(0),
                        placeholder: 'Optional',
                      ),
                      onTap: () {},
                      minTileHeight: 10,
                    ),
                  ),
                ),
                Divider(height: 1),

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
                        bottom: 0,
                      ),
                      visualDensity: VisualDensity(vertical: 0.1),
                      title: Padding(
                        padding: EdgeInsetsGeometry.only(
                          top: 0,
                          left: 8,
                          bottom: 10,
                        ),
                        child: Text('Appearance', textAlign: TextAlign.start),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        // children: [],
                        children: [
                          DynamicAvatar(
                            icon: imageUrl.isEmpty ? Icons.shop : null,
                            size: 50,
                            image: imageUrl.isEmpty
                                ? null
                                : NetworkImage(imageUrl),
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
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.invert_colors,
                              size: 36,
                              color: colors.textMute,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {},
                      // minTileHeight: 10,
                    ),
                  ),
                ),

                ClipRect(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: SizedBox(
                      height: _selectedSegment == IconSelectionType.image
                          ? null
                          : 0,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(top: 0, left: 20),

                        title: CupertinoTextFormFieldRow(
                          initialValue: imageUrl,
                          padding: EdgeInsets.all(0),
                          prefix: Text(
                            'ImageUrl: ',
                            style: TextStyle(color: colors.textMute),
                          ),

                          // placeholder: 'Title',
                        ),
                        subtitle: Padding(
                          padding: EdgeInsetsGeometry.only(top: 8, bottom: 16),
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                label: Text('Select Image'),
                                icon: Icon(Icons.image),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: activeColor,
                                  foregroundColor: colors.textInverse,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () {},
                                label: Text('Take Photo'),
                                icon: Icon(Icons.camera_alt),
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
                    ),
                  ),
                ),
                Divider(height: 1),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
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

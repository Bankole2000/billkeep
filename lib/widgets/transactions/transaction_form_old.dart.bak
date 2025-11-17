import 'dart:io';

import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/expense_provider.dart';
import 'package:billkeep/providers/project_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/providers/wallet_provider.dart';
import 'package:billkeep/screens/categories/category_select_screen.dart';
import 'package:billkeep/screens/contacts/contact_select_screen.dart';
import 'package:billkeep/screens/merchants/add_merchant_screen.dart';
import 'package:billkeep/screens/merchants/merchant_select_screen.dart';
import 'package:billkeep/utils/app_colors.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/date_helpers.dart';
import 'package:billkeep/utils/image_helpers.dart';
import 'package:billkeep/widgets/common/dynamic_avatar.dart';
import 'package:billkeep/widgets/common/select_recurrence_bottomsheet.dart';
import 'package:billkeep/widgets/projects/select_project_bottomsheet.dart';
import 'package:billkeep/widgets/wallets/select_wallet_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class TransactionForm extends ConsumerStatefulWidget {
  const TransactionForm({super.key, required this.transactionType});

  final TransactionType transactionType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionFormState();
}

enum SingingCharacter { lafayette, jefferson }

class _TransactionFormState extends ConsumerState<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  Category? _selectedCategory;
  Merchant? _selectedMerchant;
  Wallet? _fromWallet;
  Currency? _fromCurrency;
  Currency? _toCurrency;
  WalletWithRelations? _fromWalletWithRelations;
  Wallet? _toWallet;
  WalletWithRelations? _toWalletWithRelations;
  Project? _selectedProject;
  DateTime? _selectedDate = DateTime.now();
  TransactionRecurrence _recurrence = TransactionRecurrence.never;
  bool _setReminder = true;

  TransactionSource source = TransactionSource.MANUAL;

  // bool _createInitialPayment = true;

  // static const Duration duration = Duration(milliseconds: 400);
  // static const Curve curve = Curves.easeIn;
  var amount = 0;

  void _selectProject() async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) =>
          SelectProjectBottomSheet(selectedProject: _selectedProject),
    );
    if (result != null) {
      setState(() {
        _selectedProject = result;
      });
    }
  }

  void _selectWallet({bool to = false}) async {
    final result = await showModalBottomSheet<WalletWithRelations>(
      context: context,
      builder: (BuildContext context) =>
          SelectWalletBottomSheet(selectedWallet: to ? _toWallet : _fromWallet),
    );
    if (result != null) {
      setState(() {
        if (to) {
          _toWalletWithRelations = result;
          _toWallet = result.wallet;
          _toCurrency = result.currency;
        } else {
          _fromWalletWithRelations = result;
          _fromWallet = result.wallet;
          _fromCurrency = result.currency;
        }
      });
    }
  }

  void _selectRecurrence() async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) =>
          SelectRecurrenceBottomSheet(selectedRecurrence: _recurrence),
    );
    if (result != null) {
      setState(() {
        _recurrence = result;
      });
    }
  }

  void _selectContact() async {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => ContactSelectScreen(),
      ),
    );
  }

  void _selectCategory() async {
    final result = await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => TransactionCategorySelectScreen(),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedCategory = result;
        if (_titleController.text.trim().isEmpty) {
          _titleController.text = _selectedCategory!.name;
        }
      });
    }
  }

  void _selectTags() async {
    // Navigator.of(context).push(
    //   CupertinoPageRoute(
    //     fullscreenDialog: true,
    //     builder: (context) => TransactionCategorySelectScreen(),
    //   ),
    // );
  }

  void _selectMerchant({bool add = false}) async {
    dynamic result;
    if (add == true) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => AddMerchantScreen(),
        ),
      );
    } else {
      result = await Navigator.of(context).push(
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => TransactionMerchantSelectScreen(),
        ),
      );
    }

    if (result != null) {
      setState(() {
        _selectedMerchant = result;
      });
    }
  }

  void _presentDatePicker() async {
    final now = _selectedDate ?? DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
    }

    try {
      await ref
          .read(expenseRepositoryProvider)
          .createExpense(
            projectId: _selectedProject!.id,
            name: _titleController.text.trim(),
            amount: _amountController.text.trim(),
            walletId: _fromWallet!.id,
            categoryId: _selectedCategory!.id,
            merchantId: _selectedMerchant!.id,

            currency: _fromWallet!.currency,
            // type: _type,
            startDate: _selectedDate!,
            frequency: _recurrence,
            // notes: _notesController.text.trim().isEmpty
            //     ? null
            //     : _notesController.text.trim(),
            createInitialPayment: _selectedDate!.isBefore(DateTime.now()),
            source: source,
          );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _saveTransaction() {
    switch (widget.transactionType) {
      case TransactionType.expense:
        _saveExpense();
        break;
      case TransactionType.income:
        break;
      case TransactionType.transfer:
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // _selectedProject = ref.watch(activeProjectProvider).project?.id;
    super.initState();
    _amountController.text = '0';
    _titleController.text = '';

    // Delay access to ref until after widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activeProject = ref.read(activeProjectProvider);

      setState(() {
        _selectedProject = activeProject.project;
      });
    });
  }

  void selectProject(Project project) {
    setState(() {
      _selectedProject = project;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final projects = ref.watch(projectsProvider);
    // final activeProject = ref.watch(activeProjectProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    final colors = ref.watch(appColorsProvider);
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          // Scrollable content
          SizedBox(
            height:
                MediaQuery.of(context).size.height -
                ((Scaffold.of(context).appBarMaxHeight as num) + (100 as num)),
            child: SingleChildScrollView(
              // padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Amount Input
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.transactionType != TransactionType.income)
                          Text(
                            _fromCurrency?.symbol ?? '?',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: colors.text,
                            ),
                          ),
                        if (widget.transactionType == TransactionType.income)
                          Text(
                            _toCurrency?.symbol ?? '?',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: colors.text,
                            ),
                          ),
                        // const Spacer(),
                        Expanded(
                          child: TextFormField(
                            // textDirection: TextDirection.rtl,
                            // initialValue: amount.toString(),
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

                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Title Input Field
                  ListTile(
                    tileColor: colors.surface,
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: Icon(Icons.edit_sharp, color: colors.text),
                    title: CupertinoTextFormFieldRow(
                      controller: _titleController,
                      style: TextStyle(color: colors.text),
                      padding: EdgeInsets.all(0),
                      prefix: Text(
                        'Title',
                        style: TextStyle(color: colors.textMute),
                      ),
                      // placeholder: 'Title',
                      validator: (value) {
                        // display an error message after running validation
                        // should return null if validation succeeded
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 50) {
                          return 'Must be text of less than 50 characters';
                        }
                        return null;
                      },
                    ),
                    onTap: () {},
                  ),

                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Category Select
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: DynamicAvatar(
                      emoji: _selectedCategory?.iconEmoji != null
                          ? _selectedCategory!.iconEmoji
                          : null,
                      color: _selectedCategory?.color != null
                          ? HexColor.fromHex(_selectedCategory!.color!)
                          : Colors.blueGrey,
                      icon: _selectedCategory != null ? null : Icons.folder,
                      emojiOffset: Platform.isIOS
                          ? Offset(6, 0)
                          : Offset(1, -2),
                    ),

                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Category: ',
                          style: TextStyle(color: colors.textMute),
                        ),
                        if (_selectedCategory != null)
                          Text(
                            _selectedCategory!.name,
                            style: TextStyle(color: colors.text),
                          ),
                      ],
                    ),
                    onTap: _selectCategory,
                  ),

                  if (widget.transactionType == TransactionType.expense)
                    Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Merchant Select
                  ClipRect(
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        height:
                            widget.transactionType == TransactionType.expense
                            ? null
                            : 0,
                        child: ListTile(
                          tileColor: colors.surface,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          visualDensity: VisualDensity(vertical: 0.1),
                          leading: DynamicAvatar(
                            image: _selectedMerchant?.imageUrl != null
                                ? cachedImageProvider(_selectedMerchant!.imageUrl!)
                                : null,
                            icon: _selectedMerchant != null
                                ? null
                                : Icons.store,
                            color: colors.fire,
                          ),
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Merchant: ',
                                style: TextStyle(color: colors.textMute),
                              ),
                              if (_selectedMerchant != null)
                                Text(
                                  _selectedMerchant!.name,
                                  style: TextStyle(color: colors.text),
                                ),
                            ],
                          ),
                          onTap: _selectMerchant,
                          trailing: IconButton(
                            onPressed: () {
                              _selectMerchant(add: false);
                            },
                            icon: Icon(Icons.add, color: colors.text),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Project Select
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: DynamicAvatar(
                      emojiOffset: Offset(3, -1),
                      icon:
                          _selectedProject?.iconType ==
                              IconSelectionType.icon.name
                          ? IconData(
                              _selectedProject!.iconCodePoint!,
                              fontFamily: 'MaterialIcons',
                            )
                          : null,
                      emoji:
                          _selectedProject?.iconType ==
                              IconSelectionType.emoji.name
                          ? _selectedProject?.iconEmoji
                          : null,
                      image:
                          _selectedProject?.iconType ==
                                  IconSelectionType.image.name &&
                              _selectedProject?.localImagePath != null
                          ? FileImage(File(_selectedProject!.localImagePath!))
                          : _selectedProject?.imageUrl != null
                          ? cachedImageProvider(_selectedProject!.imageUrl!)
                          : null,
                      color: _selectedProject?.color != null
                          ? HexColor.fromHex('#${_selectedProject?.color}')
                          : Colors.grey.shade100,
                    ),

                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Project: ',
                          style: TextStyle(color: colors.textMute),
                        ),
                        Text(
                          _selectedProject == null
                              ? 'No Project Selected'
                              : _selectedProject!.name,
                        ),
                      ],
                    ),
                    onTap: _selectProject,
                  ),

                  if (widget.transactionType != TransactionType.income)
                    Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Wallet Select (From)
                  ClipRect(
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        height:
                            widget.transactionType == TransactionType.expense ||
                                widget.transactionType ==
                                    TransactionType.transfer
                            ? null
                            : 0,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          visualDensity: VisualDensity(vertical: 0.1),
                          leading: DynamicAvatar(
                            emojiOffset: Platform.isIOS
                                ? Offset(6, 2)
                                : Offset(3, -1),
                            icon:
                                _fromWallet?.iconType ==
                                    IconSelectionType.icon.name
                                ? IconData(
                                    _fromWallet!.iconCodePoint!,
                                    fontFamily: 'MaterialIcons',
                                  )
                                : null,
                            emoji:
                                _fromWallet?.iconType ==
                                    IconSelectionType.emoji.name
                                ? _fromWallet?.iconEmoji
                                : null,
                            image:
                                _fromWallet?.iconType ==
                                        IconSelectionType.image.name &&
                                    _fromWallet?.localImagePath != null
                                ? FileImage(File(_fromWallet!.localImagePath!))
                                : _fromWallet?.imageUrl != null
                                ? cachedImageProvider(_fromWallet!.imageUrl!)
                                : null,
                            color: _fromWallet?.color != null
                                ? HexColor.fromHex('#${_fromWallet?.color}')
                                : Colors.grey.shade100,
                          ),

                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'From: ',
                                style: TextStyle(color: colors.textMute),
                              ),
                              if (_fromWallet != null)
                                Text(
                                  '${_fromWallet?.currency} - ${_fromWallet?.name} ',
                                  style: TextStyle(color: colors.text),
                                ),
                            ],
                          ),
                          onTap: () {
                            _selectWallet(to: false);
                          },
                        ),
                      ),
                    ),
                  ),

                  if (widget.transactionType != TransactionType.expense)
                    Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Wallet Select (To)
                  ClipRect(
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        height:
                            widget.transactionType == TransactionType.income ||
                                widget.transactionType ==
                                    TransactionType.transfer
                            ? null
                            : 0,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          visualDensity: VisualDensity(vertical: 0.1),
                          leading: DynamicAvatar(
                            emojiOffset: Platform.isIOS
                                ? Offset(6, 2)
                                : Offset(3, -1),
                            icon:
                                _toWallet?.iconType ==
                                    IconSelectionType.icon.name
                                ? IconData(
                                    _toWallet!.iconCodePoint!,
                                    fontFamily: 'MaterialIcons',
                                  )
                                : null,
                            emoji:
                                _toWallet?.iconType ==
                                    IconSelectionType.emoji.name
                                ? _toWallet?.iconEmoji
                                : null,
                            image:
                                _toWallet?.iconType ==
                                        IconSelectionType.image.name &&
                                    _toWallet?.localImagePath != null
                                ? FileImage(File(_toWallet!.localImagePath!))
                                : _toWallet?.imageUrl != null
                                ? cachedImageProvider(_toWallet!.imageUrl!)
                                : null,
                            color: _toWallet?.color != null
                                ? HexColor.fromHex('#${_toWallet?.color}')
                                : Colors.grey.shade100,
                          ),

                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'To: ',
                                style: TextStyle(color: colors.textMute),
                              ),
                              if (_toWallet != null)
                                Text(
                                  ' ${_toWallet?.currency} - ${_toWallet?.name}',
                                  style: TextStyle(color: colors.text),
                                ),
                            ],
                          ),
                          onTap: () {
                            _selectWallet(to: true);
                          },
                        ),
                      ),
                    ),
                  ),

                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Date Select Input
                  ListTile(
                    tileColor: colors.surface,
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: Icon(
                      Icons.calendar_today_outlined,
                      color: colors.text,
                    ),
                    title: Row(
                      children: [
                        Text(
                          'Date: ',
                          style: TextStyle(color: colors.textMute),
                        ),
                        Text(
                          _selectedDate == null
                              ? 'Select Date'
                              : dateFormatter.format(_selectedDate!),
                        ),
                      ],
                    ),

                    onTap: _presentDatePicker,
                  ),

                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Repeat select
                  ListTile(
                    tileColor: colors.surface,
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: Icon(Icons.repeat, color: colors.text),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Repeat: ',
                          style: TextStyle(color: colors.textMute),
                        ),
                        Text(
                          recurrenceOptions[_recurrence]!,
                          style: TextStyle(color: colors.text),
                        ),
                      ],
                    ),
                    trailing:
                        _recurrence != TransactionRecurrence.never &&
                            _setReminder == true
                        ? IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings),
                          )
                        : null,
                    onTap: _selectRecurrence,
                  ),

                  ClipRect(
                    child: AnimatedSize(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        height: _recurrence == TransactionRecurrence.never
                            ? 0
                            : null,
                        child: SwitchListTile(
                          value: _setReminder,
                          onChanged: (isChecked) {
                            setState(() {
                              _setReminder = isChecked;
                            });
                          },
                          title: Text('Send me Reminders'),
                          subtitle: Text(
                            'You\'ll be notified of upcoming transactions',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Tags Input Select
                  ListTile(
                    tileColor: colors.surface,
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: Icon(Icons.tag, color: colors.text),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tags: ',
                          style: TextStyle(color: colors.textMute),
                        ),
                      ],
                    ),
                    onTap: _selectTags,
                  ),

                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Contacts Input Select
                  ListTile(
                    tileColor: colors.surface,
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: Icon(Icons.person, color: colors.text),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Contacts: ',
                          style: TextStyle(color: colors.textMute),
                        ),
                      ],
                    ),
                    onTap: _selectContact,
                  ),
                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  SizedBox(height: 300),
                ],
              ),
            ),
          ),

          // Floating button
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom, // Safe area
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // Adjust this valu
                  ),
                  backgroundColor: activeColor,
                ),
                label: Text(
                  'Save',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: colors.textInverse,
                  ),
                ),
                icon: Icon(Icons.add, size: 24, color: colors.textInverse),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

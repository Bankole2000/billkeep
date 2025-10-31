import 'dart:io';

import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/project_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/screens/categories/category_select_screen.dart';
import 'package:billkeep/screens/contacts/contact_select_screen.dart';
import 'package:billkeep/screens/merchants/add_merchant_screen.dart';
import 'package:billkeep/screens/merchants/merchant_select_screen.dart';
import 'package:billkeep/screens/projects/add_project_screen.dart';
import 'package:billkeep/utils/app_colors.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/date_helpers.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:billkeep/widgets/common/dynamic_avatar.dart';
import 'package:billkeep/widgets/common/select_recurrence_bottomsheet.dart';
import 'package:billkeep/widgets/projects/project_form.dart';
import 'package:billkeep/widgets/projects/project_list_select.dart';
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

  final amountController = TextEditingController();
  var _title = '';
  Category? _selectedCategory;
  Merchant? _selectedMerchant;
  Wallet? _fromWallet;
  Wallet? _toWallet;
  Project? _selectedProject;
  DateTime? _selectedDate = DateTime.now();
  TransactionRecurrence _recurrence = TransactionRecurrence.never;

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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SelectWalletBottomSheet(),
    );
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
      print(result);
      setState(() {
        _selectedCategory = result;
      });
    }
  }

  void _selectTags() async {
    print('select tags');
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
    print(_selectedMerchant);
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
    print(pickedDate);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _saveTransaction() {
    print(widget.transactionType);
    switch (widget.transactionType) {
      case TransactionType.expense:
        print('Create expense record');
        break;
      case TransactionType.income:
        print('Create income record');
        break;
      case TransactionType.transfer:
        print('Create transfer record');
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // _selectedProject = ref.watch(activeProjectProvider).project?.id;
    super.initState();

    // Delay access to ref until after widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activeProject = ref.read(activeProjectProvider);

      setState(() {
        _selectedProject = activeProject.project;
      });
    });
  }

  void selectProject(Project project) {
    print('selected project');
    print(project.name);
    setState(() {
      _selectedProject = project;
    });
  }

  @override
  void dispose() {
    amountController.dispose();
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
                        Text(
                          '₦',
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
                            initialValue: amount.toString(),
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

                  // Title Input Field
                  ListTile(
                    tileColor: colors.surface,
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: Icon(Icons.edit_sharp, color: colors.text),
                    title: CupertinoTextFormFieldRow(
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
                      onSaved: (value) {
                        _title = value!;
                      },
                    ),
                    onTap: () {},
                  ),

                  Divider(height: 1, color: colors.textMute),

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
                      emojiOffset: Offset(1, -2),
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
                    Divider(height: 1, color: colors.textMute),

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
                                ? NetworkImage(_selectedMerchant!.imageUrl!)
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
                              Text(
                                _selectedMerchant != null
                                    ? _selectedMerchant!.name
                                    : 'Select Merchant',
                                style: TextStyle(
                                  color: _selectedMerchant != null
                                      ? colors.text
                                      : colors.textMute,
                                ),
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

                  Divider(height: 1, color: colors.textMute),

                  // Project Select
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    visualDensity: VisualDensity(vertical: 0.1),
                    leading: DynamicAvatar(
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
                          ? NetworkImage(_selectedProject!.imageUrl!)
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
                    Divider(height: 1, color: colors.textMute),

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
                          leading: DynamicAvatar(icon: Icons.folder),

                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'From: ',
                                style: TextStyle(color: colors.textMute),
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

                  if (widget.transactionType != TransactionType.expense)
                    Divider(height: 1, color: colors.textMute),

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
                          leading: DynamicAvatar(icon: Icons.folder),

                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'To: ',
                                style: TextStyle(color: colors.textMute),
                              ),
                            ],
                          ),
                          onTap: _selectWallet,
                        ),
                      ),
                    ),
                  ),

                  Divider(height: 1, color: colors.textMute),

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

                  Divider(height: 1, color: colors.textMute),

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
                    onTap: _selectRecurrence,
                  ),

                  Divider(height: 1, color: colors.textMute),

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

                  Divider(height: 1, color: colors.textMute),

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
                  Divider(height: 1, color: colors.textMute),

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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/expense_provider.dart';
import 'package:billkeep/providers/project_provider.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/providers/wallet_provider.dart';
import 'package:billkeep/screens/categories/category_select_screen.dart';
import 'package:billkeep/screens/contacts/contact_select_screen.dart';
import 'package:billkeep/screens/merchants/add_merchant_screen.dart';
import 'package:billkeep/screens/merchants/merchant_select_screen.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/widgets/common/select_recurrence_bottomsheet.dart';
import 'package:billkeep/widgets/projects/select_project_bottomsheet.dart';
import 'package:billkeep/widgets/wallets/select_wallet_bottomsheet.dart';
import 'form/amount_input_field.dart';
import 'form/date_recurrence_fields.dart';
import 'form/title_input_field.dart';
import 'form/transaction_selector_tile.dart';

/// Refactored transaction form with extracted components
class TransactionForm extends ConsumerStatefulWidget {
  const TransactionForm({super.key, required this.transactionType});

  final TransactionType transactionType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionFormState();
}

class _TransactionFormState extends ConsumerState<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();

  // Form state
  Category? _selectedCategory;
  Merchant? _selectedMerchant;
  Wallet? _fromWallet;
  Currency? _fromCurrency;
  Currency? _toCurrency;
  Wallet? _toWallet;
  Project? _selectedProject;
  DateTime? _selectedDate = DateTime.now();
  TransactionRecurrence _recurrence = TransactionRecurrence.never;
  bool _setReminder = true;
  TransactionSource source = TransactionSource.MANUAL;

  @override
  void initState() {
    super.initState();
    _amountController.text = '0';
    _titleController.text = '';

    // Initialize project after widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activeProject = ref.read(activeProjectProvider);
      setState(() => _selectedProject = activeProject.project);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // Selection methods
  Future<void> _selectProject() async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (context) =>
          SelectProjectBottomSheet(selectedProject: _selectedProject),
    );
    if (result != null) {
      setState(() => _selectedProject = result);
    }
  }

  Future<void> _selectWallet({bool to = false}) async {
    final result = await showModalBottomSheet<WalletWithRelations>(
      context: context,
      builder: (context) =>
          SelectWalletBottomSheet(selectedWallet: to ? _toWallet : _fromWallet),
    );
    if (result != null) {
      setState(() {
        if (to) {
          _toWallet = result.wallet;
          _toCurrency = result.currency;
        } else {
          _fromWallet = result.wallet;
          _fromCurrency = result.currency;
        }
      });
    }
  }

  Future<void> _selectCategory() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
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

  Future<void> _selectMerchant({bool add = false}) async {
    if (add) {
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => AddMerchantScreen(),
        ),
      );
    } else {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => TransactionMerchantSelectScreen(),
        ),
      );
      if (result != null) {
        setState(() => _selectedMerchant = result);
      }
    }
  }

  Future<void> _selectRecurrence() async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (context) =>
          SelectRecurrenceBottomSheet(selectedRecurrence: _recurrence),
    );
    if (result != null) {
      setState(() => _recurrence = result);
    }
  }

  Future<void> _presentDatePicker() async {
    final now = _selectedDate ?? DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void _selectContact() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ContactSelectScreen(),
      ),
    );
  }

  void _selectTags() {
    // TODO: Implement tag selection
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // await ref.read(expenseRepositoryProvider).createExpense(
      //       projectId: _selectedProject!.id,
      //       name: _titleController.text.trim(),
      //       amount: _amountController.text.trim(),
      //       walletId: _fromWallet!.id,
      //       categoryId: _selectedCategory!.id,
      //       merchantId: _selectedMerchant!.id,
      //       currency: _fromWallet!.currency,
      //       startDate: _selectedDate!,
      //       frequency: _recurrence,
      //       createInitialPayment: _selectedDate!.isBefore(DateTime.now()),
      //       source: source,
      //     );

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
        // TODO: Implement income save
        break;
      case TransactionType.transfer:
        // TODO: Implement transfer save
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                ((Scaffold.of(context).appBarMaxHeight as num) + 100),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Amount input
                  AmountInputField(
                    amountController: _amountController,
                    fromCurrency: _fromCurrency,
                    toCurrency: _toCurrency,
                    transactionType: widget.transactionType,
                  ),
                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Title input
                  TitleInputField(controller: _titleController),
                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Category selector
                  CategorySelectorTile(
                    selectedCategory: _selectedCategory,
                    onTap: _selectCategory,
                  ),
                  if (widget.transactionType == TransactionType.expense)
                    Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Merchant selector (only for expenses)
                  MerchantSelectorTile(
                    selectedMerchant: _selectedMerchant,
                    onTap: () => _selectMerchant(add: false),
                    onAdd: () => _selectMerchant(add: true),
                    isVisible:
                        widget.transactionType == TransactionType.expense,
                  ),
                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Project selector
                  ProjectSelectorTile(
                    selectedProject: _selectedProject,
                    onTap: _selectProject,
                  ),
                  if (widget.transactionType != TransactionType.income)
                    Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // From wallet (expenses & transfers)
                  WalletSelectorTile(
                    selectedWallet: _fromWallet,
                    label: 'From',
                    onTap: () => _selectWallet(to: false),
                    isVisible:
                        widget.transactionType == TransactionType.expense ||
                        widget.transactionType == TransactionType.transfer,
                  ),
                  if (widget.transactionType != TransactionType.expense)
                    Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // To wallet (income & transfers)
                  WalletSelectorTile(
                    selectedWallet: _toWallet,
                    label: 'To',
                    onTap: () => _selectWallet(to: true),
                    isVisible:
                        widget.transactionType == TransactionType.income ||
                        widget.transactionType == TransactionType.transfer,
                  ),
                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Date selector
                  DateSelectorTile(
                    selectedDate: _selectedDate,
                    onTap: _presentDatePicker,
                  ),
                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Recurrence selector with reminder
                  RecurrenceSelectorTile(
                    recurrence: _recurrence,
                    setReminder: _setReminder,
                    onTap: _selectRecurrence,
                    onReminderChanged: (value) =>
                        setState(() => _setReminder = value),
                  ),
                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Tags selector
                  SimpleSelectorTile(
                    label: 'Tags',
                    icon: Icons.tag,
                    onTap: _selectTags,
                  ),
                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  // Contacts selector
                  SimpleSelectorTile(
                    label: 'Contacts',
                    icon: Icons.person,
                    onTap: _selectContact,
                  ),
                  Divider(height: 1, color: colors.textMute.withAlpha(50)),

                  const SizedBox(height: 300),
                ],
              ),
            ),
          ),

          // Floating save button
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom,
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveTransaction,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
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
                icon: _isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: colors.textInverse,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(Icons.add, size: 24, color: colors.textInverse),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

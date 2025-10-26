import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// Projects table
class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  IntColumn get iconCodePoint => integer().nullable()(); // Icon name or emoji
  TextColumn get iconEmoji => text().nullable()(); // Icon name or emoji
  TextColumn get iconType =>
      text().withDefault(const Constant('MaterialIcons'))(); // Icon or Emoji
  TextColumn get color => text().nullable()();
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))(); // NEW
  TextColumn get tempId => text().nullable()(); // Store original temp ID
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class ProjectMetadata extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get projectId => text()();
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {projectId, key},
  ];
}

class Reminders extends Table {
  TextColumn get id => text()();
  DateTimeColumn get reminderDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get reminderType =>
      text()(); // e.g., '15_min_before', '1_day_before'
}

// Add this table definition before the @DriftDatabase annotation
class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().customConstraint(
    'NOT NULL REFERENCES projects(id) ON DELETE CASCADE',
  )();
  TextColumn get name => text()();
  IntColumn get expectedAmount => integer()(); // Expected amount per cycle
  TextColumn get currency => text().references(
    Currencies,
    #code,
  )(); // Currency should come from Wallet
  TextColumn get type =>
      text()(); // 'ONE_TIME' or 'RECURRING' or 'INSTALLMENTS'
  TextColumn get frequency => text().nullable()(); // 'MONTHLY' or 'YEARLY'
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextRenewalDate => dateTime().nullable()();
  TextColumn get categoryId =>
      text().nullable().references(Categories, #id)(); // Link to category
  TextColumn get merchantId =>
      text().nullable().references(Merchants, #id)(); // Link to merchant
  TextColumn get contactId =>
      text().nullable().references(Contacts, #id)(); // Link to merchant
  TextColumn get walletId =>
      text().nullable().references(Wallets, #id)(); // Wallet to deduct from
  TextColumn get investmentId =>
      text().nullable().references(Investments, #id)(); // Add to X investment
  TextColumn get goalId => text().nullable().references(
    Goals,
    #id,
  )(); // Deduct from debt or add to savings
  TextColumn get reminderId => text().nullable().references(
    Reminders,
    #id,
  )(); // reminder references (to send notification)
  TextColumn get source => text().withDefault(
    const Constant('MANUAL'),
  )(); // 'MANUAL', 'SMS', 'EMAIL', 'SDK'
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get tempId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Payments extends Table {
  TextColumn get id => text()();
  TextColumn get paymentType => text()(); // 'DEBIT' or 'CREDIT'
  TextColumn get categoryId => text().nullable()(); // Nullable now
  TextColumn get merchantId => text().nullable()(); // Nullable now
  TextColumn get contactId => text().nullable()(); // Nullable now
  TextColumn get walletId => text().nullable()(); // Nullable now
  TextColumn get expenseId => text().nullable()(); // Nullable now
  TextColumn get incomeId => text().nullable()(); // NEW - link to income
  TextColumn get investmentId =>
      text().nullable()(); // NEW - link to investment
  TextColumn get debtId => text().nullable()(); // NEW - link to debt
  IntColumn get actualAmount => integer()(); // What was actually paid
  TextColumn get currency => text().references(Currencies, #code)();
  DateTimeColumn get paymentDate => dateTime()();
  TextColumn get source => text().withDefault(
    const Constant('MANUAL'),
  )(); // 'MANUAL', 'SMS', 'EMAIL', 'SDK'
  BoolColumn get verified =>
      boolean().withDefault(const Constant(true))(); // User confirmed
  TextColumn get notes => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get tempId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Add Income table before @DriftDatabase
class Income extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().customConstraint(
    'NOT NULL REFERENCES projects(id) ON DELETE CASCADE',
  )();
  TextColumn get description => text()();
  IntColumn get expectedAmount =>
      integer()(); // Expected amount per cycle (in cents)
  TextColumn get currency => text().references(Currencies, #code)();
  TextColumn get type => text()(); // 'ONE_TIME' or 'RECURRING'
  TextColumn get frequency => text().nullable()(); // 'MONTHLY' or 'YEARLY'
  DateTimeColumn get startDate => dateTime()(); // When income starts
  DateTimeColumn get nextExpectedDate =>
      dateTime().nullable()(); // Next expected payment
  TextColumn get categoryId =>
      text().nullable().references(Categories, #id)(); // Link to category
  TextColumn get merchantId =>
      text().nullable().references(Merchants, #id)(); // Link to merchant
  TextColumn get contactId =>
      text().nullable().references(Contacts, #id)(); // Link to merchant
  TextColumn get walletId =>
      text().nullable().references(Wallets, #id)(); // Wallet to deduct from
  TextColumn get investmentId =>
      text().nullable().references(Investments, #id)(); // Add to X investment
  TextColumn get goalId => text().nullable().references(
    Goals,
    #id,
  )(); // Deduct from debt or add to Savings
  TextColumn get reminderId => text().nullable().references(
    Reminders,
    #id,
  )(); // reminder references (to send notification)
  TextColumn get source => text().withDefault(
    const Constant('MANUAL'),
  )(); // 'MANUAL', 'SMS', 'EMAIL', 'SDK'
  TextColumn get invoiceNumber => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get tempId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class TodoItems extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().customConstraint(
    'NOT NULL REFERENCES projects(id) ON DELETE CASCADE',
  )();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  // Financial attachment (direct)
  IntColumn get directExpenseAmount => integer().nullable()();
  TextColumn get directExpenseCurrency => text().nullable()();
  TextColumn get directExpenseType =>
      text().nullable()(); // 'ONE_TIME', 'RECURRING'
  TextColumn get directExpenseFrequency => text().nullable()();
  TextColumn get directExpenseDescription => text().nullable()();

  // Track created expense and payment
  TextColumn get createdExpenseId => text().nullable()(); // NEW
  TextColumn get createdPaymentId => text().nullable()(); // NEW

  // Link to shopping list
  TextColumn get linkedShoppingListId => text().nullable()();

  // Parent todo for subtasks
  TextColumn get parentTodoId => text().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get tempId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class ShoppingLists extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().customConstraint(
    'NOT NULL REFERENCES projects(id) ON DELETE CASCADE',
  )();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get linkedExpenseId => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get tempId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class ShoppingListItems extends Table {
  TextColumn get id => text()();
  TextColumn get shoppingListId => text().customConstraint(
    'NOT NULL REFERENCES shopping_lists(id) ON DELETE CASCADE',
  )();
  TextColumn get name => text()();
  IntColumn get estimatedAmount => integer().nullable()(); // In cents
  IntColumn get actualAmount => integer().nullable()(); // In cents
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  BoolColumn get isPurchased => boolean().withDefault(const Constant(false))();
  DateTimeColumn get purchasedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();

  // Link to created expense
  TextColumn get createdExpenseId => text().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get tempId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Message Rules table
class MessageRules extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()(); // e.g. "GTBank Debit", "Paystack Credit"
  TextColumn get type => text()(); // 'SMS' or 'EMAIL'
  TextColumn get sender => text()(); // Bank shortcode or email
  TextColumn get pattern => text()(); // Regex pattern to match
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  // Parsing rules
  TextColumn get amountPattern => text()(); // Regex to extract amount
  TextColumn get descriptionPattern =>
      text().nullable()(); // Regex to extract description
  TextColumn get defaultProjectId =>
      text().nullable()(); // Auto-assign to project

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Parsed Messages table
class ParsedMessages extends Table {
  TextColumn get id => text()();
  TextColumn get ruleId => text().nullable()(); // Which rule matched
  TextColumn get rawMessage => text()(); // Original SMS/email
  TextColumn get sender => text()();
  IntColumn get amount => integer()(); // In cents
  TextColumn get description => text().nullable()();
  TextColumn get transactionType => text()(); // 'DEBIT' or 'CREDIT'
  DateTimeColumn get messageDate => dateTime()();

  // Processing status
  BoolColumn get isProcessed => boolean().withDefault(const Constant(false))();
  BoolColumn get isConfirmed => boolean().withDefault(const Constant(false))();
  TextColumn get createdRecordId =>
      text().nullable()(); // Link to expense/income
  TextColumn get recordType => text().nullable()(); // "expense" or "income"
  TextColumn get projectId => text().nullable()(); // Assigned project

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Categories table - Global categories for both expenses and income
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get iconCodePoint => integer().nullable()(); // Icon name or emoji
  TextColumn get iconEmoji => text().nullable()(); // Icon name or emoji
  TextColumn get iconType =>
      text().withDefault(const Constant('MaterialIcons'))(); // Icon or Emoji
  TextColumn get color => text().nullable()(); // Hex color code
  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(false))(); // System-provided
  TextColumn get categoryGroupId => text().customConstraint(
    'NOT NULL REFERENCES category_groups(id) ON DELETE CASCADE',
  )();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get tempId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CategoryGroups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get tempId => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Merchants extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get tempId => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get website => text().nullable()();

  // For remote images
  TextColumn get imageUrl => text().nullable()();

  // For local images (store file path, not binary data)
  TextColumn get localImagePath => text().nullable()();

  IntColumn get iconCodePoint => integer().nullable()(); // Icon name or emoji
  TextColumn get iconEmoji => text().nullable()(); // Icon name or emoji
  TextColumn get iconType =>
      text().withDefault(const Constant('MaterialIcons'))(); // Icon or Emoji
  TextColumn get color => text().nullable()(); // Hex color code
  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(false))(); // System-provided
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class MerchantMetadata extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get merchantId => text()();
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {merchantId, key},
  ];
}

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get tempId => text().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Contacts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get tempId => text().nullable()();

  IntColumn get iconCodePoint => integer().nullable()(); // Icon name or emoji
  TextColumn get iconEmoji => text().nullable()(); // Icon name or emoji
  TextColumn get iconType =>
      text().withDefault(const Constant('MaterialIcons'))(); // Icon or Emoji
  TextColumn get color => text().nullable()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class ContactInfo extends Table {
  TextColumn get id => text()();
  TextColumn get contactId => text().customConstraint(
    'NOT NULL REFERENCES contacts(id) ON DELETE CASCADE',
  )();
  TextColumn get tempId => text().nullable()();
  TextColumn get value => text()();
  TextColumn get type => text()(); // 'email', 'phone', 'url',

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Wallets extends Table {
  // TextColumn get value => text()();
  TextColumn get walletType =>
      text()(); // 'cash', 'bank', 'crypto', 'credit', 'other'
  TextColumn get currency => text().references(
    Currencies,
    #code,
  )(); // Primary currency (USD, EUR, BTC, etc.)
  IntColumn get balance => integer()(); // storage in cents

  // For remote images
  TextColumn get imageUrl => text().nullable()();

  // For local images (store file path, not binary data)
  TextColumn get localImagePath => text().nullable()();
  BoolColumn get isGlobal => boolean().withDefault(
    const Constant(true),
  )(); // Available for all projects or only a single project
  IntColumn get iconCodePoint => integer().nullable()(); // Icon name or emoji
  TextColumn get iconEmoji => text().nullable()(); // Icon name or emoji
  TextColumn get iconType =>
      text().withDefault(const Constant('MaterialIcons'))(); // Icon or Emoji
  TextColumn get color => text().nullable()();

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get tempId => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class WalletMetadata extends Table {
  TextColumn get id => text()();
  TextColumn get walletId => text()();
  TextColumn get key => text()();
  TextColumn get value => text()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {walletId, key}, // Ensure unique key per wallet
  ];
}

class Budgets extends Table {
  IntColumn get underLimitGoal =>
      integer().nullable()(); // Aspirational savings goal
  DateTimeColumn get startDate =>
      dateTime()(); // Day when the budget becomes active
  DateTimeColumn get endDate => dateTime()(); // Day when the budget expires
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get currency => text().references(Currencies, #code)();

  IntColumn get limitAmount => integer()(); // The budget limit
  IntColumn get spentAmount =>
      integer().withDefault(const Constant(0))(); // Total spent
  IntColumn get overBudgetAllowance =>
      integer().withDefault(const Constant(0))(); // How much over

  IntColumn get iconCodePoint => integer().nullable()(); // Icon name or emoji
  TextColumn get iconEmoji => text().nullable()(); // Icon name or emoji
  TextColumn get iconType =>
      text().withDefault(const Constant('MaterialIcons'))(); // Icon or Emoji
  TextColumn get color => text().nullable()();

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get tempId => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Currencies extends Table {
  TextColumn get code => text()(); // USD, EUR, BTC, ETH, etc.
  TextColumn get name => text()(); // US Dollar, Euro, Bitcoin, etc.
  TextColumn get symbol => text()(); // $, €, ₿, Ξ, etc.
  IntColumn get decimals =>
      integer().withDefault(const Constant(2))(); // 2 for USD, 8 for BTC
  BoolColumn get isCrypto => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {code};
}

class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()(); // Goal name (e.g., "New Car", "Vacation")
  TextColumn get type => textEnum<GoalType>()(); // SAVINGS or DEBT_CLEARING
  IntColumn get targetAmount => integer()(); // Target amount to reach
  TextColumn get contactId => text().nullable().references(Contacts, #id)();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();

  IntColumn get currentAmount =>
      integer().withDefault(const Constant(0))(); // Current progress
  DateTimeColumn get targetDate =>
      dateTime().nullable()(); // Optional target date
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get description => text().nullable()(); // Optional description
  IntColumn get iconCodePoint => integer().nullable()(); // Icon name or emoji
  TextColumn get iconEmoji => text().nullable()(); // Icon name or emoji
  TextColumn get iconType =>
      text().withDefault(const Constant('MaterialIcons'))(); // Icon or Emoji
  TextColumn get color =>
      text().nullable().withDefault(const Constant('#2196F3'))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get tempId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class GoalMetadata extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text()();
  TextColumn get key => text()();
  TextColumn get value => text()();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {goalId, key}, // Ensure unique key per wallet
  ];
}

class GoalContribution extends Table {
  TextColumn get id => text()();

  TextColumn get paymentId =>
      text().references(Payments, #id)(); // Reference to payment
  TextColumn get goalId => text().references(Goals, #id)(); // Reference to goal
  IntColumn get allocatedAmount => integer()(); // Amount allocated to this goal
  DateTimeColumn get allocatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes =>
      text().nullable()(); // Optional notes about allocation

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {paymentId, goalId}, // Ensure unique key per payment goal contribution
  ];
}

enum GoalType { savings, debt }

// enum InvestmentStatus { active, completed, defaulted, cancelled, sold }

class InvestmentPayments extends Table {
  TextColumn get id => text()();

  TextColumn get paymentId =>
      text().references(Payments, #id)(); // Reference to payment
  TextColumn get investmentId =>
      text().references(Investments, #id)(); // Reference to goal
  IntColumn get allocatedAmount => integer()(); // Amount allocated to this goal
  DateTimeColumn get allocatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes =>
      text().nullable()(); // Optional notes about allocation
  @override
  Set<Column> get primaryKey => {id};
}

class Investments extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()(); // e.g. Tesla Stock, Loan to John
  TextColumn get investmentTypeId => text().references(
    InvestmentTypes,
    #id,
  )(); // e.g. Investment Type, Stock, Shares, Bonds, Mutual Funds, Personal Loans, Crypto, other
  TextColumn get tempId => text().nullable()();
  DateTimeColumn get investmentDate => dateTime()();
  DateTimeColumn get maturityDate =>
      dateTime().nullable()(); // When investment matures/returns
  DateTimeColumn get closedDate =>
      dateTime().nullable()(); // When actually closed

  // Currency and amounts
  TextColumn get currencyCode => text().references(Currencies, #code)();
  IntColumn get investedAmount => integer()(); // Principal investment amount
  IntColumn get currentValue => integer().withDefault(
    const Constant(0),
  )(); // Principal + interest accrued amount

  // Return configuration
  TextColumn get returnCalculationType =>
      text().map(const _ReturnCalculationTypeConverter())();
  IntColumn get interestRate =>
      integer().nullable()(); // Annual percentage (e.g., 5 for 0.05%)
  IntColumn get fixedReturnAmount =>
      integer().nullable()(); // Fixed return per period
  TextColumn get returnFrequency =>
      text().nullable()(); // "monthly", "quarterly", "annually", "one-time"

  // // Status
  // TextColumn get status => text().map(const _InvestmentStatusConverter())();

  // Contact reference (who you invested in/lent to)
  TextColumn get contactId => text().nullable().references(Contacts, #id)();
  TextColumn get merchantId => text().nullable().references(
    Merchants,
    #id,
  )(); // Company you bought the stock from

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class InvestmentMetadata extends Table {
  TextColumn get id => text()();
  TextColumn get investmentId => text()();
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {investmentId, key},
  ];
}

class InvestmentReturns extends Table {
  TextColumn get id => text()();

  TextColumn get investmentId =>
      text().references(Investments, #id, onDelete: KeyAction.cascade)();

  IntColumn get amount => integer()();
  // Amount gained (or lost, if negative)

  TextColumn get type => text()();
  // e.g. "DIVIDEND", "INTEREST", "CAPITAL_GAIN", "LOSS"

  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();

  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class InvestmentTypes extends Table {
  TextColumn get id => text()();
  TextColumn get name =>
      text()(); // "Stock", "Bond", "Personal Loan", "Real Estate", etc.
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// class InvestmentTransactions extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get investmentId => text()();

//   TextColumn get transactionType =>
//       text().map(const _InvestmentTransactionTypeConverter())();
//   IntColumn get amount => integer()();
//   TextColumn get currencyCode => text().references(Currencies, #code)();

//   DateTimeColumn get transactionDate => dateTime()();
//   DateTimeColumn get dueDate =>
//       dateTime().nullable()(); // For scheduled returns

//   TextColumn get status => text().map(const _TransactionStatusConverter())();
//   TextColumn get reference => text().nullable()();
//   TextColumn get notes => text().nullable()();

//   DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
// }

// enum InvestmentTransactionType {
//   initialInvestment,
//   returnPayment,
//   interest,
//   dividend,
//   capitalGain,
//   fee,
//   withdrawal,
//   adjustment,
// }

// class InvestmentSchedules extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get investmentId => text()();

//   DateTimeColumn get dueDate => dateTime()();
//   IntColumn get amount => integer()();
//   TextColumn get currencyCode => text().references(Currencies, #code)();
//   TextColumn get scheduleType =>
//       text().map(const _InvestmentScheduleTypeConverter())();

//   BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
//   IntColumn get transactionId => integer().nullable().references(
//     InvestmentTransactions,
//     #id,
//     onDelete: KeyAction.setNull,
//   )();
//   TextColumn get notes => text().nullable()();
// }

// class Debts extends Table {
//   IntColumn get id => integer().autoIncrement()();

//   // Basic info
//   TextColumn get title => text()();
//   TextColumn get description => text().nullable()();
//   IntColumn get typeId => integer().references(DebtTypes, #id)();

//   // Contact reference (who you borrowed from)
//   TextColumn get contactId => text().nullable()();

//   // Currency and amounts
//   TextColumn get currencyCode => text().references(Currencies, #code)();
//   IntColumn get borrowedAmount => integer()(); // Original loan amount
//   IntColumn get outstandingBalance =>
//       integer().withDefault(const Constant(0))();

//   // Status
//   TextColumn get status => text().map(const _DebtStatusConverter())();

//   // Dates
//   DateTimeColumn get borrowDate => dateTime()();
//   DateTimeColumn get dueDate =>
//       dateTime().nullable()(); // When debt should be fully repaid
//   DateTimeColumn get closedDate =>
//       dateTime().nullable()(); // When actually paid off

//   // Interest configuration
//   TextColumn get interestCalculationType =>
//       text().map(const _InterestCalculationTypeConverter())();
//   IntColumn get interestRate =>
//       integer().nullable()(); // Annual percentage rate
//   IntColumn get fixedInterestAmount =>
//       integer().nullable()(); // Fixed interest per period
//   TextColumn get interestFrequency =>
//       text().nullable()(); // "monthly", "quarterly", etc.

//   // For compound interest
//   BoolColumn get isCompoundInterest =>
//       boolean().withDefault(const Constant(false))();
//   TextColumn get compoundingFrequency => text().nullable()();

//   // Payment tracking
//   IntColumn get totalPayments => integer().withDefault(const Constant(0))();
//   IntColumn get totalInterestPaid => integer().withDefault(const Constant(0))();

//   DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
//   DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
// }

// class DebtTypes extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get name =>
//       text()(); // "Credit Card", "Mortgage", "Personal Loan", "Car Loan", etc.
//   TextColumn get description => text().nullable()();
// }

// enum DebtStatus { active, paidOff, defaulted, writtenOff, renegotiated }

// class _DebtStatusConverter extends TypeConverter<DebtStatus, String> {
//   const _DebtStatusConverter();

//   @override
//   DebtStatus fromSql(String fromDb) {
//     return DebtStatus.values.firstWhere(
//       (e) => e.name == fromDb,
//       orElse: () => DebtStatus.active,
//     );
//   }

//   @override
//   String toSql(DebtStatus value) => value.name;
// }

// class DebtTransactions extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get debtId => integer().references(Debts, #id)();

//   TextColumn get transactionType =>
//       text().map(const _DebtTransactionTypeConverter())();
//   IntColumn get amount => integer()();
//   TextColumn get currencyCode => text().references(Currencies, #code)();

//   DateTimeColumn get transactionDate => dateTime()();
//   DateTimeColumn get dueDate =>
//       dateTime().nullable()(); // For scheduled payments

//   TextColumn get status => text().map(const _TransactionStatusConverter())();
//   TextColumn get reference => text().nullable()();
//   TextColumn get notes => text().nullable()();

//   DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
// }

// enum DebtTransactionType {
//   loanDisbursement,
//   principalPayment,
//   interestPayment,
//   fee,
//   penalty,
//   adjustment,
// }

// class DebtSchedules extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get debtId => integer().references(Debts, #id)();

//   DateTimeColumn get dueDate => dateTime()();
//   IntColumn get principalAmount => integer()();
//   IntColumn get interestAmount => integer().withDefault(const Constant(0))();
//   IntColumn get totalAmount => integer()(); // principal + interest
//   TextColumn get currencyCode => text().references(Currencies, #code)();

//   BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
//   IntColumn get transactionId => integer().nullable().references(
//     DebtTransactions,
//     #id,
//     onDelete: KeyAction.setNull,
//   )();
//   TextColumn get notes => text().nullable()();
// }

// class DebtMetadata extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get debtId => integer().references(Debts, #id)();
//   TextColumn get key => text()();
//   TextColumn get value => text()();

//   @override
//   List<Set<Column>> get uniqueKeys => [
//     {debtId, key},
//   ];
// }

// #region Enums

enum ReturnCalculationType { percentage, fixedAmount, fixedTotal, variable }

// enum InterestCalculationType { percentage, fixedAmount, fixedTotal, variable }

// enum InvestmentScheduleType { returnPayment, interest, dividend, capitalGain }

// enum TransactionStatus { pending, completed, failed, cancelled }

// enum DebtScheduleType { payment, principalOnly, interestOnly }

// #endregion

// #region Type Converters

class _ReturnCalculationTypeConverter
    extends TypeConverter<ReturnCalculationType, String> {
  const _ReturnCalculationTypeConverter();

  @override
  ReturnCalculationType fromSql(String fromDb) {
    return ReturnCalculationType.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => ReturnCalculationType.variable,
    );
  }

  @override
  String toSql(ReturnCalculationType value) => value.name;
}

// class _InterestCalculationTypeConverter
//     extends TypeConverter<InterestCalculationType, String> {
//   const _InterestCalculationTypeConverter();

//   @override
//   InterestCalculationType fromSql(String fromDb) {
//     return InterestCalculationType.values.firstWhere(
//       (e) => e.name == fromDb,
//       orElse: () => InterestCalculationType.variable,
//     );
//   }

//   @override
//   String toSql(InterestCalculationType value) => value.name;
// }

// class _InvestmentStatusConverter
//     extends TypeConverter<InvestmentStatus, String> {
//   const _InvestmentStatusConverter();

//   @override
//   InvestmentStatus fromSql(String fromDb) {
//     return InvestmentStatus.values.firstWhere(
//       (e) => e.name == fromDb,
//       orElse: () => InvestmentStatus.active,
//     );
//   }

//   @override
//   String toSql(InvestmentStatus value) => value.name;
// }

// class _InvestmentTransactionTypeConverter
//     extends TypeConverter<InvestmentTransactionType, String> {
//   const _InvestmentTransactionTypeConverter();

//   @override
//   InvestmentTransactionType fromSql(String fromDb) {
//     return InvestmentTransactionType.values.firstWhere(
//       (e) => e.name == fromDb,
//       orElse: () => InvestmentTransactionType.adjustment,
//     );
//   }

//   @override
//   String toSql(InvestmentTransactionType value) => value.name;
// }

// class _DebtTransactionTypeConverter
//     extends TypeConverter<DebtTransactionType, String> {
//   const _DebtTransactionTypeConverter();

//   @override
//   DebtTransactionType fromSql(String fromDb) {
//     return DebtTransactionType.values.firstWhere(
//       (e) => e.name == fromDb,
//       orElse: () => DebtTransactionType.adjustment,
//     );
//   }

//   @override
//   String toSql(DebtTransactionType value) => value.name;
// }

// class _TransactionStatusConverter
//     extends TypeConverter<TransactionStatus, String> {
//   const _TransactionStatusConverter();

//   @override
//   TransactionStatus fromSql(String fromDb) {
//     return TransactionStatus.values.firstWhere(
//       (e) => e.name == fromDb,
//       orElse: () => TransactionStatus.pending,
//     );
//   }

//   @override
//   String toSql(TransactionStatus value) => value.name;
// }

// class _InvestmentScheduleTypeConverter
//     extends TypeConverter<InvestmentScheduleType, String> {
//   const _InvestmentScheduleTypeConverter();

//   @override
//   InvestmentScheduleType fromSql(String fromDb) {
//     return InvestmentScheduleType.values.firstWhere(
//       (e) => e.name == fromDb,
//       orElse: () => InvestmentScheduleType.returnPayment,
//     );
//   }

//   @override
//   String toSql(InvestmentScheduleType value) => value.name;
// }

// #endregion

@DriftDatabase(
  tables: [
    Projects,
    ProjectMetadata,
    Expenses,
    Payments,
    Income,
    TodoItems,
    ShoppingLists,
    ShoppingListItems,
    MessageRules,
    ParsedMessages,
    IdMappings,
    Categories,
    CategoryGroups,
    Merchants,
    MerchantMetadata,
    Tags,
    Contacts,
    ContactInfo,
    Wallets,
    WalletMetadata,
    Budgets,
    Currencies,
    Goals,
    GoalMetadata,
    GoalContribution,
    Investments,
    InvestmentTypes,
    InvestmentMetadata,
    InvestmentPayments,
    InvestmentReturns,
    Reminders,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6; // Increment this when schema changes

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future migrations will go here
        // Migration from 1 to 2 removed - budget fields were moved to Budgets table

        // Migration from 2 to 3 - Add expense/payment tracking to todos
        if (from <= 2) {
          await m.addColumn(todoItems, todoItems.createdExpenseId);
          await m.addColumn(todoItems, todoItems.createdPaymentId);
        }

        // Migration from 3 to 4 - Add SMS/Email import tables
        if (from <= 3) {
          await m.createTable(messageRules);
          await m.createTable(parsedMessages);
        }

        // Migration from 4 to 5 - Add Categories table and categoryId to Expenses/Income
        if (from <= 4) {
          // First create CategoryGroups table (required by Categories foreign key)
          await m.createTable(categoryGroups);

          // Then create Categories table
          await m.createTable(categories);

          // Add category references to existing tables
          await m.addColumn(expenses, expenses.categoryId);
          await m.addColumn(income, income.categoryId);
        }

        // Migration from 5 to 6 - Add all new tables for wallets, currencies, investments
        if (from <= 5) {
          await m.createTable(projectMetadata);
          await m.createTable(merchants);
          await m.createTable(merchantMetadata);
          await m.createTable(tags);
          await m.createTable(contacts);
          await m.createTable(contactInfo);
          await m.createTable(currencies);
          await m.createTable(wallets);
          await m.createTable(walletMetadata);
          await m.createTable(budgets);
          await m.createTable(goals);
          await m.createTable(goalMetadata);
          await m.createTable(goalContribution);
          await m.createTable(investmentTypes);
          await m.createTable(investments);
          await m.createTable(investmentMetadata);
          await m.createTable(investmentPayments);
          await m.createTable(investmentReturns);
          await m.createTable(reminders);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> deleteDatabase() async {
    final dbPath = await _getDatabasePath();
    final file = File(dbPath);

    if (await file.exists()) {
      await file.delete();
    }
  }

  // Add this static method to create a new instance
  static Future<AppDatabase> createAndInitialize() async {
    final db = AppDatabase();
    // Force connection to initialize
    await db.customSelect('SELECT 1').getSingle();
    return db;
  }

  // Update deleteDatabase to be static and more robust
  static Future<void> deleteAndReinitialize() async {
    // Get the database path
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'billkeep.sqlite'));

    // Delete if exists
    if (await file.exists()) {
      await file.delete();
    }

    // Also delete any auxiliary files (WAL, SHM)
    final walFile = File(p.join(dbFolder.path, 'billkeep.sqlite-wal'));
    final shmFile = File(p.join(dbFolder.path, 'billkeep.sqlite-shm'));

    if (await walFile.exists()) await walFile.delete();
    if (await shmFile.exists()) await shmFile.delete();
  }

  // Create project
  Future<int> createProject(ProjectsCompanion project) {
    return into(projects).insert(project);
  }

  // Get all projects
  Future<List<Project>> getAllProjects() {
    return select(projects).get();
  }

  // Get single project
  Future<Project?> getProject(String id) {
    return (select(projects)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Create expense
  Future<int> createExpense(ExpensesCompanion expense) {
    return into(expenses).insert(expense);
  }

  // Get expenses for a project
  Future<List<Expense>> getProjectExpenses(String projectId) {
    return (select(
      expenses,
    )..where((e) => e.projectId.equals(projectId))).get();
  }

  // Add payment methods
  Future<int> createPayment(PaymentsCompanion payment) {
    return into(payments).insert(payment);
  }

  Future<List<Payment>> getExpensePayments(String expenseId) {
    return (select(
      payments,
    )..where((p) => p.expenseId.equals(expenseId))).get();
  }

  Future<int> createIncome(IncomeCompanion income) {
    return into(this.income).insert(income);
  }

  Future<List<IncomeData>> getProjectIncome(String projectId) {
    return (select(income)..where((i) => i.projectId.equals(projectId))).get();
  }

  // Method to map temp ID to canonical ID
  Future<void> mapId({
    required String tempId,
    required String canonicalId,
    required String resourceType,
  }) async {
    await into(idMappings).insert(
      IdMappingsCompanion(
        tempId: Value(tempId),
        canonicalId: Value(canonicalId),
        resourceType: Value(resourceType),
      ),
    );
  }

  // Get canonical ID from temp ID
  Future<String?> getCanonicalId(String tempId) async {
    final result = await (select(
      idMappings,
    )..where((t) => t.tempId.equals(tempId))).getSingleOrNull();
    return result?.canonicalId;
  }
}

Future<String> _getDatabasePath() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  return join(dbFolder.path, 'billkeep.db');
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'billkeep.sqlite'));
    return NativeDatabase(file);
  });
}

// Add this table to track ID mappings
class IdMappings extends Table {
  TextColumn get tempId => text()();
  TextColumn get canonicalId => text()();
  TextColumn get resourceType => text()(); // 'project', 'expense', etc.
  DateTimeColumn get mappedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {tempId};
}

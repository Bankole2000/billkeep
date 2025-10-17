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

  // Budget fields
  IntColumn get budgetAmount => integer().nullable()(); // In cents
  TextColumn get budgetType => text().nullable()(); // 'ONE_TIME' or 'RECURRING'
  TextColumn get budgetFrequency =>
      text().nullable()(); // 'WEEKLY' or 'MONTHLY' for recurring

  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))(); // NEW
  TextColumn get tempId => text().nullable()(); // Store original temp ID
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Add this table definition before the @DriftDatabase annotation
class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().customConstraint(
    'NOT NULL REFERENCES projects(id) ON DELETE CASCADE',
  )();
  TextColumn get name => text()();
  IntColumn get expectedAmount => integer()(); // Expected amount per cycle
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get type => text()(); // 'ONE_TIME' or 'RECURRING'
  TextColumn get frequency => text().nullable()(); // 'MONTHLY' or 'YEARLY'
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextRenewalDate => dateTime().nullable()();
  TextColumn get categoryId => text().nullable()(); // Link to category
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
  TextColumn get expenseId => text().nullable()(); // Nullable now
  TextColumn get incomeId => text().nullable()(); // NEW - link to income
  IntColumn get actualAmount => integer()(); // What was actually paid
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  DateTimeColumn get paymentDate => dateTime()();
  TextColumn get source => text().withDefault(
    const Constant('MANUAL'),
  )(); // 'MANUAL', 'SMS', 'EMAIL'
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
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get type => text()(); // 'ONE_TIME' or 'RECURRING'
  TextColumn get frequency => text().nullable()(); // 'MONTHLY' or 'YEARLY'
  DateTimeColumn get startDate => dateTime()(); // When income starts
  DateTimeColumn get nextExpectedDate =>
      dateTime().nullable()(); // Next expected payment
  TextColumn get categoryId => text().nullable()(); // Link to category
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
  TextColumn get type => text()(); // 'EXPENSE' or 'INCOME'
  TextColumn get icon => text().nullable()(); // Icon name or emoji
  TextColumn get color => text().nullable()(); // Hex color code
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))(); // System-provided
  TextColumn get parentCategoryId => text().nullable()(); // For subcategories
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get tempId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Projects,
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5; // Increment this when schema changes

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future migrations will go here
        if (from == 1) {
          await m.addColumn(projects, projects.budgetAmount);
          await m.addColumn(projects, projects.budgetType);
          await m.addColumn(projects, projects.budgetFrequency);
        }

        // Migration from 2 to 3 - Add expense/payment tracking to todos
        if (from == 2) {
          await m.addColumn(todoItems, todoItems.createdExpenseId);
          await m.addColumn(todoItems, todoItems.createdPaymentId);
        }

        // Migration from 3 to 4 - Add SMS/Email import tables
        if (from == 3) {
          await m.createTable(messageRules);
          await m.createTable(parsedMessages);
        }

        // Migration from 4 to 5 - Add Categories table and categoryId to Expenses/Income
        if (from == 4) {
          await m.createTable(categories);
          await m.addColumn(expenses, expenses.categoryId);
          await m.addColumn(income, income.categoryId);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  // @override
  // MigrationStrategy get migration {
  //   return MigrationStrategy(
  //     onCreate: (Migrator m) async {
  //       await m.createAll();
  //     },
  //     onUpgrade: (Migrator m, int from, int to) async {
  //       // Migration from version 1 to 2 (adding todos and shopping lists)
  //       if (from == 1) {
  //         await m.createTable(income);
  //         await m.createTable(todoItems);
  //         await m.createTable(shoppingLists);
  //         await m.createTable(shoppingListItems);
  //       }

  //       // Future migrations go here
  //       // if (from == 2) { ... }
  //       // Migration from version 2 to 3
  //       if (from <= 2) {
  //         await customStatement(
  //           'ALTER TABLE shopping_lists ADD COLUMN linked_expense_id TEXT',
  //         );
  //       }

  //       // Migration from version 3/4 to 5 - Income and Payment refactor
  //       if (from <= 3) {
  //         // Add new columns to income table
  //         await customStatement(
  //           'ALTER TABLE income ADD COLUMN type TEXT DEFAULT "ONE_TIME"',
  //         );
  //         await customStatement('ALTER TABLE income ADD COLUMN frequency TEXT');
  //         await customStatement(
  //           'ALTER TABLE income ADD COLUMN start_date INTEGER',
  //         );
  //         await customStatement(
  //           'ALTER TABLE income ADD COLUMN next_expected_date INTEGER',
  //         );
  //         await customStatement(
  //           'ALTER TABLE income ADD COLUMN is_active INTEGER DEFAULT 1',
  //         );

  //         // Rename amount to expected_amount in income
  //         await customStatement(
  //           'ALTER TABLE income RENAME COLUMN amount TO expected_amount',
  //         );

  //         // Remove old date_received, replace with start_date
  //         // SQLite doesn't support DROP COLUMN, so we need to recreate
  //         // For now, just update start_date with date_received value
  //         await customStatement(
  //           'UPDATE income SET start_date = date_received WHERE start_date IS NULL',
  //         );

  //         // Add new columns to payments table
  //         await customStatement(
  //           'ALTER TABLE payments ADD COLUMN payment_type TEXT DEFAULT "DEBIT"',
  //         );
  //         await customStatement(
  //           'ALTER TABLE payments ADD COLUMN income_id TEXT',
  //         );

  //         // Make expense_id nullable by updating constraint (already nullable in new schema)
  //       }
  //     },
  //     beforeOpen: (details) async {
  //       // Optional: Enable foreign keys
  //       await customStatement('PRAGMA foreign_keys = ON');
  //     },
  //   );
  // }

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

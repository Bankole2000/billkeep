import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:billkeep/providers/database_provider.dart';

// Stream provider for all budgets
final allBudgetsProvider = StreamProvider<List<Budget>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.select(database.budgets).watch();
});

// Stream provider family for budgets by project
final projectBudgetsProvider =
    StreamProviderFamily<List<Budget>, String>((ref, projectId) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.budgets)
        ..where((b) => b.projectId.equals(projectId) & b.isActive.equals(true)))
      .watch();
});

// Stream provider family for active budget by project (returns first active budget)
final activeProjectBudgetProvider =
    StreamProviderFamily<Budget?, String>((ref, projectId) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.budgets)
        ..where((b) => b.projectId.equals(projectId) & b.isActive.equals(true))
        ..limit(1))
      .watchSingleOrNull();
});

// Stream provider family for a single budget
final budgetProvider = StreamProviderFamily<Budget?, String>((
  ref,
  budgetId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.budgets,
  )..where((b) => b.id.equals(budgetId)))
      .watchSingleOrNull();
});

final budgetRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return BudgetRepository(database);
});

class BudgetRepository {
  final AppDatabase _database;

  BudgetRepository(this._database);

  // Create a new budget
  Future<String> createBudget({
    required String name,
    required String projectId,
    required String currency,
    required int limitAmount,
    required DateTime startDate,
    required DateTime endDate,
    String? categoryId,
    int? underLimitGoal,
    int? overBudgetAllowance,
    String? iconEmoji,
    int? iconCodePoint,
    String? iconType,
    String? color,
  }) async {
    final tempBudgetId = IdGenerator.tempBudget();

    await _database.into(_database.budgets).insert(
          BudgetsCompanion(
            id: Value(tempBudgetId),
            tempId: Value(tempBudgetId),
            name: Value(name),
            projectId: Value(projectId),
            currency: Value(currency),
            limitAmount: Value(limitAmount),
            startDate: Value(startDate),
            endDate: Value(endDate),
            categoryId: Value(categoryId),
            underLimitGoal: Value(underLimitGoal),
            overBudgetAllowance: Value(overBudgetAllowance ?? 0),
            spentAmount: const Value(0),
            iconEmoji: Value(iconEmoji),
            iconCodePoint: Value(iconCodePoint),
            iconType: Value(iconType ?? 'MaterialIcons'),
            color: Value(color),
            isActive: const Value(true),
            isSynced: const Value(false),
          ),
        );

    return tempBudgetId;
  }

  // Update a budget
  Future<void> updateBudget({
    required String budgetId,
    String? name,
    int? limitAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    int? underLimitGoal,
    int? overBudgetAllowance,
    int? spentAmount,
    String? iconEmoji,
    int? iconCodePoint,
    String? iconType,
    String? color,
    bool? isActive,
  }) async {
    final companion = BudgetsCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      limitAmount: limitAmount != null ? Value(limitAmount) : const Value.absent(),
      startDate: startDate != null ? Value(startDate) : const Value.absent(),
      endDate: endDate != null ? Value(endDate) : const Value.absent(),
      categoryId: categoryId != null ? Value(categoryId) : const Value.absent(),
      underLimitGoal: underLimitGoal != null ? Value(underLimitGoal) : const Value.absent(),
      overBudgetAllowance: overBudgetAllowance != null ? Value(overBudgetAllowance) : const Value.absent(),
      spentAmount: spentAmount != null ? Value(spentAmount) : const Value.absent(),
      iconEmoji: iconEmoji != null ? Value(iconEmoji) : const Value.absent(),
      iconCodePoint: iconCodePoint != null ? Value(iconCodePoint) : const Value.absent(),
      iconType: iconType != null ? Value(iconType) : const Value.absent(),
      color: color != null ? Value(color) : const Value.absent(),
      isActive: isActive != null ? Value(isActive) : const Value.absent(),
    );

    await (_database.update(
      _database.budgets,
    )..where((b) => b.id.equals(budgetId))).write(companion);
  }

  // Delete a budget
  Future<void> deleteBudget(String budgetId) async {
    await (_database.delete(
      _database.budgets,
    )..where((b) => b.id.equals(budgetId)))
        .go();
  }

  // Deactivate a budget (soft delete)
  Future<void> deactivateBudget(String budgetId) async {
    await (_database.update(
      _database.budgets,
    )..where((b) => b.id.equals(budgetId)))
        .write(
      const BudgetsCompanion(
        isActive: Value(false),
      ),
    );
  }

  // Get budget by ID
  Future<Budget?> getBudget(String budgetId) async {
    return await (_database.select(
      _database.budgets,
    )..where((b) => b.id.equals(budgetId)))
        .getSingleOrNull();
  }

  // Get all budgets for a project
  Future<List<Budget>> getProjectBudgets(String projectId) async {
    return await (_database.select(
      _database.budgets,
    )..where((b) => b.projectId.equals(projectId)))
        .get();
  }

  // Get active budget for a project
  Future<Budget?> getActiveProjectBudget(String projectId) async {
    return await (_database.select(
      _database.budgets,
    )
          ..where((b) => b.projectId.equals(projectId) & b.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();
  }

  // Stream all budgets
  Stream<List<Budget>> watchAllBudgets() {
    return _database.select(_database.budgets).watch();
  }

  // Stream budgets for a project
  Stream<List<Budget>> watchProjectBudgets(String projectId) {
    return (_database.select(_database.budgets)
          ..where((b) => b.projectId.equals(projectId)))
        .watch();
  }

  // Update spent amount for a budget
  Future<void> updateSpentAmount(String budgetId, int spentAmount) async {
    await (_database.update(
      _database.budgets,
    )..where((b) => b.id.equals(budgetId)))
        .write(
      BudgetsCompanion(
        spentAmount: Value(spentAmount),
      ),
    );
  }
}

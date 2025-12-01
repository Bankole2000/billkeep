import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/budget_model.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:drift/drift.dart';

class BudgetRepository {
  final AppDatabase _database;

  BudgetRepository(this._database);

  /// Create a new budget using BudgetModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final budget = BudgetModel(
  ///   name: 'Monthly Budget',
  ///   projectId: projectId,
  ///   currency: 'USD',
  ///   limitAmount: 100000,
  ///   startDate: DateTime.now(),
  ///   endDate: DateTime.now().add(Duration(days: 30)),
  /// );
  /// final id = await repository.createBudget(budget);
  /// ```
  Future<String> createBudget(BudgetModel newBudget) async {
    final tempBudgetId = IdGenerator.tempBudget();

    try {
      await _database
          .into(_database.budgets)
          .insert(newBudget.toCompanion(tempId: tempBudgetId));
    } catch (e) {
      print('Error creating budget: $e');
      rethrow;
    }

    return tempBudgetId;
  }

  /// Update budget using BudgetModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final updated = currentBudget.copyWith(name: 'New Name', limitAmount: 5000);
  /// await repository.updateBudget(updated);
  /// ```
  Future<String> updateBudget(BudgetModel updatedBudget) async {
    if (updatedBudget.id == null) {
      throw ArgumentError('Cannot update budget without an ID');
    }

    try {
      await (_database.update(
        _database.budgets,
      )..where((b) => b.id.equals(updatedBudget.id!))).write(
        updatedBudget.toCompanion(isSynced: false, updatedAt: DateTime.now()),
      );
    } catch (e) {
      print('Error updating budget: $e');
      rethrow;
    }
    return updatedBudget.id!;
  }

  // Delete a budget
  Future<void> deleteBudget(String budgetId) async {
    await (_database.delete(
      _database.budgets,
    )..where((b) => b.id.equals(budgetId))).go();
  }

  // Get budget by tempId
  Future<Budget?> getBudgetByTempId(String tempId) async {
    return await (_database.select(
      _database.budgets,
    )..where((b) => b.tempId.equals(tempId))).getSingleOrNull();
  }

  // Get budget by ID
  Future<Budget?> getBudget(String budgetId) async {
    return await (_database.select(
      _database.budgets,
    )..where((b) => b.id.equals(budgetId))).getSingleOrNull();
  }

  // Get all budgets for a project
  Future<List<Budget>> getProjectBudgets(String projectId) async {
    return await (_database.select(
      _database.budgets,
    )..where((b) => b.projectId.equals(projectId))).get();
  }

  // Deactivate a budget (soft delete)
  Future<void> deactivateBudget(String budgetId) async {
    await (_database.update(_database.budgets)
          ..where((b) => b.id.equals(budgetId)))
        .write(const BudgetsCompanion(isActive: Value(false)));
  }

  // Get active budget for a project
  Future<Budget?> getActiveProjectBudget(String projectId) async {
    return await (_database.select(_database.budgets)
          ..where(
            (b) => b.projectId.equals(projectId) & b.isActive.equals(true),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  // Stream all budgets
  Stream<List<Budget>> watchAllBudgets() {
    return _database.select(_database.budgets).watch();
  }

  // Stream budgets for a project
  Stream<List<Budget>> watchProjectBudgets(String projectId) {
    return (_database.select(
      _database.budgets,
    )..where((b) => b.projectId.equals(projectId))).watch();
  }

  // Update spent amount for a budget
  Future<void> updateSpentAmount(String budgetId, int spentAmount) async {
    await (_database.update(_database.budgets)
          ..where((b) => b.id.equals(budgetId)))
        .write(BudgetsCompanion(spentAmount: Value(spentAmount)));
  }
}

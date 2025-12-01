import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/budget_model.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:billkeep/providers/database_provider.dart';
import '../repositories/budget_repository.dart';

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



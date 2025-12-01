import 'package:billkeep/models/expense_model.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:billkeep/utils/date_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:billkeep/utils/currency_helper.dart';
import 'package:billkeep/providers/database_provider.dart';
import '../repositories/expense_repository.dart';

final projectExpensesProvider = StreamProviderFamily<List<Expense>, String>((
  ref,
  projectId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.expenses,
  )..where((e) => e.projectId.equals(projectId))).watch();
});

final expensePaymentsProvider = StreamProviderFamily<List<Payment>, String>((
  ref,
  expenseId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.payments,
  )..where((p) => p.expenseId.equals(expenseId))).watch();
});



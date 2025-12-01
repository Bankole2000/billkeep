import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/income_model.dart';
import '../utils/id_generator.dart';
import '../utils/currency_helper.dart';
import 'database_provider.dart';
import '../repositories/income_repository.dart';

final projectIncomeProvider = StreamProviderFamily<List<IncomeData>, String>((
  ref,
  projectId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.income,
  )..where((i) => i.projectId.equals(projectId))).watch();
});

final incomePaymentsProvider = StreamProviderFamily<List<Payment>, String>((
  ref,
  incomeId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.payments,
  )..where((p) => p.incomeId.equals(incomeId))).watch();
});



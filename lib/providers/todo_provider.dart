import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/todo_model.dart';
import '../utils/id_generator.dart';
import 'database_provider.dart';
import 'expense_provider.dart';
import '../repositories/todo_repository.dart';

final projectTodosProvider = StreamProviderFamily<List<TodoItem>, String>((
  ref,
  projectId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.todoItems)
        ..where((t) => t.projectId.equals(projectId) & t.parentTodoId.isNull())
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
});

final todoSubtasksProvider = StreamProviderFamily<List<TodoItem>, String>((
  ref,
  parentTodoId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.todoItems)
        ..where((t) => t.parentTodoId.equals(parentTodoId))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();
});



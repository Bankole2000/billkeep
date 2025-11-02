import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../utils/id_generator.dart';
import 'database_provider.dart';
import 'expense_provider.dart';

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

final todoRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  final expenseRepository = ref.watch(expenseRepositoryProvider);
  return TodoRepository(database, expenseRepository);
});

class TodoRepository {
  final AppDatabase _database;
  final ExpenseRepository _expenseRepository;

  TodoRepository(this._database, this._expenseRepository);

  Future<String> createTodo({
    required String projectId,
    required String title,
    String? description,
    int? directExpenseAmount,
    String? directExpenseType,
    String? directExpenseFrequency,
    String? directExpenseDescription,
    String? linkedShoppingListId,
    String? parentTodoId,
  }) async {
    final tempId = IdGenerator.tempTodo();

    // If has direct expense, create the expense record first
    String? createdExpenseId;
    if (directExpenseAmount != null) {
      final amountInDollars = (directExpenseAmount / 100).toStringAsFixed(2);

      // createdExpenseId = await _expenseRepository.createExpense(
      //   projectId: projectId,
      //   name: directExpenseDescription ?? 'Todo: $title',
      //   amount: amountInDollars,
      //   type: directExpenseType ?? 'ONE_TIME',
      //   frequency: directExpenseFrequency,
      //   notes: 'Linked to todo',
      //   createInitialPayment: false, // Don't create payment yet
      // );
    }

    await _database
        .into(_database.todoItems)
        .insert(
          TodoItemsCompanion(
            id: Value(tempId),
            tempId: Value(tempId),
            projectId: Value(projectId),
            title: Value(title),
            description: Value(description),
            directExpenseAmount: Value(directExpenseAmount),
            directExpenseType: Value(directExpenseType),
            directExpenseFrequency: Value(directExpenseFrequency),
            directExpenseDescription: Value(directExpenseDescription),
            createdExpenseId: Value(createdExpenseId), // Track the expense
            linkedShoppingListId: Value(linkedShoppingListId),
            parentTodoId: Value(parentTodoId),
            isSynced: const Value(false),
          ),
        );

    // Store created expense ID in a mapping or note
    // For now, we'll track it via the expense notes field

    return tempId;
  }

  Future<void> toggleTodoComplete(String todoId, bool isCompleted) async {
    // Get the todo first
    final todo = await (_database.select(
      _database.todoItems,
    )..where((t) => t.id.equals(todoId))).getSingle();

    if (isCompleted) {
      // Mark as completed
      await (_database.update(
        _database.todoItems,
      )..where((t) => t.id.equals(todoId))).write(
        TodoItemsCompanion(
          isCompleted: const Value(true),
          completedAt: Value(DateTime.now()),
        ),
      );

      // Create payment if has direct expense
      if (todo.createdExpenseId != null && todo.directExpenseAmount != null) {
        final amountInDollars = (todo.directExpenseAmount! / 100)
            .toStringAsFixed(2);

        final paymentId = await _expenseRepository.recordPayment(
          expenseId: todo.createdExpenseId!,
          actualAmount: amountInDollars,
          paymentDate: DateTime.now(),
          notes: 'Todo completed: ${todo.title}',
        );

        // Store payment ID in todo
        await (_database.update(_database.todoItems)
              ..where((t) => t.id.equals(todoId)))
            .write(TodoItemsCompanion(createdPaymentId: Value(paymentId)));
      }
    } else {
      // Mark as incomplete
      await (_database.update(
        _database.todoItems,
      )..where((t) => t.id.equals(todoId))).write(
        const TodoItemsCompanion(
          isCompleted: Value(false),
          completedAt: Value(null),
        ),
      );

      // Delete the payment if exists
      if (todo.createdPaymentId != null) {
        await (_database.delete(
          _database.payments,
        )..where((p) => p.id.equals(todo.createdPaymentId!))).go();

        // Clear payment ID from todo
        await (_database.update(_database.todoItems)
              ..where((t) => t.id.equals(todoId)))
            .write(const TodoItemsCompanion(createdPaymentId: Value(null)));
      }
    }
  }

  Future<void> updateTodo({
    required String todoId,
    required String title,
    String? description,
  }) async {
    await (_database.update(
      _database.todoItems,
    )..where((t) => t.id.equals(todoId))).write(
      TodoItemsCompanion(title: Value(title), description: Value(description)),
    );
  }

  Future<void> deleteTodo(String todoId) async {
    // Get the todo first to check if it has created expense/payment
    final todo = await (_database.select(
      _database.todoItems,
    )..where((t) => t.id.equals(todoId))).getSingle();

    // Delete created payment if exists
    if (todo.createdPaymentId != null) {
      await (_database.delete(
        _database.payments,
      )..where((p) => p.id.equals(todo.createdPaymentId!))).go();
    }

    // Delete created expense if exists
    if (todo.createdExpenseId != null) {
      await (_database.delete(
        _database.expenses,
      )..where((e) => e.id.equals(todo.createdExpenseId!))).go();
    }

    // Delete the todo (subtasks will be cascade deleted if they exist)
    await (_database.delete(
      _database.todoItems,
    )..where((t) => t.id.equals(todoId))).go();
  }

  Stream<List<TodoItem>> watchProjectTodos(String projectId) {
    return (_database.select(_database.todoItems)..where(
          (t) => t.projectId.equals(projectId) & t.parentTodoId.isNull(),
        ))
        .watch();
  }

  Stream<List<TodoItem>> watchSubtasks(String parentTodoId) {
    return (_database.select(
      _database.todoItems,
    )..where((t) => t.parentTodoId.equals(parentTodoId))).watch();
  }
}

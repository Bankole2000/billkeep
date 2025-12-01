import 'package:billkeep/database/database.dart';
import 'package:billkeep/repositories/expense_repository.dart';

import 'package:billkeep/models/todo_model.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:drift/drift.dart';

class TodoRepository {
  final AppDatabase _database;
  final ExpenseRepository _expenseRepository;

  TodoRepository(this._database, this._expenseRepository);

  /// Create a new todo using TodoModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final todo = TodoModel(
  ///   projectId: projectId,
  ///   title: 'Buy groceries',
  ///   description: 'Weekly shopping',
  ///   directExpenseAmount: 5000,
  /// );
  /// final id = await repository.createTodo(todo);
  /// ```
  Future<String> createTodo(TodoItemModel newTodo) async {
    final tempId = IdGenerator.tempTodo();

    // If has direct expense, create the expense record first
    // (Commented out as the expense creation logic seems incomplete)
    // String? createdExpenseId;
    // if (newTodo.directExpenseAmount != null) {
    //   final amountInDollars = (newTodo.directExpenseAmount! / 100).toStringAsFixed(2);
    //   createdExpenseId = await _expenseRepository.createExpense(...);
    // }

    try {
      await _database
          .into(_database.todoItems)
          .insert(newTodo.toCompanion(tempId: tempId));
    } catch (e) {
      print('Error creating todo: $e');
      rethrow;
    }

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

  /// Update todo using TodoModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final updated = currentTodo.copyWith(title: 'New Title', description: 'Updated');
  /// await repository.updateTodo(updated);
  /// ```
  Future<String> updateTodo(TodoItemModel updatedTodo) async {
    if (updatedTodo.id == null) {
      throw ArgumentError('Cannot update todo without an ID');
    }

    try {
      await (_database.update(
        _database.todoItems,
      )..where((t) => t.id.equals(updatedTodo.id!))).write(
        updatedTodo.toCompanion(isSynced: false, updatedAt: DateTime.now()),
      );
    } catch (e) {
      print('Error updating todo: $e');
      rethrow;
    }
    return updatedTodo.id!;
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

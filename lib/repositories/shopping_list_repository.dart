import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

import '../models/shopping_list_item_model.dart';
import '../models/shopping_list_model.dart';
import '../utils/id_generator.dart';

class ShoppingListRepository {
  final AppDatabase _database;

  ShoppingListRepository(this._database);

  /// Create a new shopping list using ShoppingListModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final shoppingList = ShoppingListModel(
  ///   projectId: projectId,
  ///   name: 'Weekly Groceries',
  ///   description: 'Shopping for the week',
  /// );
  /// final id = await repository.createShoppingList(shoppingList);
  /// ```
  Future<String> createShoppingList(ShoppingListModel newShoppingList) async {
    final tempId = IdGenerator.tempShoppingList();

    try {
      await _database
          .into(_database.shoppingLists)
          .insert(newShoppingList.toCompanion(tempId: tempId));
    } catch (e) {
      print('Error creating shopping list: $e');
      rethrow;
    }

    return tempId;
  }

  /// Add a new shopping list item using ShoppingListItemModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final item = ShoppingListItemModel(
  ///   shoppingListId: listId,
  ///   name: 'Milk',
  ///   estimatedAmount: 500,
  ///   quantity: 2,
  /// );
  /// final id = await repository.addShoppingListItem(item);
  /// ```
  Future<String> addShoppingListItem(ShoppingListItemModel newItem) async {
    final tempId = IdGenerator.generateTempId('item');

    try {
      await _database
          .into(_database.shoppingListItems)
          .insert(newItem.toCompanion(tempId: tempId));
    } catch (e) {
      print('Error adding shopping list item: $e');
      rethrow;
    }

    return tempId;
  }

  Future<void> toggleItemPurchased(String itemId, bool isPurchased) async {
    // Get the item to find its shopping list and expense link
    final item = await (_database.select(
      _database.shoppingListItems,
    )..where((i) => i.id.equals(itemId))).getSingle();

    // Get the shopping list to check for linked expense
    final shoppingList = await (_database.select(
      _database.shoppingLists,
    )..where((s) => s.id.equals(item.shoppingListId))).getSingle();

    if (isPurchased) {
      // Mark item as purchased
      await (_database.update(
        _database.shoppingListItems,
      )..where((i) => i.id.equals(itemId))).write(
        ShoppingListItemsCompanion(
          isPurchased: const Value(true),
          purchasedAt: Value(DateTime.now()),
          actualAmount: Value(item.estimatedAmount),
        ),
      );

      // Create payment if expense is linked
      if (shoppingList.linkedExpenseId != null) {
        final paymentId = IdGenerator.tempPayment();

        await _database
            .into(_database.payments)
            .insert(
              PaymentsCompanion(
                id: Value(paymentId),
                tempId: Value(paymentId),
                paymentType: const Value(
                  'DEBIT',
                ), // Shopping list = expense = DEBIT
                expenseId: Value(shoppingList.linkedExpenseId!),
                actualAmount: Value(item.estimatedAmount ?? 0),
                paymentDate: Value(DateTime.now()),
                source: const Value('SHOPPING_LIST'),
                verified: const Value(true),
                notes: Value('${item.name} x${item.quantity}'),
                isSynced: const Value(false),
              ),
            );

        // Store payment ID in shopping list item
        await (_database.update(
          _database.shoppingListItems,
        )..where((i) => i.id.equals(itemId))).write(
          ShoppingListItemsCompanion(createdExpenseId: Value(paymentId)),
        );

        // Update expense expectedAmount with total of all payments
        await _updateExpenseAmount(shoppingList.linkedExpenseId!);
      }
    } else {
      // Unmark as purchased and delete payment
      if (item.createdExpenseId != null) {
        await (_database.delete(
          _database.payments,
        )..where((p) => p.id.equals(item.createdExpenseId!))).go();
      }

      await (_database.update(
        _database.shoppingListItems,
      )..where((i) => i.id.equals(itemId))).write(
        const ShoppingListItemsCompanion(
          isPurchased: Value(false),
          purchasedAt: Value(null),
          actualAmount: Value(null),
          createdExpenseId: Value(null),
        ),
      );

      // Update expense expectedAmount after removing payment
      if (shoppingList.linkedExpenseId != null) {
        await _updateExpenseAmount(shoppingList.linkedExpenseId!);
      }
    }
  }

  // Helper method to update expense amount based on total payments
  Future<void> _updateExpenseAmount(String expenseId) async {
    final payments = await (_database.select(
      _database.payments,
    )..where((p) => p.expenseId.equals(expenseId))).get();

    final totalAmount = payments.fold<int>(
      0,
      (sum, payment) => sum + payment.actualAmount,
    );

    await (_database.update(_database.expenses)
          ..where((e) => e.id.equals(expenseId)))
        .write(ExpensesCompanion(expectedAmount: Value(totalAmount)));
  }

  /// Update shopping list using ShoppingListModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final updated = currentList.copyWith(name: 'New Name', description: 'Updated');
  /// await repository.updateShoppingList(updated);
  /// ```
  Future<String> updateShoppingList(ShoppingListModel updatedList) async {
    if (updatedList.id == null) {
      throw ArgumentError('Cannot update shopping list without an ID');
    }

    try {
      await (_database.update(
        _database.shoppingLists,
      )..where((s) => s.id.equals(updatedList.id!))).write(
        updatedList.toCompanion(isSynced: false, updatedAt: DateTime.now()),
      );
    } catch (e) {
      print('Error updating shopping list: $e');
      rethrow;
    }
    return updatedList.id!;
  }

  Future<void> deleteShoppingList(String shoppingListId) async {
    // Get the shopping list first to check for linked expense
    final shoppingList = await (_database.select(
      _database.shoppingLists,
    )..where((s) => s.id.equals(shoppingListId))).getSingle();

    // Delete linked expense if exists (payments will cascade)
    if (shoppingList.linkedExpenseId != null) {
      await (_database.delete(
        _database.expenses,
      )..where((e) => e.id.equals(shoppingList.linkedExpenseId!))).go();
    }

    // Delete the shopping list (items will cascade delete)
    await (_database.delete(
      _database.shoppingLists,
    )..where((s) => s.id.equals(shoppingListId))).go();
  }

  /// Update shopping list item using ShoppingListItemModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final updated = currentItem.copyWith(name: 'New Name', quantity: 2);
  /// await repository.updateShoppingListItem(updated);
  /// ```
  Future<String> updateShoppingListItem(
    ShoppingListItemModel updatedItem,
  ) async {
    if (updatedItem.id == null) {
      throw ArgumentError('Cannot update shopping list item without an ID');
    }

    try {
      await (_database.update(
        _database.shoppingListItems,
      )..where((i) => i.id.equals(updatedItem.id!))).write(
        updatedItem.toCompanion(isSynced: false, updatedAt: DateTime.now()),
      );
    } catch (e) {
      print('Error updating shopping list item: $e');
      rethrow;
    }
    return updatedItem.id!;
  }

  Future<void> deleteShoppingListItem(String itemId) async {
    // Get the item first
    final item = await (_database.select(
      _database.shoppingListItems,
    )..where((i) => i.id.equals(itemId))).getSingle();

    // Delete created payment if exists (when item was purchased)
    if (item.createdExpenseId != null) {
      await (_database.delete(
        _database.payments,
      )..where((p) => p.id.equals(item.createdExpenseId!))).go();
    }

    // Delete the item
    await (_database.delete(
      _database.shoppingListItems,
    )..where((i) => i.id.equals(itemId))).go();
  }

  Stream<List<ShoppingList>> watchProjectShoppingLists(String projectId) {
    return (_database.select(
      _database.shoppingLists,
    )..where((s) => s.projectId.equals(projectId))).watch();
  }

  Stream<List<ShoppingListItem>> watchShoppingListItems(String listId) {
    return (_database.select(
      _database.shoppingListItems,
    )..where((i) => i.shoppingListId.equals(listId))).watch();
  }
}

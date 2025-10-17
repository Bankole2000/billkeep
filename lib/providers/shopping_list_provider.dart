import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../utils/id_generator.dart';
import 'database_provider.dart';

final projectShoppingListsProvider =
    StreamProviderFamily<List<ShoppingList>, String>((ref, projectId) {
      final database = ref.watch(databaseProvider);
      return (database.select(database.shoppingLists)
            ..where((s) => s.projectId.equals(projectId))
            ..orderBy([(s) => OrderingTerm.desc(s.createdAt)]))
          .watch();
    });

final shoppingListItemsProvider =
    StreamProviderFamily<List<ShoppingListItem>, String>((ref, listId) {
      final database = ref.watch(databaseProvider);
      return (database.select(
        database.shoppingListItems,
      )..where((i) => i.shoppingListId.equals(listId))).watch();
    });

final shoppingListRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return ShoppingListRepository(database);
});

class ShoppingListRepository {
  final AppDatabase _database;

  ShoppingListRepository(this._database);

  Future<String> createShoppingList({
    required String projectId,
    required String name,
    String? description,
    String? linkedExpenseId,
  }) async {
    final tempId = IdGenerator.tempShoppingList();

    await _database
        .into(_database.shoppingLists)
        .insert(
          ShoppingListsCompanion(
            id: Value(tempId),
            tempId: Value(tempId),
            projectId: Value(projectId),
            name: Value(name),
            description: Value(description),
            linkedExpenseId: Value(linkedExpenseId),
            isSynced: const Value(false),
          ),
        );

    return tempId;
  }

  Future<String> addShoppingListItem({
    required String shoppingListId,
    required String name,
    int? estimatedAmount,
    int quantity = 1,
    String? notes,
  }) async {
    final tempId = IdGenerator.generateTempId('item');

    await _database
        .into(_database.shoppingListItems)
        .insert(
          ShoppingListItemsCompanion(
            id: Value(tempId),
            tempId: Value(tempId),
            shoppingListId: Value(shoppingListId),
            name: Value(name),
            estimatedAmount: Value(estimatedAmount),
            quantity: Value(quantity),
            notes: Value(notes),
            isSynced: const Value(false),
          ),
        );

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

  Future<void> updateShoppingList({
    required String shoppingListId,
    required String name,
    String? description,
  }) async {
    await (_database.update(
      _database.shoppingLists,
    )..where((s) => s.id.equals(shoppingListId))).write(
      ShoppingListsCompanion(
        name: Value(name),
        description: Value(description),
      ),
    );
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

  Future<void> updateShoppingListItem({
    required String itemId,
    required String name,
    int? estimatedAmount,
    int quantity = 1,
    String? notes,
  }) async {
    await (_database.update(
      _database.shoppingListItems,
    )..where((i) => i.id.equals(itemId))).write(
      ShoppingListItemsCompanion(
        name: Value(name),
        estimatedAmount: Value(estimatedAmount),
        quantity: Value(quantity),
        notes: Value(notes),
      ),
    );
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

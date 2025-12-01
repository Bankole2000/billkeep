import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/shopping_list_model.dart';
import '../models/shopping_list_item_model.dart';
import '../utils/id_generator.dart';
import 'database_provider.dart';
import '../repositories/shopping_list_repository.dart';

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



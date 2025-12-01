import 'package:billkeep/models/category_models.dart';
import 'package:billkeep/models/category_model.dart';
import 'package:billkeep/utils/app_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:billkeep/providers/database_provider.dart';
import '../repositories/category_repository.dart';

final groupedCategoriesProvider =
    StreamProvider<List<CategoryGroupWithCategories>>((ref) {
      final database = ref.watch(databaseProvider);
      final searchQuery = ref.watch(categorySearchQueryProvider);

      final query =
          (database.select(
            database.categories,
          )..orderBy([(c) => OrderingTerm.asc(c.name)])).join([
            innerJoin(
              database.categoryGroups,
              database.categoryGroups.id.equalsExp(
                database.categories.categoryGroupId,
              ),
            ),
          ]);

      return query.watch().map((rows) {
        final grouped = <String, CategoryGroupWithCategories>{};

        for (final row in rows) {
          final group = row.readTable(database.categoryGroups);
          final category = row.readTable(database.categories);

          // 🔎 Filter by search query
          if (searchQuery.isNotEmpty &&
              !category.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              )) {
            continue;
          }

          grouped.putIfAbsent(
            group.id,
            () => CategoryGroupWithCategories(group: group, categories: []),
          );
          grouped[group.id]!.categories.add(category);
        }

        return grouped.values.toList();
      });
    });

final categorySearchQueryProvider = StateProvider<String>((ref) => '');

final categoryViewModeProvider = StateProvider<ViewModeOptions>(
  (ref) => ViewModeOptions.grid,
);

final expandedGroupsProvider =
    StateNotifierProvider<ExpandedGroupsNotifier, Set<String>>((ref) {
      return ExpandedGroupsNotifier();
    });

class ExpandedGroupsNotifier extends StateNotifier<Set<String>> {
  ExpandedGroupsNotifier() : super({});

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  void expandAll(Iterable<String> ids) {
    state = {...state, ...ids};
  }

  void collapseAll() {
    state = {};
  }
}

// Stream provider for all category groups
final allCategoryGroupsProvider = StreamProvider<List<CategoryGroup>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.select(database.categoryGroups).watch();
});

// Stream provider for all categories
final allCategoriesProvider = StreamProvider<List<Category>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.select(database.categories).watch();
});

// Stream provider for expense categories (parent categories only)
// final expenseCategoriesProvider = StreamProvider<List<Category>>((ref) {
//   final database = ref.watch(databaseProvider);
//   return (database.select(database.categories)
//         ..where((c) =>
//             c.type.equals('EXPENSE') & c.parentCategoryId.isNull()))
//       .watch();
// });

// Stream provider for income categories (parent categories only)
// final incomeCategoriesProvider = StreamProvider<List<Category>>((ref) {
//   final database = ref.watch(databaseProvider);
//   return (database.select(database.categories)
//         ..where((c) =>
//             c.type.equals('INCOME') & c.parentCategoryId.isNull()))
//       .watch();
// });

// Stream provider family for subcategories of a parent category
// final subcategoriesProvider =
//     StreamProviderFamily<List<Category>, String>((ref, parentId) {
//   final database = ref.watch(databaseProvider);
//   return (database.select(database.categories)
//         ..where((c) => c.parentCategoryId.equals(parentId)))
//       .watch();
// });

// Stream provider family for a single category
final categoryProvider = StreamProviderFamily<Category?, String>((
  ref,
  categoryId,
) {
  final database = ref.watch(databaseProvider);
  return (database.select(
    database.categories,
  )..where((c) => c.id.equals(categoryId))).watchSingleOrNull();
});



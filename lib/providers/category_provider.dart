import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:billkeep/providers/database_provider.dart';

// Stream provider for all categories
final allCategoriesProvider = StreamProvider<List<Category>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.select(database.categories).watch();
});

// Stream provider for expense categories (parent categories only)
final expenseCategoriesProvider = StreamProvider<List<Category>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.categories)
        ..where((c) =>
            c.type.equals('EXPENSE') & c.parentCategoryId.isNull()))
      .watch();
});

// Stream provider for income categories (parent categories only)
final incomeCategoriesProvider = StreamProvider<List<Category>>((ref) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.categories)
        ..where((c) =>
            c.type.equals('INCOME') & c.parentCategoryId.isNull()))
      .watch();
});

// Stream provider family for subcategories of a parent category
final subcategoriesProvider =
    StreamProviderFamily<List<Category>, String>((ref, parentId) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.categories)
        ..where((c) => c.parentCategoryId.equals(parentId)))
      .watch();
});

// Stream provider family for a single category
final categoryProvider =
    StreamProviderFamily<Category?, String>((ref, categoryId) {
  final database = ref.watch(databaseProvider);
  return (database.select(database.categories)
        ..where((c) => c.id.equals(categoryId)))
      .watchSingleOrNull();
});

final categoryRepositoryProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return CategoryRepository(database);
});

class CategoryRepository {
  final AppDatabase _database;

  CategoryRepository(this._database);

  // Create a new category
  Future<String> createCategory({
    required String name,
    required String type, // 'EXPENSE' or 'INCOME'
    String? icon,
    String? color,
    String? parentCategoryId,
  }) async {
    final tempCategoryId = IdGenerator.generate('category');

    await _database.into(_database.categories).insert(
          CategoriesCompanion(
            id: Value(tempCategoryId),
            tempId: Value(tempCategoryId),
            name: Value(name),
            type: Value(type),
            icon: Value(icon),
            color: Value(color),
            parentCategoryId: Value(parentCategoryId),
            isDefault: const Value(false),
            isSynced: const Value(false),
          ),
        );

    return tempCategoryId;
  }

  // Update a category
  Future<void> updateCategory({
    required String categoryId,
    required String name,
    String? icon,
    String? color,
  }) async {
    await (_database.update(_database.categories)
          ..where((c) => c.id.equals(categoryId)))
        .write(
      CategoriesCompanion(
        name: Value(name),
        icon: Value(icon),
        color: Value(color),
      ),
    );
  }

  // Delete a category (only if not default and has no associated expenses/income)
  Future<void> deleteCategory(String categoryId) async {
    // Check if category is default
    final category = await (_database.select(_database.categories)
          ..where((c) => c.id.equals(categoryId)))
        .getSingleOrNull();

    if (category == null) {
      throw Exception('Category not found');
    }

    if (category.isDefault) {
      throw Exception('Cannot delete default categories');
    }

    // Check if any expenses use this category
    final expensesWithCategory = await (_database.select(_database.expenses)
          ..where((e) => e.categoryId.equals(categoryId)))
        .get();

    if (expensesWithCategory.isNotEmpty) {
      throw Exception(
        'Cannot delete category - ${expensesWithCategory.length} expenses use this category',
      );
    }

    // Check if any income uses this category
    final incomeWithCategory = await (_database.select(_database.income)
          ..where((i) => i.categoryId.equals(categoryId)))
        .get();

    if (incomeWithCategory.isNotEmpty) {
      throw Exception(
        'Cannot delete category - ${incomeWithCategory.length} income records use this category',
      );
    }

    // Delete subcategories first
    await (_database.delete(_database.categories)
          ..where((c) => c.parentCategoryId.equals(categoryId)))
        .go();

    // Delete the category
    await (_database.delete(_database.categories)
          ..where((c) => c.id.equals(categoryId)))
        .go();
  }

  // Get all parent categories by type
  Future<List<Category>> getParentCategories(String type) async {
    return await (_database.select(_database.categories)
          ..where((c) => c.type.equals(type) & c.parentCategoryId.isNull()))
        .get();
  }

  // Get subcategories for a parent
  Future<List<Category>> getSubcategories(String parentId) async {
    return await (_database.select(_database.categories)
          ..where((c) => c.parentCategoryId.equals(parentId)))
        .get();
  }

  // Stream all categories
  Stream<List<Category>> watchAllCategories() {
    return _database.select(_database.categories).watch();
  }

  // Stream parent categories by type
  Stream<List<Category>> watchParentCategories(String type) {
    return (_database.select(_database.categories)
          ..where((c) => c.type.equals(type) & c.parentCategoryId.isNull()))
        .watch();
  }

  // Stream subcategories
  Stream<List<Category>> watchSubcategories(String parentId) {
    return (_database.select(_database.categories)
          ..where((c) => c.parentCategoryId.equals(parentId)))
        .watch();
  }

  // Get category with subcategories
  Future<Map<String, dynamic>> getCategoryWithSubcategories(
    String categoryId,
  ) async {
    final category = await (_database.select(_database.categories)
          ..where((c) => c.id.equals(categoryId)))
        .getSingleOrNull();

    if (category == null) {
      throw Exception('Category not found');
    }

    final subcategories = await getSubcategories(categoryId);

    return {
      'category': category,
      'subcategories': subcategories,
    };
  }

  // Get category by ID
  Future<Category?> getCategory(String categoryId) async {
    return await (_database.select(_database.categories)
          ..where((c) => c.id.equals(categoryId)))
        .getSingleOrNull();
  }

  // Search categories by name
  Future<List<Category>> searchCategories(String query, String type) async {
    return await (_database.select(_database.categories)
          ..where((c) => c.name.contains(query) & c.type.equals(type)))
        .get();
  }
}

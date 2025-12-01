import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/category_model.dart';
import 'package:billkeep/utils/id_generator.dart';
import 'package:drift/drift.dart';
class CategoryRepository {
  final AppDatabase _database;

  CategoryRepository(this._database);

  /// Create a new category using CategoryModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final category = CategoryModel(
  ///   name: 'Groceries',
  ///   categoryGroupId: groupId,
  ///   iconEmoji: '🛒',
  ///   color: '#00FF00',
  /// );
  /// final id = await repository.createCategory(category);
  /// ```
  Future<String> createCategory(CategoryModel newCategory) async {
    final tempCategoryId = IdGenerator.tempCategory();

    try {
      await _database
          .into(_database.categories)
          .insert(newCategory.toCompanion(tempId: tempCategoryId));
    } catch (e) {
      print('Error creating category: $e');
      rethrow;
    }

    return tempCategoryId;
  }

  /// Update category using CategoryModel (clean & type-safe)
  ///
  /// Example usage:
  /// ```dart
  /// final updated = currentCategory.copyWith(name: 'New Name', color: '#FF0000');
  /// await repository.updateCategory(updated);
  /// ```
  Future<String> updateCategory(CategoryModel updatedCategory) async {
    if (updatedCategory.id == null) {
      throw ArgumentError('Cannot update category without an ID');
    }

    try {
      await (_database.update(
        _database.categories,
      )..where((c) => c.id.equals(updatedCategory.id!))).write(
        updatedCategory.toCompanion(isSynced: false, updatedAt: DateTime.now()),
      );
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
    return updatedCategory.id!;
  }

  // Delete a category (only if not default and has no associated expenses/income)
  Future<void> deleteCategory(String categoryId) async {
    // Check if category is default
    final category = await (_database.select(
      _database.categories,
    )..where((c) => c.id.equals(categoryId))).getSingleOrNull();

    if (category == null) {
      throw Exception('Category not found');
    }

    if (category.isDefault) {
      throw Exception('Cannot delete default categories');
    }

    // Check if any expenses use this category
    final expensesWithCategory = await (_database.select(
      _database.expenses,
    )..where((e) => e.categoryId.equals(categoryId))).get();

    if (expensesWithCategory.isNotEmpty) {
      throw Exception(
        'Cannot delete category - ${expensesWithCategory.length} expenses use this category',
      );
    }

    // Check if any income uses this category
    final incomeWithCategory = await (_database.select(
      _database.income,
    )..where((i) => i.categoryId.equals(categoryId))).get();

    if (incomeWithCategory.isNotEmpty) {
      throw Exception(
        'Cannot delete category - ${incomeWithCategory.length} income records use this category',
      );
    }

    // // Delete subcategories first
    // await (_database.delete(_database.categories)
    //       ..where((c) => c.parentCategoryId.equals(categoryId)))
    //     .go();

    // Delete the category
    await (_database.delete(
      _database.categories,
    )..where((c) => c.id.equals(categoryId))).go();
  }

  // // Get all parent categories by type
  // Future<List<Category>> getParentCategories(String type) async {
  //   return await (_database.select(_database.categories)
  //         ..where((c) => c.type.equals(type) & c.parentCategoryId.isNull()))
  //       .get();
  // }

  // // Get subcategories for a parent
  // Future<List<Category>> getSubcategories(String parentId) async {
  //   return await (_database.select(_database.categories)
  //         ..where((c) => c.parentCategoryId.equals(parentId)))
  //       .get();
  // }

  // Stream all categories
  Stream<List<Category>> watchAllCategories() {
    return _database.select(_database.categories).watch();
  }

  // Stream parent categories by type
  // Stream<List<Category>> watchParentCategories(String type) {
  //   return (_database.select(_database.categories)
  //         ..where((c) => c.type.equals(type) & c.parentCategoryId.isNull()))
  //       .watch();
  // }

  // Stream subcategories
  // Stream<List<Category>> watchSubcategories(String parentId) {
  //   return (_database.select(_database.categories)
  //         ..where((c) => c.parentCategoryId.equals(parentId)))
  //       .watch();
  // }

  // Get category with subcategories
  Future<Map<String, dynamic>> getCategoryWithSubcategories(
    String categoryId,
  ) async {
    final category = await (_database.select(
      _database.categories,
    )..where((c) => c.id.equals(categoryId))).getSingleOrNull();

    if (category == null) {
      throw Exception('Category not found');
    }

    // final subcategories = await getSubcategories(categoryId);

    return {
      'category': category,
      // 'subcategories': subcategories,
    };
  }

  // Get category by ID
  Future<Category?> getCategory(String categoryId) async {
    return await (_database.select(
      _database.categories,
    )..where((c) => c.id.equals(categoryId))).getSingleOrNull();
  }

  // Search categories by name
  Future<List<Category>> searchCategories(String query, String type) async {
    return await (_database.select(
      _database.categories,
    )..where((c) => c.name.contains(query))).get();
  }
}


import 'package:billkeep/database/database.dart';

class CategoryGroupWithCategories {
  final CategoryGroup group;
  final List<Category> categories;

  CategoryGroupWithCategories({required this.group, required this.categories});
}

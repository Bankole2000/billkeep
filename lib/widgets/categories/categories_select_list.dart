import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/category_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesList extends ConsumerWidget {
  final Function(Category)? onCategorySelected;
  final List<CategoryGroupWithCategories> categoryGroups;
  const CategoriesList({
    super.key,
    required this.onCategorySelected,
    required this.categoryGroups,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (categoryGroups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No merchants found',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}

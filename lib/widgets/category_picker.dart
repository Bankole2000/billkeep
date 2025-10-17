import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/category_provider.dart';

class CategoryPicker extends ConsumerStatefulWidget {
  final String type; // 'EXPENSE' or 'INCOME'
  final String? selectedCategoryId;
  final Function(String?) onCategorySelected;

  const CategoryPicker({
    super.key,
    required this.type,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  ConsumerState<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends ConsumerState<CategoryPicker> {
  @override
  Widget build(BuildContext context) {
    final categoriesAsync = widget.type == 'EXPENSE'
        ? ref.watch(expenseCategoriesProvider)
        : ref.watch(incomeCategoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        // Find selected category
        Category? selectedCategory;
        Category? selectedParent;

        if (widget.selectedCategoryId != null) {
          // Check if it's a parent category
          selectedCategory = categories.firstWhere(
            (c) => c.id == widget.selectedCategoryId,
            orElse: () {
              // It might be a subcategory, need to find its parent
              return categories.first;
            },
          );

          // If not found in parents, search in subcategories
          if (selectedCategory.id != widget.selectedCategoryId) {
            for (final parent in categories) {
              final subcategoriesAsync = ref.watch(subcategoriesProvider(parent.id));
              subcategoriesAsync.whenData((subs) {
                final found = subs.firstWhere(
                  (s) => s.id == widget.selectedCategoryId,
                  orElse: () => subs.first,
                );
                if (found.id == widget.selectedCategoryId) {
                  selectedCategory = found;
                  selectedParent = parent;
                }
              });
            }
          }
        }

        return InkWell(
          onTap: () => _showCategoryPickerDialog(context, categories),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (selectedCategory != null) ...[
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: selectedCategory.color != null
                        ? Color(int.parse(
                            selectedCategory.color!.replaceFirst('#', '0xFF')))
                        : Colors.grey,
                    child: Text(
                      selectedCategory.icon ?? '📁',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (selectedParent != null)
                          Text(
                            selectedParent.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        Text(
                          selectedCategory.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const Icon(Icons.category_outlined),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Select Category'),
                  ),
                ],
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  void _showCategoryPickerDialog(
    BuildContext context,
    List<Category> categories,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (widget.selectedCategoryId != null)
                      TextButton(
                        onPressed: () {
                          widget.onCategorySelected(null);
                          Navigator.pop(context);
                        },
                        child: const Text('Clear'),
                      ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryPickerTile(
                      category: category,
                      selectedCategoryId: widget.selectedCategoryId,
                      onCategorySelected: (categoryId) {
                        widget.onCategorySelected(categoryId);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategoryPickerTile extends ConsumerWidget {
  final Category category;
  final String? selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategoryPickerTile({
    super.key,
    required this.category,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subcategoriesAsync = ref.watch(subcategoriesProvider(category.id));

    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: category.color != null
            ? Color(int.parse(category.color!.replaceFirst('#', '0xFF')))
            : Colors.grey,
        child: Text(
          category.icon ?? '📁',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      title: Text(category.name),
      trailing: selectedCategoryId == category.id
          ? const Icon(Icons.check, color: Colors.blue)
          : null,
      onExpansionChanged: (expanded) {
        if (!expanded) {
          // When collapsing, if no subcategory selected, select parent
          final subcategories = subcategoriesAsync.value ?? [];
          final hasSelectedSubcategory = subcategories.any(
            (sub) => sub.id == selectedCategoryId,
          );
          if (!hasSelectedSubcategory) {
            onCategorySelected(category.id);
          }
        }
      },
      children: [
        subcategoriesAsync.when(
          data: (subcategories) {
            if (subcategories.isEmpty) {
              return ListTile(
                onTap: () => onCategorySelected(category.id),
                title: const Text('No subcategories'),
              );
            }

            return Column(
              children: subcategories.map((sub) {
                final isSelected = selectedCategoryId == sub.id;
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 72, right: 16),
                  leading: Text(
                    sub.icon ?? '📄',
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(sub.name),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  selected: isSelected,
                  onTap: () => onCategorySelected(sub.id),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Error: $error'),
        ),
      ],
    );
  }
}

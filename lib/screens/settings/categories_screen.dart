import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/category_provider.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Expense Categories'),
            Tab(text: 'Income Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CategoryListView(type: 'EXPENSE'),
          CategoryListView(type: 'INCOME'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(
          context,
          _tabController.index == 0 ? 'EXPENSE' : 'INCOME',
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(type: type),
    );
  }
}

class CategoryListView extends ConsumerWidget {
  final String type;

  const CategoryListView({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = type == 'EXPENSE'
        ? ref.watch(expenseCategoriesProvider)
        : ref.watch(incomeCategoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  type == 'EXPENSE' ? Icons.money_off : Icons.attach_money,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${type.toLowerCase()} categories yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 8),
                const Text('Tap + to add a category'),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryTile(category: category);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

class CategoryTile extends ConsumerWidget {
  final Category category;

  const CategoryTile({super.key, required this.category});

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
      subtitle: Text(
        category.isDefault ? 'Default Category' : 'Custom Category',
        style: TextStyle(
          color: category.isDefault ? Colors.blue : Colors.grey,
          fontSize: 12,
        ),
      ),
      trailing: !category.isDefault
          ? PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditCategoryDialog(context, category);
                } else if (value == 'delete') {
                  _deleteCategory(context, ref, category);
                }
              },
            )
          : null,
      children: [
        subcategoriesAsync.when(
          data: (subcategories) {
            if (subcategories.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No subcategories'),
              );
            }

            return Column(
              children: subcategories.map((sub) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 72, right: 16),
                  leading: Text(
                    sub.icon ?? '📄',
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(sub.name),
                  trailing: !sub.isDefault
                      ? IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () => _deleteCategory(context, ref, sub),
                        )
                      : null,
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Error: $error'),
        ),
        if (!category.isDefault)
          Padding(
            padding: const EdgeInsets.only(left: 72, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _showAddSubcategoryDialog(context, category),
                icon: const Icon(Icons.add),
                label: const Text('Add Subcategory'),
              ),
            ),
          ),
      ],
    );
  }

  void _showEditCategoryDialog(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => EditCategoryDialog(category: category),
    );
  }

  void _showAddSubcategoryDialog(BuildContext context, Category parentCategory) {
    showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(
        type: parentCategory.type,
        parentCategoryId: parentCategory.id,
      ),
    );
  }

  void _deleteCategory(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref
            .read(categoryRepositoryProvider)
            .deleteCategory(category.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category deleted')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}

class AddCategoryDialog extends ConsumerStatefulWidget {
  final String type;
  final String? parentCategoryId;

  const AddCategoryDialog({
    super.key,
    required this.type,
    this.parentCategoryId,
  });

  @override
  ConsumerState<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedIcon;
  String? _selectedColor;

  final List<String> _availableIcons = [
    '📁', '💰', '🏠', '🚗', '🍔', '🏥', '🎮', '🛍️', '📚', '💻',
    '✈️', '🎬', '🎨', '💼', '🔧', '📱', '⚡', '🎯', '💳', '🎁'
  ];

  final List<String> _availableColors = [
    '#FF6B6B', '#4ECDC4', '#95E1D3', '#F38181', '#AA96DA',
    '#FCBAD3', '#FFFFD2', '#A8E6CF', '#FFD3B6', '#98D8C8',
    '#F6A5C0', '#4CAF50', '#2196F3', '#9C27B0', '#FF9800',
    '#E91E63', '#00BCD4', '#8BC34A', '#607D8B', '#B5B5B5',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.parentCategoryId == null ? 'Add Category' : 'Add Subcategory',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Icon', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableIcons.map((icon) {
                  final isSelected = _selectedIcon == icon;
                  return InkWell(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(icon, style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableColors.map((color) {
                  final isSelected = _selectedColor == color;
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey,
                          width: isSelected ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveCategory,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(categoryRepositoryProvider).createCategory(
              name: _nameController.text,
              type: widget.type,
              icon: _selectedIcon,
              color: _selectedColor,
              parentCategoryId: widget.parentCategoryId,
            );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category created')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}

class EditCategoryDialog extends ConsumerStatefulWidget {
  final Category category;

  const EditCategoryDialog({super.key, required this.category});

  @override
  ConsumerState<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends ConsumerState<EditCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String? _selectedIcon;
  String? _selectedColor;

  final List<String> _availableIcons = [
    '📁', '💰', '🏠', '🚗', '🍔', '🏥', '🎮', '🛍️', '📚', '💻',
    '✈️', '🎬', '🎨', '💼', '🔧', '📱', '⚡', '🎯', '💳', '🎁'
  ];

  final List<String> _availableColors = [
    '#FF6B6B', '#4ECDC4', '#95E1D3', '#F38181', '#AA96DA',
    '#FCBAD3', '#FFFFD2', '#A8E6CF', '#FFD3B6', '#98D8C8',
    '#F6A5C0', '#4CAF50', '#2196F3', '#9C27B0', '#FF9800',
    '#E91E63', '#00BCD4', '#8BC34A', '#607D8B', '#B5B5B5',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _selectedIcon = widget.category.icon;
    _selectedColor = widget.category.color;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Category'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Icon', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableIcons.map((icon) {
                  final isSelected = _selectedIcon == icon;
                  return InkWell(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(icon, style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableColors.map((color) {
                  final isSelected = _selectedColor == color;
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey,
                          width: isSelected ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _updateCategory,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _updateCategory() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(categoryRepositoryProvider).updateCategory(
              categoryId: widget.category.id,
              name: _nameController.text,
              icon: _selectedIcon,
              color: _selectedColor,
            );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category updated')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}

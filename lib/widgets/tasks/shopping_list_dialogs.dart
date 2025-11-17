import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../providers/shopping_list_provider.dart';

/// Show edit shopping list dialog
void showEditShoppingListDialog(
  BuildContext context,
  WidgetRef ref,
  ShoppingList list,
) {
  final nameController = TextEditingController(text: list.name);
  final descriptionController = TextEditingController(text: list.description);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Shopping List'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'List Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (nameController.text.trim().isEmpty) return;

            await ref.read(shoppingListRepositoryProvider).updateShoppingList(
                  shoppingListId: list.id,
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                );

            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Shopping list updated')),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

/// Show delete shopping list confirmation dialog
void showDeleteShoppingListConfirmation(
  BuildContext context,
  WidgetRef ref,
  String listId,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Shopping List?'),
      content: const Text(
        'This will permanently delete the shopping list, all items, and linked expenses/payments.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await ref
                .read(shoppingListRepositoryProvider)
                .deleteShoppingList(listId);
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Shopping list deleted')),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

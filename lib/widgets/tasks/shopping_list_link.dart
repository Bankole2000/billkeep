import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/shopping_list_provider.dart';

/// Widget to show linked shopping list info in a todo card
class ShoppingListLink extends ConsumerWidget {
  final String shoppingListId;

  const ShoppingListLink({super.key, required this.shoppingListId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingListsAsync = ref.watch(projectShoppingListsProvider(''));

    return shoppingListsAsync.when(
      data: (lists) {
        final list = lists.where((l) => l.id == shoppingListId).firstOrNull;
        if (list == null) {
          return const Text(
            'Shopping list not found',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          );
        }

        // Get items count
        final itemsAsync = ref.watch(shoppingListItemsProvider(shoppingListId));

        return itemsAsync.when(
          data: (items) {
            final purchasedCount = items.where((i) => i.isPurchased).length;

            return InkWell(
              onTap: () {
                // TODO: Navigate to shopping list detail
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Open ${list.name}')),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 4),
                  Text(
                    '${list.name} ($purchasedCount/${items.length} items)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

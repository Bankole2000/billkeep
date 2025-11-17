import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/shopping_list_provider.dart';
import '../../screens/shopping/shopping_list_details_screen.dart';
import '../../utils/page_transitions.dart';
import 'shopping_list_dialogs.dart';

/// Shopping lists view for tasks screen
class ShoppingListsView extends ConsumerWidget {
  final String projectId;

  const ShoppingListsView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingListsAsync = ref.watch(
      projectShoppingListsProvider(projectId),
    );

    return shoppingListsAsync.when(
      data: (shoppingLists) {
        if (shoppingLists.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text('No shopping lists yet. Tap + to create one.'),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: shoppingLists.length,
          itemBuilder: (context, index) {
            final list = shoppingLists[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.blue),
                title: Row(
                  children: [
                    Expanded(child: Text(list.name)),
                    if (list.linkedExpenseId != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              size: 14,
                              color: Colors.green,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Tracked',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                subtitle: list.description != null
                    ? Text(list.description!)
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          showEditShoppingListDialog(context, ref, list);
                        } else if (value == 'delete') {
                          showDeleteShoppingListConfirmation(
                            context,
                            ref,
                            list.id,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    AppPageRoute.slideRight(
                      ShoppingListDetailScreen(shoppingList: list),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) =>
          const Center(child: Text('Error loading shopping lists')),
    );
  }
}

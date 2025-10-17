import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../providers/shopping_list_provider.dart';
import '../../utils/currency_helper.dart';

class ShoppingListDetailScreen extends ConsumerWidget {
  final ShoppingList shoppingList;

  const ShoppingListDetailScreen({super.key, required this.shoppingList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(shoppingListItemsProvider(shoppingList.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Summary card
          itemsAsync.when(
            data: (items) {
              final totalEstimated = items.fold<int>(
                0,
                (sum, item) =>
                    sum + ((item.estimatedAmount ?? 0) * item.quantity),
              );
              final totalActual = items.fold<int>(
                0,
                (sum, item) => sum + ((item.actualAmount ?? 0) * item.quantity),
              );
              final purchasedCount = items.where((i) => i.isPurchased).length;

              return Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimated Total:'),
                          Text(
                            CurrencyHelper.formatAmount(totalEstimated),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (totalActual > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Actual Total:'),
                            Text(
                              CurrencyHelper.formatAmount(totalActual),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Items:'),
                          Text('$purchasedCount / ${items.length} purchased'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Items list
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Text('No items yet. Tap + to add items.'),
                  );
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    // In the items ListView.builder, update the item card:
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: item.isPurchased,
                          onChanged: (value) {
                            ref
                                .read(shoppingListRepositoryProvider)
                                .toggleItemPurchased(item.id, value ?? false);
                          },
                        ),
                        title: Text(
                          '${item.name} ${item.quantity > 1 ? "x${item.quantity}" : ""}',
                          style: TextStyle(
                            decoration: item.isPurchased
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: item.estimatedAmount != null
                            ? Text(
                                'Est: ${CurrencyHelper.formatAmount(item.estimatedAmount!)}${item.actualAmount != null ? " | Actual: ${CurrencyHelper.formatAmount(item.actualAmount!)}" : ""}',
                              )
                            : null,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditItemDialog(context, item, ref);
                            } else if (value == 'delete') {
                              _showDeleteItemConfirmation(
                                context,
                                item.id,
                                ref,
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
                                  Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.red,
                                  ),
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
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Error loading items')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context, ref, shoppingList.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, WidgetRef ref, String listId) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final quantityController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Estimated Amount (Optional)',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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

              final amount = amountController.text.trim().isEmpty
                  ? null
                  : CurrencyHelper.dollarsToCents(amountController.text.trim());

              await ref
                  .read(shoppingListRepositoryProvider)
                  .addShoppingListItem(
                    shoppingListId: listId,
                    name: nameController.text.trim(),
                    estimatedAmount: amount,
                    quantity: int.tryParse(quantityController.text) ?? 1,
                  );

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(
    BuildContext context,
    ShoppingListItem item,
    WidgetRef ref,
  ) {
    final nameController = TextEditingController(text: item.name);
    final amountController = TextEditingController(
      text: item.estimatedAmount != null
          ? (item.estimatedAmount! / 100).toStringAsFixed(2)
          : '',
    );
    final quantityController = TextEditingController(
      text: item.quantity.toString(),
    );
    final notesController = TextEditingController(text: item.notes);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Estimated Amount (Optional)',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;

              final amount = amountController.text.trim().isEmpty
                  ? null
                  : CurrencyHelper.dollarsToCents(amountController.text.trim());

              await ref
                  .read(shoppingListRepositoryProvider)
                  .updateShoppingListItem(
                    itemId: item.id,
                    name: nameController.text.trim(),
                    estimatedAmount: amount,
                    quantity: int.tryParse(quantityController.text) ?? 1,
                    notes: notesController.text.trim().isEmpty
                        ? null
                        : notesController.text.trim(),
                  );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Item updated')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteItemConfirmation(
    BuildContext context,
    String itemId,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text(
          'This will permanently delete this item and any linked payment.',
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
                  .deleteShoppingListItem(itemId);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Item deleted')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/providers/todo_provider.dart';
import 'package:billkeep/providers/shopping_list_provider.dart';
import 'package:billkeep/widgets/common/project_speed_dial.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:billkeep/screens/shopping/shopping_list_details_screen.dart';
import '../../utils/currency_helper.dart';

final tasksSegmentProvider = StateProvider<int>((ref) => 0);

class TasksScreen extends ConsumerWidget {
  final Project project;

  const TasksScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSegment = ref.watch(tasksSegmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${project.name} - Tasks'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 0,
                  label: Text('Todos'),
                  icon: Icon(Icons.check_box),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('Shopping Lists'),
                  icon: Icon(Icons.shopping_cart),
                ),
              ],
              selected: {selectedSegment},
              onSelectionChanged: (Set<int> newSelection) {
                ref.read(tasksSegmentProvider.notifier).state =
                    newSelection.first;
              },
            ),
          ),

          Expanded(
            child: selectedSegment == 0
                ? _TodosView(projectId: project.id)
                : _ShoppingListsView(projectId: project.id),
          ),
        ],
      ),
      floatingActionButton: ProjectSpeedDial(projectId: project.id),
    );
  }
}

// Todos view with actual data
class _TodosView extends ConsumerWidget {
  final String projectId;

  const _TodosView({required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(projectTodosProvider(projectId));

    return todosAsync.when(
      data: (todos) {
        if (todos.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_box_outline_blank,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text('No todos yet. Tap + to create one.'),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return _TodoCard(todo: todo);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading todos')),
    );
  }
}

class _TodoCard extends ConsumerStatefulWidget {
  final TodoItem todo;

  const _TodoCard({required this.todo});

  @override
  ConsumerState<_TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends ConsumerState<_TodoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasDirectExpense = widget.todo.directExpenseAmount != null;
    final hasShoppingList = widget.todo.linkedShoppingListId != null;
    final subtasksAsync = ref.watch(todoSubtasksProvider(widget.todo.id));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: widget.todo.isCompleted,
              onChanged: (value) {
                ref
                    .read(todoRepositoryProvider)
                    .toggleTodoComplete(widget.todo.id, value ?? false);
              },
            ),
            title: Text(
              widget.todo.title,
              style: TextStyle(
                decoration: widget.todo.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.todo.description != null) ...[
                  Text(widget.todo.description!),
                  const SizedBox(height: 4),
                ],

                // Show financial attachment info
                if (hasDirectExpense)
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 16,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Direct: ${CurrencyHelper.formatAmount(widget.todo.directExpenseAmount!)} - ${widget.todo.directExpenseType}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),

                if (hasShoppingList)
                  _ShoppingListLink(
                    shoppingListId: widget.todo.linkedShoppingListId!,
                  ),

                // Show subtask count
                subtasksAsync.when(
                  data: (subtasks) {
                    if (subtasks.isEmpty) return const SizedBox.shrink();
                    final completedCount = subtasks
                        .where((s) => s.isCompleted)
                        .length;
                    return Row(
                      children: [
                        Icon(
                          Icons.subdirectory_arrow_right,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$completedCount/${subtasks.length} subtasks',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditTodoDialog(context);
                    } else if (value == 'delete') {
                      _showDeleteTodoConfirmation(context);
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
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
                // Always show add subtask button
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Add Subtask',
                  onPressed: () {
                    _showAddSubtaskDialog(context);
                  },
                ),
                // Show expand/collapse if has subtasks
                subtasksAsync.when(
                  data: (subtasks) {
                    if (subtasks.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      onPressed: () {
                        setState(() => _isExpanded = !_isExpanded);
                      },
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Expandable subtasks
          if (_isExpanded)
            subtasksAsync.when(
              data: (subtasks) {
                return Column(
                  children: [
                    const Divider(height: 1),
                    ...subtasks.map(
                      (subtask) => Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: CheckboxListTile(
                          dense: true,
                          title: Text(
                            subtask.title,
                            style: TextStyle(
                              decoration: subtask.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: subtask.directExpenseAmount != null
                              ? Text(
                                  CurrencyHelper.formatAmount(
                                    subtask.directExpenseAmount!,
                                  ),
                                  style: const TextStyle(fontSize: 12),
                                )
                              : null,
                          value: subtask.isCompleted,
                          onChanged: (value) {
                            ref
                                .read(todoRepositoryProvider)
                                .toggleTodoComplete(subtask.id, value ?? false);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
              error: (_, __) => const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Error loading subtasks'),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddSubtaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    bool hasExpense = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Subtask'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Subtask Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Has expense'),
                  value: hasExpense,
                  onChanged: (value) {
                    setState(() => hasExpense = value ?? false);
                  },
                ),
                if (hasExpense) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ],
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
                if (titleController.text.trim().isEmpty) return;

                await ref
                    .read(todoRepositoryProvider)
                    .createTodo(
                      projectId: widget.todo.projectId,
                      title: titleController.text.trim(),
                      parentTodoId: widget.todo.id,
                      directExpenseAmount:
                          hasExpense && amountController.text.trim().isNotEmpty
                          ? CurrencyHelper.dollarsToCents(
                              amountController.text.trim(),
                            )
                          : null,
                      directExpenseType: hasExpense ? 'ONE_TIME' : null,
                    );

                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTodoDialog(BuildContext context) {
    final titleController = TextEditingController(text: widget.todo.title);
    final descriptionController = TextEditingController(
      text: widget.todo.description,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Todo Title',
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
              if (titleController.text.trim().isEmpty) return;

              await ref
                  .read(todoRepositoryProvider)
                  .updateTodo(
                    todoId: widget.todo.id,
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim().isEmpty
                        ? null
                        : descriptionController.text.trim(),
                  );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Todo updated')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteTodoConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo?'),
        content: const Text(
          'This will permanently delete the todo, its subtasks, and any linked expenses/payments.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(todoRepositoryProvider).deleteTodo(widget.todo.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Todo deleted')));
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

// class _TodoCardState extends ConsumerState<_TodoCard> {
//   bool _isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     final hasDirectExpense = widget.todo.directExpenseAmount != null;
//     final hasShoppingList = widget.todo.linkedShoppingListId != null;
//     final subtasksAsync = ref.watch(todoSubtasksProvider(widget.todo.id));

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       child: Column(
//         children: [
//           CheckboxListTile(
//             title: Text(
//               widget.todo.title,
//               style: TextStyle(
//                 decoration: widget.todo.isCompleted
//                     ? TextDecoration.lineThrough
//                     : null,
//               ),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (widget.todo.description != null) ...[
//                   Text(widget.todo.description!),
//                   const SizedBox(height: 4),
//                 ],

//                 // Show financial attachment info
//                 if (hasDirectExpense)
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.attach_money,
//                         size: 16,
//                         color: Colors.orange[700],
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         'Direct: ${CurrencyHelper.formatAmount(widget.todo.directExpenseAmount!)} - ${widget.todo.directExpenseType}',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.orange[700],
//                         ),
//                       ),
//                     ],
//                   ),

//                 if (hasShoppingList)
//                   _ShoppingListLink(
//                     shoppingListId: widget.todo.linkedShoppingListId!,
//                   ),

//                 // Show subtask count
//                 subtasksAsync.when(
//                   data: (subtasks) {
//                     if (subtasks.isEmpty) return const SizedBox.shrink();
//                     final completedCount = subtasks
//                         .where((s) => s.isCompleted)
//                         .length;
//                     return Row(
//                       children: [
//                         Icon(
//                           Icons.subdirectory_arrow_right,
//                           size: 16,
//                           color: Colors.grey[600],
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           '$completedCount/${subtasks.length} subtasks',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                   loading: () => const SizedBox.shrink(),
//                   error: (_, __) => const SizedBox.shrink(),
//                 ),
//               ],
//             ),
//             value: widget.todo.isCompleted,
//             secondary: subtasksAsync.when(
//               data: (subtasks) {
//                 if (subtasks.isEmpty) return null;
//                 return IconButton(
//                   icon: Icon(
//                     _isExpanded ? Icons.expand_less : Icons.expand_more,
//                   ),
//                   onPressed: () {
//                     setState(() => _isExpanded = !_isExpanded);
//                   },
//                 );
//               },
//               loading: () => null,
//               error: (_, __) => null,
//             ),
//             onChanged: (value) {
//               ref
//                   .read(todoRepositoryProvider)
//                   .toggleTodoComplete(widget.todo.id, value ?? false);
//             },
//           ),

//           // Expandable subtasks
//           if (_isExpanded)
//             subtasksAsync.when(
//               data: (subtasks) {
//                 if (subtasks.isEmpty) {
//                   return Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         _showAddSubtaskDialog(context);
//                       },
//                       icon: const Icon(Icons.add, size: 16),
//                       label: const Text('Add Subtask'),
//                     ),
//                   );
//                 }

//                 return Column(
//                   children: [
//                     const Divider(height: 1),
//                     ...subtasks.map(
//                       (subtask) => Padding(
//                         padding: const EdgeInsets.only(left: 32),
//                         child: CheckboxListTile(
//                           dense: true,
//                           title: Text(
//                             subtask.title,
//                             style: TextStyle(
//                               decoration: subtask.isCompleted
//                                   ? TextDecoration.lineThrough
//                                   : null,
//                             ),
//                           ),
//                           subtitle: subtask.directExpenseAmount != null
//                               ? Text(
//                                   CurrencyHelper.formatAmount(
//                                     subtask.directExpenseAmount!,
//                                   ),
//                                   style: const TextStyle(fontSize: 12),
//                                 )
//                               : null,
//                           value: subtask.isCompleted,
//                           onChanged: (value) {
//                             ref
//                                 .read(todoRepositoryProvider)
//                                 .toggleTodoComplete(subtask.id, value ?? false);
//                           },
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           _showAddSubtaskDialog(context);
//                         },
//                         icon: const Icon(Icons.add, size: 16),
//                         label: const Text('Add Subtask'),
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 8,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//               loading: () => const Padding(
//                 padding: EdgeInsets.all(16),
//                 child: CircularProgressIndicator(),
//               ),
//               error: (_, __) => const Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Text('Error loading subtasks'),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   void _showAddSubtaskDialog(BuildContext context) {
//     final titleController = TextEditingController();
//     final amountController = TextEditingController();
//     bool hasExpense = false;

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Add Subtask'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Subtask Title',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               CheckboxListTile(
//                 contentPadding: EdgeInsets.zero,
//                 title: const Text('Has expense'),
//                 value: hasExpense,
//                 onChanged: (value) {
//                   setState(() => hasExpense = value ?? false);
//                 },
//               ),
//               if (hasExpense)
//                 TextField(
//                   controller: amountController,
//                   decoration: const InputDecoration(
//                     labelText: 'Amount',
//                     border: OutlineInputBorder(),
//                     prefixText: '\$ ',
//                   ),
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: true,
//                   ),
//                 ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (titleController.text.trim().isEmpty) return;

//                 await ref
//                     .read(todoRepositoryProvider)
//                     .createTodo(
//                       projectId: widget.todo.projectId,
//                       title: titleController.text.trim(),
//                       parentTodoId: widget.todo.id,
//                       directExpenseAmount:
//                           hasExpense && amountController.text.trim().isNotEmpty
//                           ? CurrencyHelper.dollarsToCents(
//                               amountController.text.trim(),
//                             )
//                           : null,
//                       directExpenseType: hasExpense ? 'ONE_TIME' : null,
//                     );

//                 if (context.mounted) Navigator.pop(context);
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget to show linked shopping list info
class _ShoppingListLink extends ConsumerWidget {
  final String shoppingListId;

  const _ShoppingListLink({required this.shoppingListId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get shopping list details
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
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Open ${list.name}')));
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

// Shopping Lists view - placeholder for now
// Replace the _ShoppingListsView class with:
class _ShoppingListsView extends ConsumerWidget {
  final String projectId;

  const _ShoppingListsView({required this.projectId});

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
            // In _ShoppingListsView, update the shopping list card:
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
                          color: Colors.green.withOpacity(0.2),
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
                          _showEditShoppingListDialog(context, list, ref);
                        } else if (value == 'delete') {
                          _showDeleteShoppingListConfirmation(
                            context,
                            list.id,
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

  void _showEditShoppingListDialog(
    BuildContext context,
    ShoppingList list,
    WidgetRef ref,
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

              await ref
                  .read(shoppingListRepositoryProvider)
                  .updateShoppingList(
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

  void _showDeleteShoppingListConfirmation(
    BuildContext context,
    String listId,
    WidgetRef ref,
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
}

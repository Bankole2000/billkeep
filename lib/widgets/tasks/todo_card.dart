import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../providers/todo_provider.dart';
import '../../utils/currency_helper.dart';
import 'shopping_list_link.dart';
import 'todo_dialogs.dart';

/// Todo card component with subtasks support
class TodoCard extends ConsumerStatefulWidget {
  final TodoItem todo;

  const TodoCard({super.key, required this.todo});

  @override
  ConsumerState<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends ConsumerState<TodoCard> {
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

                // Direct expense indicator
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

                // Shopping list link
                if (hasShoppingList)
                  ShoppingListLink(
                    shoppingListId: widget.todo.linkedShoppingListId!,
                  ),

                // Subtask count
                subtasksAsync.when(
                  data: (subtasks) {
                    if (subtasks.isEmpty) return const SizedBox.shrink();
                    final completedCount =
                        subtasks.where((s) => s.isCompleted).length;
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
                // Action menu
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      showEditTodoDialog(context, ref, widget.todo);
                    } else if (value == 'delete') {
                      showDeleteTodoConfirmation(context, ref, widget.todo.id);
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

                // Add subtask button
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Add Subtask',
                  onPressed: () {
                    showAddSubtaskDialog(context, ref, widget.todo);
                  },
                ),

                // Expand/collapse button (if has subtasks)
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

          // Expandable subtasks list
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
}

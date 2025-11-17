import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/todo_provider.dart';
import 'todo_card.dart';

/// Todos view for tasks screen
class TodosView extends ConsumerWidget {
  final String projectId;

  const TodosView({super.key, required this.projectId});

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
            return TodoCard(todo: todo);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading todos')),
    );
  }
}

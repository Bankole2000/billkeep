import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/todos/todo_form.dart';

class AddTodoScreen extends ConsumerWidget {
  final String projectId;

  const AddTodoScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: TodoForm(projectId: projectId),
    );
  }
}

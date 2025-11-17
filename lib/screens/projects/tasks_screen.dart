import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../widgets/common/project_speed_dial.dart';
import '../../widgets/tasks/todos_view.dart';
import '../../widgets/tasks/shopping_lists_view.dart';

final tasksSegmentProvider = StateProvider<int>((ref) => 0);

/// Refactored tasks screen with extracted components
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
          // Segmented control
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

          // Content based on segment
          Expanded(
            child: selectedSegment == 0
                ? TodosView(projectId: project.id)
                : ShoppingListsView(projectId: project.id),
          ),
        ],
      ),
      floatingActionButton: ProjectSpeedDial(projectId: project.id),
    );
  }
}

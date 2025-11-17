import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../widgets/projects/planning/budget_view.dart';
import '../../widgets/projects/planning/projections_view.dart';
import '../../widgets/projects/planning/analytics_view.dart';

final planningSegmentProvider = StateProvider<int>((ref) => 0);

class PlanningScreen extends ConsumerWidget {
  final Project project;

  const PlanningScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSegment = ref.watch(planningSegmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${project.name} - Planning'),
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
                  label: Text('Budget'),
                  icon: Icon(Icons.account_balance),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text('Projections'),
                  icon: Icon(Icons.trending_up),
                ),
                ButtonSegment(
                  value: 2,
                  label: Text('Analytics'),
                  icon: Icon(Icons.analytics),
                ),
              ],
              selected: {selectedSegment},
              onSelectionChanged: (Set<int> newSelection) {
                ref.read(planningSegmentProvider.notifier).state =
                    newSelection.first;
              },
            ),
          ),

          // Content based on segment
          Expanded(
            child: [
              BudgetView(project: project),
              ProjectionsView(project: project),
              AnalyticsView(project: project),
            ][selectedSegment],
          ),
        ],
      ),
    );
  }
}

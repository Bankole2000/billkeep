import 'package:billkeep/screens/projects/finances_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/database/database.dart';
import 'package:billkeep/widgets/projects/project_summary_card.dart';
import 'package:billkeep/widgets/projects/project_dashboard_card.dart';
import 'tasks_screen.dart';
import 'package:billkeep/widgets/common/project_speed_dial.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:billkeep/screens/projects/planning_screen.dart';
import 'settings_screen.dart';

class ProjectDetailScreen extends ConsumerWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          // Summary card
          ProjectSummaryCard(project: project),

          // Dashboard cards
          ProjectDashboardCard(
            icon: Icons.account_balance_wallet,
            title: 'Finances',
            subtitle: 'Expenses, Income & Payments',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                AppPageRoute.slideRight(FinancesScreen(project: project)),
              );
            },
          ),

          ProjectDashboardCard(
            icon: Icons.checklist,
            title: 'Tasks',
            subtitle: 'Todos & Shopping Lists',
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                AppPageRoute.slideRight(TasksScreen(project: project)),
              );
            },
          ),

          ProjectDashboardCard(
            icon: Icons.trending_up,
            title: 'Planning',
            subtitle: 'Budget, Projections & Analytics',
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                AppPageRoute.slideRight(PlanningScreen(project: project)),
              );
            },
          ),

          ProjectDashboardCard(
            icon: Icons.settings,
            title: 'Settings',
            subtitle: 'Notifications, SMS & Configuration',
            color: Colors.grey,
            onTap: () {
              Navigator.push(
                context,
                AppPageRoute.slideRight(SettingsScreen(project: project)),
              );
            },
          ),

          const SizedBox(height: 80), // Space for FAB
        ],
      ),
      floatingActionButton: ProjectSpeedDial(projectId: project.id),
    );
  }
}

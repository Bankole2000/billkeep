import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/widgets/common/app_bar_active_project_selector.dart';
import 'package:billkeep/widgets/navigation/reports_side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return Scaffold(
      drawer: ReportsSideDrawer(),
      extendBodyBehindAppBar: true,
      backgroundColor: colors.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: colors.textInverse),
        actionsIconTheme: IconThemeData(color: colors.textInverse),
        backgroundColor: activeColor,
        title: AppBarActiveProjectSelector(pageType: 'Reports'),
      ),
      body: const Center(child: Text('Reports - Coming Soon')),
    );
  }
}

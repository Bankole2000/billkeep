import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/widgets/common/tabbar_icon_label.dart';
import 'package:billkeep/widgets/home/add_task_subscreen.dart';
import 'package:billkeep/widgets/home/add_transaction_subscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFinancesScreen extends ConsumerWidget {
  const AddFinancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          backgroundColor: colors.surface,
          iconTheme: IconThemeData(color: colors.text),
          actionsIconTheme: IconThemeData(color: colors.text),
          title: Text('Add New', style: TextStyle(color: colors.text)),
          centerTitle: true,
          bottom: TabBar(
            unselectedLabelColor: colors.textMute,
            labelColor: colors.text,
            indicatorColor: colors.text,
            tabs: [
              TabbarIconLabel(icon: Icons.money, label: 'Transaction'),
              TabbarIconLabel(icon: Icons.check_box, label: 'Task'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [AddTransactionSubscreen(), AddTaskSubscreen()],
        ),
      ),
    );
  }
}

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
        appBar: AppBar(
          backgroundColor: activeColor,
          iconTheme: IconThemeData(color: colors.textInverse),
          actionsIconTheme: IconThemeData(color: colors.textInverse),
          title: Text('Add New', style: TextStyle(color: colors.textInverse)),
          centerTitle: true,
          bottom: TabBar(
            unselectedLabelColor: colors.textMuteInverse,
            labelColor: colors.textInverse,
            indicatorColor: colors.textInverse,
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

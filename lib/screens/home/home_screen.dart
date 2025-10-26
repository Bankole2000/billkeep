import 'package:billkeep/providers/ui_providers.dart';
import 'package:billkeep/widgets/common/app_bar_active_project_selector.dart';
import 'package:billkeep/widgets/common/tabbar_icon_label.dart';
import 'package:billkeep/widgets/navigation/side_drawer_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const SideNavigationDrawer(),
        backgroundColor: colors.background,
        extendBodyBehindAppBar: true,

        appBar: AppBar(
          backgroundColor: colors.surface,
          iconTheme: IconThemeData(color: colors.text),
          actionsIconTheme: IconThemeData(color: colors.text),
          title: AppBarActiveProjectSelector(),
          bottom: TabBar(
            unselectedLabelColor: colors.textMute,
            labelColor: colors.text,
            indicatorColor: colors.text,

            tabs: const [
              TabbarIconLabel(icon: Icons.remove_red_eye, label: 'Overview'),
              TabbarIconLabel(
                icon: Icons.account_balance_wallet,
                label: 'Finances',
              ),
              TabbarIconLabel(icon: Icons.checklist, label: 'Tasks'),
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            Center(child: Text('Overview - Coming Soon')),
            Center(child: Text('Finances - Coming Soon')),
            Center(child: Text('Tasks - Coming Soon')),
          ],
        ),
      ),
    );
  }
}

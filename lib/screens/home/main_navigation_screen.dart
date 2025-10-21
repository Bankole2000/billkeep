import 'package:billkeep/screens/budget/add_budget_screen.dart';
import 'package:billkeep/screens/budget/budget_screen.dart';
import 'package:billkeep/screens/reports/add_reports_screen.dart';
import 'package:billkeep/screens/reports/reports_screen.dart';
import 'package:billkeep/screens/home/add_finances_screen.dart';
import 'package:billkeep/screens/settings/add_settings_screen.dart';
import 'package:billkeep/screens/settings/settings_screen.dart';
import 'package:billkeep/utils/page_transitions.dart';
import 'package:billkeep/widgets/navigation/bottom_app_bar_navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:billkeep/providers/ui_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billkeep/screens/home/home_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(bottomAppBarNavigationIndexProvider);
    final colors = ref.watch(appColorsProvider);
    final activeColor = ref.watch(activeThemeColorProvider);

    final screens = [
      const HomeScreen(),
      const BudgetScreen(), // Placeholder
      const ReportsScreen(), // Placeholder
      const SettingsScreen(), // Placeholder
    ];

    final addScreens = [
      const AddFinancesScreen(),
      const AddBudgetScreen(),
      const AddReportsScreen(),
      const AddSettingsScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          // You can experiment with different transitions
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0.0), // slide in from right
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: screens[selectedIndex],
      ),
      backgroundColor: colors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: activeColor,
        onPressed: () {
          // Example: open "Add Expense" modal
          Navigator.push(
            context,
            AppPageRoute.containerTransform(addScreens[selectedIndex]),
          );
        },
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: colors.textInverse),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: colors.surface,
        notchMargin: 6,
        child: SizedBox(
          height: 20,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left side (2 items)
              BottomAppBarNavigationItem(
                icon: selectedIndex == 0
                    ? Icons.dashboard
                    : Icons.dashboard_outlined,
                label: 'Overview',
                index: 0,
                isSelected: selectedIndex == 0,
                activeColor: colors.navy,
              ),
              BottomAppBarNavigationItem(
                icon: selectedIndex == 1 ? Icons.work : Icons.work_outline,
                label: 'Budget',
                index: 1,
                isSelected: selectedIndex == 1,
                activeColor: colors.electric,
              ),

              // Space for FAB
              const SizedBox(width: 60),

              // Right side (2 items)
              BottomAppBarNavigationItem(
                icon: selectedIndex == 2
                    ? Icons.insert_chart_outlined
                    : Icons.insert_chart_outlined_outlined,
                label: 'Reports',
                index: 2,
                isSelected: selectedIndex == 2,
                activeColor: colors.earth,
              ),
              BottomAppBarNavigationItem(
                icon: selectedIndex == 3
                    ? Icons.settings
                    : Icons.settings_outlined,
                label: 'Settings',
                index: 3,
                isSelected: selectedIndex == 3,
                activeColor: colors.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

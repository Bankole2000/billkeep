import 'package:billkeep/screens/budget/budget_screen.dart';
import 'package:billkeep/screens/dashboard/dashboard_screen.dart';
import 'package:billkeep/screens/settings/settings_screen.dart';
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
      const DashboardScreen(), // Placeholder
      const BudgetScreen(), // Placeholder
      const SettingsScreen(), // Placeholder
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
      // backgroundColor: const Color.fromARGB(255, 0, 82, 150),
      floatingActionButton: FloatingActionButton(
        backgroundColor: activeColor,
        onPressed: () {
          // Example: open "Add Expense" modal
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Add new expense')));
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: const Color(0xFF161618),
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
                activeColor: colors.electric,
              ),
              BottomAppBarNavigationItem(
                icon: selectedIndex == 1 ? Icons.work : Icons.work_outline,
                label: 'Budget',
                index: 1,
                isSelected: selectedIndex == 1,
                activeColor: colors.earth,
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
                activeColor: colors.water,
              ),
              BottomAppBarNavigationItem(
                icon: selectedIndex == 3
                    ? Icons.settings
                    : Icons.settings_outlined,
                label: 'Settings',
                index: 3,
                isSelected: selectedIndex == 3,
                activeColor: colors.textInverse,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

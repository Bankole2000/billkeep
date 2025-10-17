import 'package:billkeep/screens/shopping/shopping_list_screen.dart';
import 'package:billkeep/screens/todos/add_todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:billkeep/screens/expenses/add_expense_screen.dart';
import 'package:billkeep/screens/income/add_income_screen.dart';
import 'package:billkeep/utils/page_transitions.dart';

class ProjectSpeedDial extends StatelessWidget {
  final String projectId;

  const ProjectSpeedDial({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.money_off),
          label: 'Add Expense',
          onTap: () {
            Navigator.push(
              context,
              AppPageRoute.slideRight(AddExpenseScreen(projectId: projectId)),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.attach_money),
          label: 'Add Income',
          onTap: () {
            Navigator.push(
              context,
              AppPageRoute.slideRight(AddIncomeScreen(projectId: projectId)),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.check_box),
          label: 'Add Todo',
          onTap: () {
            Navigator.push(
              context,
              AppPageRoute.slideRight(AddTodoScreen(projectId: projectId)),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.shopping_cart),
          label: 'Add Shopping List',
          onTap: () {
            Navigator.push(
              context,
              AppPageRoute.slideRight(
                AddShoppingListScreen(projectId: projectId),
              ),
            );
          },
        ),
      ],
    );
  }
}

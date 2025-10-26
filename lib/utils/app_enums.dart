import 'package:flutter/material.dart';

enum TransactionType { expense, income, transfer }

enum TaskType { todo, shopping, meeting }

const transactionIcons = {
  TransactionType.expense: Icons.output_outlined,
  TransactionType.income: Icons.input,
  TransactionType.transfer: Icons.swap_horiz,
};

const taskIcons = {
  TaskType.meeting: Icons.groups,
  TaskType.shopping: Icons.shopping_cart_outlined,
  TaskType.todo: Icons.library_add_check_outlined,
};

enum IconSelectionType { icon, emoji, image }

const iconSelectionTypeIcons = {
  IconSelectionType.emoji: Icons.insert_emoticon_sharp,
  IconSelectionType.icon: Icons.insert_emoticon_rounded,
  IconSelectionType.image: Icons.photo,
};

enum TransactionRecurrence {
  never,
  everyDay,
  everyWorkDay,
  everyWeek,
  everySecondWeek,
  everyThirdWeek,
  everyMonth,
  everySecondMonth,
  everyThirdMonth,
  firstDayOfTheMonth,
  lastDayOfTheMonth,
  everySixMonths,
  everyYear,
}

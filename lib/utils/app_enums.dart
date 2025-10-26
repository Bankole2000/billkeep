import 'package:flutter/material.dart';

enum TransactionType { expense, income, transfer }

const transactionIcons = {
  TransactionType.expense: Icons.output_outlined,
  TransactionType.income: Icons.input,
  TransactionType.transfer: Icons.swap_horiz,
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

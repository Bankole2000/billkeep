// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum TransactionType { expense, income, transfer }

enum TransactionSource { MANUAL, SMS, TODO, SHOPPING, SDK }

TransactionSource stringToTransactionSource(String source) {
  switch (source) {
    case 'MANUAL':
      return TransactionSource.MANUAL;
    case 'SMS':
      return TransactionSource.SMS;
    case 'TODO':
      return TransactionSource.TODO;
    case 'SHOPPING':
      return TransactionSource.SHOPPING;
    case 'SDK':
      return TransactionSource.SDK;
    default:
      return TransactionSource.MANUAL;
  }
}

enum TaskType { todo, shopping, meeting }

enum ViewModeOptions { grid, list }

enum DynamicFieldType { string, number, boolean, dateTime, url, email, user, object } 

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

IconSelectionType stringToIconSelectionType(String key) {
  switch (key) {
    case 'icon':
      return IconSelectionType.icon;
    case 'emoji':
      return IconSelectionType.emoji;
    case 'image':
      return IconSelectionType.image;
    default:
      return IconSelectionType.icon;
  }
}

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

TransactionRecurrence stringToTransactionRecurrence(String recurrence) {
  switch (recurrence) {
    case 'never':
      return TransactionRecurrence.never;
    case 'everyDay':
      return TransactionRecurrence.everyDay;
    case 'everyWorkDay':
      return TransactionRecurrence.everyWorkDay;
    case 'everyWeek':
      return TransactionRecurrence.everyWeek;
    case 'everySecondWeek':
      return TransactionRecurrence.everySecondWeek;
    case 'everyThirdWeek':
      return TransactionRecurrence.everyThirdWeek;
    case 'everyMonth':
      return TransactionRecurrence.everyMonth;
    case 'everySecondMonth':
      return TransactionRecurrence.everySecondMonth;
    case 'everyThirdMonth':
      return TransactionRecurrence.everyThirdMonth;
    case 'firstDayOfTheMonth':
      return TransactionRecurrence.firstDayOfTheMonth;
    case 'lastDayOfTheMonth':
      return TransactionRecurrence.lastDayOfTheMonth;
    case 'everySixMonths':
      return TransactionRecurrence.everySixMonths;
    case 'everyYear':
      return TransactionRecurrence.everyYear;
    default:
      return TransactionRecurrence.never;
  }
}

const recurrenceOptions = {
  TransactionRecurrence.never: 'Never',
  TransactionRecurrence.everyDay: 'Every Day',
  TransactionRecurrence.everyWorkDay: 'Every Work Day',
  TransactionRecurrence.everyWeek: 'Every Week',
  TransactionRecurrence.everySecondWeek: 'Every Second Week',
  TransactionRecurrence.everyThirdWeek: 'Every Third Week',
  TransactionRecurrence.everyMonth: 'Every Month',
  TransactionRecurrence.everySecondMonth: 'Every Second Month',
  TransactionRecurrence.everyThirdMonth: 'Every Third Month',
  TransactionRecurrence.firstDayOfTheMonth: 'First Day of the Month',
  TransactionRecurrence.lastDayOfTheMonth: 'Last Day of the Month',
  TransactionRecurrence.everySixMonths: 'Every Six Months',
  TransactionRecurrence.everyYear: 'Every Year',
};

const recurrenceIcons = {
  TransactionRecurrence.never: Icons.cancel,
  TransactionRecurrence.everyDay: Icons.access_time_sharp,
  TransactionRecurrence.everyWorkDay: Icons.next_week_outlined,
  TransactionRecurrence.everyWeek: Icons.date_range,
  TransactionRecurrence.everySecondWeek: Icons.timelapse,
  TransactionRecurrence.everyThirdWeek: Icons.twenty_one_mp,
  TransactionRecurrence.everyMonth: Icons.calendar_month,
  TransactionRecurrence.everySecondMonth: Icons.sixty_fps_outlined,
  TransactionRecurrence.everyThirdMonth: Icons.calendar_month_sharp,
  TransactionRecurrence.firstDayOfTheMonth: Icons.edit_calendar,
  TransactionRecurrence.lastDayOfTheMonth: Icons.edit_calendar,
  TransactionRecurrence.everySixMonths: Icons.calendar_month,
  TransactionRecurrence.everyYear: Icons.cake,
};

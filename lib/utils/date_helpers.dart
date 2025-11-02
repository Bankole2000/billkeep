import 'package:billkeep/utils/app_enums.dart';
import 'package:intl/intl.dart';

final dateFormatter = DateFormat.yMMMEd();

extension TransactionRecurrenceExtension on TransactionRecurrence {
  /// Calculate the next due date based on a given date
  DateTime calculateNextDueDate(DateTime fromDate) {
    switch (this) {
      case TransactionRecurrence.never:
        return fromDate; // No recurrence, return same date

      case TransactionRecurrence.everyDay:
        return DateTime(fromDate.year, fromDate.month, fromDate.day + 1);

      case TransactionRecurrence.everyWorkDay:
        DateTime nextDate = DateTime(
          fromDate.year,
          fromDate.month,
          fromDate.day + 1,
        );
        // Skip weekends (Saturday = 6, Sunday = 7)
        while (nextDate.weekday == DateTime.saturday ||
            nextDate.weekday == DateTime.sunday) {
          nextDate = nextDate.add(Duration(days: 1));
        }
        return nextDate;

      case TransactionRecurrence.everyWeek:
        return DateTime(fromDate.year, fromDate.month, fromDate.day + 7);

      case TransactionRecurrence.everySecondWeek:
        return DateTime(fromDate.year, fromDate.month, fromDate.day + 14);

      case TransactionRecurrence.everyThirdWeek:
        return DateTime(fromDate.year, fromDate.month, fromDate.day + 21);

      case TransactionRecurrence.everyMonth:
        int nextMonth = fromDate.month + 1;
        int nextYear = fromDate.year;

        if (nextMonth > 12) {
          nextMonth = 1;
          nextYear++;
        }

        // Handle day overflow (e.g., Jan 31 -> Feb 28/29)
        int nextDay = fromDate.day;
        int daysInNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        if (nextDay > daysInNextMonth) {
          nextDay = daysInNextMonth;
        }

        return DateTime(nextYear, nextMonth, nextDay);

      case TransactionRecurrence.everySecondMonth:
        int nextMonth = fromDate.month + 2;
        int nextYear = fromDate.year;

        while (nextMonth > 12) {
          nextMonth -= 12;
          nextYear++;
        }

        int nextDay = fromDate.day;
        int daysInNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        if (nextDay > daysInNextMonth) {
          nextDay = daysInNextMonth;
        }

        return DateTime(nextYear, nextMonth, nextDay);

      case TransactionRecurrence.everyThirdMonth:
        int nextMonth = fromDate.month + 3;
        int nextYear = fromDate.year;

        while (nextMonth > 12) {
          nextMonth -= 12;
          nextYear++;
        }

        int nextDay = fromDate.day;
        int daysInNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        if (nextDay > daysInNextMonth) {
          nextDay = daysInNextMonth;
        }

        return DateTime(nextYear, nextMonth, nextDay);

      case TransactionRecurrence.firstDayOfTheMonth:
        int nextMonth = fromDate.month + 1;
        int nextYear = fromDate.year;

        if (nextMonth > 12) {
          nextMonth = 1;
          nextYear++;
        }

        return DateTime(nextYear, nextMonth, 1);

      case TransactionRecurrence.lastDayOfTheMonth:
        int nextMonth = fromDate.month + 1;
        int nextYear = fromDate.year;

        if (nextMonth > 12) {
          nextMonth = 1;
          nextYear++;
        }

        // Get last day of next month
        int lastDay = DateTime(nextYear, nextMonth + 1, 0).day;

        return DateTime(nextYear, nextMonth, lastDay);

      case TransactionRecurrence.everySixMonths:
        int nextMonth = fromDate.month + 6;
        int nextYear = fromDate.year;

        while (nextMonth > 12) {
          nextMonth -= 12;
          nextYear++;
        }

        int nextDay = fromDate.day;
        int daysInNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        if (nextDay > daysInNextMonth) {
          nextDay = daysInNextMonth;
        }

        return DateTime(nextYear, nextMonth, nextDay);

      case TransactionRecurrence.everyYear:
        int nextYear = fromDate.year + 1;
        int nextDay = fromDate.day;

        // Handle Feb 29 on leap years
        if (fromDate.month == 2 && fromDate.day == 29) {
          // Check if next year is leap year
          bool isLeapYear =
              (nextYear % 4 == 0 && nextYear % 100 != 0) ||
              (nextYear % 400 == 0);
          if (!isLeapYear) {
            nextDay = 28; // Use Feb 28 if not leap year
          }
        }

        return DateTime(nextYear, fromDate.month, nextDay);
    }
  }

  /// Calculate multiple future due dates
  List<DateTime> calculateFutureDueDates(DateTime startDate, int count) {
    List<DateTime> dates = [];
    DateTime currentDate = startDate;

    for (int i = 0; i < count; i++) {
      currentDate = calculateNextDueDate(currentDate);
      dates.add(currentDate);
    }

    return dates;
  }

  /// Calculate all due dates between two dates
  List<DateTime> calculateDueDatesBetween(
    DateTime startDate,
    DateTime endDate,
  ) {
    List<DateTime> dates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      currentDate = calculateNextDueDate(currentDate);
      if (currentDate.isBefore(endDate) ||
          currentDate.isAtSameMomentAs(endDate)) {
        dates.add(currentDate);
      }
    }

    return dates;
  }
}

// Usage examples:
// void main() {
//   final today = DateTime.now();
  
//   // Every day
//   print('Every Day: ${TransactionRecurrence.everyDay.calculateNextDueDate(today)}');
  
//   // Every work day
//   print('Every Work Day: ${TransactionRecurrence.everyWorkDay.calculateNextDueDate(today)}');
  
//   // Every month
//   print('Every Month: ${TransactionRecurrence.everyMonth.calculateNextDueDate(today)}');
  
//   // First day of month
//   print('First Day: ${TransactionRecurrence.firstDayOfTheMonth.calculateNextDueDate(today)}');
  
//   // Last day of month
//   print('Last Day: ${TransactionRecurrence.lastDayOfTheMonth.calculateNextDueDate(today)}');
  
//   // Test edge case: Jan 31 + 1 month
//   final jan31 = DateTime(2025, 1, 31);
//   print('Jan 31 + 1 month: ${TransactionRecurrence.everyMonth.calculateNextDueDate(jan31)}');
//   // Output: Feb 28 or 29 (depending on leap year)
// }

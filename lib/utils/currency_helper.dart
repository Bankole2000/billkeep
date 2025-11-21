import 'dart:math';

class CurrencyHelper {
  // Convert dollars to cents (for storage)
  static int dollarsToCents(String dollars, [int decimalPlaces = 2]) {
    final value = double.tryParse(dollars) ?? 0;
    return (value * pow(10, decimalPlaces)).round();
  }

  // Convert cents to dollars (for display)
  static String centsToDollars(int cents) {
    return (cents / 100).toStringAsFixed(2);
  }

  // Format for display with currency symbol
  static String formatAmount(int cents, {String symbol = '\$'}) {
    return '$symbol${centsToDollars(cents)}';
  }

  // Parse user input and convert to cents
  static int parseInput(String input, [int decimalPlaces = 2]) {
    // Remove any currency symbols or commas
    final cleaned = input.replaceAll(RegExp(r'[^\d.]'), '');
    return dollarsToCents(cleaned, decimalPlaces);
  }
}

import 'dart:math';

class IdGenerator {
  static final _random = Random();

  // Generate temporary client-side ID
  static String generateTempId(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart = _random.nextInt(999999).toString().padLeft(6, '0');
    return '$prefix-temp-${timestamp}_$randomPart';
  }

  // Check if ID is temporary
  static bool isTemporaryId(String id) {
    return id.contains('-temp-');
  }

  // Convenience methods for temporary IDs
  static String tempProject() => generateTempId('proj');
  static String tempExpense() => generateTempId('exp');
  static String tempIncome() => generateTempId('inc');
  static String tempTodo() => generateTempId('todo');
  static String tempShoppingList() => generateTempId('shop');
  static String tempPayment() => generateTempId('pay');
  static String tempSmsMessage() => generateTempId('sms');
  static String tempMessageRule() => generateTempId('rule');
}

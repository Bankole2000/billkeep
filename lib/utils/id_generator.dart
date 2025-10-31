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
  static String tempProjectMeta() => generateTempId('projmeta');
  static String tempExpense() => generateTempId('exp');
  static String tempPayment() => generateTempId('pay');
  static String tempIncome() => generateTempId('inc');
  static String tempTodo() => generateTempId('todo');
  static String tempShoppingList() => generateTempId('shop');
  static String tempShoppingListItem() => generateTempId('shopitem');
  static String tempMessageRule() => generateTempId('rule');
  static String tempSmsMessage() => generateTempId('sms');
  static String tempIdMapping() => generateTempId('idmap');
  static String tempCategory() => generateTempId('cat');
  static String tempCategoryGroup() => generateTempId('catgroup');
  static String tempMerchant() => generateTempId('merch');
  static String tempMerchantMeta() => generateTempId('merchmeta');
  static String tempTag() => generateTempId('tag');
  static String tempContact() => generateTempId('cont');
  static String tempContactInfo() => generateTempId('continfo');
  static String tempWallet() => generateTempId('wall');
  static String tempWalletProvider() => generateTempId('prov');
  static String tempWalletMeta() => generateTempId('wallmeta');
  static String tempWalletProviderMeta() => generateTempId('provmeta');
  static String tempBudget() => generateTempId('budg');
  static String tempCurrency() => generateTempId('curr');
  static String tempGoal() => generateTempId('goal');
  static String tempGoalMeta() => generateTempId('goalmeta');
  static String tempGoalContribution() => generateTempId('goalcont');
  static String tempInvestment() => generateTempId('inv');
  static String tempInvestmentType() => generateTempId('invtype');
  static String tempInvestmentMeta() => generateTempId('invmeta');
  static String tempInvestmentPayment() => generateTempId('invpay');
  static String tempInvestmentReturn() => generateTempId('invret');
  static String tempReminder() => generateTempId('rem');
}

import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'category_model.dart';
import 'contact_model.dart';
import 'expense_model.dart';
import 'income_model.dart';
import 'merchant_model.dart';
import 'user_model.dart';
import 'wallet_model.dart';

class PaymentModel {
  final String? id;
  final String? paymentType;
  final String? wallet;
  final WalletModel? walletData;
  final String? expense;
  final ExpenseModel? expenseData;
  final String? income;
  final IncomeModel? incomeData;
  final int? actualAmount;
  final String? currency;
  final DateTime? paymentDate;
  final String? source;
  final bool? verified;
  final bool? isSynced;
  final String? tempId;
  final String? user;
  final UserModel? userData;
  final Map<String, dynamic>? metadata;
  final String? category;
  final CategoryModel? categoryData;
  final String? merchant;
  final MerchantModel? merchantData;
  final String? contact;
  final ContactModel? contactData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentModel({
    this.id,
    this.paymentType,
    this.wallet,
    this.walletData,
    this.expense,
    this.expenseData,
    this.income,
    this.incomeData,
    this.actualAmount,
    this.currency,
    this.paymentDate,
    this.source,
    this.verified,
    this.isSynced,
    this.tempId,
    this.user,
    this.userData,
    this.metadata,
    this.category,
    this.categoryData,
    this.merchant,
    this.merchantData,
    this.contact,
    this.contactData,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String?,
      paymentType: json['paymentType'] as String?,
      wallet: json['wallet'] as String?,
      walletData: json['expand']?['wallet'] != null
          ? WalletModel.fromJson(json['expand']['wallet'] as Map<String, dynamic>)
          : null,
      expense: json['expense'] as String?,
      expenseData: json['expand']?['expense'] != null
          ? ExpenseModel.fromJson(json['expand']['expense'] as Map<String, dynamic>)
          : null,
      income: json['income'] as String?,
      incomeData: json['expand']?['income'] != null
          ? IncomeModel.fromJson(json['expand']['income'] as Map<String, dynamic>)
          : null,
      actualAmount: json['actualAmount'] as int?,
      currency: json['currency'] as String?,
      paymentDate: json['paymentDate'] != null
          ? DateTime.parse(json['paymentDate'] as String)
          : null,
      source: json['source'] as String?,
      verified: json['verified'] as bool?,
      isSynced: json['isSynced'] as bool?,
      tempId: json['tempId'] as String?,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      category: json['category'] as String?,
      categoryData: json['expand']?['category'] != null
          ? CategoryModel.fromJson(json['expand']['category'] as Map<String, dynamic>)
          : null,
      merchant: json['merchant'] as String?,
      merchantData: json['expand']?['merchant'] != null
          ? MerchantModel.fromJson(json['expand']['merchant'] as Map<String, dynamic>)
          : null,
      contact: json['contact'] as String?,
      contactData: json['expand']?['contact'] != null
          ? ContactModel.fromJson(json['expand']['contact'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentType': paymentType,
      'wallet': wallet,
      'expense': expense,
      'income': income,
      'actualAmount': actualAmount,
      'currency': currency,
      'paymentDate': paymentDate?.toIso8601String(),
      'source': source,
      'verified': verified,
      'isSynced': isSynced,
      'tempId': tempId,
      'user': user,
      'metadata': metadata,
      'category': category,
      'merchant': merchant,
      'contact': contact,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  PaymentsCompanion toCompanion({
    String? id,
    String? paymentType,
    String? wallet,
    WalletModel? walletData,
    String? expense,
    ExpenseModel? expenseData,
    String? income,
    IncomeModel? incomeData,
    int? actualAmount,
    String? currency,
    DateTime? paymentDate,
    String? source,
    bool? verified,
    bool? isSynced,
    String? tempId,
    String? user,
    UserModel? userData,
    String? category,
    CategoryModel? categoryData,
    String? merchant,
    MerchantModel? merchantData,
    String? contact,
    ContactModel? contactData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentsCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      paymentType: paymentType != null ? Value(paymentType) : (this.paymentType != null ? Value(this.paymentType!) : const Value.absent()),
      walletId: wallet != null ? Value(wallet) : (this.wallet != null ? Value(this.wallet!) : const Value.absent()),
      // walletData: walletData != null ? Value(walletData) : (this.walletData != null ? Value(this.walletData!) : const Value.absent()),
      expenseId: expense != null ? Value(expense) : (this.expense != null ? Value(this.expense!) : const Value.absent()),
      // expenseData: expenseData != null ? Value(expenseData) : (this.expenseData != null ? Value(this.expenseData!) : const Value.absent()),
      incomeId: income != null ? Value(income) : (this.income != null ? Value(this.income!) : const Value.absent()),
      // incomeData: incomeData != null ? Value(incomeData) : (this.incomeData != null ? Value(this.incomeData!) : const Value.absent()),
      actualAmount: actualAmount != null ? Value(actualAmount) : (this.actualAmount != null ? Value(this.actualAmount!) : const Value.absent()),
      currency: currency != null ? Value(currency) : (this.currency != null ? Value(this.currency!) : const Value.absent()),
      paymentDate: paymentDate != null ? Value(paymentDate) : (this.paymentDate != null ? Value(this.paymentDate!) : const Value.absent()),
      source: source != null ? Value(source) : (this.source != null ? Value(this.source!) : const Value.absent()),
      verified: verified != null ? Value(verified) : (this.verified != null ? Value(this.verified!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      categoryId: category != null ? Value(category) : (this.category != null ? Value(this.category!) : const Value.absent()),
      // categoryData: categoryData != null ? Value(categoryData) : (this.categoryData != null ? Value(this.categoryData!) : const Value.absent()),
      merchantId: merchant != null ? Value(merchant) : (this.merchant != null ? Value(this.merchant!) : const Value.absent()),
      // merchantData: merchantData != null ? Value(merchantData) : (this.merchantData != null ? Value(this.merchantData!) : const Value.absent()),
      contactId: contact != null ? Value(contact) : (this.contact != null ? Value(this.contact!) : const Value.absent()),
      // contactData: contactData != null ? Value(contactData) : (this.contactData != null ? Value(this.contactData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

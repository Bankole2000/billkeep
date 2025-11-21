import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'contact_model.dart';
import 'currency_model.dart';
import 'merchant_model.dart';
import 'user_model.dart';

class InvestmentModel {
  final String? id;
  final String? name;
  final String? tempId;
  final DateTime? investmentDate;
  final DateTime? maturityDate;
  final DateTime? closedDate;
  final String? currency;
  final CurrencyModel? currencyData;
  final String? user;
  final UserModel? userData;
  final int? investedAmount;
  final int? currentValue;
  final int? interestRate;
  final int? fixedReturnAmount;
  final String? returnFrequency;
  final String? contact;
  final ContactModel? contactData;
  final String? merchant;
  final MerchantModel? merchantData;
  final bool? isSynced;
  final String? returnCalculationType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InvestmentModel({
    this.id,
    this.name,
    this.tempId,
    this.investmentDate,
    this.maturityDate,
    this.closedDate,
    this.currency,
    this.currencyData,
    this.user,
    this.userData,
    this.investedAmount,
    this.currentValue,
    this.interestRate,
    this.fixedReturnAmount,
    this.returnFrequency,
    this.contact,
    this.contactData,
    this.merchant,
    this.merchantData,
    this.isSynced,
    this.returnCalculationType,
    this.createdAt,
    this.updatedAt,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      tempId: json['tempId'] as String?,
      investmentDate: json['investmentDate'] != null
          ? DateTime.parse(json['investmentDate'] as String)
          : null,
      maturityDate: json['maturityDate'] != null
          ? DateTime.parse(json['maturityDate'] as String)
          : null,
      closedDate: json['closedDate'] != null
          ? DateTime.parse(json['closedDate'] as String)
          : null,
      currency: json['currency'] as String?,
      currencyData: json['expand']?['currency'] != null
          ? CurrencyModel.fromJson(json['expand']['currency'] as Map<String, dynamic>)
          : null,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      investedAmount: json['investedAmount'] as int?,
      currentValue: json['currentValue'] as int?,
      interestRate: json['interestRate'] as int?,
      fixedReturnAmount: json['fixedReturnAmount'] as int?,
      returnFrequency: json['returnFrequency'] as String?,
      contact: json['contact'] as String?,
      contactData: json['expand']?['contact'] != null
          ? ContactModel.fromJson(json['expand']['contact'] as Map<String, dynamic>)
          : null,
      merchant: json['merchant'] as String?,
      merchantData: json['expand']?['merchant'] != null
          ? MerchantModel.fromJson(json['expand']['merchant'] as Map<String, dynamic>)
          : null,
      isSynced: json['isSynced'] as bool?,
      returnCalculationType: json['returnCalculationType'] as String?,
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
      'name': name,
      'tempId': tempId,
      'investmentDate': investmentDate?.toIso8601String(),
      'maturityDate': maturityDate?.toIso8601String(),
      'closedDate': closedDate?.toIso8601String(),
      'currency': currency,
      'user': user,
      'investedAmount': investedAmount,
      'currentValue': currentValue,
      'interestRate': interestRate,
      'fixedReturnAmount': fixedReturnAmount,
      'returnFrequency': returnFrequency,
      'contact': contact,
      'merchant': merchant,
      'isSynced': isSynced,
      'returnCalculationType': returnCalculationType,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  InvestmentsCompanion toCompanion({
    String? id,
    String? name,
    String? tempId,
    DateTime? investmentDate,
    DateTime? maturityDate,
    DateTime? closedDate,
    String? currency,
    CurrencyModel? currencyData,
    String? user,
    UserModel? userData,
    int? investedAmount,
    int? currentValue,
    int? interestRate,
    int? fixedReturnAmount,
    String? returnFrequency,
    String? contact,
    ContactModel? contactData,
    String? merchant,
    MerchantModel? merchantData,
    bool? isSynced,
    String? returnCalculationType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InvestmentsCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      investmentDate: investmentDate != null ? Value(investmentDate) : (this.investmentDate != null ? Value(this.investmentDate!) : const Value.absent()),
      maturityDate: maturityDate != null ? Value(maturityDate) : (this.maturityDate != null ? Value(this.maturityDate!) : const Value.absent()),
      closedDate: closedDate != null ? Value(closedDate) : (this.closedDate != null ? Value(this.closedDate!) : const Value.absent()),
      currency: currency != null ? Value(currency) : (this.currency != null ? Value(this.currency!) : const Value.absent()),
      // currencyData: currencyData != null ? Value(currencyData) : (this.currencyData != null ? Value(this.currencyData!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      investedAmount: investedAmount != null ? Value(investedAmount) : (this.investedAmount != null ? Value(this.investedAmount!) : const Value.absent()),
      currentValue: currentValue != null ? Value(currentValue) : (this.currentValue != null ? Value(this.currentValue!) : const Value.absent()),
      interestRate: interestRate != null ? Value(interestRate) : (this.interestRate != null ? Value(this.interestRate!) : const Value.absent()),
      fixedReturnAmount: fixedReturnAmount != null ? Value(fixedReturnAmount) : (this.fixedReturnAmount != null ? Value(this.fixedReturnAmount!) : const Value.absent()),
      returnFrequency: returnFrequency != null ? Value(returnFrequency) : (this.returnFrequency != null ? Value(this.returnFrequency!) : const Value.absent()),
      contactId: contact != null ? Value(contact) : (this.contact != null ? Value(this.contact!) : const Value.absent()),
      // contactData: contactData != null ? Value(contactData) : (this.contactData != null ? Value(this.contactData!) : const Value.absent()),
      merchantId: merchant != null ? Value(merchant) : (this.merchant != null ? Value(this.merchant!) : const Value.absent()),
      // merchantData: merchantData != null ? Value(merchantData) : (this.merchantData != null ? Value(this.merchantData!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      returnCalculationType: returnCalculationType != null ? Value(returnCalculationType) : (this.returnCalculationType != null ? Value(this.returnCalculationType!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

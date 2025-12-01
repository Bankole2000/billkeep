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

  /// Converts a Drift database record to an InvestmentModel
  factory InvestmentModel.fromDrift(Investment investment) {
    return InvestmentModel(
      id: investment.id,
      name: investment.name,
      tempId: investment.tempId,
      investmentDate: investment.investmentDate,
      maturityDate: investment.maturityDate,
      closedDate: investment.closedDate,
      currency: investment.currency,
      user: investment.userId,
      investedAmount: investment.investedAmount,
      currentValue: investment.currentValue,
      interestRate: investment.interestRate,
      fixedReturnAmount: investment.fixedReturnAmount,
      returnFrequency: investment.returnFrequency,
      contact: investment.contactId,
      merchant: investment.merchantId,
      isSynced: investment.isSynced,
      returnCalculationType: investment.returnCalculationType,
      createdAt: investment.createdAt,
      updatedAt: investment.updatedAt,
    );
  }


  /// Compares this InvestmentModel with another for equality
  bool isEqualTo(InvestmentModel other) {
    return id == other.id &&
        name == other.name &&
        tempId == other.tempId &&
        investmentDate == other.investmentDate &&
        maturityDate == other.maturityDate &&
        closedDate == other.closedDate &&
        currency == other.currency &&
        user == other.user &&
        investedAmount == other.investedAmount &&
        currentValue == other.currentValue &&
        interestRate == other.interestRate &&
        fixedReturnAmount == other.fixedReturnAmount &&
        returnFrequency == other.returnFrequency &&
        contact == other.contact &&
        merchant == other.merchant &&
        isSynced == other.isSynced &&
        returnCalculationType == other.returnCalculationType;
  }

  /// Updates this InvestmentModel with another, prioritizing non-null fields from the other
  InvestmentModel merge(InvestmentModel other) {
    return InvestmentModel(
      id: other.id ?? id,
      name: other.name ?? name,
      tempId: other.tempId ?? tempId,
      investmentDate: other.investmentDate ?? investmentDate,
      maturityDate: other.maturityDate ?? maturityDate,
      closedDate: other.closedDate ?? closedDate,
      currency: other.currency ?? currency,
      currencyData: other.currencyData ?? currencyData,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      investedAmount: other.investedAmount ?? investedAmount,
      currentValue: other.currentValue ?? currentValue,
      interestRate: other.interestRate ?? interestRate,
      fixedReturnAmount: other.fixedReturnAmount ?? fixedReturnAmount,
      returnFrequency: other.returnFrequency ?? returnFrequency,
      contact: other.contact ?? contact,
      contactData: other.contactData ?? contactData,
      merchant: other.merchant ?? merchant,
      merchantData: other.merchantData ?? merchantData,
      isSynced: other.isSynced ?? isSynced,
      returnCalculationType: other.returnCalculationType ?? returnCalculationType,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this InvestmentModel with the given fields replaced with new values
  InvestmentModel copyWith({
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
    return InvestmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      tempId: tempId ?? this.tempId,
      investmentDate: investmentDate ?? this.investmentDate,
      maturityDate: maturityDate ?? this.maturityDate,
      closedDate: closedDate ?? this.closedDate,
      currency: currency ?? this.currency,
      currencyData: currencyData ?? this.currencyData,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      investedAmount: investedAmount ?? this.investedAmount,
      currentValue: currentValue ?? this.currentValue,
      interestRate: interestRate ?? this.interestRate,
      fixedReturnAmount: fixedReturnAmount ?? this.fixedReturnAmount,
      returnFrequency: returnFrequency ?? this.returnFrequency,
      contact: contact ?? this.contact,
      contactData: contactData ?? this.contactData,
      merchant: merchant ?? this.merchant,
      merchantData: merchantData ?? this.merchantData,
      isSynced: isSynced ?? this.isSynced,
      returnCalculationType: returnCalculationType ?? this.returnCalculationType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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

import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'category_model.dart';
import 'contact_model.dart';
import 'currency_model.dart';
import 'merchant_model.dart';
import 'project_model.dart';
import 'reminder_model.dart';
import 'user_model.dart';
import 'wallet_model.dart';

class IncomeModel {
  final String? id;
  final String? projectId;
  final ProjectModel? projectIdData;
  final String? description;
  final int? expectedAmount;
  final String? type;
  final String? frequency;
  final DateTime? startDate;
  final DateTime? nextExpectedDate;
  final String? walletId;
  final WalletModel? walletIdData;
  final String? reminderId;
  final ReminderModel? reminderIdData;
  final String? source;
  final bool? isActive;
  final bool? isSynced;
  final String? tempId;
  final String? user;
  final UserModel? userData;
  final Map<String, dynamic>? metadata;
  final String? currency;
  final CurrencyModel? currencyData;
  final String? category;
  final CategoryModel? categoryData;
  final String? merchant;
  final MerchantModel? merchantData;
  final String? contact;
  final ContactModel? contactData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IncomeModel({
    this.id,
    this.projectId,
    this.projectIdData,
    this.description,
    this.expectedAmount,
    this.type,
    this.frequency,
    this.startDate,
    this.nextExpectedDate,
    this.walletId,
    this.walletIdData,
    this.reminderId,
    this.reminderIdData,
    this.source,
    this.isActive,
    this.isSynced,
    this.tempId,
    this.user,
    this.userData,
    this.metadata,
    this.currency,
    this.currencyData,
    this.category,
    this.categoryData,
    this.merchant,
    this.merchantData,
    this.contact,
    this.contactData,
    this.createdAt,
    this.updatedAt,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['id'] as String?,
      projectId: json['projectId'] as String?,
      projectIdData: json['expand']?['projectId'] != null
          ? ProjectModel.fromJson(
              json['expand']['projectId'] as Map<String, dynamic>,
            )
          : null,
      description: json['description'] as String?,
      expectedAmount: json['expectedAmount'] as int?,
      type: json['type'] as String?,
      frequency: json['frequency'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      nextExpectedDate: json['nextExpectedDate'] != null
          ? DateTime.parse(json['nextExpectedDate'] as String)
          : null,
      walletId: json['walletId'] as String?,
      walletIdData: json['expand']?['walletId'] != null
          ? WalletModel.fromJson(
              json['expand']['walletId'] as Map<String, dynamic>,
            )
          : null,
      reminderId: json['reminderId'] as String?,
      reminderIdData: json['expand']?['reminderId'] != null
          ? ReminderModel.fromJson(
              json['expand']['reminderId'] as Map<String, dynamic>,
            )
          : null,
      source: json['source'] as String?,
      isActive: json['isActive'] as bool?,
      isSynced: json['isSynced'] as bool?,
      tempId: json['tempId'] as String?,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      currency: json['currency'] as String?,
      currencyData: json['expand']?['currency'] != null
          ? CurrencyModel.fromJson(
              json['expand']['currency'] as Map<String, dynamic>,
            )
          : null,
      category: json['category'] as String?,
      categoryData: json['expand']?['category'] != null
          ? CategoryModel.fromJson(
              json['expand']['category'] as Map<String, dynamic>,
            )
          : null,
      merchant: json['merchant'] as String?,
      merchantData: json['expand']?['merchant'] != null
          ? MerchantModel.fromJson(
              json['expand']['merchant'] as Map<String, dynamic>,
            )
          : null,
      contact: json['contact'] as String?,
      contactData: json['expand']?['contact'] != null
          ? ContactModel.fromJson(
              json['expand']['contact'] as Map<String, dynamic>,
            )
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts a Drift database record to an IncomeModel
  factory IncomeModel.fromDrift(IncomeData income) {
    return IncomeModel(
      id: income.id,
      projectId: income.projectId,
      description: income.description,
      expectedAmount: income.expectedAmount,
      type: income.type,
      frequency: income.frequency,
      startDate: income.startDate,
      nextExpectedDate: income.nextExpectedDate,
      walletId: income.walletId,
      reminderId: income.reminderId,
      source: income.source,
      isActive: income.isActive,
      isSynced: income.isSynced,
      tempId: income.tempId,
      user: income.userId,
      currency: income.currency,
      category: income.categoryId,
      merchant: income.merchantId,
      contact: income.contactId,
      createdAt: income.createdAt,
      updatedAt: income.updatedAt,
    );
  }


  /// Compares this IncomeModel with another for equality
  bool isEqualTo(IncomeModel other) {
    return id == other.id &&
        projectId == other.projectId &&
        description == other.description &&
        expectedAmount == other.expectedAmount &&
        type == other.type &&
        frequency == other.frequency &&
        startDate == other.startDate &&
        nextExpectedDate == other.nextExpectedDate &&
        walletId == other.walletId &&
        reminderId == other.reminderId &&
        source == other.source &&
        isActive == other.isActive &&
        isSynced == other.isSynced &&
        tempId == other.tempId &&
        user == other.user &&
        currency == other.currency &&
        category == other.category &&
        merchant == other.merchant &&
        contact == other.contact;
  }

  /// Updates this IncomeModel with another, prioritizing non-null fields from the other
  IncomeModel merge(IncomeModel other) {
    return IncomeModel(
      id: other.id ?? id,
      projectId: other.projectId ?? projectId,
      projectIdData: other.projectIdData ?? projectIdData,
      description: other.description ?? description,
      expectedAmount: other.expectedAmount ?? expectedAmount,
      type: other.type ?? type,
      frequency: other.frequency ?? frequency,
      startDate: other.startDate ?? startDate,
      nextExpectedDate: other.nextExpectedDate ?? nextExpectedDate,
      walletId: other.walletId ?? walletId,
      walletIdData: other.walletIdData ?? walletIdData,
      reminderId: other.reminderId ?? reminderId,
      reminderIdData: other.reminderIdData ?? reminderIdData,
      source: other.source ?? source,
      isActive: other.isActive ?? isActive,
      isSynced: other.isSynced ?? isSynced,
      tempId: other.tempId ?? tempId,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      currency: other.currency ?? currency,
      currencyData: other.currencyData ?? currencyData,
      category: other.category ?? category,
      categoryData: other.categoryData ?? categoryData,
      merchant: other.merchant ?? merchant,
      merchantData: other.merchantData ?? merchantData,
      contact: other.contact ?? contact,
      contactData: other.contactData ?? contactData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this IncomeModel with the given fields replaced with new values
  IncomeModel copyWith({
    String? id,
    String? projectId,
    ProjectModel? projectIdData,
    String? description,
    int? expectedAmount,
    String? type,
    String? frequency,
    DateTime? startDate,
    DateTime? nextExpectedDate,
    String? walletId,
    WalletModel? walletIdData,
    String? reminderId,
    ReminderModel? reminderIdData,
    String? source,
    bool? isActive,
    bool? isSynced,
    String? tempId,
    String? user,
    UserModel? userData,
    Map<String, dynamic>? metadata,
    String? currency,
    CurrencyModel? currencyData,
    String? category,
    CategoryModel? categoryData,
    String? merchant,
    MerchantModel? merchantData,
    String? contact,
    ContactModel? contactData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IncomeModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectIdData: projectIdData ?? this.projectIdData,
      description: description ?? this.description,
      expectedAmount: expectedAmount ?? this.expectedAmount,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      nextExpectedDate: nextExpectedDate ?? this.nextExpectedDate,
      walletId: walletId ?? this.walletId,
      walletIdData: walletIdData ?? this.walletIdData,
      reminderId: reminderId ?? this.reminderId,
      reminderIdData: reminderIdData ?? this.reminderIdData,
      source: source ?? this.source,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
      tempId: tempId ?? this.tempId,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      metadata: metadata ?? this.metadata,
      currency: currency ?? this.currency,
      currencyData: currencyData ?? this.currencyData,
      category: category ?? this.category,
      categoryData: categoryData ?? this.categoryData,
      merchant: merchant ?? this.merchant,
      merchantData: merchantData ?? this.merchantData,
      contact: contact ?? this.contact,
      contactData: contactData ?? this.contactData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'description': description,
      'expectedAmount': expectedAmount,
      'type': type,
      'frequency': frequency,
      'startDate': startDate?.toIso8601String(),
      'nextExpectedDate': nextExpectedDate?.toIso8601String(),
      'walletId': walletId,
      'reminderId': reminderId,
      'source': source,
      'isActive': isActive,
      'isSynced': isSynced,
      'tempId': tempId,
      'user': user,
      'metadata': metadata,
      'currency': currency,
      'category': category,
      'merchant': merchant,
      'contact': contact,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  IncomeCompanion toCompanion({
    String? id,
    String? projectId,
    ProjectModel? projectIdData,
    String? description,
    int? expectedAmount,
    String? type,
    String? frequency,
    DateTime? startDate,
    DateTime? nextExpectedDate,
    String? walletId,
    WalletModel? walletIdData,
    String? reminderId,
    ReminderModel? reminderIdData,
    String? source,
    bool? isActive,
    bool? isSynced,
    String? tempId,
    String? user,
    UserModel? userData,
    String? currency,
    CurrencyModel? currencyData,
    String? category,
    CategoryModel? categoryData,
    String? merchant,
    MerchantModel? merchantData,
    String? contact,
    ContactModel? contactData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IncomeCompanion(
      id: id != null
          ? Value(id)
          : (this.id != null ? Value(this.id!) : const Value.absent()),
      projectId: projectId != null
          ? Value(projectId)
          : (this.projectId != null
                ? Value(this.projectId!)
                : const Value.absent()),
      // projectIdData: projectIdData != null ? Value(projectIdData) : (this.projectIdData != null ? Value(this.projectIdData!) : const Value.absent()),
      description: description != null
          ? Value(description)
          : (this.description != null
                ? Value(this.description!)
                : const Value.absent()),
      expectedAmount: expectedAmount != null
          ? Value(expectedAmount)
          : (this.expectedAmount != null
                ? Value(this.expectedAmount!)
                : const Value.absent()),
      type: type != null
          ? Value(type)
          : (this.type != null ? Value(this.type!) : const Value.absent()),
      frequency: frequency != null
          ? Value(frequency)
          : (this.frequency != null
                ? Value(this.frequency!)
                : const Value.absent()),
      startDate: startDate != null
          ? Value(startDate)
          : (this.startDate != null
                ? Value(this.startDate!)
                : const Value.absent()),
      nextExpectedDate: nextExpectedDate != null
          ? Value(nextExpectedDate)
          : (this.nextExpectedDate != null
                ? Value(this.nextExpectedDate!)
                : const Value.absent()),
      walletId: walletId != null
          ? Value(walletId)
          : (this.walletId != null
                ? Value(this.walletId!)
                : const Value.absent()),
      // walletIdData: walletIdData != null ? Value(walletIdData) : (this.walletIdData != null ? Value(this.walletIdData!) : const Value.absent()),
      reminderId: reminderId != null
          ? Value(reminderId)
          : (this.reminderId != null
                ? Value(this.reminderId!)
                : const Value.absent()),
      // reminderIdData: reminderIdData != null ? Value(reminderIdData) : (this.reminderIdData != null ? Value(this.reminderIdData!) : const Value.absent()),
      source: source != null
          ? Value(source)
          : (this.source != null ? Value(this.source!) : const Value.absent()),
      isActive: isActive != null
          ? Value(isActive)
          : (this.isActive != null
                ? Value(this.isActive!)
                : const Value.absent()),
      isSynced: isSynced != null
          ? Value(isSynced)
          : (this.isSynced != null
                ? Value(this.isSynced!)
                : const Value.absent()),
      tempId: tempId != null
          ? Value(tempId)
          : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      userId: user != null
          ? Value(user)
          : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      currency: currency != null
          ? Value(currency)
          : (this.currency != null
                ? Value(this.currency!)
                : const Value.absent()),
      // currencyData: currencyData != null ? Value(currencyData) : (this.currencyData != null ? Value(this.currencyData!) : const Value.absent()),
      categoryId: category != null
          ? Value(category)
          : (this.category != null
                ? Value(this.category!)
                : const Value.absent()),
      // categoryData: categoryData != null ? Value(categoryData) : (this.categoryData != null ? Value(this.categoryData!) : const Value.absent()),
      merchantId: merchant != null
          ? Value(merchant)
          : (this.merchant != null
                ? Value(this.merchant!)
                : const Value.absent()),
      // merchantData: merchantData != null ? Value(merchantData) : (this.merchantData != null ? Value(this.merchantData!) : const Value.absent()),
      contactId: contact != null
          ? Value(contact)
          : (this.contact != null
                ? Value(this.contact!)
                : const Value.absent()),
      // contactData: contactData != null ? Value(contactData) : (this.contactData != null ? Value(this.contactData!) : const Value.absent()),
      createdAt: createdAt != null
          ? Value(createdAt)
          : (this.createdAt != null
                ? Value(this.createdAt!)
                : const Value.absent()),
      updatedAt: updatedAt != null
          ? Value(updatedAt)
          : (this.updatedAt != null
                ? Value(this.updatedAt!)
                : const Value.absent()),
    );
  }
}

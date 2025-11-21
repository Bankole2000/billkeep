import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'reminder_model.dart';
import 'wallet_model.dart';
import 'project_model.dart';
import 'user_model.dart';
import 'category_model.dart';
import 'merchant_model.dart';
import 'contact_model.dart';
import 'investment_model.dart';
import 'goal_model.dart';
import 'budget_model.dart';

class ExpenseModel {
  final String? id;
  final String? tempId;
  final bool? isSynced;
  final String? source;
  final String? reminder;
  final ReminderModel? reminderData;
  final String? wallet;
  final WalletModel? walletData;
  final String? frequency;
  final String? name;
  final String? project;
  final ProjectModel? projectData;
  final int? expectedAmount;
  final String? type;
  final DateTime? startDate;
  final DateTime? nextRenewalDate;
  final String? user;
  final UserModel? userData;
  final Map<String, dynamic>? metadata;
  final String? currency;
  final String? category;
  final CategoryModel? categoryData;
  final String? merchant;
  final MerchantModel? merchantData;
  final String? contact;
  final ContactModel? contactData;
  final String? investment;
  final InvestmentModel? investmentData;
  final String? goal;
  final GoalModel? goalData;
  final String? budget;
  final BudgetModel? budgetData;
  final String? notes;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExpenseModel({
    this.id,
    this.tempId,
    this.isSynced,
    this.source,
    this.reminder,
    this.reminderData,
    this.wallet,
    this.walletData,
    this.frequency,
    this.name,
    this.project,
    this.projectData,
    this.expectedAmount,
    this.type,
    this.startDate,
    this.nextRenewalDate,
    this.user,
    this.userData,
    this.metadata,
    this.currency,
    this.category,
    this.categoryData,
    this.merchant,
    this.merchantData,
    this.contact,
    this.contactData,
    this.investment,
    this.investmentData,
    this.goal,
    this.goalData,
    this.budget,
    this.budgetData,
    this.notes,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String?,
      tempId: json['tempId'] as String?,
      isSynced: json['isSynced'] as bool?,
      source: json['source'] as String?,
      reminder: json['reminder'] as String?,
      reminderData: json['expand']?['reminder'] != null
          ? ReminderModel.fromJson(json['expand']['reminder'] as Map<String, dynamic>)
          : null,
      wallet: json['wallet'] as String?,
      walletData: json['expand']?['wallet'] != null
          ? WalletModel.fromJson(json['expand']['wallet'] as Map<String, dynamic>)
          : null,
      frequency: json['frequency'] as String?,
      name: json['name'] as String?,
      project: json['project'] as String?,
      projectData: json['expand']?['project'] != null
          ? ProjectModel.fromJson(json['expand']['project'] as Map<String, dynamic>)
          : null,
      expectedAmount: json['expectedAmount'] as int?,
      type: json['type'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      nextRenewalDate: json['nextRenewalDate'] != null
          ? DateTime.parse(json['nextRenewalDate'] as String)
          : null,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      currency: json['currency'] as String?,
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
      investment: json['investment'] as String?,
      investmentData: json['expand']?['investment'] != null
          ? InvestmentModel.fromJson(json['expand']['investment'] as Map<String, dynamic>)
          : null,
      goal: json['goal'] as String?,
      goalData: json['expand']?['goal'] != null
          ? GoalModel.fromJson(json['expand']['goal'] as Map<String, dynamic>)
          : null,
      budget: json['budget'] as String?,
      budgetData: json['expand']?['budget'] != null
          ? BudgetModel.fromJson(json['expand']['budget'] as Map<String, dynamic>)
          : null,
      notes: json['notes'] as String?,
      isActive: json['isActive'] as bool?,
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
      'tempId': tempId,
      'isSynced': isSynced,
      'source': source,
      'reminder': reminder,
      'wallet': wallet,
      'frequency': frequency,
      'name': name,
      'project': project,
      'expectedAmount': expectedAmount,
      'type': type,
      'startDate': startDate?.toIso8601String(),
      'nextRenewalDate': nextRenewalDate?.toIso8601String(),
      'user': user,
      'metadata': metadata,
      'currency': currency,
      'category': category,
      'merchant': merchant,
      'contact': contact,
      'investment': investment,
      'goal': goal,
      'budget': budget,
      'notes': notes,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  ExpensesCompanion toCompanion({
    String? id,
    String? tempId,
    bool? isSynced,
    String? source,
    String? reminder,
    ReminderModel? reminderData,
    String? wallet,
    WalletModel? walletData,
    String? frequency,
    String? name,
    String? project,
    ProjectModel? projectData,
    int? expectedAmount,
    String? type,
    DateTime? startDate,
    DateTime? nextRenewalDate,
    String? user,
    UserModel? userData,
    String? currency,
    String? category,
    CategoryModel? categoryData,
    String? merchant,
    MerchantModel? merchantData,
    String? contact,
    ContactModel? contactData,
    String? investment,
    InvestmentModel? investmentData,
    String? goal,
    GoalModel? goalData,
    String? budget,
    BudgetModel? budgetData,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpensesCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      source: source != null ? Value(source) : (this.source != null ? Value(this.source!) : const Value.absent()),
      reminderId: reminder != null ? Value(reminder) : (this.reminder != null ? Value(this.reminder!) : const Value.absent()),
      // reminderData: reminderData != null ? Value(reminderData) : (this.reminderData != null ? Value(this.reminderData!) : const Value.absent()),
      walletId: wallet != null ? Value(wallet) : (this.wallet != null ? Value(this.wallet!) : const Value.absent()),
      // walletData: walletData != null ? Value(walletData) : (this.walletData != null ? Value(this.walletData!) : const Value.absent()),
      frequency: frequency != null ? Value(frequency) : (this.frequency != null ? Value(this.frequency!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      projectId: project != null ? Value(project) : (this.project != null ? Value(this.project!) : const Value.absent()),
      // projectData: projectData != null ? Value(projectData) : (this.projectData != null ? Value(this.projectData!) : const Value.absent()),
      expectedAmount: expectedAmount != null ? Value(expectedAmount) : (this.expectedAmount != null ? Value(this.expectedAmount!) : const Value.absent()),
      type: type != null ? Value(type) : (this.type != null ? Value(this.type!) : const Value.absent()),
      startDate: startDate != null ? Value(startDate) : (this.startDate != null ? Value(this.startDate!) : const Value.absent()),
      nextRenewalDate: nextRenewalDate != null ? Value(nextRenewalDate) : (this.nextRenewalDate != null ? Value(this.nextRenewalDate!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      currency: currency != null ? Value(currency) : (this.currency != null ? Value(this.currency!) : const Value.absent()),
      categoryId: category != null ? Value(category) : (this.category != null ? Value(this.category!) : const Value.absent()),
      // categoryData: categoryData != null ? Value(categoryData) : (this.categoryData != null ? Value(this.categoryData!) : const Value.absent()),
      merchantId: merchant != null ? Value(merchant) : (this.merchant != null ? Value(this.merchant!) : const Value.absent()),
      // merchantData: merchantData != null ? Value(merchantData) : (this.merchantData != null ? Value(this.merchantData!) : const Value.absent()),
      contactId: contact != null ? Value(contact) : (this.contact != null ? Value(this.contact!) : const Value.absent()),
      // contactData: contactData != null ? Value(contactData) : (this.contactData != null ? Value(this.contactData!) : const Value.absent()),
      investmentId: investment != null ? Value(investment) : (this.investment != null ? Value(this.investment!) : const Value.absent()),
      // investmentData: investmentData != null ? Value(investmentData) : (this.investmentData != null ? Value(this.investmentData!) : const Value.absent()),
      goalId: goal != null ? Value(goal) : (this.goal != null ? Value(this.goal!) : const Value.absent()),
      // goalData: goalData != null ? Value(goalData) : (this.goalData != null ? Value(this.goalData!) : const Value.absent()),
      budgetId: budget != null ? Value(budget) : (this.budget != null ? Value(this.budget!) : const Value.absent()),
      // budgetData: budgetData != null ? Value(budgetData) : (this.budgetData != null ? Value(this.budgetData!) : const Value.absent()),
      notes: notes != null ? Value(notes) : (this.notes != null ? Value(this.notes!) : const Value.absent()),
      isActive: isActive != null ? Value(isActive) : (this.isActive != null ? Value(this.isActive!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

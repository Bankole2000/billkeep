import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

import 'category_model.dart';
import 'currency_model.dart';
import 'project_model.dart';
import 'user_model.dart';

class BudgetModel {
  final String? id;
  final String? name;
  final String? description;
  final String? tempId;
  final bool? isSynced;
  final int? underLimitGoal;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isActive;
  final String? project;
  final ProjectModel? projectData;
  final int? limitAmount;
  final int? spentAmount;
  final int? overBudgetAllowance;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String? iconType;
  final String? color;
  final String? user;
  final UserModel? userData;
  final Map<String, dynamic>? metadata;
  final String? currency;
  final CurrencyModel? currencyData;
  final String? category;
  final CategoryModel? categoryData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BudgetModel({
    this.id,
    this.name,
    this.description,
    this.tempId,
    this.isSynced,
    this.underLimitGoal,
    this.startDate,
    this.endDate,
    this.isActive,
    this.project,
    this.projectData,
    this.limitAmount,
    this.spentAmount,
    this.overBudgetAllowance,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType,
    this.color,
    this.user,
    this.userData,
    this.metadata,
    this.currency,
    this.currencyData,
    this.category,
    this.categoryData,
    this.createdAt,
    this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      tempId: json['tempId'] as String?,
      isSynced: json['isSynced'] as bool?,
      underLimitGoal: json['underLimitGoal'] as int?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      isActive: json['isActive'] as bool?,
      project: json['project'] as String?,
      projectData: json['expand']?['project'] != null
          ? ProjectModel.fromJson(json['expand']['project'] as Map<String, dynamic>)
          : null,
      limitAmount: json['limitAmount'] as int?,
      spentAmount: json['spentAmount'] as int?,
      overBudgetAllowance: json['overBudgetAllowance'] as int?,
      iconCodePoint: json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String?,
      color: json['color'] as String?,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      currency: json['currency'] as String?,
      currencyData: json['expand']?['currency'] != null
          ? CurrencyModel.fromJson(json['expand']['currency'] as Map<String, dynamic>)
          : null,
      category: json['category'] as String?,
      categoryData: json['expand']?['category'] != null
          ? CategoryModel.fromJson(json['expand']['category'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts a Drift database record to a BudgetModel
  factory BudgetModel.fromDrift(Budget budget) {
    return BudgetModel(
      id: budget.id,
      name: budget.name,
      description: budget.description,
      tempId: budget.tempId,
      isSynced: budget.isSynced,
      underLimitGoal: budget.underLimitGoal,
      startDate: budget.startDate,
      endDate: budget.endDate,
      isActive: budget.isActive,
      project: budget.projectId,
      limitAmount: budget.limitAmount,
      spentAmount: budget.spentAmount,
      overBudgetAllowance: budget.overBudgetAllowance,
      iconCodePoint: budget.iconCodePoint,
      iconEmoji: budget.iconEmoji,
      iconType: budget.iconType,
      color: budget.color,
      user: budget.userId,
      currency: budget.currency,
      category: budget.categoryId,
      createdAt: budget.createdAt,
      updatedAt: budget.updatedAt,
    );
  }


  /// Compares this BudgetModel with another for equality
  bool isEqualTo(BudgetModel other) {
    return id == other.id &&
        name == other.name &&
        description == other.description &&
        tempId == other.tempId &&
        isSynced == other.isSynced &&
        underLimitGoal == other.underLimitGoal &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        isActive == other.isActive &&
        project == other.project &&
        limitAmount == other.limitAmount &&
        spentAmount == other.spentAmount &&
        overBudgetAllowance == other.overBudgetAllowance &&
        iconCodePoint == other.iconCodePoint &&
        iconEmoji == other.iconEmoji &&
        iconType == other.iconType &&
        color == other.color &&
        user == other.user &&
        currency == other.currency &&
        category == other.category;
  }

  /// Updates this BudgetModel with another, prioritizing non-null fields from the other
  BudgetModel merge(BudgetModel other) {
    return BudgetModel(
      id: other.id ?? id,
      name: other.name ?? name,
      description: other.description ?? description,
      tempId: other.tempId ?? tempId,
      isSynced: other.isSynced ?? isSynced,
      underLimitGoal: other.underLimitGoal ?? underLimitGoal,
      startDate: other.startDate ?? startDate,
      endDate: other.endDate ?? endDate,
      isActive: other.isActive ?? isActive,
      project: other.project ?? project,
      projectData: other.projectData ?? projectData,
      limitAmount: other.limitAmount ?? limitAmount,
      spentAmount: other.spentAmount ?? spentAmount,
      overBudgetAllowance: other.overBudgetAllowance ?? overBudgetAllowance,
      iconCodePoint: other.iconCodePoint ?? iconCodePoint,
      iconEmoji: other.iconEmoji ?? iconEmoji,
      iconType: other.iconType ?? iconType,
      color: other.color ?? color,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      currency: other.currency ?? currency,
      currencyData: other.currencyData ?? currencyData,
      category: other.category ?? category,
      categoryData: other.categoryData ?? categoryData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this BudgetModel with the given fields replaced with new values
  BudgetModel copyWith({
    String? id,
    String? name,
    String? description,
    String? tempId,
    bool? isSynced,
    int? underLimitGoal,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? project,
    ProjectModel? projectData,
    int? limitAmount,
    int? spentAmount,
    int? overBudgetAllowance,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    String? user,
    UserModel? userData,
    Map<String, dynamic>? metadata,
    String? currency,
    CurrencyModel? currencyData,
    String? category,
    CategoryModel? categoryData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tempId: tempId ?? this.tempId,
      isSynced: isSynced ?? this.isSynced,
      underLimitGoal: underLimitGoal ?? this.underLimitGoal,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      project: project ?? this.project,
      projectData: projectData ?? this.projectData,
      limitAmount: limitAmount ?? this.limitAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      overBudgetAllowance: overBudgetAllowance ?? this.overBudgetAllowance,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      iconType: iconType ?? this.iconType,
      color: color ?? this.color,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      metadata: metadata ?? this.metadata,
      currency: currency ?? this.currency,
      currencyData: currencyData ?? this.currencyData,
      category: category ?? this.category,
      categoryData: categoryData ?? this.categoryData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tempId': tempId,
      'isSynced': isSynced,
      'underLimitGoal': underLimitGoal,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'project': project,
      'limitAmount': limitAmount,
      'spentAmount': spentAmount,
      'overBudgetAllowance': overBudgetAllowance,
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'user': user,
      'metadata': metadata,
      'currency': currency,
      'category': category,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  BudgetsCompanion toCompanion({
    String? id,
    String? name,
    String? description,
    String? tempId,
    bool? isSynced,
    int? underLimitGoal,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? project,
    ProjectModel? projectData,
    int? limitAmount,
    int? spentAmount,
    int? overBudgetAllowance,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    String? user,
    UserModel? userData,
    String? currency,
    CurrencyModel? currencyData,
    String? category,
    CategoryModel? categoryData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetsCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      description: description != null ? Value(description) : (this.description != null ? Value(this.description!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      underLimitGoal: underLimitGoal != null ? Value(underLimitGoal) : (this.underLimitGoal != null ? Value(this.underLimitGoal!) : const Value.absent()),
      startDate: startDate != null ? Value(startDate) : (this.startDate != null ? Value(this.startDate!) : const Value.absent()),
      endDate: endDate != null ? Value(endDate) : (this.endDate != null ? Value(this.endDate!) : const Value.absent()),
      isActive: isActive != null ? Value(isActive) : (this.isActive != null ? Value(this.isActive!) : const Value.absent()),
      projectId: project != null ? Value(project) : (this.project != null ? Value(this.project!) : const Value.absent()),
      // projectData: projectData != null ? Value(projectData) : (this.projectData != null ? Value(this.projectData!) : const Value.absent()),
      limitAmount: limitAmount != null ? Value(limitAmount) : (this.limitAmount != null ? Value(this.limitAmount!) : const Value.absent()),
      spentAmount: spentAmount != null ? Value(spentAmount) : (this.spentAmount != null ? Value(this.spentAmount!) : const Value.absent()),
      overBudgetAllowance: overBudgetAllowance != null ? Value(overBudgetAllowance) : (this.overBudgetAllowance != null ? Value(this.overBudgetAllowance!) : const Value.absent()),
      iconCodePoint: iconCodePoint != null ? Value(iconCodePoint) : (this.iconCodePoint != null ? Value(this.iconCodePoint!) : const Value.absent()),
      iconEmoji: iconEmoji != null ? Value(iconEmoji) : (this.iconEmoji != null ? Value(this.iconEmoji!) : const Value.absent()),
      iconType: iconType != null ? Value(iconType) : (this.iconType != null ? Value(this.iconType!) : const Value.absent()),
      color: color != null ? Value(color) : (this.color != null ? Value(this.color!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      currency: currency != null ? Value(currency) : (this.currency != null ? Value(this.currency!) : const Value.absent()),
      // currencyData: currencyData != null ? Value(currencyData) : (this.currencyData != null ? Value(this.currencyData!) : const Value.absent()),
      categoryId: category != null ? Value(category) : (this.category != null ? Value(this.category!) : const Value.absent()),
      // categoryData: categoryData != null ? Value(categoryData) : (this.categoryData != null ? Value(this.categoryData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

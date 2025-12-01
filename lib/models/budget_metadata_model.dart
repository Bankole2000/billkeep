import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

import 'budget_model.dart';
import 'user_model.dart';

class BudgetMetadataModel {
  final String? id;
  final String? name;
  final String? type;
  final String? stringValue;
  final int? numberValue;
  final bool? booleanValue;
  final DateTime? dateTimeValue;
  final String? urlValue;
  final String? emailValue;
  final String? user;
  final UserModel? userData;
  final String? budget;
  final BudgetModel? budgetData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BudgetMetadataModel({
    this.id,
    this.name,
    this.type,
    this.stringValue,
    this.numberValue,
    this.booleanValue,
    this.dateTimeValue,
    this.urlValue,
    this.emailValue,
    this.user,
    this.userData,
    this.budget,
    this.budgetData,
    this.createdAt,
    this.updatedAt,
  });

  factory BudgetMetadataModel.fromJson(Map<String, dynamic> json) {
    return BudgetMetadataModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      stringValue: json['stringValue'] as String?,
      numberValue: json['numberValue'] as int?,
      booleanValue: json['booleanValue'] as bool?,
      dateTimeValue: json['dateTimeValue'] != null
          ? DateTime.parse(json['dateTimeValue'] as String)
          : null,
      urlValue: json['urlValue'] as String?,
      emailValue: json['emailValue'] as String?,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      budget: json['budget'] as String?,
      budgetData: json['expand']?['budget'] != null
          ? BudgetModel.fromJson(json['expand']['budget'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts a Drift database record to a BudgetMetadataModel
  factory BudgetMetadataModel.fromDrift(BudgetMetadataData metadata) {
    return BudgetMetadataModel(
      id: metadata.id,
      name: metadata.name,
      type: metadata.type,
      stringValue: metadata.stringValue,
      numberValue: metadata.numberValue,
      booleanValue: metadata.booleanValue,
      dateTimeValue: metadata.dateTimeValue,
      urlValue: metadata.urlValue,
      emailValue: metadata.emailValue,
      user: metadata.userId,
      budget: metadata.budgetId,
      createdAt: metadata.createdAt,
      updatedAt: metadata.updatedAt,
    );
  }


  /// Compares this BudgetMetadataModel with another for equality
  bool isEqualTo(BudgetMetadataModel other) {
    return id == other.id &&
        name == other.name &&
        type == other.type &&
        stringValue == other.stringValue &&
        numberValue == other.numberValue &&
        booleanValue == other.booleanValue &&
        dateTimeValue == other.dateTimeValue &&
        urlValue == other.urlValue &&
        emailValue == other.emailValue &&
        user == other.user &&
        budget == other.budget;
  }

  /// Updates this BudgetMetadataModel with another, prioritizing non-null fields from the other
  BudgetMetadataModel merge(BudgetMetadataModel other) {
    return BudgetMetadataModel(
      id: other.id ?? id,
      name: other.name ?? name,
      type: other.type ?? type,
      stringValue: other.stringValue ?? stringValue,
      numberValue: other.numberValue ?? numberValue,
      booleanValue: other.booleanValue ?? booleanValue,
      dateTimeValue: other.dateTimeValue ?? dateTimeValue,
      urlValue: other.urlValue ?? urlValue,
      emailValue: other.emailValue ?? emailValue,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      budget: other.budget ?? budget,
      budgetData: other.budgetData ?? budgetData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this BudgetMetadataModel with the given fields replaced with new values
  BudgetMetadataModel copyWith({
    String? id,
    String? name,
    String? type,
    String? stringValue,
    int? numberValue,
    bool? booleanValue,
    DateTime? dateTimeValue,
    String? urlValue,
    String? emailValue,
    String? user,
    UserModel? userData,
    String? budget,
    BudgetModel? budgetData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetMetadataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      stringValue: stringValue ?? this.stringValue,
      numberValue: numberValue ?? this.numberValue,
      booleanValue: booleanValue ?? this.booleanValue,
      dateTimeValue: dateTimeValue ?? this.dateTimeValue,
      urlValue: urlValue ?? this.urlValue,
      emailValue: emailValue ?? this.emailValue,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      budget: budget ?? this.budget,
      budgetData: budgetData ?? this.budgetData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'stringValue': stringValue,
      'numberValue': numberValue,
      'booleanValue': booleanValue,
      'dateTimeValue': dateTimeValue?.toIso8601String(),
      'urlValue': urlValue,
      'emailValue': emailValue,
      'user': user,
      'budget': budget,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  BudgetMetadataCompanion toCompanion({
    String? id,
    String? name,
    String? type,
    String? stringValue,
    int? numberValue,
    bool? booleanValue,
    DateTime? dateTimeValue,
    String? urlValue,
    String? emailValue,
    String? user,
    UserModel? userData,
    String? budget,
    BudgetModel? budgetData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetMetadataCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      type: type != null ? Value(type) : (this.type != null ? Value(this.type!) : const Value.absent()),
      stringValue: stringValue != null ? Value(stringValue) : (this.stringValue != null ? Value(this.stringValue!) : const Value.absent()),
      numberValue: numberValue != null ? Value(numberValue) : (this.numberValue != null ? Value(this.numberValue!) : const Value.absent()),
      booleanValue: booleanValue != null ? Value(booleanValue) : (this.booleanValue != null ? Value(this.booleanValue!) : const Value.absent()),
      dateTimeValue: dateTimeValue != null ? Value(dateTimeValue) : (this.dateTimeValue != null ? Value(this.dateTimeValue!) : const Value.absent()),
      urlValue: urlValue != null ? Value(urlValue) : (this.urlValue != null ? Value(this.urlValue!) : const Value.absent()),
      emailValue: emailValue != null ? Value(emailValue) : (this.emailValue != null ? Value(this.emailValue!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      budgetId: budget != null ? Value(budget) : (this.budget != null ? Value(this.budget!) : const Value.absent()),
      // budgetData: budgetData != null ? Value(budgetData) : (this.budgetData != null ? Value(this.budgetData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }
}

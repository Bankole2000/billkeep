import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'expense_model.dart';
import 'project_model.dart';
import 'user_model.dart';

class ShoppingListModel {
  final String? id;
  final String? name;
  final String? project;
  final ProjectModel? projectData;
  final String? description;
  final String? expense;
  final ExpenseModel? expenseData;
  final String? tempId;
  final bool? isSynced;
  final String? user;
  final UserModel? userData;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShoppingListModel({
    this.id,
    this.name,
    this.project,
    this.projectData,
    this.description,
    this.expense,
    this.expenseData,
    this.tempId,
    this.isSynced,
    this.user,
    this.userData,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory ShoppingListModel.fromJson(Map<String, dynamic> json) {
    return ShoppingListModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      project: json['project'] as String?,
      projectData: json['expand']?['project'] != null
          ? ProjectModel.fromJson(json['expand']['project'] as Map<String, dynamic>)
          : null,
      description: json['description'] as String?,
      expense: json['expense'] as String?,
      expenseData: json['expand']?['expense'] != null
          ? ExpenseModel.fromJson(json['expand']['expense'] as Map<String, dynamic>)
          : null,
      tempId: json['tempId'] as String?,
      isSynced: json['isSynced'] as bool?,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
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
      'project': project,
      'description': description,
      'expense': expense,
      'tempId': tempId,
      'isSynced': isSynced,
      'user': user,
      'metadata': metadata,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  ShoppingListsCompanion toCompanion({
    String? id,
    String? name,
    String? project,
    ProjectModel? projectData,
    String? description,
    String? expense,
    ExpenseModel? expenseData,
    String? tempId,
    bool? isSynced,
    String? user,
    UserModel? userData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShoppingListsCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      projectId: project != null ? Value(project) : (this.project != null ? Value(this.project!) : const Value.absent()),
      // projectData: projectData != null ? Value(projectData) : (this.projectData != null ? Value(this.projectData!) : const Value.absent()),
      description: description != null ? Value(description) : (this.description != null ? Value(this.description!) : const Value.absent()),
      expenseId: expense != null ? Value(expense) : (this.expense != null ? Value(this.expense!) : const Value.absent()),
      // expenseData: expenseData != null ? Value(expenseData) : (this.expenseData != null ? Value(this.expenseData!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }
}


import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'expense_model.dart';
import 'payment_model.dart';
import 'project_model.dart';
import 'user_model.dart';

class TodoItemModel {
  final String? id;
  final String? title;
  final String? description;
  final String? project;
  final ProjectModel? projectData;
  final bool? isCompleted;
  final String? expense;
  final ExpenseModel? expenseData;
  final bool? isSynced;
  final String? tempId;
  final String? user;
  final UserModel? userData;
  final String? parentTodo;
  final TodoItemModel? parentTodoData;
  final Map<String, dynamic>? metadata;
  final String? payment;
  final PaymentModel? paymentData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TodoItemModel({
    this.id,
    this.title,
    this.description,
    this.project,
    this.projectData,
    this.isCompleted,
    this.expense,
    this.expenseData,
    this.isSynced,
    this.tempId,
    this.user,
    this.userData,
    this.parentTodo,
    this.parentTodoData,
    this.metadata,
    this.payment,
    this.paymentData,
    this.createdAt,
    this.updatedAt,
  });

  factory TodoItemModel.fromJson(Map<String, dynamic> json) {
    return TodoItemModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      project: json['project'] as String?,
      projectData: json['expand']?['project'] != null
          ? ProjectModel.fromJson(json['expand']['project'] as Map<String, dynamic>)
          : null,
      isCompleted: json['isCompleted'] as bool?,
      expense: json['expense'] as String?,
      expenseData: json['expand']?['expense'] != null
          ? ExpenseModel.fromJson(json['expand']['expense'] as Map<String, dynamic>)
          : null,
      isSynced: json['isSynced'] as bool?,
      tempId: json['tempId'] as String?,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      parentTodo: json['parentTodo'] as String?,
      parentTodoData: json['expand']?['parentTodo'] != null
          ? TodoItemModel.fromJson(json['expand']['parentTodo'] as Map<String, dynamic>)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      payment: json['payment'] as String?,
      paymentData: json['expand']?['payment'] != null
          ? PaymentModel.fromJson(json['expand']['payment'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts a Drift database record to a TodoItemModel
  factory TodoItemModel.fromDrift(TodoItem todoItem) {
    return TodoItemModel(
      id: todoItem.id,
      title: todoItem.title,
      description: todoItem.description,
      project: todoItem.projectId,
      isCompleted: todoItem.isCompleted,
      expense: todoItem.expenseId,
      isSynced: todoItem.isSynced,
      tempId: todoItem.tempId,
      user: todoItem.userId,
      parentTodo: todoItem.parentTodoId,
      payment: todoItem.paymentId,
      createdAt: todoItem.createdAt,
      updatedAt: todoItem.updatedAt,
    );
  }


  /// Compares this TodoItemModel with another for equality
  bool isEqualTo(TodoItemModel other) {
    return id == other.id &&
        title == other.title &&
        description == other.description &&
        project == other.project &&
        isCompleted == other.isCompleted &&
        expense == other.expense &&
        isSynced == other.isSynced &&
        tempId == other.tempId &&
        user == other.user &&
        parentTodo == other.parentTodo &&
        payment == other.payment;
  }

  /// Updates this TodoItemModel with another, prioritizing non-null fields from the other
  TodoItemModel merge(TodoItemModel other) {
    return TodoItemModel(
      id: other.id ?? id,
      title: other.title ?? title,
      description: other.description ?? description,
      project: other.project ?? project,
      projectData: other.projectData ?? projectData,
      isCompleted: other.isCompleted ?? isCompleted,
      expense: other.expense ?? expense,
      expenseData: other.expenseData ?? expenseData,
      isSynced: other.isSynced ?? isSynced,
      tempId: other.tempId ?? tempId,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      parentTodo: other.parentTodo ?? parentTodo,
      parentTodoData: other.parentTodoData ?? parentTodoData,
      payment: other.payment ?? payment,
      paymentData: other.paymentData ?? paymentData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this TodoItemModel with the given fields replaced with new values
  TodoItemModel copyWith({
    String? id,
    String? title,
    String? description,
    String? project,
    ProjectModel? projectData,
    bool? isCompleted,
    String? expense,
    ExpenseModel? expenseData,
    bool? isSynced,
    String? tempId,
    String? user,
    UserModel? userData,
    String? parentTodo,
    TodoItemModel? parentTodoData,
    Map<String, dynamic>? metadata,
    String? payment,
    PaymentModel? paymentData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      project: project ?? this.project,
      projectData: projectData ?? this.projectData,
      isCompleted: isCompleted ?? this.isCompleted,
      expense: expense ?? this.expense,
      expenseData: expenseData ?? this.expenseData,
      isSynced: isSynced ?? this.isSynced,
      tempId: tempId ?? this.tempId,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      parentTodo: parentTodo ?? this.parentTodo,
      parentTodoData: parentTodoData ?? this.parentTodoData,
      metadata: metadata ?? this.metadata,
      payment: payment ?? this.payment,
      paymentData: paymentData ?? this.paymentData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'project': project,
      'isCompleted': isCompleted,
      'expense': expense,
      'isSynced': isSynced,
      'tempId': tempId,
      'user': user,
      'parentTodo': parentTodo,
      'metadata': metadata,
      'payment': payment,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  TodoItemsCompanion toCompanion({
    String? id,
    String? title,
    String? description,
    String? project,
    ProjectModel? projectData,
    bool? isCompleted,
    String? expense,
    ExpenseModel? expenseData,
    bool? isSynced,
    String? tempId,
    String? user,
    UserModel? userData,
    String? parentTodo,
    TodoItemModel? parentTodoData,
    String? payment,
    PaymentModel? paymentData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoItemsCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      title: title != null ? Value(title) : (this.title != null ? Value(this.title!) : const Value.absent()),
      description: description != null ? Value(description) : (this.description != null ? Value(this.description!) : const Value.absent()),
      projectId: project != null ? Value(project) : (this.project != null ? Value(this.project!) : const Value.absent()),
      // projectData: projectData != null ? Value(projectData) : (this.projectData != null ? Value(this.projectData!) : const Value.absent()),
      isCompleted: isCompleted != null ? Value(isCompleted) : (this.isCompleted != null ? Value(this.isCompleted!) : const Value.absent()),
      expenseId: expense != null ? Value(expense) : (this.expense != null ? Value(this.expense!) : const Value.absent()),
      // expenseData: expenseData != null ? Value(expenseData) : (this.expenseData != null ? Value(this.expenseData!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      parentTodoId: parentTodo != null ? Value(parentTodo) : (this.parentTodo != null ? Value(this.parentTodo!) : const Value.absent()),
      // parentTodoData: parentTodoData != null ? Value(parentTodoData) : (this.parentTodoData != null ? Value(this.parentTodoData!) : const Value.absent()),
      paymentId: payment != null ? Value(payment) : (this.payment != null ? Value(this.payment!) : const Value.absent()),
      // paymentData: paymentData != null ? Value(paymentData) : (this.paymentData != null ? Value(this.paymentData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }
}

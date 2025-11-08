class TodoModel {
  final String id;
  final String projectId;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? completedAt;
  final int? directExpenseAmount;
  final String? directExpenseCurrency;
  final String? directExpenseType;
  final String? directExpenseFrequency;
  final String? directExpenseDescription;
  final String? createdExpenseId;
  final String? createdPaymentId;
  final String? linkedShoppingListId;
  final String? parentTodoId;
  final bool isSynced;
  final String? tempId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TodoModel({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.completedAt,
    this.directExpenseAmount,
    this.directExpenseCurrency,
    this.directExpenseType,
    this.directExpenseFrequency,
    this.directExpenseDescription,
    this.createdExpenseId,
    this.createdPaymentId,
    this.linkedShoppingListId,
    this.parentTodoId,
    this.isSynced = false,
    this.tempId,
    this.createdAt,
    this.updatedAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      directExpenseAmount: json['directExpenseAmount'] as int?,
      directExpenseCurrency: json['directExpenseCurrency'] as String?,
      directExpenseType: json['directExpenseType'] as String?,
      directExpenseFrequency: json['directExpenseFrequency'] as String?,
      directExpenseDescription: json['directExpenseDescription'] as String?,
      createdExpenseId: json['createdExpenseId'] as String?,
      createdPaymentId: json['createdPaymentId'] as String?,
      linkedShoppingListId: json['linkedShoppingListId'] as String?,
      parentTodoId: json['parentTodoId'] as String?,
      isSynced: json['isSynced'] as bool? ?? false,
      tempId: json['tempId'] as String?,
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
      'projectId': projectId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'directExpenseAmount': directExpenseAmount,
      'directExpenseCurrency': directExpenseCurrency,
      'directExpenseType': directExpenseType,
      'directExpenseFrequency': directExpenseFrequency,
      'directExpenseDescription': directExpenseDescription,
      'createdExpenseId': createdExpenseId,
      'createdPaymentId': createdPaymentId,
      'linkedShoppingListId': linkedShoppingListId,
      'parentTodoId': parentTodoId,
      'isSynced': isSynced,
      'tempId': tempId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

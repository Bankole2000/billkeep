class ShoppingListModel {
  final String id;
  final String projectId;
  final String name;
  final String? description;
  final String? linkedExpenseId;
  final bool isSynced;
  final String? tempId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShoppingListModel({
    required this.id,
    required this.projectId,
    required this.name,
    this.description,
    this.linkedExpenseId,
    this.isSynced = false,
    this.tempId,
    this.createdAt,
    this.updatedAt,
  });

  factory ShoppingListModel.fromJson(Map<String, dynamic> json) {
    return ShoppingListModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      linkedExpenseId: json['linkedExpenseId'] as String?,
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
      'name': name,
      'description': description,
      'linkedExpenseId': linkedExpenseId,
      'isSynced': isSynced,
      'tempId': tempId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class ShoppingListItemModel {
  final String id;
  final String shoppingListId;
  final String name;
  final int? estimatedAmount;
  final int? actualAmount;
  final String currency;
  final int quantity;
  final bool isPurchased;
  final DateTime? purchasedAt;
  final String? notes;
  final String? createdExpenseId;
  final bool isSynced;
  final String? tempId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShoppingListItemModel({
    required this.id,
    required this.shoppingListId,
    required this.name,
    this.estimatedAmount,
    this.actualAmount,
    this.currency = 'USD',
    this.quantity = 1,
    this.isPurchased = false,
    this.purchasedAt,
    this.notes,
    this.createdExpenseId,
    this.isSynced = false,
    this.tempId,
    this.createdAt,
    this.updatedAt,
  });

  factory ShoppingListItemModel.fromJson(Map<String, dynamic> json) {
    return ShoppingListItemModel(
      id: json['id'] as String,
      shoppingListId: json['shoppingListId'] as String,
      name: json['name'] as String,
      estimatedAmount: json['estimatedAmount'] as int?,
      actualAmount: json['actualAmount'] as int?,
      currency: json['currency'] as String? ?? 'USD',
      quantity: json['quantity'] as int? ?? 1,
      isPurchased: json['isPurchased'] as bool? ?? false,
      purchasedAt: json['purchasedAt'] != null
          ? DateTime.parse(json['purchasedAt'] as String)
          : null,
      notes: json['notes'] as String?,
      createdExpenseId: json['createdExpenseId'] as String?,
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
      'shoppingListId': shoppingListId,
      'name': name,
      'estimatedAmount': estimatedAmount,
      'actualAmount': actualAmount,
      'currency': currency,
      'quantity': quantity,
      'isPurchased': isPurchased,
      'purchasedAt': purchasedAt?.toIso8601String(),
      'notes': notes,
      'createdExpenseId': createdExpenseId,
      'isSynced': isSynced,
      'tempId': tempId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

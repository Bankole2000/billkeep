class BudgetModel {
  final String id;
  final String name;
  final String? description;
  final int? underLimitGoal;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String projectId;
  final String? categoryId;
  final String currency;
  final int limitAmount;
  final int spentAmount;
  final int overBudgetAllowance;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String iconType;
  final String? color;
  final String? tempId;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BudgetModel({
    required this.id,
    required this.name,
    this.description,
    this.underLimitGoal,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    required this.projectId,
    this.categoryId,
    required this.currency,
    required this.limitAmount,
    this.spentAmount = 0,
    this.overBudgetAllowance = 0,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType = 'MaterialIcons',
    this.color,
    this.tempId,
    this.isSynced = false,
    this.createdAt,
    this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      underLimitGoal: json['underLimitGoal'] as int?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      projectId: json['projectId'] as String,
      categoryId: json['categoryId'] as String?,
      currency: json['currency'] as String,
      limitAmount: json['limitAmount'] as int,
      spentAmount: json['spentAmount'] as int? ?? 0,
      overBudgetAllowance: json['overBudgetAllowance'] as int? ?? 0,
      iconCodePoint: json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String? ?? 'MaterialIcons',
      color: json['color'] as String?,
      tempId: json['tempId'] as String?,
      isSynced: json['isSynced'] as bool? ?? false,
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
      'description': description,
      'underLimitGoal': underLimitGoal,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'projectId': projectId,
      'categoryId': categoryId,
      'currency': currency,
      'limitAmount': limitAmount,
      'spentAmount': spentAmount,
      'overBudgetAllowance': overBudgetAllowance,
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'tempId': tempId,
      'isSynced': isSynced,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

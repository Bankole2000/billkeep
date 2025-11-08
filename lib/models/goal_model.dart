class GoalModel {
  final String id;
  final String name;
  final String type;
  final int targetAmount;
  final String? contactId;
  final String? categoryId;
  final int currentAmount;
  final DateTime? targetDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isCompleted;
  final String? description;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String iconType;
  final String? color;
  final bool isSynced;
  final String? tempId;

  GoalModel({
    required this.id,
    required this.name,
    required this.type,
    required this.targetAmount,
    this.contactId,
    this.categoryId,
    this.currentAmount = 0,
    this.targetDate,
    this.createdAt,
    this.updatedAt,
    this.isCompleted = false,
    this.description,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType = 'MaterialIcons',
    this.color = '#2196F3',
    this.isSynced = false,
    this.tempId,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      targetAmount: json['targetAmount'] as int,
      contactId: json['contactId'] as String?,
      categoryId: json['categoryId'] as String?,
      currentAmount: json['currentAmount'] as int? ?? 0,
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
      description: json['description'] as String?,
      iconCodePoint: json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String? ?? 'MaterialIcons',
      color: json['color'] as String? ?? '#2196F3',
      isSynced: json['isSynced'] as bool? ?? false,
      tempId: json['tempId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'targetAmount': targetAmount,
      'contactId': contactId,
      'categoryId': categoryId,
      'currentAmount': currentAmount,
      'targetDate': targetDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isCompleted': isCompleted,
      'description': description,
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'isSynced': isSynced,
      'tempId': tempId,
    };
  }
}

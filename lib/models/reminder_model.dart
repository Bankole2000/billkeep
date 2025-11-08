class ReminderModel {
  final String id;
  final DateTime reminderDate;
  final bool isActive;
  final String reminderType;
  final String? tempId;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReminderModel({
    required this.id,
    required this.reminderDate,
    this.isActive = true,
    required this.reminderType,
    this.tempId,
    this.isSynced = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as String,
      reminderDate: DateTime.parse(json['reminderDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      reminderType: json['reminderType'] as String,
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
      'reminderDate': reminderDate.toIso8601String(),
      'isActive': isActive,
      'reminderType': reminderType,
      'tempId': tempId,
      'isSynced': isSynced,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

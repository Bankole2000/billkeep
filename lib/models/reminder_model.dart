import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'user_model.dart';

class ReminderModel {
  final String? id;
  final String? reminderType;
  final String? tempId;
  final bool? isSynced;
  final DateTime? reminderDate;
  final bool? isActive;
  final String? user;
  final UserModel? userData;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReminderModel({
    this.id,
    this.reminderType,
    this.tempId,
    this.isSynced,
    this.reminderDate,
    this.isActive,
    this.user,
    this.userData,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as String?,
      reminderType: json['reminderType'] as String?,
      tempId: json['tempId'] as String?,
      isSynced: json['isSynced'] as bool?,
      reminderDate: json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'] as String)
          : null,
      isActive: json['isActive'] as bool?,
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

  /// Converts a Drift database record to a ReminderModel
  factory ReminderModel.fromDrift(Reminder reminder) {
    return ReminderModel(
      id: reminder.id,
      reminderType: reminder.reminderType,
      tempId: reminder.tempId,
      isSynced: reminder.isSynced,
      reminderDate: reminder.reminderDate,
      isActive: reminder.isActive,
      user: reminder.userId,
      createdAt: reminder.createdAt,
      updatedAt: reminder.updatedAt,
    );
  }


  /// Compares this ReminderModel with another for equality
  bool isEqualTo(ReminderModel other) {
    return id == other.id &&
        reminderType == other.reminderType &&
        tempId == other.tempId &&
        isSynced == other.isSynced &&
        reminderDate == other.reminderDate &&
        isActive == other.isActive &&
        user == other.user;
  }

  /// Updates this ReminderModel with another, prioritizing non-null fields from the other
  ReminderModel merge(ReminderModel other) {
    return ReminderModel(
      id: other.id ?? id,
      reminderType: other.reminderType ?? reminderType,
      tempId: other.tempId ?? tempId,
      isSynced: other.isSynced ?? isSynced,
      reminderDate: other.reminderDate ?? reminderDate,
      isActive: other.isActive ?? isActive,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this ReminderModel with the given fields replaced with new values
  ReminderModel copyWith({
    String? id,
    String? reminderType,
    String? tempId,
    bool? isSynced,
    DateTime? reminderDate,
    bool? isActive,
    String? user,
    UserModel? userData,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      reminderType: reminderType ?? this.reminderType,
      tempId: tempId ?? this.tempId,
      isSynced: isSynced ?? this.isSynced,
      reminderDate: reminderDate ?? this.reminderDate,
      isActive: isActive ?? this.isActive,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reminderType': reminderType,
      'tempId': tempId,
      'isSynced': isSynced,
      'reminderDate': reminderDate?.toIso8601String(),
      'isActive': isActive,
      'user': user,
      'metadata': metadata,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  RemindersCompanion toCompanion({
    String? id,
    String? reminderType,
    String? tempId,
    bool? isSynced,
    DateTime? reminderDate,
    bool? isActive,
    String? user,
    UserModel? userData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RemindersCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      reminderType: reminderType != null ? Value(reminderType) : (this.reminderType != null ? Value(this.reminderType!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      reminderDate: reminderDate != null ? Value(reminderDate) : (this.reminderDate != null ? Value(this.reminderDate!) : const Value.absent()),
      isActive: isActive != null ? Value(isActive) : (this.isActive != null ? Value(this.isActive!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

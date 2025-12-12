import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'goal_model.dart';
import 'user_model.dart';

class GoalMetadataModel {
  final String? id;
  final String? name;
  final String? type;
  final String? stringValue;
  final int? numberValue;
  final bool? booleanValue;
  final DateTime? dateTimeValue;
  final String? user;
  final UserModel? userData;
  final String? goal;
  final GoalModel? goalData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GoalMetadataModel({
    this.id,
    this.name,
    this.type,
    this.stringValue,
    this.numberValue,
    this.booleanValue,
    this.dateTimeValue,
    this.user,
    this.userData,
    this.goal,
    this.goalData,
    this.createdAt,
    this.updatedAt,
  });

  factory GoalMetadataModel.fromJson(Map<String, dynamic> json) {
    return GoalMetadataModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      stringValue: json['stringValue'] as String?,
      numberValue: json['numberValue'] as int?,
      booleanValue: json['booleanValue'] as bool?,
      dateTimeValue: json['dateTimeValue'] != null
          ? DateTime.parse(json['dateTimeValue'] as String)
          : null,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      goal: json['goal'] as String?,
      goalData: json['expand']?['goal'] != null
          ? GoalModel.fromJson(json['expand']['goal'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts a Drift database record to a GoalMetadataModel
  factory GoalMetadataModel.fromDrift(GoalMetadataData metadata) {
    return GoalMetadataModel(
      id: metadata.id,
      name: metadata.name,
      type: metadata.type,
      stringValue: metadata.stringValue,
      numberValue: metadata.numberValue,
      booleanValue: metadata.booleanValue,
      dateTimeValue: metadata.dateTimeValue,
      user: metadata.userId,
      goal: metadata.goalId,
      createdAt: metadata.createdAt,
      updatedAt: metadata.updatedAt,
    );
  }


  /// Compares this GoalMetadataModel with another for equality
  bool isEqualTo(GoalMetadataModel other) {
    return id == other.id &&
        name == other.name &&
        type == other.type &&
        stringValue == other.stringValue &&
        numberValue == other.numberValue &&
        booleanValue == other.booleanValue &&
        dateTimeValue == other.dateTimeValue &&
        user == other.user &&
        goal == other.goal;
  }

  /// Updates this GoalMetadataModel with another, prioritizing non-null fields from the other
  GoalMetadataModel merge(GoalMetadataModel other) {
    return GoalMetadataModel(
      id: other.id ?? id,
      name: other.name ?? name,
      type: other.type ?? type,
      stringValue: other.stringValue ?? stringValue,
      numberValue: other.numberValue ?? numberValue,
      booleanValue: other.booleanValue ?? booleanValue,
      dateTimeValue: other.dateTimeValue ?? dateTimeValue,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      goal: other.goal ?? goal,
      goalData: other.goalData ?? goalData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this GoalMetadataModel with the given fields replaced with new values
  GoalMetadataModel copyWith({
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
    String? goal,
    GoalModel? goalData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GoalMetadataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      stringValue: stringValue ?? this.stringValue,
      numberValue: numberValue ?? this.numberValue,
      booleanValue: booleanValue ?? this.booleanValue,
      dateTimeValue: dateTimeValue ?? this.dateTimeValue,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      goal: goal ?? this.goal,
      goalData: goalData ?? this.goalData,
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
      'user': user,
      'goal': goal,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  GoalMetadataCompanion toCompanion({
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
    String? goal,
    GoalModel? goalData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GoalMetadataCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      type: type != null ? Value(type) : (this.type != null ? Value(this.type!) : const Value.absent()),
      stringValue: stringValue != null ? Value(stringValue) : (this.stringValue != null ? Value(this.stringValue!) : const Value.absent()),
      numberValue: numberValue != null ? Value(numberValue) : (this.numberValue != null ? Value(this.numberValue!) : const Value.absent()),
      booleanValue: booleanValue != null ? Value(booleanValue) : (this.booleanValue != null ? Value(this.booleanValue!) : const Value.absent()),
      dateTimeValue: dateTimeValue != null ? Value(dateTimeValue) : (this.dateTimeValue != null ? Value(this.dateTimeValue!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      goalId: goal != null ? Value(goal) : (this.goal != null ? Value(this.goal!) : const Value.absent()),
      // goalData: goalData != null ? Value(goalData) : (this.goalData != null ? Value(this.goalData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

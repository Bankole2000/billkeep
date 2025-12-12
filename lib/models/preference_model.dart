import 'dart:convert';

import 'package:billkeep/database/database.dart';
import 'package:billkeep/models/user_model.dart';
import 'package:billkeep/utils/preference_enums.dart';
import 'package:drift/drift.dart';

class PreferenceModel {
  final String? id;
  final String? tempId;
  final String? displayName;
  final String key;
  final String? type;
  final String? stringValue;
  final int? numberValue;
  final bool? booleanValue;
  final DateTime? dateTimeValue;
  final String? user;
  final Map<String, dynamic>? objectValue;
  final UserModel? userData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PreferenceModel({
    this.id,
    this.tempId,
    required this.key,
    this.displayName,
    this.type,
    this.stringValue,
    this.numberValue,
    this.booleanValue,
    this.dateTimeValue,
    this.user,
    this.userData,
    this.objectValue,
    this.createdAt,
    this.updatedAt,
  });

  factory PreferenceModel.fromJson(Map<String, dynamic> json) {
    return PreferenceModel(
      id: json['id'] as String?,
      tempId: json['tempId'] as String?,
      displayName: json['displayName'] as String?,
      key: json['key'] as String,
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
      objectValue: json['objectValue'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts a Drift database record to a PreferenceModel
  factory PreferenceModel.fromDrift(Preference preference) {
    return PreferenceModel(
      id: preference.id,
      tempId: preference.tempId,
      displayName: preference.displayName,
      key: preference.key,
      type: preference.type,
      stringValue: preference.stringValue,
      numberValue: preference.numberValue,
      booleanValue: preference.booleanValue,
      dateTimeValue: preference.dateTimeValue,
      objectValue: (preference.objectValue != null)
          ? (jsonDecode(preference.objectValue!) as Map<String, dynamic>)
          : null,
      user: preference.userId,
      createdAt: preference.createdAt,
      updatedAt: preference.updatedAt,
    );
  }


  /// Compares this PreferenceModel with another for equality
  bool isEqualTo(PreferenceModel other) {
    return id == other.id &&
        displayName == other.displayName &&
        key == other.key &&
        tempId == other.tempId &&
        type == other.type &&
        stringValue == other.stringValue &&
        numberValue == other.numberValue &&
        booleanValue == other.booleanValue &&
        objectValue == other.objectValue &&
        dateTimeValue == other.dateTimeValue &&
        user == other.user;
  }

  /// Updates this PreferenceModel with another, prioritizing non-null fields from the other
  PreferenceModel merge(PreferenceModel other) {
    return PreferenceModel(
      id: other.id ?? id,
      tempId: other.tempId ?? tempId,
      displayName: other.displayName ?? displayName,
      key: other.key ?? key,
      type: other.type ?? type,
      stringValue: other.stringValue ?? stringValue,
      numberValue: other.numberValue ?? numberValue,
      booleanValue: other.booleanValue ?? booleanValue,
      objectValue: other.objectValue ?? objectValue,
      dateTimeValue: other.dateTimeValue ?? dateTimeValue,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this PreferenceModel with the given fields replaced with new values
  PreferenceModel copyWith({
    String? id,
    String? tempId,
    String? displayName,
    String? key,
    String? type,
    String? stringValue,
    int? numberValue,
    bool? booleanValue,
    DateTime? dateTimeValue,
    String? urlValue,
    String? emailValue,
    String? user,
    UserModel? userData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PreferenceModel(
      id: id ?? this.id,
      tempId: tempId ?? this.tempId,
      displayName: displayName ?? this.displayName,
      key: key ?? this.key,
      type: type ?? this.type,
      stringValue: stringValue ?? this.stringValue,
      numberValue: numberValue ?? this.numberValue,
      booleanValue: booleanValue ?? this.booleanValue,
      objectValue: objectValue ?? this.objectValue,
      dateTimeValue: dateTimeValue ?? this.dateTimeValue,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tempId': tempId,
      'displayName': displayName,
      'key': key,
      'type': type,
      'stringValue': stringValue,
      'numberValue': numberValue,
      'booleanValue': booleanValue,
      'objectValue': objectValue,
      'dateTimeValue': dateTimeValue?.toIso8601String(),
      'user': user,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  PreferencesCompanion toCompanion({
    String? id,
    String? tempId,
    String? displayName,
    String? key,
    String? type,
    String? stringValue,
    int? numberValue,
    bool? booleanValue,
    Map<String, dynamic>? objectValue,
    DateTime? dateTimeValue,
    String? user,
    UserModel? userData,
    String? budget,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PreferencesCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      displayName: displayName != null ? Value(displayName) : (this.displayName != null ? Value(this.displayName!) : const Value.absent()),
      key: key != null ? Value(key) : (this.key != null ? Value(this.key!) : const Value.absent()),
      type: type != null ? Value(type) : (this.type != null ? Value(this.type!) : const Value.absent()),
      stringValue: stringValue != null ? Value(stringValue) : (this.stringValue != null ? Value(this.stringValue!) : const Value.absent()),
      numberValue: numberValue != null ? Value(numberValue) : (this.numberValue != null ? Value(this.numberValue!) : const Value.absent()),
      booleanValue: booleanValue != null ? Value(booleanValue) : (this.booleanValue != null ? Value(this.booleanValue!) : const Value.absent()),
      objectValue: objectValue != null ? Value(jsonEncode(objectValue)) : (this.objectValue != null ? Value(jsonEncode(this.objectValue!)) : const Value.absent()),
      dateTimeValue: dateTimeValue != null ? Value(dateTimeValue) : (this.dateTimeValue != null ? Value(this.dateTimeValue!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }
}
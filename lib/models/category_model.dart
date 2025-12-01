import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

import 'category_group_model.dart';
import 'user_model.dart';

class CategoryModel {
  final String? id;
  final String? name;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String? iconType;
  final String? color;
  final String? categoryGroup;
  final CategoryGroupModel? categoryGroupData;
  final bool? isSynced;
  final String? tempId;
  final Map<String, dynamic>? metadata;
  final String? user;
  final UserModel? userData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    this.id,
    this.name,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType,
    this.color,
    this.categoryGroup,
    this.categoryGroupData,
    this.isSynced,
    this.tempId,
    this.metadata,
    this.user,
    this.userData,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      iconCodePoint: json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String?,
      color: json['color'] as String?,
      categoryGroup: json['categoryGroup'] as String?,
      categoryGroupData: json['expand']?['categoryGroup'] != null
          ? CategoryGroupModel.fromJson(json['expand']['categoryGroup'] as Map<String, dynamic>)
          : null,
      isSynced: json['isSynced'] as bool?,
      tempId: json['tempId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts a Drift database record to a CategoryModel
  factory CategoryModel.fromDrift(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      iconCodePoint: category.iconCodePoint,
      iconEmoji: category.iconEmoji,
      iconType: category.iconType,
      color: category.color,
      categoryGroup: category.categoryGroupId,
      isSynced: category.isSynced,
      tempId: category.tempId,
      user: category.userId,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }


  /// Compares this CategoryModel with another for equality
  bool isEqualTo(CategoryModel other) {
    return id == other.id &&
        name == other.name &&
        iconCodePoint == other.iconCodePoint &&
        iconEmoji == other.iconEmoji &&
        iconType == other.iconType &&
        color == other.color &&
        categoryGroup == other.categoryGroup &&
        isSynced == other.isSynced &&
        tempId == other.tempId &&
        user == other.user;
  }

  /// Updates this CategoryModel with another, prioritizing non-null fields from the other
  CategoryModel merge(CategoryModel other) {
    return CategoryModel(
      id: other.id ?? id,
      name: other.name ?? name,
      iconCodePoint: other.iconCodePoint ?? iconCodePoint,
      iconEmoji: other.iconEmoji ?? iconEmoji,
      iconType: other.iconType ?? iconType,
      color: other.color ?? color,
      categoryGroup: other.categoryGroup ?? categoryGroup,
      categoryGroupData: other.categoryGroupData ?? categoryGroupData,
      isSynced: other.isSynced ?? isSynced,
      tempId: other.tempId ?? tempId,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this CategoryModel with the given fields replaced with new values
  CategoryModel copyWith({
    String? id,
    String? name,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    String? categoryGroup,
    CategoryGroupModel? categoryGroupData,
    bool? isSynced,
    String? tempId,
    Map<String, dynamic>? metadata,
    String? user,
    UserModel? userData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      iconType: iconType ?? this.iconType,
      color: color ?? this.color,
      categoryGroup: categoryGroup ?? this.categoryGroup,
      categoryGroupData: categoryGroupData ?? this.categoryGroupData,
      isSynced: isSynced ?? this.isSynced,
      tempId: tempId ?? this.tempId,
      metadata: metadata ?? this.metadata,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'categoryGroup': categoryGroup,
      'isSynced': isSynced,
      'tempId': tempId,
      'metadata': metadata,
      'user': user,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  CategoriesCompanion toCompanion({
    String? id,
    String? name,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    String? categoryGroup,
    CategoryGroupModel? categoryGroupData,
    bool? isSynced,
    String? tempId,
    String? user,
    UserModel? userData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoriesCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      iconCodePoint: iconCodePoint != null ? Value(iconCodePoint) : (this.iconCodePoint != null ? Value(this.iconCodePoint!) : const Value.absent()),
      iconEmoji: iconEmoji != null ? Value(iconEmoji) : (this.iconEmoji != null ? Value(this.iconEmoji!) : const Value.absent()),
      iconType: iconType != null ? Value(iconType) : (this.iconType != null ? Value(this.iconType!) : const Value.absent()),
      color: color != null ? Value(color) : (this.color != null ? Value(this.color!) : const Value.absent()),
      categoryGroupId: categoryGroup != null ? Value(categoryGroup) : (this.categoryGroup != null ? Value(this.categoryGroup!) : const Value.absent()),
      // categoryGroupData: categoryGroupData != null ? Value(categoryGroupData) : (this.categoryGroupData != null ? Value(this.categoryGroupData!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'category_model.dart';
import 'currency_model.dart';
import 'user_model.dart';

class GoalModel {
  final String? id;
  final String? name;
  final String? type;
  final int? targetAmount;
  final String? category;
  final CategoryModel? categoryData;
  final String? user;
  final UserModel? userData;
  final DateTime? goalDate;
  final String? currency;
  final CurrencyModel? currencyData;
  final String? iconEmoji;
  final String? iconType;
  final String? color;
  final String? tempId;
  final int? iconCodePoint;
  final Map<String, dynamic>? metadata;
  final String? description;
  final bool? isCompleted;
  final DateTime? completionDate;
  final String? imageUrl;
  final String? localImagePath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GoalModel({
    this.id,
    this.name,
    this.type,
    this.targetAmount,
    this.category,
    this.categoryData,
    this.user,
    this.userData,
    this.goalDate,
    this.currency,
    this.currencyData,
    this.iconEmoji,
    this.iconType,
    this.color,
    this.tempId,
    this.iconCodePoint,
    this.metadata,
    this.description,
    this.isCompleted,
    this.completionDate,
    this.imageUrl,
    this.localImagePath,
    this.createdAt,
    this.updatedAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      targetAmount: json['targetAmount'] as int?,
      category: json['category'] as String?,
      categoryData: json['expand']?['category'] != null
          ? CategoryModel.fromJson(json['expand']['category'] as Map<String, dynamic>)
          : null,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      goalDate: json['goalDate'] != null
          ? DateTime.parse(json['goalDate'] as String)
          : null,
      currency: json['currency'] as String?,
      currencyData: json['expand']?['currency'] != null
          ? CurrencyModel.fromJson(json['expand']['currency'] as Map<String, dynamic>)
          : null,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String?,
      color: json['color'] as String?,
      tempId: json['tempId'] as String?,
      iconCodePoint: json['iconCodePoint'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool?,
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'] as String)
          : null,
      imageUrl: json['imageUrl'] as String?,
      localImagePath: json['localImagePath'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts a Drift database record to a GoalModel
  factory GoalModel.fromDrift(Goal goal) {
    return GoalModel(
      id: goal.id,
      name: goal.name,
      type: goal.type,
      targetAmount: goal.targetAmount,
      category: goal.categoryId,
      user: goal.userId,
      goalDate: goal.goalDate,
      currency: goal.currencyId,
      iconEmoji: goal.iconEmoji,
      iconType: goal.iconType,
      color: goal.color,
      tempId: goal.tempId,
      iconCodePoint: goal.iconCodePoint,
      description: goal.description,
      isCompleted: goal.isCompleted,
      completionDate: goal.completionDate,
      imageUrl: goal.imageUrl,
      localImagePath: goal.localImagePath,
      createdAt: goal.createdAt,
      updatedAt: goal.updatedAt,
    );
  }


  /// Compares this GoalModel with another for equality
  bool isEqualTo(GoalModel other) {
    return id == other.id &&
        name == other.name &&
        type == other.type &&
        targetAmount == other.targetAmount &&
        category == other.category &&
        user == other.user &&
        goalDate == other.goalDate &&
        currency == other.currency &&
        iconEmoji == other.iconEmoji &&
        iconType == other.iconType &&
        color == other.color &&
        tempId == other.tempId &&
        iconCodePoint == other.iconCodePoint &&
        description == other.description &&
        isCompleted == other.isCompleted &&
        completionDate == other.completionDate &&
        imageUrl == other.imageUrl &&
        localImagePath == other.localImagePath;
  }

  /// Updates this GoalModel with another, prioritizing non-null fields from the other
  GoalModel merge(GoalModel other) {
    return GoalModel(
      id: other.id ?? id,
      name: other.name ?? name,
      type: other.type ?? type,
      targetAmount: other.targetAmount ?? targetAmount,
      category: other.category ?? category,
      categoryData: other.categoryData ?? categoryData,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      goalDate: other.goalDate ?? goalDate,
      currency: other.currency ?? currency,
      currencyData: other.currencyData ?? currencyData,
      iconEmoji: other.iconEmoji ?? iconEmoji,
      iconType: other.iconType ?? iconType,
      color: other.color ?? color,
      tempId: other.tempId ?? tempId,
      iconCodePoint: other.iconCodePoint ?? iconCodePoint,
      description: other.description ?? description,
      isCompleted: other.isCompleted ?? isCompleted,
      completionDate: other.completionDate ?? completionDate,
      imageUrl: other.imageUrl ?? imageUrl,
      localImagePath: other.localImagePath ?? localImagePath,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this GoalModel with the given fields replaced with new values
  GoalModel copyWith({
    String? id,
    String? name,
    String? type,
    int? targetAmount,
    String? category,
    CategoryModel? categoryData,
    String? user,
    UserModel? userData,
    DateTime? goalDate,
    String? currency,
    CurrencyModel? currencyData,
    String? iconEmoji,
    String? iconType,
    String? color,
    String? tempId,
    int? iconCodePoint,
    Map<String, dynamic>? metadata,
    String? description,
    bool? isCompleted,
    DateTime? completionDate,
    String? imageUrl,
    String? localImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GoalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      targetAmount: targetAmount ?? this.targetAmount,
      category: category ?? this.category,
      categoryData: categoryData ?? this.categoryData,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      goalDate: goalDate ?? this.goalDate,
      currency: currency ?? this.currency,
      currencyData: currencyData ?? this.currencyData,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      iconType: iconType ?? this.iconType,
      color: color ?? this.color,
      tempId: tempId ?? this.tempId,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      metadata: metadata ?? this.metadata,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      completionDate: completionDate ?? this.completionDate,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'targetAmount': targetAmount,
      'category': category,
      'user': user,
      'goalDate': goalDate?.toIso8601String(),
      'currency': currency,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'tempId': tempId,
      'iconCodePoint': iconCodePoint,
      'metadata': metadata,
      'description': description,
      'isCompleted': isCompleted,
      'completionDate': completionDate?.toIso8601String(),
      'imageUrl': imageUrl,
      'localImagePath': localImagePath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  GoalsCompanion toCompanion({
    String? id,
    String? name,
    String? type,
    int? targetAmount,
    String? category,
    CategoryModel? categoryData,
    String? user,
    UserModel? userData,
    DateTime? goalDate,
    String? currency,
    CurrencyModel? currencyData,
    String? iconEmoji,
    String? iconType,
    String? color,
    String? tempId,
    int? iconCodePoint,
    String? description,
    bool? isCompleted,
    DateTime? completionDate,
    String? imageUrl,
    String? localImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GoalsCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      type: type != null ? Value(type) : (this.type != null ? Value(this.type!) : const Value.absent()),
      targetAmount: targetAmount != null ? Value(targetAmount) : (this.targetAmount != null ? Value(this.targetAmount!) : const Value.absent()),
      categoryId: category != null ? Value(category) : (this.category != null ? Value(this.category!) : const Value.absent()),
      // categoryData: categoryData != null ? Value(categoryData) : (this.categoryData != null ? Value(this.categoryData!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      goalDate: goalDate != null ? Value(goalDate) : (this.goalDate != null ? Value(this.goalDate!) : const Value.absent()),
      currencyId: currency != null ? Value(currency) : (this.currency != null ? Value(this.currency!) : const Value.absent()),
      // currencyData: currencyData != null ? Value(currencyData) : (this.currencyData != null ? Value(this.currencyData!) : const Value.absent()),
      iconEmoji: iconEmoji != null ? Value(iconEmoji) : (this.iconEmoji != null ? Value(this.iconEmoji!) : const Value.absent()),
      iconType: iconType != null ? Value(iconType) : (this.iconType != null ? Value(this.iconType!) : const Value.absent()),
      color: color != null ? Value(color) : (this.color != null ? Value(this.color!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      iconCodePoint: iconCodePoint != null ? Value(iconCodePoint) : (this.iconCodePoint != null ? Value(this.iconCodePoint!) : const Value.absent()),
      description: description != null ? Value(description) : (this.description != null ? Value(this.description!) : const Value.absent()),
      isCompleted: isCompleted != null ? Value(isCompleted) : (this.isCompleted != null ? Value(this.isCompleted!) : const Value.absent()),
      completionDate: completionDate != null ? Value(completionDate) : (this.completionDate != null ? Value(this.completionDate!) : const Value.absent()),
      imageUrl: imageUrl != null ? Value(imageUrl) : (this.imageUrl != null ? Value(this.imageUrl!) : const Value.absent()),
      localImagePath: localImagePath != null ? Value(localImagePath) : (this.localImagePath != null ? Value(this.localImagePath!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }
}

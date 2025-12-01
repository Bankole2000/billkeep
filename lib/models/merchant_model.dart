import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'user_model.dart';

class MerchantModel {
  final String? id;
  final String? name;
  final String? tempId;
  final String? description;
  final String? website;
  final String? imageUrl;
  final String? localImagePath;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String? iconType;
  final String? color;
  final bool? isSynced;
  final String? user;
  final UserModel? userData;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MerchantModel({
    this.id,
    this.name,
    this.tempId,
    this.description,
    this.website,
    this.imageUrl,
    this.localImagePath,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType,
    this.color,
    this.isSynced,
    this.user,
    this.userData,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      tempId: json['tempId'] as String?,
      description: json['description'] as String?,
      website: json['website'] as String?,
      imageUrl: json['imageUrl'] as String?,
      localImagePath: json['localImagePath'] as String?,
      iconCodePoint: json['iconCodePoint'] is bool ? null : json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String?,
      color: json['color'] as String?,
      isSynced: json['isSynced'] as bool?,
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

  /// Converts a Drift database record to a MerchantModel
  factory MerchantModel.fromDrift(Merchant merchant) {
    return MerchantModel(
      id: merchant.id,
      name: merchant.name,
      tempId: merchant.tempId,
      description: merchant.description,
      website: merchant.website,
      imageUrl: merchant.imageUrl,
      localImagePath: merchant.localImagePath,
      iconCodePoint: merchant.iconCodePoint,
      iconEmoji: merchant.iconEmoji,
      iconType: merchant.iconType,
      color: merchant.color,
      isSynced: merchant.isSynced,
      user: merchant.userId,
      createdAt: merchant.createdAt,
      updatedAt: merchant.updatedAt,
    );
  }


  /// Compares this MerchantModel with another for equality
  bool isEqualTo(MerchantModel other) {
    return id == other.id &&
        name == other.name &&
        tempId == other.tempId &&
        description == other.description &&
        website == other.website &&
        imageUrl == other.imageUrl &&
        localImagePath == other.localImagePath &&
        iconCodePoint == other.iconCodePoint &&
        iconEmoji == other.iconEmoji &&
        iconType == other.iconType &&
        color == other.color &&
        isSynced == other.isSynced &&
        user == other.user;
  }

  /// Updates this MerchantModel with another, prioritizing non-null fields from the other
  MerchantModel merge(MerchantModel other) {
    return MerchantModel(
      id: other.id ?? id,
      name: other.name ?? name,
      tempId: other.tempId ?? tempId,
      description: other.description ?? description,
      website: other.website ?? website,
      imageUrl: other.imageUrl ?? imageUrl,
      localImagePath: other.localImagePath ?? localImagePath,
      iconCodePoint: other.iconCodePoint ?? iconCodePoint,
      iconEmoji: other.iconEmoji ?? iconEmoji,
      iconType: other.iconType ?? iconType,
      color: other.color ?? color,
      isSynced: other.isSynced ?? isSynced,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this MerchantModel with the given fields replaced with new values
  MerchantModel copyWith({
    String? id,
    String? name,
    String? tempId,
    String? description,
    String? website,
    String? imageUrl,
    String? localImagePath,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    bool? isSynced,
    String? user,
    UserModel? userData,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MerchantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      tempId: tempId ?? this.tempId,
      description: description ?? this.description,
      website: website ?? this.website,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      iconType: iconType ?? this.iconType,
      color: color ?? this.color,
      isSynced: isSynced ?? this.isSynced,
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
      'name': name,
      'tempId': tempId,
      'description': description,
      'website': website,
      'imageUrl': imageUrl,
      'localImagePath': localImagePath,
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'isSynced': isSynced,
      'user': user,
      'metadata': metadata,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  MerchantsCompanion toCompanion({
    String? id,
    String? name,
    String? tempId,
    String? description,
    String? website,
    String? imageUrl,
    String? localImagePath,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    bool? isSynced,
    String? user,
    UserModel? userData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MerchantsCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      description: description != null ? Value(description) : (this.description != null ? Value(this.description!) : const Value.absent()),
      website: website != null ? Value(website) : (this.website != null ? Value(this.website!) : const Value.absent()),
      imageUrl: imageUrl != null ? Value(imageUrl) : (this.imageUrl != null ? Value(this.imageUrl!) : const Value.absent()),
      localImagePath: localImagePath != null ? Value(localImagePath) : (this.localImagePath != null ? Value(this.localImagePath!) : const Value.absent()),
      iconCodePoint: iconCodePoint != null ? Value(iconCodePoint) : (this.iconCodePoint != null ? Value(this.iconCodePoint!) : const Value.absent()),
      iconEmoji: iconEmoji != null ? Value(iconEmoji) : (this.iconEmoji != null ? Value(this.iconEmoji!) : const Value.absent()),
      iconType: iconType != null ? Value(iconType) : (this.iconType != null ? Value(this.iconType!) : const Value.absent()),
      color: color != null ? Value(color) : (this.color != null ? Value(this.color!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

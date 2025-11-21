import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'user_model.dart';

class WalletProviderModel {
  final String? id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? localImagePath;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String? iconType;
  final String? color;
  final String? websiteUrl;
  final bool? isFiatBank;
  final bool? isCrypto;
  final bool? isMobileMoney;
  final bool? isCreditCard;
  final String? tempId;
  final bool? isSynced;
  final String? user;
  final UserModel? userData;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WalletProviderModel({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.localImagePath,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType,
    this.color,
    this.websiteUrl,
    this.isFiatBank,
    this.isCrypto,
    this.isMobileMoney,
    this.isCreditCard,
    this.tempId,
    this.isSynced,
    this.user,
    this.userData,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletProviderModel.fromJson(Map<String, dynamic> json) {
    return WalletProviderModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      localImagePath: json['localImagePath'] as String?,
      iconCodePoint: json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String?,
      color: json['color'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      isFiatBank: json['isFiatBank'] as bool?,
      isCrypto: json['isCrypto'] as bool?,
      isMobileMoney: json['isMobileMoney'] as bool?,
      isCreditCard: json['isCreditCard'] as bool?,
      tempId: json['tempId'] as String?,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'localImagePath': localImagePath,
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'websiteUrl': websiteUrl,
      'isFiatBank': isFiatBank,
      'isCrypto': isCrypto,
      'isMobileMoney': isMobileMoney,
      'isCreditCard': isCreditCard,
      'tempId': tempId,
      'isSynced': isSynced,
      'user': user,
      'metadata': metadata,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  WalletProvidersCompanion toCompanion({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? localImagePath,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    String? websiteUrl,
    bool? isFiatBank,
    bool? isCrypto,
    bool? isMobileMoney,
    bool? isCreditCard,
    String? tempId,
    bool? isSynced,
    String? user,
    UserModel? userData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletProvidersCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      description: description != null ? Value(description) : (this.description != null ? Value(this.description!) : const Value.absent()),
      imageUrl: imageUrl != null ? Value(imageUrl) : (this.imageUrl != null ? Value(this.imageUrl!) : const Value.absent()),
      localImagePath: localImagePath != null ? Value(localImagePath) : (this.localImagePath != null ? Value(this.localImagePath!) : const Value.absent()),
      iconCodePoint: iconCodePoint != null ? Value(iconCodePoint) : (this.iconCodePoint != null ? Value(this.iconCodePoint!) : const Value.absent()),
      iconEmoji: iconEmoji != null ? Value(iconEmoji) : (this.iconEmoji != null ? Value(this.iconEmoji!) : const Value.absent()),
      iconType: iconType != null ? Value(iconType) : (this.iconType != null ? Value(this.iconType!) : const Value.absent()),
      color: color != null ? Value(color) : (this.color != null ? Value(this.color!) : const Value.absent()),
      websiteUrl: websiteUrl != null ? Value(websiteUrl) : (this.websiteUrl != null ? Value(this.websiteUrl!) : const Value.absent()),
      isFiatBank: isFiatBank != null ? Value(isFiatBank) : (this.isFiatBank != null ? Value(this.isFiatBank!) : const Value.absent()),
      isCrypto: isCrypto != null ? Value(isCrypto) : (this.isCrypto != null ? Value(this.isCrypto!) : const Value.absent()),
      isMobileMoney: isMobileMoney != null ? Value(isMobileMoney) : (this.isMobileMoney != null ? Value(this.isMobileMoney!) : const Value.absent()),
      isCreditCard: isCreditCard != null ? Value(isCreditCard) : (this.isCreditCard != null ? Value(this.isCreditCard!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

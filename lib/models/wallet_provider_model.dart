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

  /// Converts a Drift database record to a WalletProviderModel
  factory WalletProviderModel.fromDrift(WalletProvider walletProvider) {
    return WalletProviderModel(
      id: walletProvider.id,
      name: walletProvider.name,
      description: walletProvider.description,
      imageUrl: walletProvider.imageUrl,
      localImagePath: walletProvider.localImagePath,
      iconCodePoint: walletProvider.iconCodePoint,
      iconEmoji: walletProvider.iconEmoji,
      iconType: walletProvider.iconType,
      color: walletProvider.color,
      websiteUrl: walletProvider.websiteUrl,
      isFiatBank: walletProvider.isFiatBank,
      isCrypto: walletProvider.isCrypto,
      isMobileMoney: walletProvider.isMobileMoney,
      isCreditCard: walletProvider.isCreditCard,
      tempId: walletProvider.tempId,
      isSynced: walletProvider.isSynced,
      user: walletProvider.userId,
      createdAt: walletProvider.createdAt,
      updatedAt: walletProvider.updatedAt,
    );
  }


  /// Compares this WalletProviderModel with another for equality
  bool isEqualTo(WalletProviderModel other) {
    return id == other.id &&
        name == other.name &&
        description == other.description &&
        imageUrl == other.imageUrl &&
        localImagePath == other.localImagePath &&
        iconCodePoint == other.iconCodePoint &&
        iconEmoji == other.iconEmoji &&
        iconType == other.iconType &&
        color == other.color &&
        websiteUrl == other.websiteUrl &&
        isFiatBank == other.isFiatBank &&
        isCrypto == other.isCrypto &&
        isMobileMoney == other.isMobileMoney &&
        isCreditCard == other.isCreditCard &&
        tempId == other.tempId &&
        isSynced == other.isSynced &&
        user == other.user;
  }

  /// Updates this WalletProviderModel with another, prioritizing non-null fields from the other
  WalletProviderModel merge(WalletProviderModel other) {
    return WalletProviderModel(
      id: other.id ?? id,
      name: other.name ?? name,
      description: other.description ?? description,
      imageUrl: other.imageUrl ?? imageUrl,
      localImagePath: other.localImagePath ?? localImagePath,
      iconCodePoint: other.iconCodePoint ?? iconCodePoint,
      iconEmoji: other.iconEmoji ?? iconEmoji,
      iconType: other.iconType ?? iconType,
      color: other.color ?? color,
      websiteUrl: other.websiteUrl ?? websiteUrl,
      isFiatBank: other.isFiatBank ?? isFiatBank,
      isCrypto: other.isCrypto ?? isCrypto,
      isMobileMoney: other.isMobileMoney ?? isMobileMoney,
      isCreditCard: other.isCreditCard ?? isCreditCard,
      tempId: other.tempId ?? tempId,
      isSynced: other.isSynced ?? isSynced,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this WalletProviderModel with the given fields replaced with new values
  WalletProviderModel copyWith({
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
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletProviderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      iconType: iconType ?? this.iconType,
      color: color ?? this.color,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      isFiatBank: isFiatBank ?? this.isFiatBank,
      isCrypto: isCrypto ?? this.isCrypto,
      isMobileMoney: isMobileMoney ?? this.isMobileMoney,
      isCreditCard: isCreditCard ?? this.isCreditCard,
      tempId: tempId ?? this.tempId,
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

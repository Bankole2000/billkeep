import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'currency_model.dart';
import 'project_model.dart';
import 'wallet_provider_model.dart';
import 'user_model.dart';

class WalletModel {
  final String? id;
  final String? walletType;
  final int? balance;
  final String? imageUrl;
  final String? localImagePath;
  final bool? isGlobal;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String? iconType;
  final String? color;
  final String? name;
  final String? tempId;
  final bool? isSynced;
  final String? user;
  final UserModel? userData;
  final Map<String, dynamic>? metadata;
  final String? currency;
  final CurrencyModel? currencyData;
  final String? provider;
  final WalletProviderModel? providerData;
  final String? project;
  final ProjectModel? projectData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WalletModel({
    this.id,
    this.walletType,
    this.balance,
    this.imageUrl,
    this.localImagePath,
    this.isGlobal,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType,
    this.color,
    this.name,
    this.tempId,
    this.isSynced,
    this.user,
    this.userData,
    this.metadata,
    this.currency,
    this.currencyData,
    this.provider,
    this.providerData,
    this.project,
    this.projectData,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String?,
      walletType: json['walletType'] as String?,
      balance: json['balance'] as int?,
      imageUrl: json['imageUrl'] as String?,
      localImagePath: json['localImagePath'] as String?,
      isGlobal: json['isGlobal'] as bool?,
      iconCodePoint: json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String?,
      color: json['color'] as String?,
      name: json['name'] as String?,
      tempId: json['tempId'] as String?,
      isSynced: json['isSynced'] as bool?,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      currency: json['currency'] as String?,
      currencyData: json['expand']?['currency'] != null
          ? CurrencyModel.fromJson(json['expand']['currency'] as Map<String, dynamic>)
          : null,
      provider: json['provider'] as String?,
      providerData: json['expand']?['provider'] != null
          ? WalletProviderModel.fromJson(json['expand']['provider'] as Map<String, dynamic>)
          : null,
      project: json['project'] as String?,
      projectData: json['expand']?['project'] != null
          ? ProjectModel.fromJson(json['expand']['project'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts a Drift database record to a WalletModel
  factory WalletModel.fromDrift(Wallet wallet) {
    return WalletModel(
      id: wallet.id,
      walletType: wallet.walletType,
      balance: wallet.balance,
      imageUrl: wallet.imageUrl,
      localImagePath: wallet.localImagePath,
      isGlobal: wallet.isGlobal,
      iconCodePoint: wallet.iconCodePoint,
      iconEmoji: wallet.iconEmoji,
      iconType: wallet.iconType,
      color: wallet.color,
      name: wallet.name,
      tempId: wallet.tempId,
      isSynced: wallet.isSynced,
      user: wallet.userId,
      currency: wallet.currency,
      provider: wallet.providerId,
      project: wallet.projectId,
      createdAt: wallet.createdAt,
      updatedAt: wallet.updatedAt,
    );
  }


  /// Compares this WalletModel with another for equality
  bool isEqualTo(WalletModel other) {
    return id == other.id &&
        walletType == other.walletType &&
        balance == other.balance &&
        imageUrl == other.imageUrl &&
        localImagePath == other.localImagePath &&
        isGlobal == other.isGlobal &&
        iconCodePoint == other.iconCodePoint &&
        iconEmoji == other.iconEmoji &&
        iconType == other.iconType &&
        color == other.color &&
        name == other.name &&
        tempId == other.tempId &&
        isSynced == other.isSynced &&
        user == other.user &&
        currency == other.currency &&
        provider == other.provider &&
        project == other.project;
  }

  /// Updates this WalletModel with another, prioritizing non-null fields from the other
  WalletModel merge(WalletModel other) {
    return WalletModel(
      id: other.id ?? id,
      walletType: other.walletType ?? walletType,
      balance: other.balance ?? balance,
      imageUrl: other.imageUrl ?? imageUrl,
      localImagePath: other.localImagePath ?? localImagePath,
      isGlobal: other.isGlobal ?? isGlobal,
      iconCodePoint: other.iconCodePoint ?? iconCodePoint,
      iconEmoji: other.iconEmoji ?? iconEmoji,
      iconType: other.iconType ?? iconType,
      color: other.color ?? color,
      name: other.name ?? name,
      tempId: other.tempId ?? tempId,
      isSynced: other.isSynced ?? isSynced,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      currency: other.currency ?? currency,
      currencyData: other.currencyData ?? currencyData,
      provider: other.provider ?? provider,
      providerData: other.providerData ?? providerData,
      project: other.project ?? project,
      projectData: other.projectData ?? projectData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walletType': walletType,
      'balance': balance,
      'imageUrl': imageUrl,
      'localImagePath': localImagePath,
      'isGlobal': isGlobal,
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'name': name,
      'tempId': tempId,
      'isSynced': isSynced,
      'user': user,
      'metadata': metadata,
      'currency': currency,
      'provider': provider,
      'project': project,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Creates a copy of this WalletModel with the given fields replaced with new values
  WalletModel copyWith({
    String? id,
    String? walletType,
    int? balance,
    String? imageUrl,
    String? localImagePath,
    bool? isGlobal,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    String? name,
    String? tempId,
    bool? isSynced,
    String? user,
    UserModel? userData,
    Map<String, dynamic>? metadata,
    String? currency,
    CurrencyModel? currencyData,
    String? provider,
    WalletProviderModel? providerData,
    String? project,
    ProjectModel? projectData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletModel(
      id: id ?? this.id,
      walletType: walletType ?? this.walletType,
      balance: balance ?? this.balance,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      isGlobal: isGlobal ?? this.isGlobal,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      iconType: iconType ?? this.iconType,
      color: color ?? this.color,
      name: name ?? this.name,
      tempId: tempId ?? this.tempId,
      isSynced: isSynced ?? this.isSynced,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      metadata: metadata ?? this.metadata,
      currency: currency ?? this.currency,
      currencyData: currencyData ?? this.currencyData,
      provider: provider ?? this.provider,
      providerData: providerData ?? this.providerData,
      project: project ?? this.project,
      projectData: projectData ?? this.projectData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts this model to a Drift Companion for database operations
  WalletsCompanion toCompanion({
    String? id,
    String? walletType,
    int? balance,
    String? imageUrl,
    String? localImagePath,
    bool? isGlobal,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    String? name,
    String? tempId,
    bool? isSynced,
    String? user,
    UserModel? userData,
    String? currency,
    CurrencyModel? currencyData,
    String? provider,
    WalletProviderModel? providerData,
    String? project,
    ProjectModel? projectData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletsCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      walletType: walletType != null ? Value(walletType) : (this.walletType != null ? Value(this.walletType!) : const Value.absent()),
      balance: balance != null ? Value(balance) : (this.balance != null ? Value(this.balance!) : const Value.absent()),
      imageUrl: imageUrl != null ? Value(imageUrl) : (this.imageUrl != null ? Value(this.imageUrl!) : const Value.absent()),
      localImagePath: localImagePath != null ? Value(localImagePath) : (this.localImagePath != null ? Value(this.localImagePath!) : const Value.absent()),
      isGlobal: isGlobal != null ? Value(isGlobal) : (this.isGlobal != null ? Value(this.isGlobal!) : const Value.absent()),
      iconCodePoint: iconCodePoint != null ? Value(iconCodePoint) : (this.iconCodePoint != null ? Value(this.iconCodePoint!) : const Value.absent()),
      iconEmoji: iconEmoji != null ? Value(iconEmoji) : (this.iconEmoji != null ? Value(this.iconEmoji!) : const Value.absent()),
      iconType: iconType != null ? Value(iconType) : (this.iconType != null ? Value(this.iconType!) : const Value.absent()),
      color: color != null ? Value(color) : (this.color != null ? Value(this.color!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      currency: currency != null ? Value(currency) : (this.currency != null ? Value(this.currency!) : const Value.absent()),
      // currencyData: currencyData != null ? Value(currencyData) : (this.currencyData != null ? Value(this.currencyData!) : const Value.absent()),
      providerId: provider != null ? Value(provider) : (this.provider != null ? Value(this.provider!) : const Value.absent()),
      // providerData: providerData != null ? Value(providerData) : (this.providerData != null ? Value(this.providerData!) : const Value.absent()),
      projectId: project != null ? Value(project) : (this.project != null ? Value(this.project!) : const Value.absent()),
      // projectData: projectData != null ? Value(projectData) : (this.projectData != null ? Value(this.projectData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

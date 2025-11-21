import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'wallet_model.dart';
import 'user_model.dart';

class ProjectModel {
  final String? id;
  final String? name;
  final String? description;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String? iconType;
  final String? imageUrl;
  final String? localImagePath;
  final String? color;
  final bool? isSynced;
  final String? tempId;
  final bool? isArchived;
  final String? defaultWallet;
  final WalletModel? defaultWalletData;
  final String? user;
  final UserModel? userData;
  final String? status;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProjectModel({
    this.id,
    this.name,
    this.description,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType,
    this.imageUrl,
    this.localImagePath,
    this.color,
    this.isSynced,
    this.tempId,
    this.isArchived,
    this.defaultWallet,
    this.defaultWalletData,
    this.user,
    this.userData,
    this.status,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      iconCodePoint: json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String?,
      imageUrl: json['imageUrl'] as String?,
      localImagePath: json['localImagePath'] as String?,
      color: json['color'] as String?,
      isSynced: json['isSynced'] as bool?,
      tempId: json['tempId'] as String?,
      isArchived: json['isArchived'] as bool?,
      defaultWallet: json['defaultWallet'] as String?,
      defaultWalletData: json['expand']?['defaultWallet'] != null
          ? WalletModel.fromJson(json['expand']['defaultWallet'] as Map<String, dynamic>)
          : null,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      status: json['status'] as String?,
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
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'imageUrl': imageUrl,
      'localImagePath': localImagePath,
      'color': color,
      'isSynced': isSynced,
      'tempId': tempId,
      'isArchived': isArchived,
      'defaultWallet': defaultWallet,
      'user': user,
      'status': status,
      'metadata': metadata,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  ProjectsCompanion toCompanion({
    String? id,
    String? name,
    String? description,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? imageUrl,
    String? localImagePath,
    String? color,
    bool? isSynced,
    String? tempId,
    bool? isArchived,
    String? defaultWallet,
    WalletModel? defaultWalletData,
    String? user,
    UserModel? userData,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectsCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      description: description != null ? Value(description) : (this.description != null ? Value(this.description!) : const Value.absent()),
      iconCodePoint: iconCodePoint != null ? Value(iconCodePoint) : (this.iconCodePoint != null ? Value(this.iconCodePoint!) : const Value.absent()),
      iconEmoji: iconEmoji != null ? Value(iconEmoji) : (this.iconEmoji != null ? Value(this.iconEmoji!) : const Value.absent()),
      iconType: iconType != null ? Value(iconType) : (this.iconType != null ? Value(this.iconType!) : const Value.absent()),
      imageUrl: imageUrl != null ? Value(imageUrl) : (this.imageUrl != null ? Value(this.imageUrl!) : const Value.absent()),
      localImagePath: localImagePath != null ? Value(localImagePath) : (this.localImagePath != null ? Value(this.localImagePath!) : const Value.absent()),
      color: color != null ? Value(color) : (this.color != null ? Value(this.color!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      isArchived: isArchived != null ? Value(isArchived) : (this.isArchived != null ? Value(this.isArchived!) : const Value.absent()),
      defaultWallet: defaultWallet != null ? Value(defaultWallet) : (this.defaultWallet != null ? Value(this.defaultWallet!) : const Value.absent()),
      // defaultWalletData: defaultWalletData != null ? Value(defaultWalletData) : (this.defaultWalletData != null ? Value(this.defaultWalletData!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      status: status != null ? Value(status) : (this.status != null ? Value(this.status!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

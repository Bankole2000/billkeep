import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

import 'user_model.dart';

class ContactModel {
  final String? id;
  final String? name;
  final String? tempId;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String? iconType;
  final String? color;
  final bool? isSynced;
  final String? imageUrl;
  final String? localImagePath;
  final Map<String, dynamic>? metadata;
  final String? user;
  final UserModel? userData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ContactModel({
    this.id,
    this.name,
    this.tempId,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType,
    this.color,
    this.isSynced,
    this.imageUrl,
    this.localImagePath,
    this.metadata,
    this.user,
    this.userData,
    this.createdAt,
    this.updatedAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      tempId: json['tempId'] as String?,
      iconCodePoint: json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String?,
      color: json['color'] as String?,
      isSynced: json['isSynced'] as bool?,
      imageUrl: json['imageUrl'] as String?,
      localImagePath: json['localImagePath'] as String?,
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

  /// Converts a Drift database record to a ContactModel
  factory ContactModel.fromDrift(Contact contact) {
    return ContactModel(
      id: contact.id,
      name: contact.name,
      tempId: contact.tempId,
      iconCodePoint: contact.iconCodePoint,
      iconEmoji: contact.iconEmoji,
      iconType: contact.iconType,
      color: contact.color,
      isSynced: contact.isSynced,
      imageUrl: contact.imageUrl,
      localImagePath: contact.localImagePath,
      user: contact.userId,
      createdAt: contact.createdAt,
      updatedAt: contact.updatedAt,
    );
  }


  /// Compares this ContactModel with another for equality
  bool isEqualTo(ContactModel other) {
    return id == other.id &&
        name == other.name &&
        tempId == other.tempId &&
        iconCodePoint == other.iconCodePoint &&
        iconEmoji == other.iconEmoji &&
        iconType == other.iconType &&
        color == other.color &&
        isSynced == other.isSynced &&
        imageUrl == other.imageUrl &&
        localImagePath == other.localImagePath &&
        user == other.user;
  }

  /// Updates this ContactModel with another, prioritizing non-null fields from the other
  ContactModel merge(ContactModel other) {
    return ContactModel(
      id: other.id ?? id,
      name: other.name ?? name,
      tempId: other.tempId ?? tempId,
      iconCodePoint: other.iconCodePoint ?? iconCodePoint,
      iconEmoji: other.iconEmoji ?? iconEmoji,
      iconType: other.iconType ?? iconType,
      color: other.color ?? color,
      isSynced: other.isSynced ?? isSynced,
      imageUrl: other.imageUrl ?? imageUrl,
      localImagePath: other.localImagePath ?? localImagePath,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this ContactModel with the given fields replaced with new values
  ContactModel copyWith({
    String? id,
    String? name,
    String? tempId,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    bool? isSynced,
    String? imageUrl,
    String? localImagePath,
    Map<String, dynamic>? metadata,
    String? user,
    UserModel? userData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      tempId: tempId ?? this.tempId,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      iconType: iconType ?? this.iconType,
      color: color ?? this.color,
      isSynced: isSynced ?? this.isSynced,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
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
      'tempId': tempId,
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'isSynced': isSynced,
      'imageUrl': imageUrl,
      'localImagePath': localImagePath,
      'metadata': metadata,
      'user': user,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  ContactsCompanion toCompanion({
    String? id,
    String? name,
    String? tempId,
    int? iconCodePoint,
    String? iconEmoji,
    String? iconType,
    String? color,
    bool? isSynced,
    String? imageUrl,
    String? localImagePath,
    String? user,
    UserModel? userData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ContactsCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      iconCodePoint: iconCodePoint != null ? Value(iconCodePoint) : (this.iconCodePoint != null ? Value(this.iconCodePoint!) : const Value.absent()),
      iconEmoji: iconEmoji != null ? Value(iconEmoji) : (this.iconEmoji != null ? Value(this.iconEmoji!) : const Value.absent()),
      iconType: iconType != null ? Value(iconType) : (this.iconType != null ? Value(this.iconType!) : const Value.absent()),
      color: color != null ? Value(color) : (this.color != null ? Value(this.color!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      imageUrl: imageUrl != null ? Value(imageUrl) : (this.imageUrl != null ? Value(this.imageUrl!) : const Value.absent()),
      localImagePath: localImagePath != null ? Value(localImagePath) : (this.localImagePath != null ? Value(this.localImagePath!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

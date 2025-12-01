import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'user_model.dart';
import 'wallet_provider_model.dart';

class WalletProviderMetadataModel {
  final String? id;
  final String? name;
  final String? type;
  final String? stringValue;
  final int? numberValue;
  final bool? booleanValue;
  final DateTime? dateTimeValue;
  final String? urlValue;
  final String? emailValue;
  final String? user;
  final UserModel? userData;
  final String? walletProvider;
  final WalletProviderModel? walletProviderData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WalletProviderMetadataModel({
    this.id,
    this.name,
    this.type,
    this.stringValue,
    this.numberValue,
    this.booleanValue,
    this.dateTimeValue,
    this.urlValue,
    this.emailValue,
    this.user,
    this.userData,
    this.walletProvider,
    this.walletProviderData,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletProviderMetadataModel.fromJson(Map<String, dynamic> json) {
    return WalletProviderMetadataModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      stringValue: json['stringValue'] as String?,
      numberValue: json['numberValue'] as int?,
      booleanValue: json['booleanValue'] as bool?,
      dateTimeValue: json['dateTimeValue'] != null
          ? DateTime.parse(json['dateTimeValue'] as String)
          : null,
      urlValue: json['urlValue'] as String?,
      emailValue: json['emailValue'] as String?,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      walletProvider: json['walletProvider'] as String?,
      walletProviderData: json['expand']?['walletProvider'] != null
          ? WalletProviderModel.fromJson(json['expand']['walletProvider'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts a Drift database record to a WalletProviderMetadataModel
  factory WalletProviderMetadataModel.fromDrift(WalletProviderMetadataData metadata) {
    return WalletProviderMetadataModel(
      id: metadata.id,
      name: metadata.name,
      type: metadata.type,
      stringValue: metadata.stringValue,
      numberValue: metadata.numberValue,
      booleanValue: metadata.booleanValue,
      dateTimeValue: metadata.dateTimeValue,
      urlValue: metadata.urlValue,
      emailValue: metadata.emailValue,
      user: metadata.userId,
      walletProvider: metadata.walletProviderId,
      createdAt: metadata.createdAt,
      updatedAt: metadata.updatedAt,
    );
  }


  /// Compares this WalletProviderMetadataModel with another for equality
  bool isEqualTo(WalletProviderMetadataModel other) {
    return id == other.id &&
        name == other.name &&
        type == other.type &&
        stringValue == other.stringValue &&
        numberValue == other.numberValue &&
        booleanValue == other.booleanValue &&
        dateTimeValue == other.dateTimeValue &&
        urlValue == other.urlValue &&
        emailValue == other.emailValue &&
        user == other.user &&
        walletProvider == other.walletProvider;
  }

  /// Updates this WalletProviderMetadataModel with another, prioritizing non-null fields from the other
  WalletProviderMetadataModel merge(WalletProviderMetadataModel other) {
    return WalletProviderMetadataModel(
      id: other.id ?? id,
      name: other.name ?? name,
      type: other.type ?? type,
      stringValue: other.stringValue ?? stringValue,
      numberValue: other.numberValue ?? numberValue,
      booleanValue: other.booleanValue ?? booleanValue,
      dateTimeValue: other.dateTimeValue ?? dateTimeValue,
      urlValue: other.urlValue ?? urlValue,
      emailValue: other.emailValue ?? emailValue,
      user: other.user ?? user,
      userData: other.userData ?? userData,
      walletProvider: other.walletProvider ?? walletProvider,
      walletProviderData: other.walletProviderData ?? walletProviderData,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }
  /// Creates a copy of this WalletProviderMetadataModel with the given fields replaced with new values
  WalletProviderMetadataModel copyWith({
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
    String? walletProvider,
    WalletProviderModel? walletProviderData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletProviderMetadataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      stringValue: stringValue ?? this.stringValue,
      numberValue: numberValue ?? this.numberValue,
      booleanValue: booleanValue ?? this.booleanValue,
      dateTimeValue: dateTimeValue ?? this.dateTimeValue,
      urlValue: urlValue ?? this.urlValue,
      emailValue: emailValue ?? this.emailValue,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      walletProvider: walletProvider ?? this.walletProvider,
      walletProviderData: walletProviderData ?? this.walletProviderData,
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
      'urlValue': urlValue,
      'emailValue': emailValue,
      'user': user,
      'walletProvider': walletProvider,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  WalletProviderMetadataCompanion toCompanion({
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
    String? walletProvider,
    WalletProviderModel? walletProviderData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletProviderMetadataCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      type: type != null ? Value(type) : (this.type != null ? Value(this.type!) : const Value.absent()),
      stringValue: stringValue != null ? Value(stringValue) : (this.stringValue != null ? Value(this.stringValue!) : const Value.absent()),
      numberValue: numberValue != null ? Value(numberValue) : (this.numberValue != null ? Value(this.numberValue!) : const Value.absent()),
      booleanValue: booleanValue != null ? Value(booleanValue) : (this.booleanValue != null ? Value(this.booleanValue!) : const Value.absent()),
      dateTimeValue: dateTimeValue != null ? Value(dateTimeValue) : (this.dateTimeValue != null ? Value(this.dateTimeValue!) : const Value.absent()),
      urlValue: urlValue != null ? Value(urlValue) : (this.urlValue != null ? Value(this.urlValue!) : const Value.absent()),
      emailValue: emailValue != null ? Value(emailValue) : (this.emailValue != null ? Value(this.emailValue!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      walletProviderId: walletProvider != null ? Value(walletProvider) : (this.walletProvider != null ? Value(this.walletProvider!) : const Value.absent()),
      // walletProviderData: walletProviderData != null ? Value(walletProviderData) : (this.walletProviderData != null ? Value(this.walletProviderData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

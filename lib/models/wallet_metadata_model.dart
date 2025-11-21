import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

import 'user_model.dart';
import 'wallet_model.dart';

class WalletMetadataModel {
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
  final String? wallet;
  final WalletModel? walletData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WalletMetadataModel({
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
    this.wallet,
    this.walletData,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletMetadataModel.fromJson(Map<String, dynamic> json) {
    return WalletMetadataModel(
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
      wallet: json['wallet'] as String?,
      walletData: json['expand']?['wallet'] != null
          ? WalletModel.fromJson(json['expand']['wallet'] as Map<String, dynamic>)
          : null,
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
      'type': type,
      'stringValue': stringValue,
      'numberValue': numberValue,
      'booleanValue': booleanValue,
      'dateTimeValue': dateTimeValue?.toIso8601String(),
      'urlValue': urlValue,
      'emailValue': emailValue,
      'user': user,
      'wallet': wallet,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  WalletMetadataCompanion toCompanion({
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
    String? wallet,
    WalletModel? walletData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletMetadataCompanion(
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
      walletId: wallet != null ? Value(wallet) : (this.wallet != null ? Value(this.wallet!) : const Value.absent()),
      // walletData: walletData != null ? Value(walletData) : (this.walletData != null ? Value(this.walletData!) : const Value.absent()),
      createdAt: createdAt != null ? Value(createdAt) : (this.createdAt != null ? Value(this.createdAt!) : const Value.absent()),
      updatedAt: updatedAt != null ? Value(updatedAt) : (this.updatedAt != null ? Value(this.updatedAt!) : const Value.absent()),
    );
  }

}

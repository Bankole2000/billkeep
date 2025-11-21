import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

import 'user_model.dart';

class CurrencyModel {
  final String? id;
  final String? code;
  final String? name;
  final String? symbol;
  final int? decimals;
  final bool? isCrypto;
  final bool? isActive;
  final String? user;
  final UserModel? userData;
  final bool? isSynced;
  final String? tempId;
  final Map<String, dynamic>? metadata;
  final DateTime? created;
  final DateTime? updated;

  CurrencyModel({
    this.id,
    this.code,
    this.name,
    this.symbol,
    this.decimals,
    this.isCrypto,
    this.isActive,
    this.user,
    this.userData,
    this.isSynced,
    this.tempId,
    this.metadata,
    this.created,
    this.updated,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      decimals: json['decimals'] as int?,
      isCrypto: json['isCrypto'] as bool?,
      isActive: json['isActive'] as bool?,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
      isSynced: json['isSynced'] as bool?,
      tempId: json['tempId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      created: json['created'] != null
          ? DateTime.parse(json['created'] as String)
          : null,
      updated: json['updated'] != null
          ? DateTime.parse(json['updated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'symbol': symbol,
      'decimals': decimals,
      'isCrypto': isCrypto,
      'isActive': isActive,
      'user': user,
      'isSynced': isSynced,
      'tempId': tempId,
      'metadata': metadata,
      'created': created?.toIso8601String(),
      'updated': updated?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  CurrenciesCompanion toCompanion({
    String? id,
    String? code,
    String? name,
    String? symbol,
    int? decimals,
    bool? isCrypto,
    bool? isActive,
    String? user,
    UserModel? userData,
    bool? isSynced,
    String? tempId,
    DateTime? created,
    DateTime? updated,
  }) {
    return CurrenciesCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      code: code != null ? Value(code) : (this.code != null ? Value(this.code!) : const Value.absent()),
      name: name != null ? Value(name) : (this.name != null ? Value(this.name!) : const Value.absent()),
      symbol: symbol != null ? Value(symbol) : (this.symbol != null ? Value(this.symbol!) : const Value.absent()),
      decimals: decimals != null ? Value(decimals) : (this.decimals != null ? Value(this.decimals!) : const Value.absent()),
      isCrypto: isCrypto != null ? Value(isCrypto) : (this.isCrypto != null ? Value(this.isCrypto!) : const Value.absent()),
      isActive: isActive != null ? Value(isActive) : (this.isActive != null ? Value(this.isActive!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      isSynced: isSynced != null ? Value(isSynced) : (this.isSynced != null ? Value(this.isSynced!) : const Value.absent()),
      tempId: tempId != null ? Value(tempId) : (this.tempId != null ? Value(this.tempId!) : const Value.absent()),
      created: created != null ? Value(created) : (this.created != null ? Value(this.created!) : const Value.absent()),
      updated: updated != null ? Value(updated) : (this.updated != null ? Value(this.updated!) : const Value.absent()),
    );
  }

}

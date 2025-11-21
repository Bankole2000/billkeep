import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'investment_model.dart';
import 'payment_model.dart';
import 'user_model.dart';

class InvestmentPaymentModel {
  final String? id;
  final String? payment;
  final PaymentModel? paymentData;
  final String? investment;
  final InvestmentModel? investmentData;
  final int? allocatedAmount;
  final DateTime? allocatedAt;
  final String? notes;
  final String? user;
  final UserModel? userData;
  final Map<String, dynamic>? metadata;
  final DateTime? created;
  final DateTime? updated;

  InvestmentPaymentModel({
    this.id,
    this.payment,
    this.paymentData,
    this.investment,
    this.investmentData,
    this.allocatedAmount,
    this.allocatedAt,
    this.notes,
    this.user,
    this.userData,
    this.metadata,
    this.created,
    this.updated,
  });

  factory InvestmentPaymentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentPaymentModel(
      id: json['id'] as String?,
      payment: json['payment'] as String?,
      paymentData: json['expand']?['payment'] != null
          ? PaymentModel.fromJson(json['expand']['payment'] as Map<String, dynamic>)
          : null,
      investment: json['investment'] as String?,
      investmentData: json['expand']?['investment'] != null
          ? InvestmentModel.fromJson(json['expand']['investment'] as Map<String, dynamic>)
          : null,
      allocatedAmount: json['allocatedAmount'] as int?,
      allocatedAt: json['allocatedAt'] != null
          ? DateTime.parse(json['allocatedAt'] as String)
          : null,
      notes: json['notes'] as String?,
      user: json['user'] as String?,
      userData: json['expand']?['user'] != null
          ? UserModel.fromJson(json['expand']['user'] as Map<String, dynamic>)
          : null,
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
      'payment': payment,
      'investment': investment,
      'allocatedAmount': allocatedAmount,
      'allocatedAt': allocatedAt?.toIso8601String(),
      'notes': notes,
      'user': user,
      'metadata': metadata,
      'created': created?.toIso8601String(),
      'updated': updated?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  InvestmentPaymentsCompanion toCompanion({
    String? id,
    String? payment,
    PaymentModel? paymentData,
    String? investment,
    InvestmentModel? investmentData,
    int? allocatedAmount,
    DateTime? allocatedAt,
    String? notes,
    String? user,
    UserModel? userData,
    DateTime? created,
    DateTime? updated,
  }) {
    return InvestmentPaymentsCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      paymentId: payment != null ? Value(payment) : (this.payment != null ? Value(this.payment!) : const Value.absent()),
      // paymentData: paymentData != null ? Value(paymentData) : (this.paymentData != null ? Value(this.paymentData!) : const Value.absent()),
      investmentId: investment != null ? Value(investment) : (this.investment != null ? Value(this.investment!) : const Value.absent()),
      // investmentData: investmentData != null ? Value(investmentData) : (this.investmentData != null ? Value(this.investmentData!) : const Value.absent()),
      allocatedAmount: allocatedAmount != null ? Value(allocatedAmount) : (this.allocatedAmount != null ? Value(this.allocatedAmount!) : const Value.absent()),
      allocatedAt: allocatedAt != null ? Value(allocatedAt) : (this.allocatedAt != null ? Value(this.allocatedAt!) : const Value.absent()),
      notes: notes != null ? Value(notes) : (this.notes != null ? Value(this.notes!) : const Value.absent()),
      userId: user != null ? Value(user) : (this.user != null ? Value(this.user!) : const Value.absent()),
      // userData: userData != null ? Value(userData) : (this.userData != null ? Value(this.userData!) : const Value.absent()),
      created: created != null ? Value(created) : (this.created != null ? Value(this.created!) : const Value.absent()),
      updated: updated != null ? Value(updated) : (this.updated != null ? Value(this.updated!) : const Value.absent()),
    );
  }

}

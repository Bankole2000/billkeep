import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';
import 'goal_model.dart';
import 'payment_model.dart';

class GoalContributionModel {
  final String? id;
  final String? payment;
  final PaymentModel? paymentData;
  final String? goal;
  final GoalModel? goalData;
  final int? allocatedAmount;
  final DateTime? allocatedAt;
  final String? notes;
  final DateTime? created;
  final DateTime? updated;

  GoalContributionModel({
    this.id,
    this.payment,
    this.paymentData,
    this.goal,
    this.goalData,
    this.allocatedAmount,
    this.allocatedAt,
    this.notes,
    this.created,
    this.updated,
  });

  factory GoalContributionModel.fromJson(Map<String, dynamic> json) {
    return GoalContributionModel(
      id: json['id'] as String?,
      payment: json['payment'] as String?,
      paymentData: json['expand']?['payment'] != null
          ? PaymentModel.fromJson(json['expand']['payment'] as Map<String, dynamic>)
          : null,
      goal: json['goal'] as String?,
      goalData: json['expand']?['goal'] != null
          ? GoalModel.fromJson(json['expand']['goal'] as Map<String, dynamic>)
          : null,
      allocatedAmount: json['allocatedAmount'] as int?,
      allocatedAt: json['allocatedAt'] != null
          ? DateTime.parse(json['allocatedAt'] as String)
          : null,
      notes: json['notes'] as String?,
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
      'goal': goal,
      'allocatedAmount': allocatedAmount,
      'allocatedAt': allocatedAt?.toIso8601String(),
      'notes': notes,
      'created': created?.toIso8601String(),
      'updated': updated?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  GoalContributionCompanion toCompanion({
    String? id,
    String? payment,
    PaymentModel? paymentData,
    String? goal,
    GoalModel? goalData,
    int? allocatedAmount,
    DateTime? allocatedAt,
    String? notes,
    DateTime? created,
    DateTime? updated,
  }) {
    return GoalContributionCompanion(
      id: id != null ? Value(id) : (this.id != null ? Value(this.id!) : const Value.absent()),
      paymentId: payment != null ? Value(payment) : (this.payment != null ? Value(this.payment!) : const Value.absent()),
      // paymentData: paymentData != null ? Value(paymentData) : (this.paymentData != null ? Value(this.paymentData!) : const Value.absent()),
      goalId: goal != null ? Value(goal) : (this.goal != null ? Value(this.goal!) : const Value.absent()),
      // goalData: goalData != null ? Value(goalData) : (this.goalData != null ? Value(this.goalData!) : const Value.absent()),
      allocatedAmount: allocatedAmount != null ? Value(allocatedAmount) : (this.allocatedAmount != null ? Value(this.allocatedAmount!) : const Value.absent()),
      allocatedAt: allocatedAt != null ? Value(allocatedAt) : (this.allocatedAt != null ? Value(this.allocatedAt!) : const Value.absent()),
      notes: notes != null ? Value(notes) : (this.notes != null ? Value(this.notes!) : const Value.absent()),
      created: created != null ? Value(created) : (this.created != null ? Value(this.created!) : const Value.absent()),
      updated: updated != null ? Value(updated) : (this.updated != null ? Value(this.updated!) : const Value.absent()),
    );
  }

}

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

  /// Converts a Drift database record to a GoalContributionModel
  factory GoalContributionModel.fromDrift(GoalContributionData contribution) {
    return GoalContributionModel(
      id: contribution.id,
      payment: contribution.paymentId,
      goal: contribution.goalId,
      allocatedAmount: contribution.allocatedAmount,
      allocatedAt: contribution.allocatedAt,
      notes: contribution.notes,
      created: contribution.created,
      updated: contribution.updated,
    );
  }


  /// Compares this GoalContributionModel with another for equality
  bool isEqualTo(GoalContributionModel other) {
    return id == other.id &&
        payment == other.payment &&
        goal == other.goal &&
        allocatedAmount == other.allocatedAmount &&
        allocatedAt == other.allocatedAt &&
        notes == other.notes &&
        created == other.created &&
        updated == other.updated;
  }

  /// Updates this GoalContributionModel with another, prioritizing non-null fields from the other
  GoalContributionModel merge(GoalContributionModel other) {
    return GoalContributionModel(
      id: other.id ?? id,
      payment: other.payment ?? payment,
      paymentData: other.paymentData ?? paymentData,
      goal: other.goal ?? goal,
      goalData: other.goalData ?? goalData,
      allocatedAmount: other.allocatedAmount ?? allocatedAmount,
      allocatedAt: other.allocatedAt ?? allocatedAt,
      notes: other.notes ?? notes,
      created: other.created ?? created,
      updated: other.updated ?? updated,
    );
  }
  /// Creates a copy of this GoalContributionModel with the given fields replaced with new values
  GoalContributionModel copyWith({
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
    return GoalContributionModel(
      id: id ?? this.id,
      payment: payment ?? this.payment,
      paymentData: paymentData ?? this.paymentData,
      goal: goal ?? this.goal,
      goalData: goalData ?? this.goalData,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      allocatedAt: allocatedAt ?? this.allocatedAt,
      notes: notes ?? this.notes,
      created: created ?? this.created,
      updated: updated ?? this.updated,
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

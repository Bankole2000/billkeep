class ExpenseModel {
  final String id;
  final String projectId;
  final String name;
  final int expectedAmount;
  final String currency;
  final String type;
  final String? frequency;
  final DateTime startDate;
  final DateTime? nextRenewalDate;
  final String? categoryId;
  final String? merchantId;
  final String? contactId;
  final String? walletId;
  final String? investmentId;
  final String? goalId;
  final String? reminderId;
  final String source;
  final String? notes;
  final bool isActive;
  final bool isSynced;
  final String? tempId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExpenseModel({
    required this.id,
    required this.projectId,
    required this.name,
    required this.expectedAmount,
    required this.currency,
    required this.type,
    this.frequency,
    required this.startDate,
    this.nextRenewalDate,
    this.categoryId,
    this.merchantId,
    this.contactId,
    this.walletId,
    this.investmentId,
    this.goalId,
    this.reminderId,
    this.source = 'MANUAL',
    this.notes,
    this.isActive = true,
    this.isSynced = false,
    this.tempId,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      name: json['name'] as String,
      expectedAmount: json['expectedAmount'] as int,
      currency: json['currency'] as String,
      type: json['type'] as String,
      frequency: json['frequency'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      nextRenewalDate: json['nextRenewalDate'] != null
          ? DateTime.parse(json['nextRenewalDate'] as String)
          : null,
      categoryId: json['categoryId'] as String?,
      merchantId: json['merchantId'] as String?,
      contactId: json['contactId'] as String?,
      walletId: json['walletId'] as String?,
      investmentId: json['investmentId'] as String?,
      goalId: json['goalId'] as String?,
      reminderId: json['reminderId'] as String?,
      source: json['source'] as String? ?? 'MANUAL',
      notes: json['notes'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isSynced: json['isSynced'] as bool? ?? false,
      tempId: json['tempId'] as String?,
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
      'projectId': projectId,
      'name': name,
      'expectedAmount': expectedAmount,
      'currency': currency,
      'type': type,
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'nextRenewalDate': nextRenewalDate?.toIso8601String(),
      'categoryId': categoryId,
      'merchantId': merchantId,
      'contactId': contactId,
      'walletId': walletId,
      'investmentId': investmentId,
      'goalId': goalId,
      'reminderId': reminderId,
      'source': source,
      'notes': notes,
      'isActive': isActive,
      'isSynced': isSynced,
      'tempId': tempId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

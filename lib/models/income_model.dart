class IncomeModel {
  final String id;
  final String projectId;
  final String description;
  final int expectedAmount;
  final String currency;
  final String type;
  final String? frequency;
  final DateTime startDate;
  final DateTime? nextExpectedDate;
  final String? categoryId;
  final String? merchantId;
  final String? contactId;
  final String? walletId;
  final String? investmentId;
  final String? goalId;
  final String? reminderId;
  final String source;
  final String? invoiceNumber;
  final String? notes;
  final bool isActive;
  final bool isSynced;
  final String? tempId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IncomeModel({
    required this.id,
    required this.projectId,
    required this.description,
    required this.expectedAmount,
    required this.currency,
    required this.type,
    this.frequency,
    required this.startDate,
    this.nextExpectedDate,
    this.categoryId,
    this.merchantId,
    this.contactId,
    this.walletId,
    this.investmentId,
    this.goalId,
    this.reminderId,
    this.source = 'MANUAL',
    this.invoiceNumber,
    this.notes,
    this.isActive = true,
    this.isSynced = false,
    this.tempId,
    this.createdAt,
    this.updatedAt,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      description: json['description'] as String,
      expectedAmount: json['expectedAmount'] as int,
      currency: json['currency'] as String,
      type: json['type'] as String,
      frequency: json['frequency'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      nextExpectedDate: json['nextExpectedDate'] != null
          ? DateTime.parse(json['nextExpectedDate'] as String)
          : null,
      categoryId: json['categoryId'] as String?,
      merchantId: json['merchantId'] as String?,
      contactId: json['contactId'] as String?,
      walletId: json['walletId'] as String?,
      investmentId: json['investmentId'] as String?,
      goalId: json['goalId'] as String?,
      reminderId: json['reminderId'] as String?,
      source: json['source'] as String? ?? 'MANUAL',
      invoiceNumber: json['invoiceNumber'] as String?,
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
      'description': description,
      'expectedAmount': expectedAmount,
      'currency': currency,
      'type': type,
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'nextExpectedDate': nextExpectedDate?.toIso8601String(),
      'categoryId': categoryId,
      'merchantId': merchantId,
      'contactId': contactId,
      'walletId': walletId,
      'investmentId': investmentId,
      'goalId': goalId,
      'reminderId': reminderId,
      'source': source,
      'invoiceNumber': invoiceNumber,
      'notes': notes,
      'isActive': isActive,
      'isSynced': isSynced,
      'tempId': tempId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

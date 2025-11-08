class PaymentModel {
  final String id;
  final String paymentType;
  final String? categoryId;
  final String? merchantId;
  final String? contactId;
  final String? walletId;
  final String? expenseId;
  final String? incomeId;
  final String? investmentId;
  final String? debtId;
  final int actualAmount;
  final String currency;
  final DateTime paymentDate;
  final String source;
  final bool verified;
  final String? notes;
  final bool isSynced;
  final String? tempId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentModel({
    required this.id,
    required this.paymentType,
    this.categoryId,
    this.merchantId,
    this.contactId,
    this.walletId,
    this.expenseId,
    this.incomeId,
    this.investmentId,
    this.debtId,
    required this.actualAmount,
    required this.currency,
    required this.paymentDate,
    this.source = 'MANUAL',
    this.verified = true,
    this.notes,
    this.isSynced = false,
    this.tempId,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      paymentType: json['paymentType'] as String,
      categoryId: json['categoryId'] as String?,
      merchantId: json['merchantId'] as String?,
      contactId: json['contactId'] as String?,
      walletId: json['walletId'] as String?,
      expenseId: json['expenseId'] as String?,
      incomeId: json['incomeId'] as String?,
      investmentId: json['investmentId'] as String?,
      debtId: json['debtId'] as String?,
      actualAmount: json['actualAmount'] as int,
      currency: json['currency'] as String,
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      source: json['source'] as String? ?? 'MANUAL',
      verified: json['verified'] as bool? ?? true,
      notes: json['notes'] as String?,
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
      'paymentType': paymentType,
      'categoryId': categoryId,
      'merchantId': merchantId,
      'contactId': contactId,
      'walletId': walletId,
      'expenseId': expenseId,
      'incomeId': incomeId,
      'investmentId': investmentId,
      'debtId': debtId,
      'actualAmount': actualAmount,
      'currency': currency,
      'paymentDate': paymentDate.toIso8601String(),
      'source': source,
      'verified': verified,
      'notes': notes,
      'isSynced': isSynced,
      'tempId': tempId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

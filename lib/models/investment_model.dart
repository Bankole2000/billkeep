class InvestmentModel {
  final String id;
  final String name;
  final String investmentTypeId;
  final String? tempId;
  final DateTime investmentDate;
  final DateTime? maturityDate;
  final DateTime? closedDate;
  final String currencyCode;
  final int investedAmount;
  final int currentValue;
  final String returnCalculationType;
  final int? interestRate;
  final int? fixedReturnAmount;
  final String? returnFrequency;
  final String? contactId;
  final String? merchantId;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InvestmentModel({
    required this.id,
    required this.name,
    required this.investmentTypeId,
    this.tempId,
    required this.investmentDate,
    this.maturityDate,
    this.closedDate,
    required this.currencyCode,
    required this.investedAmount,
    this.currentValue = 0,
    required this.returnCalculationType,
    this.interestRate,
    this.fixedReturnAmount,
    this.returnFrequency,
    this.contactId,
    this.merchantId,
    this.isSynced = false,
    this.createdAt,
    this.updatedAt,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      investmentTypeId: json['investmentTypeId'] as String,
      tempId: json['tempId'] as String?,
      investmentDate: DateTime.parse(json['investmentDate'] as String),
      maturityDate: json['maturityDate'] != null
          ? DateTime.parse(json['maturityDate'] as String)
          : null,
      closedDate: json['closedDate'] != null
          ? DateTime.parse(json['closedDate'] as String)
          : null,
      currencyCode: json['currencyCode'] as String,
      investedAmount: json['investedAmount'] as int,
      currentValue: json['currentValue'] as int? ?? 0,
      returnCalculationType: json['returnCalculationType'] as String,
      interestRate: json['interestRate'] as int?,
      fixedReturnAmount: json['fixedReturnAmount'] as int?,
      returnFrequency: json['returnFrequency'] as String?,
      contactId: json['contactId'] as String?,
      merchantId: json['merchantId'] as String?,
      isSynced: json['isSynced'] as bool? ?? false,
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
      'investmentTypeId': investmentTypeId,
      'tempId': tempId,
      'investmentDate': investmentDate.toIso8601String(),
      'maturityDate': maturityDate?.toIso8601String(),
      'closedDate': closedDate?.toIso8601String(),
      'currencyCode': currencyCode,
      'investedAmount': investedAmount,
      'currentValue': currentValue,
      'returnCalculationType': returnCalculationType,
      'interestRate': interestRate,
      'fixedReturnAmount': fixedReturnAmount,
      'returnFrequency': returnFrequency,
      'contactId': contactId,
      'merchantId': merchantId,
      'isSynced': isSynced,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

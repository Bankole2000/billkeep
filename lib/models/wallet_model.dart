class WalletModel {
  final String id;
  final String name;
  final String walletType;
  final String currency;
  final int balance;
  final String? imageUrl;
  final String? providerId;
  final String? localImagePath;
  final bool isGlobal;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String iconType;
  final String? color;
  final String? tempId;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WalletModel({
    required this.id,
    required this.name,
    required this.walletType,
    required this.currency,
    required this.balance,
    this.imageUrl,
    this.providerId,
    this.localImagePath,
    this.isGlobal = true,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType = 'MaterialIcons',
    this.color,
    this.tempId,
    this.isSynced = false,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      name: json['name'] as String,
      walletType: json['walletType'] as String,
      currency: json['currency'] as String,
      balance: json['balance'] as int,
      imageUrl: json['imageUrl'] as String?,
      providerId: json['providerId'] as String?,
      localImagePath: json['localImagePath'] as String?,
      isGlobal: json['isGlobal'] as bool? ?? true,
      iconCodePoint: json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String? ?? 'MaterialIcons',
      color: json['color'] as String?,
      tempId: json['tempId'] as String?,
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
      'walletType': walletType,
      'currency': currency,
      'balance': balance,
      'imageUrl': imageUrl,
      'providerId': providerId,
      'localImagePath': localImagePath,
      'isGlobal': isGlobal,
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'tempId': tempId,
      'isSynced': isSynced,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

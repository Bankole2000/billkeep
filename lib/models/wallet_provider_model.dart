class WalletProviderModel {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? localImagePath;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String iconType;
  final String? color;
  final String? websiteUrl;
  final bool isFiatBank;
  final bool isCrypto;
  final bool isMobileMoney;
  final bool isCreditCard;
  final bool isDefault;
  final String? tempId;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WalletProviderModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.localImagePath,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType = 'image',
    this.color,
    this.websiteUrl,
    this.isFiatBank = false,
    this.isCrypto = false,
    this.isMobileMoney = false,
    this.isCreditCard = false,
    this.isDefault = false,
    this.tempId,
    this.isSynced = false,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletProviderModel.fromJson(Map<String, dynamic> json) {
    return WalletProviderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      localImagePath: json['localImagePath'] as String?,
      iconCodePoint: json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String? ?? 'image',
      color: json['color'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      isFiatBank: json['isFiatBank'] as bool? ?? false,
      isCrypto: json['isCrypto'] as bool? ?? false,
      isMobileMoney: json['isMobileMoney'] as bool? ?? false,
      isCreditCard: json['isCreditCard'] as bool? ?? false,
      isDefault: json['isDefault'] as bool? ?? false,
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
      'description': description,
      'imageUrl': imageUrl,
      'localImagePath': localImagePath,
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'websiteUrl': websiteUrl,
      'isFiatBank': isFiatBank,
      'isCrypto': isCrypto,
      'isMobileMoney': isMobileMoney,
      'isCreditCard': isCreditCard,
      'isDefault': isDefault,
      'tempId': tempId,
      'isSynced': isSynced,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class MerchantModel {
  final String id;
  final String name;
  final String? tempId;
  final String? description;
  final String? website;
  final String? imageUrl;
  final String? localImagePath;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String iconType;
  final String? color;
  final bool isDefault;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MerchantModel({
    required this.id,
    required this.name,
    this.tempId,
    this.description,
    this.website,
    this.imageUrl,
    this.localImagePath,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType = 'MaterialIcons',
    this.color,
    this.isDefault = false,
    this.isSynced = false,
    this.createdAt,
    this.updatedAt,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      tempId: json['tempId'] as String?,
      description: json['description'] as String?,
      website: json['website'] as String?,
      imageUrl: json['imageUrl'] as String?,
      localImagePath: json['localImagePath'] as String?,
      iconCodePoint: json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String? ?? 'MaterialIcons',
      color: json['color'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
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
      'tempId': tempId,
      'description': description,
      'website': website,
      'imageUrl': imageUrl,
      'localImagePath': localImagePath,
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'isDefault': isDefault,
      'isSynced': isSynced,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

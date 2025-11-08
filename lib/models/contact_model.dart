class ContactModel {
  final String id;
  final String name;
  final String? tempId;
  final int? iconCodePoint;
  final String? iconEmoji;
  final String iconType;
  final String? color;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ContactModel({
    required this.id,
    required this.name,
    this.tempId,
    this.iconCodePoint,
    this.iconEmoji,
    this.iconType = 'MaterialIcons',
    this.color,
    this.isSynced = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String,
      name: json['name'] as String,
      tempId: json['tempId'] as String?,
      iconCodePoint: json['iconCodePoint'] as int?,
      iconEmoji: json['iconEmoji'] as String?,
      iconType: json['iconType'] as String? ?? 'MaterialIcons',
      color: json['color'] as String?,
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
      'iconCodePoint': iconCodePoint,
      'iconEmoji': iconEmoji,
      'iconType': iconType,
      'color': color,
      'isSynced': isSynced,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class ContactInfoModel {
  final String id;
  final String contactId;
  final String? tempId;
  final String value;
  final String type;
  final bool isSynced;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ContactInfoModel({
    required this.id,
    required this.contactId,
    this.tempId,
    required this.value,
    required this.type,
    this.isSynced = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      id: json['id'] as String,
      contactId: json['contactId'] as String,
      tempId: json['tempId'] as String?,
      value: json['value'] as String,
      type: json['type'] as String,
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
      'contactId': contactId,
      'tempId': tempId,
      'value': value,
      'type': type,
      'isSynced': isSynced,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

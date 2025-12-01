import 'package:billkeep/database/database.dart';
import 'package:drift/drift.dart';

class UserModel {
  final String? id;
  final String? email;
  final bool? emailVisibility;
  final bool? verified;
  final String? name;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    this.email,
    this.emailVisibility,
    this.verified,
    this.name,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      emailVisibility: json['emailVisibility'] as bool?,
      verified: json['verified'] as bool?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Converts a Drift database record to a UserModel
  factory UserModel.fromDrift(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      emailVisibility: user.emailVisibility,
      verified: user.verified,
      name: user.name,
      avatar: user.avatar,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  /// Compares this UserModel with another for equality
  bool isEqualTo(UserModel other) {
    return id == other.id &&
        email == other.email &&
        emailVisibility == other.emailVisibility &&
        verified == other.verified &&
        name == other.name &&
        avatar == other.avatar;
  }

  /// Updates this UserModel with another, prioritizing non-null fields from the other
  UserModel merge(UserModel other) {
    return UserModel(
      id: other.id ?? id,
      email: other.email ?? email,
      emailVisibility: other.emailVisibility ?? emailVisibility,
      verified: other.verified ?? verified,
      name: other.name ?? name,
      avatar: other.avatar ?? avatar,
      createdAt: other.createdAt ?? createdAt,
      updatedAt: other.updatedAt ?? updatedAt,
    );
  }

  /// Creates a copy of this UserModel with the given fields replaced with new values
  UserModel copyWith({
    String? id,
    String? email,
    bool? emailVisibility,
    bool? verified,
    String? name,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      emailVisibility: emailVisibility ?? this.emailVisibility,
      verified: verified ?? this.verified,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'emailVisibility': emailVisibility,
      'verified': verified,
      'name': name,
      'avatar': avatar,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts this model to a Drift Companion for database operations
  UsersCompanion toCompanion({
    String? id,
    String? email,
    bool? emailVisibility,
    bool? verified,
    String? name,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UsersCompanion(
      id: id != null
          ? Value(id)
          : (this.id != null ? Value(this.id!) : const Value.absent()),
      email: email != null
          ? Value(email)
          : (this.email != null ? Value(this.email!) : const Value.absent()),
      emailVisibility: emailVisibility != null
          ? Value(emailVisibility)
          : (this.emailVisibility != null
                ? Value(this.emailVisibility!)
                : const Value.absent()),
      verified: verified != null
          ? Value(verified)
          : (this.verified != null
                ? Value(this.verified!)
                : const Value.absent()),
      name: name != null
          ? Value(name)
          : (this.name != null ? Value(this.name!) : const Value.absent()),
      avatar: avatar != null
          ? Value(avatar)
          : (this.avatar != null ? Value(this.avatar!) : const Value.absent()),
      createdAt: createdAt != null
          ? Value(createdAt)
          : (this.createdAt != null
                ? Value(this.createdAt!)
                : const Value.absent()),
      updatedAt: updatedAt != null
          ? Value(updatedAt)
          : (this.updatedAt != null
                ? Value(this.updatedAt!)
                : const Value.absent()),
    );
  }
}

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      user: UserModel.fromJson(json['record'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user.toJson()};
  }
}

class SignupResponse {
  final UserModel user;

  SignupResponse({required this.user});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(user: UserModel.fromJson(json));
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson()};
  }
}

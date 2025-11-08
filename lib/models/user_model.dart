class User {
  final String id;
  final String username;
  final String email;
  final DateTime? created;
  final DateTime? updated;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.created,
    this.updated,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print(json['name']);
    print(json['email']);
    print(json['created']);
    print(json['updated']);
    return User(
      id: json['id'] as String,
      username: json['name'] as String,
      email: json['email'] as String,
      created: json['created'] != null
          ? DateTime.parse(json['created'] as String)
          : null,
      updated: json['updated'] != null
          ? DateTime.parse(json['updated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'created': created?.toIso8601String(),
      'updated': updated?.toIso8601String(),
    };
  }
}

class AuthResponse {
  final String token;
  final User user;

  AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      user: User.fromJson(json['record'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}

class SignupResponse {
  final User user;

  SignupResponse({
    required this.user,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      user: User.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
    };
  }
}

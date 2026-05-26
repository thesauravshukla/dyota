class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.emailVerified,
  });

  final String id;
  final String email;
  final bool emailVerified;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      emailVerified: (json['emailVerified'] as bool?) ?? false,
    );
  }

  AuthUser copyWith({bool? emailVerified}) {
    return AuthUser(
      id: id,
      email: email,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}

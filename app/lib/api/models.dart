/// Returned by POST /auth/login/start.
class LoginStarted {
  final String sessionId;
  final DateTime otpExpiresAt;
  final DateTime resendAvailableAt;
  final int sendsRemaining;

  LoginStarted({
    required this.sessionId,
    required this.otpExpiresAt,
    required this.resendAvailableAt,
    required this.sendsRemaining,
  });

  factory LoginStarted.fromJson(Map<String, dynamic> json) => LoginStarted(
        sessionId: json['sessionId'] as String,
        otpExpiresAt: DateTime.parse(json['otpExpiresAt'] as String),
        resendAvailableAt: DateTime.parse(json['resendAvailableAt'] as String),
        sendsRemaining: json['sendsRemaining'] as int,
      );
}

/// Returned by POST /auth/login/resend.
class LoginResent {
  final DateTime resendAvailableAt;
  final DateTime otpExpiresAt;
  final int sendsRemaining;
  final bool newCodeIssued;

  LoginResent({
    required this.resendAvailableAt,
    required this.otpExpiresAt,
    required this.sendsRemaining,
    required this.newCodeIssued,
  });

  factory LoginResent.fromJson(Map<String, dynamic> json) => LoginResent(
        resendAvailableAt: DateTime.parse(json['resendAvailableAt'] as String),
        otpExpiresAt: DateTime.parse(json['otpExpiresAt'] as String),
        sendsRemaining: json['sendsRemaining'] as int,
        newCodeIssued: json['newCodeIssued'] as bool,
      );
}

class AppUser {
  final String id;
  final String? phone;
  final String? email;
  final String? displayName;

  AppUser({required this.id, this.phone, this.email, this.displayName});

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
        displayName: json['displayName'] as String?,
      );

  String get label => displayName ?? email ?? phone ?? id;
}

/// Returned by POST /auth/login/verify.
///
/// A wrong code is a normal outcome and arrives as 200 with [authenticated]
/// false, so the UI branches on this rather than on an HTTP error.
class LoginResult {
  final bool authenticated;
  final String? reason;
  final int? attemptsRemaining;
  final String? token;
  final bool? isNewUser;
  final AppUser? user;

  LoginResult({
    required this.authenticated,
    this.reason,
    this.attemptsRemaining,
    this.token,
    this.isNewUser,
    this.user,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
        authenticated: json['authenticated'] as bool,
        reason: json['reason'] as String?,
        attemptsRemaining: json['attemptsRemaining'] as int?,
        token: json['token'] as String?,
        isNewUser: json['isNewUser'] as bool?,
        user: json['user'] == null
            ? null
            : AppUser.fromJson(json['user'] as Map<String, dynamic>),
      );
}

import '../models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> signup({
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<AuthUser> login({required String email, required String password});

  /// Returns the signed-in user, or null if the user cancelled the
  /// platform sign-in sheet.
  Future<AuthUser?> signInWithGoogle();

  Future<void> logout();

  /// Returns the user if stored tokens are still valid, else null.
  Future<AuthUser?> restoreSession();

  Future<void> requestEmailVerification(String email);

  Future<void> confirmEmailVerification(String token);

  Future<void> forgotPassword(String email);

  Future<void> resetPassword({required String token, required String newPassword});
}

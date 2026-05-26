import '../../../data/models/auth_user.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitializing extends AuthState {
  const AuthInitializing();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.message});
  final String? message;
}

class AuthSubmitting extends AuthState {
  const AuthSubmitting(this.previous);
  final AuthState previous;
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final AuthUser user;
}

class AuthError extends AuthState {
  const AuthError(this.message, {this.previous});
  final String message;
  final AuthState? previous;
}

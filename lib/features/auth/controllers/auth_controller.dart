import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/api_error.dart';
import '../../../data/models/auth_user.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/auth_repository_provider.dart';
import 'auth_state.dart';

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repo;

  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);
    _bootstrap();
    return const AuthInitializing();
  }

  Future<void> _bootstrap() async {
    try {
      final user = await _repo.restoreSession();
      state = user != null ? AuthAuthenticated(user) : const AuthUnauthenticated();
    } catch (_) {
      state = const AuthUnauthenticated();
    }
  }

  Future<void> login({required String email, required String password}) async {
    await _run(() => _repo.login(email: email, password: password));
  }

  Future<void> signup({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    await _run(() => _repo.signup(
          email: email,
          password: password,
          confirmPassword: confirmPassword,
        ));
  }

  Future<void> signInWithGoogle() async {
    final prev = state;
    state = AuthSubmitting(prev);
    try {
      final user = await _repo.signInWithGoogle();
      if (user == null) {
        state = prev; // user cancelled the platform sheet
        return;
      }
      state = AuthAuthenticated(user);
    } on ApiException catch (e) {
      state = AuthError(e.message, previous: prev);
    } catch (_) {
      state = AuthError('Google sign-in failed. Please try again.', previous: prev);
    }
  }

  Future<void> logout() async {
    final prev = state;
    state = AuthSubmitting(prev);
    try {
      await _repo.logout();
    } finally {
      state = const AuthUnauthenticated();
    }
  }

  Future<void> refreshUser() async {
    final user = await _repo.restoreSession();
    state = user != null ? AuthAuthenticated(user) : const AuthUnauthenticated();
  }

  void clearError() {
    final s = state;
    if (s is AuthError) {
      state = s.previous ?? const AuthUnauthenticated();
    }
  }

  Future<void> _run(Future<AuthUser> Function() action) async {
    final prev = state;
    state = AuthSubmitting(prev);
    try {
      final user = await action();
      state = AuthAuthenticated(user);
    } on ApiException catch (e) {
      state = AuthError(e.message, previous: prev);
    } catch (_) {
      state = AuthError('Something went wrong. Please try again.', previous: prev);
    }
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

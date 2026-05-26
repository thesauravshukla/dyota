import '../../core/storage/token_store.dart';
import '../models/auth_tokens.dart';
import '../models/auth_user.dart';
import '../sources/auth_api.dart';
import '../sources/oauth_sign_in.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthApi api,
    required TokenStore tokenStore,
    required GoogleOAuthSource googleSource,
  })  : _api = api,
        _tokenStore = tokenStore,
        _googleSource = googleSource;

  final AuthApi _api;
  final TokenStore _tokenStore;
  final GoogleOAuthSource _googleSource;

  @override
  Future<AuthUser> signup({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final tokens = await _api.signup(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    return _persist(tokens);
  }

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    final tokens = await _api.login(email: email, password: password);
    return _persist(tokens);
  }

  @override
  Future<AuthUser?> signInWithGoogle() async {
    final idToken = await _googleSource.signIn();
    if (idToken == null) return null; // user cancelled
    final tokens = await _api.googleSignIn(idToken);
    return _persist(tokens);
  }

  @override
  Future<void> logout() async {
    final refresh = await _tokenStore.readRefreshToken();
    if (refresh != null) {
      try {
        await _api.logout(refresh);
      } catch (_) {
        // Best-effort; clear local state regardless.
      }
    }
    await _tokenStore.clear();
  }

  @override
  Future<AuthUser?> restoreSession() async {
    final access = await _tokenStore.readAccessToken();
    if (access == null) return null;
    try {
      return await _api.me();
    } catch (_) {
      // Interceptor already attempted refresh; clear any stale state.
      await _tokenStore.clear();
      return null;
    }
  }

  @override
  Future<void> requestEmailVerification(String email) =>
      _api.resendVerification(email: email);

  @override
  Future<void> confirmEmailVerification(String token) => _api.verifyEmail(token);

  @override
  Future<void> forgotPassword(String email) => _api.forgotPassword(email);

  @override
  Future<void> resetPassword({required String token, required String newPassword}) =>
      _api.resetPassword(token: token, password: newPassword);

  Future<AuthUser> _persist(AuthTokens tokens) async {
    await _tokenStore.save(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
    return tokens.user;
  }
}

import 'package:flutter/foundation.dart';

import '../api/api_exception.dart';
import '../api/auth_api.dart';
import '../api/models.dart';
import '../storage/token_store.dart';

enum AuthStatus {
  /// Still deciding — the splash is showing.
  unknown,
  authenticated,
  unauthenticated,
  /// We hold a token but could not reach the server to check it.
  unreachable,
}

/// Owns "who is signed in" for the whole app. Transient login state (the
/// verification session id and its timers) deliberately lives on the OTP screen
/// instead: it is meaningless once verification succeeds, and state you have to
/// remember to clear is state that leaks.
class AuthController extends ChangeNotifier {
  AuthController({AuthApi? api, TokenStore? store})
      : _api = api ?? AuthApi(),
        _store = store ?? TokenStore();

  final AuthApi _api;
  final TokenStore _store;

  AuthStatus status = AuthStatus.unknown;
  AppUser? user;
  String? _token;

  /// True only for the session in which the account was created, so the welcome
  /// shows once and never again after a dismiss or a restart.
  bool showWelcome = false;

  String? get token => _token;

  /// Called once at launch.
  Future<void> restore() async {
    final stored = await _store.read();
    if (stored == null) {
      _set(AuthStatus.unauthenticated);
      return;
    }
    try {
      user = await _api.me(stored);
      _token = stored;
      _set(AuthStatus.authenticated);
    } on ApiException catch (e) {
      if (e.code == 'NETWORK') {
        // A bad connection is not a revoked session. Keeping the token here is
        // the difference between "retry" and logging someone out on a train.
        _set(AuthStatus.unreachable);
      } else {
        await _store.clear();
        _token = null;
        user = null;
        _set(AuthStatus.unauthenticated);
      }
    }
  }

  Future<void> signIn(String token, AppUser signedIn, {bool isNewUser = false}) async {
    await _store.save(token);
    _token = token;
    user = signedIn;
    showWelcome = isNewUser;
    _set(AuthStatus.authenticated);
  }

  void dismissWelcome() {
    showWelcome = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    final current = _token;
    if (current != null) {
      // Best effort: if the call fails the local token still goes, so the user
      // is signed out on this device either way.
      try {
        await _api.logout(current);
      } on ApiException {
        // ignored deliberately
      }
    }
    await _store.clear();
    _token = null;
    user = null;
    _set(AuthStatus.unauthenticated);
  }

  void _set(AuthStatus next) {
    status = next;
    notifyListeners();
  }
}

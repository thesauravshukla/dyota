import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Wraps `google_sign_in` (v7+) to expose a single
/// `signIn()` that returns a Google ID token suitable for
/// `POST /auth/oauth/google`. Returns `null` when the user cancels.
class GoogleOAuthSource {
  GoogleOAuthSource({required String serverClientId, GoogleSignIn? instance})
      : _serverClientId = serverClientId,
        _signIn = instance ?? GoogleSignIn.instance;

  final String _serverClientId;
  final GoogleSignIn _signIn;
  Future<void>? _initialized;

  bool get isConfigured => _serverClientId.isNotEmpty;

  bool get isSupportedOnPlatform => _signIn.supportsAuthenticate();

  bool get isAvailable => isConfigured && isSupportedOnPlatform;

  Future<void> _ensureInit() {
    return _initialized ??= _signIn.initialize(serverClientId: _serverClientId);
  }

  /// Returns the Google-issued idToken, or null if the user cancelled.
  /// Throws on any other failure.
  Future<String?> signIn() async {
    if (!isConfigured) {
      throw StateError(
        'GOOGLE_SERVER_CLIENT_ID is not set. Pass it via --dart-define.',
      );
    }
    if (!isSupportedOnPlatform) {
      throw UnsupportedError(
        'Google sign-in is not supported on this platform.',
      );
    }
    await _ensureInit();
    try {
      final account = await _signIn.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw StateError('Google sign-in did not return an idToken.');
      }
      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Google sign-in failed: $e\n$st');
      }
      rethrow;
    }
  }
}

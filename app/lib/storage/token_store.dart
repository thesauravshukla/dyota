import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the bearer token in the platform keystore — Keychain on iOS,
/// EncryptedSharedPreferences on Android. Deliberately not SharedPreferences,
/// which is plaintext and readable on a rooted device.
///
/// The defaults are already AES-GCM backed on Android, so no explicit options
/// are needed; this package version encrypts unconditionally.
class TokenStore {
  static const _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> save(String token) => _storage.write(key: _tokenKey, value: token);

  Future<String?> read() => _storage.read(key: _tokenKey);

  Future<void> clear() => _storage.delete(key: _tokenKey);
}

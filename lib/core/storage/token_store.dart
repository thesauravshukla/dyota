import 'secure_storage.dart';

class TokenStore {
  TokenStore(this._storage);

  static const _accessKey = 'auth.access_token';
  static const _refreshKey = 'auth.refresh_token';

  final SecureStorage _storage;

  String? _cachedAccess;

  Future<String?> readAccessToken() async {
    return _cachedAccess ??= await _storage.read(_accessKey);
  }

  Future<String?> readRefreshToken() => _storage.read(_refreshKey);

  Future<void> save({required String accessToken, required String refreshToken}) async {
    _cachedAccess = accessToken;
    await _storage.write(_accessKey, accessToken);
    await _storage.write(_refreshKey, refreshToken);
  }

  Future<void> clear() async {
    _cachedAccess = null;
    await _storage.delete(_accessKey);
    await _storage.delete(_refreshKey);
  }
}

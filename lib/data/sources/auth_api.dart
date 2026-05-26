import 'package:dio/dio.dart';

import '../models/api_error.dart';
import '../models/auth_tokens.dart';
import '../models/auth_user.dart';

/// Thin REST client matching docs/auth-lld.md §3.3. Throws [ApiException]
/// on non-2xx; returns parsed models on success.
class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<AuthTokens> signup({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final res = await _post('/auth/signup', {
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    });
    return AuthTokens.fromJson(res);
  }

  Future<AuthTokens> login({required String email, required String password}) async {
    final res = await _post('/auth/login', {'email': email, 'password': password});
    return AuthTokens.fromJson(res);
  }

  Future<AuthTokens> googleSignIn(String idToken) async {
    final res = await _post('/auth/oauth/google', {'idToken': idToken});
    return AuthTokens.fromJson(res);
  }

  Future<void> logout(String refreshToken) =>
      _postVoid('/auth/logout', {'refreshToken': refreshToken});

  Future<AuthUser> me() async {
    final res = await _dio.get<Map<String, dynamic>>('/auth/me');
    _ensureOk(res);
    return AuthUser.fromJson(res.data!);
  }

  Future<void> verifyEmail(String token) =>
      _postVoid('/auth/email/verify', {'token': token});

  Future<void> resendVerification({String? email}) =>
      _postVoid('/auth/email/resend', {if (email != null) 'email': email});

  Future<void> forgotPassword(String email) =>
      _postVoid('/auth/password/forgot', {'email': email});

  Future<void> resetPassword({required String token, required String password}) =>
      _postVoid('/auth/password/reset', {'token': token, 'password': password});

  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(path, data: body);
      _ensureOk(res);
      return res.data!;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> _postVoid(String path, Map<String, dynamic> body) async {
    try {
      final res = await _dio.post<dynamic>(path, data: body);
      _ensureOk(res);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  void _ensureOk(Response<dynamic> res) {
    final status = res.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw ApiException.fromResponse(res);
    }
  }
}

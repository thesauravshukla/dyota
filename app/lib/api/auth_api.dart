import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import 'api_exception.dart';
import 'models.dart';

/// Talks to order-management-service. It never contacts authentication-service
/// directly — that service is internal and unreachable from a client.
class AuthApi {
  final http.Client _client;

  AuthApi({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri(String path) => Uri.parse('${AppConfig.apiBaseUrl}${AppConfig.apiPrefix}$path');

  Future<LoginStarted> start(String email) async {
    final json = await _post('/login/start', {
      'identifier': email,
      'identifierType': 'EMAIL',
    });
    return LoginStarted.fromJson(json);
  }

  Future<LoginResent> resend(String sessionId) async {
    final json = await _post('/login/resend', {'sessionId': sessionId});
    return LoginResent.fromJson(json);
  }

  Future<LoginResult> verify(String sessionId, String code) async {
    final json = await _post('/login/verify', {
      'sessionId': sessionId,
      'code': code,
    });
    return LoginResult.fromJson(json);
  }

  Future<AppUser> me(String token) async {
    final json = await _get('/me', token);
    return AppUser.fromJson(json);
  }

  Future<void> logout(String token) async {
    await _post('/logout', const {}, token: token);
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    return _send(() => _client.post(
          _uri(path),
          headers: _headers(token),
          body: jsonEncode(body),
        ));
  }

  Future<Map<String, dynamic>> _get(String path, String token) async {
    return _send(() => _client.get(_uri(path), headers: _headers(token)));
  }

  Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<Map<String, dynamic>> _send(Future<http.Response> Function() request) async {
    final http.Response response;
    try {
      response = await request().timeout(const Duration(seconds: 15));
    } catch (e) {
      throw ApiException('NETWORK', 'Could not reach the server: $e');
    }

    if (response.statusCode == 204 || response.body.isEmpty) {
      return const {};
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw ApiException('MALFORMED_RESPONSE', 'Unexpected response from server');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    // The API returns a stable machine-readable code; surface it rather than
    // the status, so the UI can distinguish "wait 20s" from "start again".
    final seconds = decoded['retryAfterSeconds'];
    throw ApiException(
      decoded['code'] as String? ?? 'UNKNOWN',
      decoded['message'] as String? ?? 'Request failed',
      retryAfter: seconds is int ? Duration(seconds: seconds) : null,
    );
  }
}

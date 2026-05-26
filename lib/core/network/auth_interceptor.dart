import 'package:dio/dio.dart';

import '../storage/token_store.dart';

typedef RefreshCallback = Future<bool> Function();
typedef LogoutCallback = Future<void> Function();

/// Attaches `Authorization: Bearer <access>` and, on a 401 from an
/// authenticated request, performs a single-flight refresh and replays
/// the original request once. If refresh fails, tokens are cleared and
/// the caller is notified via [onSessionLost].
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.tokenStore,
    required this.dio,
    required this.refresh,
    required this.onSessionLost,
  });

  final TokenStore tokenStore;
  final Dio dio;
  final RefreshCallback refresh;
  final LogoutCallback onSessionLost;

  static const _retryFlag = 'auth.retried';

  Future<bool>? _inflightRefresh;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStore.readAccessToken();
    if (token != null && !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final req = err.requestOptions;
    final alreadyRetried = req.extra[_retryFlag] == true;

    if (status != 401 || alreadyRetried) {
      handler.next(err);
      return;
    }

    final refreshed = await (_inflightRefresh ??= _runRefresh());
    _inflightRefresh = null;

    if (!refreshed) {
      await onSessionLost();
      handler.next(err);
      return;
    }

    final newToken = await tokenStore.readAccessToken();
    req
      ..extra[_retryFlag] = true
      ..headers['Authorization'] = 'Bearer $newToken';

    try {
      final response = await dio.fetch(req);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<bool> _runRefresh() async {
    try {
      return await refresh();
    } catch (_) {
      return false;
    }
  }
}

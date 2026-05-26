import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/token_store.dart';
import '../storage/token_store_provider.dart';
import 'api_client.dart';
import 'auth_interceptor.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient.create();
  final tokenStore = ref.watch(tokenStoreProvider);

  client.dio.interceptors.add(
    AuthInterceptor(
      tokenStore: tokenStore,
      dio: client.dio,
      refresh: () => _refresh(client.refreshDio, tokenStore),
      onSessionLost: tokenStore.clear,
    ),
  );

  return client;
});

Future<bool> _refresh(Dio refreshDio, TokenStore tokenStore) async {
  final refreshToken = await tokenStore.readRefreshToken();
  if (refreshToken == null) return false;

  try {
    final res = await refreshDio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    final status = res.statusCode ?? 0;
    if (status < 200 || status >= 300) return false;

    final data = res.data;
    final access = data?['accessToken'] as String?;
    final newRefresh = data?['refreshToken'] as String?;
    if (access == null || newRefresh == null) return false;

    await tokenStore.save(accessToken: access, refreshToken: newRefresh);
    return true;
  } catch (_) {
    return false;
  }
}

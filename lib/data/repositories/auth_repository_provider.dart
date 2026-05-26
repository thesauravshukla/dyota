import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/api_config.dart';
import '../../core/network/api_client_provider.dart';
import '../../core/storage/token_store_provider.dart';
import '../sources/auth_api.dart';
import '../sources/oauth_sign_in.dart';
import 'auth_repository.dart';
import 'auth_repository_impl.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(apiClientProvider).dio);
});

final googleOAuthSourceProvider = Provider<GoogleOAuthSource>((ref) {
  return GoogleOAuthSource(serverClientId: ApiConfig.googleServerClientId);
});

/// True when Google sign-in is both configured (server client ID present)
/// and supported on the current platform.
final googleSignInAvailableProvider = Provider<bool>((ref) {
  return ref.watch(googleOAuthSourceProvider).isAvailable;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    api: ref.watch(authApiProvider),
    tokenStore: ref.watch(tokenStoreProvider),
    googleSource: ref.watch(googleOAuthSourceProvider),
  );
});

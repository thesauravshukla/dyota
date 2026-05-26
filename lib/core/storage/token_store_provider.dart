import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'secure_storage.dart';
import 'token_store.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

final tokenStoreProvider = Provider<TokenStore>((ref) {
  return TokenStore(ref.watch(secureStorageProvider));
});

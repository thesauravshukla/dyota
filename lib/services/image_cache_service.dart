import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';

/// Centralized service for fetching and caching Firebase Storage image URLs.
/// Avoids redundant network calls by caching resolved URLs in memory.
class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._();
  static ImageCacheService get instance => _instance;

  final _logger = Logger('ImageCacheService');
  final Map<String, String> _cache = {};

  // Lazy-initialized to avoid Firebase errors in tests
  FirebaseStorage get _storage => FirebaseStorage.instance;

  ImageCacheService._();

  /// Get a single image URL, using cache if available.
  Future<String?> getImageUrl(String storagePath) async {
    if (storagePath.isEmpty) return null;

    final cached = _cache[storagePath];
    if (cached != null) return cached;

    try {
      final url = await _storage.ref(storagePath).getDownloadURL();
      _cache[storagePath] = url;
      return url;
    } catch (e) {
      _logger.warning('Failed to fetch image URL: $storagePath', e);
      return null;
    }
  }

  /// Fetch multiple image URLs in parallel.
  Future<List<String>> getImageUrls(List<String> storagePaths) async {
    final futures = storagePaths.map(getImageUrl);
    final results = await Future.wait(futures);
    return results.whereType<String>().toList();
  }

  /// Clear the cache.
  void clearCache() {
    _cache.clear();
  }

  /// Number of cached entries.
  int get cacheSize => _cache.length;
}

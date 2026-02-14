import 'package:flutter_test/flutter_test.dart';
import 'package:dyota/services/image_cache_service.dart';

void main() {
  group('ImageCacheService', () {
    late ImageCacheService service;

    setUp(() {
      service = ImageCacheService.instance;
      service.clearCache();
    });

    test('is a singleton', () {
      final a = ImageCacheService.instance;
      final b = ImageCacheService.instance;
      expect(identical(a, b), isTrue);
    });

    test('clearCache empties the cache', () {
      // Cache is empty after clear
      expect(service.cacheSize, 0);
    });

    test('getImageUrl returns null for empty path', () async {
      final result = await service.getImageUrl('');
      expect(result, isNull);
    });

    test('getImageUrls returns empty list for empty input', () async {
      final result = await service.getImageUrls([]);
      expect(result, isEmpty);
    });

    test('cacheSize reflects cached entries correctly after clear', () {
      expect(service.cacheSize, 0);
      service.clearCache();
      expect(service.cacheSize, 0);
    });
  });
}

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dyota/services/search_service.dart';

void main() {
  group('SearchService', () {
    late FakeFirebaseFirestore fakeFirestore;
    late SearchService searchService;

    setUp(() async {
      fakeFirestore = FakeFirebaseFirestore();
      searchService = SearchService(firestore: fakeFirestore);

      // Seed test data
      await fakeFirestore.collection('items').doc('product1').set({
        'category': {'value': 'Silk'},
        'subCategory': {'value': 'Tussar Silk'},
        'productName': {'value': 'Premium Red Tussar'},
        'pricePerMetre': {'value': '500', 'prefix': 'Rs. '},
        'searchTerms': ['silk', 'tussar', 'premium', 'red'],
      });

      await fakeFirestore.collection('items').doc('product2').set({
        'category': {'value': 'Cotton'},
        'subCategory': {'value': 'Organic Cotton'},
        'productName': {'value': 'Blue Organic Cotton'},
        'pricePerMetre': {'value': '300', 'prefix': 'Rs. '},
        'searchTerms': ['cotton', 'organic', 'blue'],
      });

      await fakeFirestore.collection('items').doc('product3').set({
        'category': {'value': 'Silk'},
        'subCategory': {'value': 'Banarasi'},
        'productName': {'value': 'Golden Banarasi Silk'},
        'pricePerMetre': {'value': '1200', 'prefix': 'Rs. '},
        'searchTerms': ['silk', 'banarasi', 'golden'],
      });
    });

    test('returns empty list for empty query', () async {
      final results = await searchService.search('');
      expect(results, isEmpty);
    });

    test('finds products matching a single keyword', () async {
      final results = await searchService.search('silk');
      expect(results.length, 2);

      final docIds = results.map((r) => r.documentId).toSet();
      expect(docIds, contains('product1'));
      expect(docIds, contains('product3'));
    });

    test('finds products matching another keyword', () async {
      final results = await searchService.search('cotton');
      expect(results.length, 1);
      expect(results.first.documentId, 'product2');
    });

    test('returns empty for non-matching query', () async {
      final results = await searchService.search('polyester');
      expect(results, isEmpty);
    });

    test('results are sorted by score descending', () async {
      final results = await searchService.search('silk');
      // All matches have the same score (exact word match = 100)
      for (int i = 0; i < results.length - 1; i++) {
        expect(results[i].score, greaterThanOrEqualTo(results[i + 1].score));
      }
    });

    test('search is case insensitive', () async {
      final results = await searchService.search('SILK');
      expect(results.length, 2);
    });

    test('respects limit parameter', () async {
      final results = await searchService.search('silk', limit: 1);
      expect(results.length, 1);
    });

    group('backfillSearchTerms', () {
      test('adds searchTerms to documents that lack them', () async {
        // Add a document without searchTerms
        await fakeFirestore.collection('items').doc('product4').set({
          'category': {'value': 'Linen'},
          'subCategory': {'value': 'Pure Linen'},
          'productName': {'value': 'White Linen'},
        });

        final updated = await searchService.backfillSearchTerms();
        expect(updated, 1); // Only product4 lacked searchTerms

        // Verify searchTerms were added
        final doc =
            await fakeFirestore.collection('items').doc('product4').get();
        final terms = List<String>.from(doc.data()!['searchTerms']);
        expect(terms, contains('linen'));
        expect(terms, contains('white'));
      });

      test('does not re-backfill documents that already have searchTerms',
          () async {
        final updated = await searchService.backfillSearchTerms();
        expect(updated, 0); // All 3 seed docs already have searchTerms
      });
    });

    group('auto-backfill on search', () {
      test('auto-backfills and finds results if searchTerms missing', () async {
        // Create a fresh Firestore with NO searchTerms on docs
        final freshFirestore = FakeFirebaseFirestore();
        final freshService = SearchService(firestore: freshFirestore);

        await freshFirestore.collection('items').doc('p1').set({
          'category': {'value': 'Silk'},
          'productName': {'value': 'Red Silk'},
        });

        // Search should auto-backfill and return the product
        final results = await freshService.search('silk');
        expect(results.length, 1);
        expect(results.first.documentId, 'p1');
      });
    });
  });
}

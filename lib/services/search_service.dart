import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

/// Result of a product search, with a relevance score.
class SearchResult {
  final int score;
  final String documentId;

  SearchResult(this.score, this.documentId);
}

/// Service for searching products using Firestore-indexed searchTerms.
///
/// Requires each product document to have a `searchTerms` field:
/// a List<String> of lowercase keywords (category, subcategory, product name, etc.).
///
/// To populate searchTerms, run the [backfillSearchTerms] method once,
/// or ensure new products are saved with this field.
class SearchService {
  final FirebaseFirestore _firestore;
  final Logger _logger = Logger('SearchService');

  SearchService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  bool _backfillDone = false;

  /// Search products by matching query words against the searchTerms array.
  ///
  /// If searchTerms haven't been backfilled yet, runs backfill automatically
  /// and retries the search once.
  Future<List<SearchResult>> search(String query, {int limit = 30}) async {
    final words = _tokenize(query);
    if (words.isEmpty) return [];

    var results = await _executeSearch(words, limit);

    // If no results and we haven't backfilled yet, do it now and retry
    if (results.isEmpty && !_backfillDone) {
      final updated = await backfillSearchTerms();
      _backfillDone = true;
      if (updated > 0) {
        results = await _executeSearch(words, limit);
      }
    }

    return results;
  }

  Future<List<SearchResult>> _executeSearch(
      List<String> words, int limit) async {
    final queryWords = words.take(10).toList();

    try {
      final snapshot = await _firestore
          .collection('items')
          .where('searchTerms', arrayContainsAny: queryWords)
          .limit(limit)
          .get();

      final results = snapshot.docs.map((doc) {
        final terms =
            List<String>.from(doc.data()['searchTerms'] as List? ?? []);
        final score = _calculateScore(queryWords, terms);
        return SearchResult(score, doc.id);
      }).toList();

      results.sort((a, b) => b.score.compareTo(a.score));
      return results;
    } catch (e) {
      _logger.severe('Search failed', e);
      return [];
    }
  }

  /// One-time backfill: adds searchTerms to all products that don't have them.
  Future<int> backfillSearchTerms() async {
    final snapshot = await _firestore.collection('items').get();
    int updated = 0;

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (data.containsKey('searchTerms')) continue;

      final terms = _extractSearchTerms(data);
      batch.update(doc.reference, {'searchTerms': terms});
      updated++;
    }

    if (updated > 0) {
      await batch.commit();
      _logger.info('Backfilled searchTerms for $updated documents');
    }
    return updated;
  }

  /// Extract searchable keywords from a product document.
  List<String> _extractSearchTerms(Map<String, dynamic> data) {
    final terms = <String>{};

    // Extract from nested map fields (category.value, subCategory.value, etc.)
    for (final entry in data.entries) {
      if (entry.value is Map<String, dynamic>) {
        final mapValue = entry.value as Map<String, dynamic>;
        if (mapValue.containsKey('value')) {
          final v = mapValue['value'];
          if (v is String && v.isNotEmpty) {
            terms.addAll(_tokenize(v));
          }
        }
      } else if (entry.value is String &&
          entry.key != 'parentId' &&
          !entry.key.contains('image')) {
        terms.addAll(_tokenize(entry.value as String));
      }
    }

    return terms.toList();
  }

  /// Tokenize a string into lowercase words.
  List<String> _tokenize(String text) {
    return text
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
  }

  /// Score a document based on how many query words match its searchTerms.
  int _calculateScore(List<String> queryWords, List<String> terms) {
    int score = 0;
    for (final word in queryWords) {
      for (final term in terms) {
        if (term == word) {
          score += 100; // Exact match
        } else if (term.contains(word)) {
          score += 50; // Partial match
        }
      }
    }
    return score;
  }
}

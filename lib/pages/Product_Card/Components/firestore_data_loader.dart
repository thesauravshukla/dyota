import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// A reusable class to handle loading data from Firestore with caching,
/// debounced loading state updates, and proper lifecycle management.
class FirestoreDataLoader<T> {
  final String documentId;
  final Function(bool) onLoadingChanged;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final T Function(DocumentSnapshot) converter;

  bool _isLoading = true;
  bool _hasNotifiedLoading = false;
  String? _cachedDocumentId;
  DocumentSnapshot? _cachedData;
  Future<DocumentSnapshot>? _fetchFuture;

  FirestoreDataLoader({
    required this.documentId,
    required this.onLoadingChanged,
    required this.converter,
  }) {
    _cachedDocumentId = documentId;
  }

  /// Notifies the parent about a loading state change.
  /// Uses microtask to avoid frame issues.
  void updateLoadingState(bool isLoading, bool mounted) {
    if (_isLoading != isLoading) {
      _isLoading = isLoading;
      Future.microtask(() {
        if (mounted) {
          onLoadingChanged(isLoading);
        }
      });
    }
  }

  /// Sets the initial loading state
  void setInitialLoadingState(bool mounted) {
    if (mounted && !_hasNotifiedLoading) {
      _hasNotifiedLoading = true;
      Future.microtask(() => onLoadingChanged(true));
    }
  }

  /// Updates the document ID if it has changed
  void updateDocumentId(String newDocumentId, bool mounted) {
    if (newDocumentId != _cachedDocumentId) {
      _cachedDocumentId = newDocumentId;
      _cachedData = null;
      _fetchFuture = null;
      _isLoading = true;
      Future.microtask(() {
        if (mounted) {
          onLoadingChanged(true);
        }
      });
    }
  }

  /// Fetches document data from Firestore with caching
  Future<DocumentSnapshot> fetchData(String collection) {
    if (_fetchFuture == null || documentId != _cachedDocumentId) {
      _cachedDocumentId = documentId;
      _fetchFuture = _firestore
          .collection(collection)
          .doc(documentId)
          .get()
          .then((snapshot) {
        _cachedData = snapshot;
        return snapshot;
      });
    }
    return _fetchFuture!;
  }

  /// Builds a widget based on the document data
  /// If cached data is available, it's used immediately
  /// Otherwise, a FutureBuilder is used to fetch data
  Widget buildWithData({
    required BuildContext context,
    required bool mounted,
    required String collection,
    required Widget Function(T data) builder,
    required Widget Function(String error) errorBuilder,
    required Widget Function() loadingBuilder,
    required Widget Function() emptyBuilder,
  }) {
    // If we already have cached data, use it immediately
    if (_cachedData != null && _cachedDocumentId == documentId) {
      if (_isLoading) {
        updateLoadingState(false, mounted);
      }

      if (_cachedData!.exists) {
        final data = converter(_cachedData!);
        return builder(data);
      } else {
        return emptyBuilder();
      }
    }

    return FutureBuilder<DocumentSnapshot>(
      future: fetchData(collection),
      builder: (context, snapshot) {
        // Only notify on major state changes, not on every build
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingBuilder();
        } else {
          // Data loaded or error - if we were previously loading, notify we're done
          Future.microtask(() {
            if (mounted && _isLoading) {
              updateLoadingState(false, mounted);
            }
          });

          if (snapshot.hasError) {
            return errorBuilder(snapshot.error.toString());
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return emptyBuilder();
          }

          final data = converter(snapshot.data!);
          return builder(data);
        }
      },
    );
  }

  /// Ensures we're not loading when component is disposed
  void handleDispose(bool mounted) {
    if (_isLoading) {
      Future.microtask(() {
        onLoadingChanged(false);
      });
    }
  }
}

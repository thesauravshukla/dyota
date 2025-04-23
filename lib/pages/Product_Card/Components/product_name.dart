import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductName extends StatefulWidget {
  final String documentId;
  final Function(bool) onLoadingChanged;

  const ProductName({
    Key? key,
    required this.documentId,
    required this.onLoadingChanged,
  }) : super(key: key);

  @override
  State<ProductName> createState() => _ProductNameState();
}

class _ProductNameState extends State<ProductName>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  bool _hasNotifiedLoading = false;
  String? _cachedDocumentId;
  DocumentSnapshot? _cachedData;
  Future<DocumentSnapshot>? _fetchFuture;

  @override
  bool get wantKeepAlive => true; // Keep this widget alive when scrolling

  Future<DocumentSnapshot> _fetchData() {
    if (_fetchFuture == null || widget.documentId != _cachedDocumentId) {
      _cachedDocumentId = widget.documentId;
      _fetchFuture = FirebaseFirestore.instance
          .collection('items')
          .doc(widget.documentId)
          .get()
          .then((snapshot) {
        _cachedData = snapshot;
        return snapshot;
      });
    }
    return _fetchFuture!;
  }

  @override
  void initState() {
    super.initState();
    _cachedDocumentId = widget.documentId;
    // Set initial loading state once, using microtask to avoid frame issues
    Future.microtask(() {
      if (mounted && !_hasNotifiedLoading) {
        _hasNotifiedLoading = true;
        widget.onLoadingChanged(true);
      }
    });
  }

  @override
  void didUpdateWidget(ProductName oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If document ID changed, reset loading state
    if (oldWidget.documentId != widget.documentId) {
      _cachedDocumentId = widget.documentId;
      _cachedData = null;
      _fetchFuture = null;
      _isLoading = true;
      Future.microtask(() {
        if (mounted) {
          widget.onLoadingChanged(true);
        }
      });
    }
  }

  void _updateLoadingState(bool isLoading) {
    if (_isLoading != isLoading) {
      _isLoading = isLoading;
      Future.microtask(() {
        if (mounted) {
          widget.onLoadingChanged(isLoading);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    // If we already have cached data, use it immediately
    if (_cachedData != null && _cachedDocumentId == widget.documentId) {
      if (_isLoading) {
        _updateLoadingState(false);
      }

      if (_cachedData!.exists) {
        final data = _cachedData!.data() as Map<String, dynamic>;
        final productName = data['productName']['value'] ?? 'Unknown Product';

        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Text(
            productName,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        return Center(child: Text('Product not found.'));
      }
    }

    return FutureBuilder<DocumentSnapshot>(
      future: _fetchData(),
      builder: (context, snapshot) {
        // Only notify on major state changes, not on every build
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(height: 40); // Empty container while loading
        } else {
          // Data loaded or error - if we were previously loading, notify we're done
          Future.microtask(() {
            if (mounted && _isLoading) {
              _updateLoadingState(false);
            }
          });

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Product not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final productName = data['productName']['value'] ?? 'Unknown Product';

          return Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Text(
              productName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    // Ensure we're not loading when component is disposed
    if (_isLoading) {
      Future.microtask(() {
        widget.onLoadingChanged(false);
      });
    }
    super.dispose();
  }
}

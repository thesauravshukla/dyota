import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Product_Card/Components/detail_item.dart';
import 'package:flutter/material.dart';

class DynamicFieldsDisplay extends StatefulWidget {
  final String documentId;
  final Function(bool) onLoadingChanged;

  const DynamicFieldsDisplay({
    Key? key,
    required this.documentId,
    required this.onLoadingChanged,
  }) : super(key: key);

  @override
  State<DynamicFieldsDisplay> createState() => _DynamicFieldsDisplayState();
}

class _DynamicFieldsDisplayState extends State<DynamicFieldsDisplay>
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
  void didUpdateWidget(DynamicFieldsDisplay oldWidget) {
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
        Map<String, dynamic> data = _cachedData!.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> fields = [];

        data.forEach((key, value) {
          if (value is Map<String, dynamic> &&
              value.containsKey('displayName') &&
              value.containsKey('toDisplay') &&
              value.containsKey('value') &&
              value.containsKey('priority') &&
              value['toDisplay'] == 1) {
            fields.add(value);
          }
        });

        // Sort fields by priority
        fields.sort(
            (a, b) => (a['priority'] as int).compareTo(b['priority'] as int));

        List<Widget> fieldsToDisplay = fields.map((field) {
          String getFieldValue(Map<String, dynamic> field) {
            String value = field['value'].toString() ?? '';
            String prefix = field['prefix'] ?? '';
            String suffix = field['suffix'] ?? '';
            return '$prefix$value$suffix';
          }

          return DetailItem(
            title: field['displayName'],
            value: getFieldValue(field),
          );
        }).toList();

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.outline,
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Product Details',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              ...fieldsToDisplay,
            ],
          ),
        );
      } else {
        return Center(child: Text('Document does not exist'));
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
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Document does not exist'));
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          List<Map<String, dynamic>> fields = [];

          data.forEach((key, value) {
            if (value is Map<String, dynamic> &&
                value.containsKey('displayName') &&
                value.containsKey('toDisplay') &&
                value.containsKey('value') &&
                value.containsKey('priority') &&
                value['toDisplay'] == 1) {
              fields.add(value);
            }
          });

          // Sort fields by priority
          fields.sort(
              (a, b) => (a['priority'] as int).compareTo(b['priority'] as int));

          List<Widget> fieldsToDisplay = fields.map((field) {
            String getFieldValue(Map<String, dynamic> field) {
              String value = field['value'].toString() ?? '';
              String prefix = field['prefix'] ?? '';
              String suffix = field['suffix'] ?? '';
              return '$prefix$value$suffix';
            }

            return DetailItem(
              title: field['displayName'],
              value: getFieldValue(field),
            );
          }).toList();

          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Product Details',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                ...fieldsToDisplay,
              ],
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

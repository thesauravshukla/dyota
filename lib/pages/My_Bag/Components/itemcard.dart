import 'package:dyota/pages/My_Bag/Components/delete_confirmation_dialog.dart';
import 'package:dyota/pages/My_Bag/Components/fetch_data.dart';
import 'package:dyota/pages/My_Bag/Components/image_loader.dart';
import 'package:dyota/pages/Product_Card/product_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  final String documentId;
  final VoidCallback onDelete;
  final Function(bool)? onLoadingChanged;

  ItemCard({
    required this.documentId,
    required this.onDelete,
    this.onLoadingChanged,
  });

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _isDeleted = false;
  bool _isLoading = true;
  bool _hasNotifiedLoading = false;
  Map<String, dynamic>? _cachedCartData;
  Map<String, dynamic>? _cachedDocumentData;

  @override
  void initState() {
    super.initState();

    // Only notify about loading after a short delay to prevent UI flashing
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted && !_hasNotifiedLoading && widget.onLoadingChanged != null) {
        _hasNotifiedLoading = true;
        widget.onLoadingChanged!(_isLoading);
      }
    });

    // Safety timeout to ensure loading state is eventually reset
    Future.delayed(Duration(seconds: 3), () {
      if (mounted && _isLoading) {
        _updateLoadingState(false);
      }
    });
  }

  String _parseDocumentId(String input) {
    return input.split('-')[0];
  }

  String _getFieldValue(Map<String, dynamic> field) {
    String value = field['value']?.toString() ?? '';
    String prefix = field['prefix']?.toString() ?? '';
    String suffix = field['suffix']?.toString() ?? '';
    return '$prefix$value$suffix';
  }

  void _updateLoadingState(bool isLoading) {
    if (_isLoading != isLoading) {
      _isLoading = isLoading;
      if (widget.onLoadingChanged != null && mounted) {
        // Use a longer delay to prevent too frequent updates
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) widget.onLoadingChanged!(_isLoading);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleted) {
      return SizedBox.shrink();
    }

    String parsedDocumentId = _parseDocumentId(widget.documentId);
    String unparsedDocumentId = widget.documentId;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _updateLoadingState(false);
      return Center(child: Text('User not logged in'));
    }
    final email = user.email!;

    // Use cached data to prevent rebuilds
    return FutureBuilder<Map<String, dynamic>?>(
      future: _cachedCartData != null
          ? Future.value(_cachedCartData)
          : fetchCartData(email, unparsedDocumentId),
      builder: (context, cartSnapshot) {
        if (cartSnapshot.connectionState == ConnectionState.waiting) {
          // Only notify parent if not already loading
          if (!_isLoading) _updateLoadingState(true);
          return const SizedBox(height: 0);
        } else if (cartSnapshot.connectionState == ConnectionState.done) {
          // Only reset if we're currently loading
          if (_isLoading) {
            // Delay the state update to ensure UI stability
            Future.delayed(Duration.zero, () {
              if (mounted) _updateLoadingState(false);
            });
          }
        } else if (cartSnapshot.hasError) {
          _updateLoadingState(false);
          return Center(child: Text('Error: ${cartSnapshot.error}'));
        } else if (!cartSnapshot.hasData || cartSnapshot.data == null) {
          _updateLoadingState(false);
          return Center(child: Text('No cart data found'));
        }

        // Cache the data to avoid refetching
        if (_cachedCartData == null) {
          _cachedCartData = cartSnapshot.data;
        }

        Map<String, dynamic> cartData = cartSnapshot.data!;
        List<Map<String, dynamic>> cartFields = cartData.entries
            .where((entry) => entry.value is Map<String, dynamic>)
            .map((entry) => entry.value as Map<String, dynamic>)
            .toList();

        cartFields.sort(
            (a, b) => (a['priority'] as int).compareTo(b['priority'] as int));

        return FutureBuilder<Map<String, dynamic>?>(
          future: _cachedDocumentData != null
              ? Future.value(_cachedDocumentData)
              : fetchDocumentData(parsedDocumentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              if (!_isLoading) _updateLoadingState(true);
              return const SizedBox(height: 0);
            } else if (snapshot.hasError) {
              _updateLoadingState(false);
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              _updateLoadingState(false);
              return Center(child: Text(''));
            }

            // Cache the document data
            if (_cachedDocumentData == null) {
              _cachedDocumentData = snapshot.data;
            }

            // We have all data, so we're not loading
            if (_isLoading) {
              _updateLoadingState(false);
            }

            Map<String, dynamic> data = snapshot.data!;
            List<Map<String, dynamic>> fields = data.entries
                .where((entry) => entry.value is Map<String, dynamic>)
                .map((entry) => entry.value as Map<String, dynamic>)
                .toList();

            fields.sort((a, b) =>
                (a['priority'] as int).compareTo(b['priority'] as int));

            List<Map<String, dynamic>> topFields = fields.take(2).toList();

            List<dynamic> imageLocations = data['imageLocation'];
            String imageLocation = imageLocations[0] ?? '';

            return ImageLoader(
              imageLocation: imageLocation,
              builder: (context, imageUrl) {
                _updateLoadingState(false);
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductCard(documentId: parsedDocumentId),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(5),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Image.network(
                            imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: cartFields
                                      .where((field) => field['toDisplay'] == 1)
                                      .map((field) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '${field['displayName'] ?? ''}:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              _getFieldValue(field),
                                              style: TextStyle(fontSize: 12),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDeleteConfirmationDialog(
                                  context, email, unparsedDocumentId, () {
                                setState(() {
                                  _isDeleted = true;
                                });
                                widget.onDelete();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    if (widget.onLoadingChanged != null && _isLoading) {
      Future.microtask(() {
        widget.onLoadingChanged!(false);
      });
    }
    super.dispose();
  }
}

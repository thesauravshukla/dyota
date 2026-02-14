import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/shared/app_image.dart';
import 'package:dyota/services/image_cache_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  final String documentId;

  const OrderCard({Key? key, required this.documentId}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;

  String _parseDocumentId(String input) => input.split('-')[0];

  String _getFieldValue(Map<String, dynamic> field) {
    final value = field['value']?.toString() ?? '';
    final prefix = field['prefix']?.toString() ?? '';
    final suffix = field['suffix']?.toString() ?? '';
    return '$prefix$value$suffix';
  }

  Future<String> _getImageUrl(String documentId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('items')
          .doc(documentId)
          .get();
      if (doc.exists) {
        final images = doc.data()?['imageLocation'] ?? [];
        if (images.isNotEmpty) {
          return await ImageCacheService.instance
                  .getImageUrl(images[0].toString()) ??
              '';
        }
      }
    } catch (_) {}
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('orders')
          .doc(widget.documentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 100, child: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox(
              height: 100, child: Center(child: Text('No data available')));
        }

        final data = snapshot.data!.data()!;
        final status = data['status'] ?? 'N/A';

        return Card(
          color: colorScheme.surface,
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: order number + status chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${data['orderId'] ?? 'Unknown'}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    _buildStatusChip(status, colorScheme),
                  ],
                ),
                const SizedBox(height: 12),

                // Quantity and total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${data['totalItems'] ?? 0} items',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    Text(
                      '${data['totalAmount']?['prefix'] ?? ''}${data['totalAmount']?['value'] ?? '0'}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Details button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () =>
                        setState(() => _isExpanded = !_isExpanded),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_isExpanded ? 'Hide Details' : 'View Details'),
                        const SizedBox(width: 4),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                // Expanded item list
                if (_isExpanded) _buildItemsList(user.email!, colorScheme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status, ColorScheme colorScheme) {
    Color chipColor;
    switch (status) {
      case 'Delivered':
        chipColor = Colors.green;
        break;
      case 'Cancelled':
        chipColor = colorScheme.error;
        break;
      default:
        chipColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: chipColor, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildItemsList(String email, ColorScheme colorScheme) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('orders')
          .doc(widget.documentId)
          .collection('items')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Center(child: Text('Error loading items')),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Center(child: Text('No items found')),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Divider(color: colorScheme.outline),
              ...snapshot.data!.docs.map((doc) {
                final itemData = doc.data();
                final productId = _parseDocumentId(doc.id);
                return _buildItemRow(productId, itemData, colorScheme);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemRow(String productId, Map<String, dynamic> itemData,
      ColorScheme colorScheme) {
    return FutureBuilder<String>(
      future: _getImageUrl(productId),
      builder: (context, imageSnapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: imageSnapshot.hasData &&
                          imageSnapshot.data!.isNotEmpty
                      ? AppImage(
                          url: imageSnapshot.data!, width: 72, height: 72)
                      : Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.image,
                              color: colorScheme.onSurfaceVariant),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: itemData.entries
                      .where((e) => e.value is Map<String, dynamic>)
                      .map((e) {
                    final field = e.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: '${field['displayName'] ?? ''}: ',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          TextSpan(
                            text: _getFieldValue(field),
                            style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant),
                          ),
                        ]),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

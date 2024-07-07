import 'package:dyota/pages/My_Bag/Components/delete_confirmation_dialog.dart';
import 'package:dyota/pages/My_Bag/Components/fetch_data.dart';
import 'package:dyota/pages/My_Bag/Components/image_loader.dart';
import 'package:dyota/pages/Product_Card/product_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  final String documentId;
  final VoidCallback onDelete;

  ItemCard({required this.documentId, required this.onDelete});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _isDeleted = false;

  String _parseDocumentId(String input) {
    return input.split('-')[0];
  }

  String _getFieldValue(Map<String, dynamic> field) {
    String value = field['value']?.toString() ?? '';
    String prefix = field['prefix']?.toString() ?? '';
    String suffix = field['suffix']?.toString() ?? '';
    return '$prefix$value$suffix';
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
      return Center(child: Text('User not logged in'));
    }
    final email = user.email!;

    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchCartData(email, unparsedDocumentId),
      builder: (context, cartSnapshot) {
        if (cartSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (cartSnapshot.hasError) {
          return Center(child: Text('Error: ${cartSnapshot.error}'));
        } else if (!cartSnapshot.hasData || cartSnapshot.data == null) {
          return Center(child: Text('No cart data found'));
        }

        Map<String, dynamic> cartData = cartSnapshot.data!;
        List<Map<String, dynamic>> cartFields = cartData.entries
            .where((entry) => entry.value is Map<String, dynamic>)
            .map((entry) => entry.value as Map<String, dynamic>)
            .toList();

        cartFields.sort(
            (a, b) => (a['priority'] as int).compareTo(b['priority'] as int));

        return FutureBuilder<Map<String, dynamic>?>(
          future: fetchDocumentData(parsedDocumentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text(''));
            }

            Map<String, dynamic> data = snapshot.data!;
            List<Map<String, dynamic>> fields = data.entries
                .where((entry) => entry.value is Map<String, dynamic>)
                .map((entry) => entry.value as Map<String, dynamic>)
                .toList();

            fields.sort((a, b) =>
                (a['priority'] as int).compareTo(b['priority'] as int));

            List<Map<String, dynamic>> topFields = fields.take(2).toList();

            String imageLocation = data['imageLocation'] ?? '';

            return ImageLoader(
              imageLocation: imageLocation,
              builder: (context, imageUrl) {
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
}

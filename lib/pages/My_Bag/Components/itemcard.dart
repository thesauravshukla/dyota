import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Product_Card/product_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  final String documentId;

  ItemCard({required this.documentId});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _isDeleted = false;

  String _parseDocumentId(String input) {
    return input.split('-')[0];
  }

  Future<Map<String, dynamic>?> _fetchDocumentData(String docId) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('items').doc(docId).get();
    return doc.data() as Map<String, dynamic>?;
  }

  Future<String> _getImageUrl(String imageLocation) async {
    return await FirebaseStorage.instance.ref(imageLocation).getDownloadURL();
  }

  Future<Map<String, dynamic>?> _fetchCartData(
      String email, String unparsedDocumentId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cartItemsList')
        .doc(unparsedDocumentId)
        .get();
    return doc.data() as Map<String, dynamic>?;
  }

  Future<void> _deleteItem(
      BuildContext context, String email, String unparsedDocumentId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cartItemsList')
        .doc(unparsedDocumentId)
        .delete();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Item removed from bag')));
    setState(() {
      _isDeleted = true;
    });
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String email, String unparsedDocumentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Item'),
          content:
              Text('Are you sure you want to remove this item from the bag?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _deleteItem(context, email, unparsedDocumentId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
      future: _fetchCartData(email, unparsedDocumentId),
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
          future: _fetchDocumentData(parsedDocumentId),
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

            return FutureBuilder<String>(
              future: _getImageUrl(imageLocation),
              builder: (context, imageSnapshot) {
                if (imageSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (imageSnapshot.hasError) {
                  return Center(child: Text('Error: ${imageSnapshot.error}'));
                } else if (!imageSnapshot.hasData) {
                  return Center(child: Text(''));
                }

                String imageUrl = imageSnapshot.data!;

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
                        child: Row(children: [
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
                                  children: cartFields.map((field) {
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
                                              field['value'].toString() ?? '',
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
                              _showDeleteConfirmationDialog(
                                  context, email, unparsedDocumentId);
                            },
                          ),
                        ]),
                      ),
                    ));
              },
            );
          },
        );
      },
    );
  }
}

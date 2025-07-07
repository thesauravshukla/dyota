import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  final String documentId;

  const OrderCard({Key? key, required this.documentId}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;

  String _parseDocumentId(String input) {
    return input.split('-')[0];
  }

  String _getFieldValue(Map<String, dynamic> field) {
    String value = field['value']?.toString() ?? '';
    String prefix = field['prefix']?.toString() ?? '';
    String suffix = field['suffix']?.toString() ?? '';
    return '$prefix$value$suffix';
  }

  Future<String> _getImageUrl(String documentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('items')
          .doc(documentId)
          .get();

      if (doc.exists) {
        List<dynamic> imageLocations = doc.data()?['imageLocation'] ?? [];
        if (imageLocations.isNotEmpty) {
          String imagePath = imageLocations[0];
          final ref = FirebaseStorage.instance.ref().child(imagePath);
          return await ref.getDownloadURL();
        } else {
          print('No image locations found for documentId: $documentId');
        }
      } else {
        print('Document not found for documentId: $documentId');
      }
    } catch (e) {
      print('Error fetching image URL for documentId $documentId: $e');
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    String parsedDocumentId = _parseDocumentId(widget.documentId);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('orders')
          .doc(widget.documentId)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text('No data available')),
          );
        }

        final data = snapshot.data!.data()!;
        final status = data['status'] ?? 'N/A';

        return Card(
          color: Colors.grey[200], // Set the card color to grey
          elevation: 4.0,
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Order No. ${data['orderId'] ?? 'Unknown'}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Quantity: ${data['totalItems'] ?? 0}'),
                    Text(
                      'Total Amount: ${data['totalAmount']?['prefix'] ?? ''}${data['totalAmount']?['value'] ?? '0'}',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(_isExpanded ? 'Hide Details' : 'Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                if (_isExpanded)
                  FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.email)
                        .collection('orders')
                        .doc(widget.documentId)
                        .collection('items')
                        .get(),
                    builder: (context, itemsSnapshot) {
                      if (itemsSnapshot.hasError) {
                        return Center(child: Text('Error loading items'));
                      }

                      if (!itemsSnapshot.hasData ||
                          itemsSnapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No items found'));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: itemsSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = itemsSnapshot.data!.docs[index];
                          final itemData = doc.data();
                          final productId = _parseDocumentId(doc.id);

                          return FutureBuilder<String>(
                            future: _getImageUrl(productId),
                            builder: (context, imageSnapshot) {
                              return Card(
                                color: Colors.grey[300],
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        child: imageSnapshot.hasData &&
                                                imageSnapshot.data!.isNotEmpty
                                            ? Image.network(
                                                imageSnapshot.data!,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                color: Colors.grey[400],
                                                child: Icon(Icons.image,
                                                    color: Colors.grey[600]),
                                              ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: itemData.entries
                                              .where((entry) => entry.value
                                                  is Map<String, dynamic>)
                                              .map((entry) {
                                            final field = entry.value;
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${field['displayName'] ?? ''}: ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          _getFieldValue(field),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Handle status action
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:
                          status == 'Delivered' ? Colors.green : Colors.black,
                    ),
                    child: Text(status),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

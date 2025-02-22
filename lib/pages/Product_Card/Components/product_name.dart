import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductName extends StatelessWidget {
  final String documentId;

  const ProductName({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('items').doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
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
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDescription extends StatelessWidget {
  final String documentId;

  const ProductDescription({Key? key, required this.documentId})
      : super(key: key);

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
        final productDescriptionMap =
            data['productDescription'] as Map<String, dynamic>?;

        final productDescription = productDescriptionMap != null
            ? productDescriptionMap['value'] ?? 'No description available.'
            : 'No description available.';

        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 2),
          child: Text(
            productDescription,
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
        );
      },
    );
  }
}

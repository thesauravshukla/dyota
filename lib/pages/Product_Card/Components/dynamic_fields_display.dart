import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Product_Card/Components/detail_item.dart';
import 'package:flutter/material.dart';

class DynamicFieldsDisplay extends StatelessWidget {
  final String documentId;

  const DynamicFieldsDisplay({Key? key, required this.documentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('items').doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
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

        List<Widget> fieldsToDisplay = fields
            .map((field) => DetailItem(
                  title: field['displayName'],
                  value: field['value'].toString(),
                ))
            .toList();

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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              ...fieldsToDisplay,
            ],
          ),
        );
      },
    );
  }
}

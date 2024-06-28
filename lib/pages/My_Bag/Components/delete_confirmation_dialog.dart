import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void showDeleteConfirmationDialog(BuildContext context, String email,
    String unparsedDocumentId, VoidCallback onDelete) {
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
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(email)
                  .collection('cartItemsList')
                  .doc(unparsedDocumentId)
                  .delete();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Item removed from bag')));
              onDelete();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

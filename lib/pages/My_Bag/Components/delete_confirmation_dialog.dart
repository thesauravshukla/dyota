import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('DeleteConfirmationDialog');

void showDeleteConfirmationDialog(BuildContext context, String email,
    String unparsedDocumentId, VoidCallback onDelete) {
  _logger.info(
      'Showing delete confirmation dialog for document ID: $unparsedDocumentId');

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
              _logger.info('Delete action cancelled');
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () async {
              _logger.info(
                  'Confirmed delete for document ID: $unparsedDocumentId');
              Navigator.of(context).pop(); // Close the dialog first
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(email)
                  .collection('cartItemsList')
                  .doc(unparsedDocumentId)
                  .delete();
              _logger.info(
                  'Item deleted from Firestore for document ID: $unparsedDocumentId');
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Item removed from bag')));
              onDelete();
            },
          ),
        ],
      );
    },
  );
}

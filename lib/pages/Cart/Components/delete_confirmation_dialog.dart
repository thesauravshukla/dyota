import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/shared/app_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('DeleteConfirmationDialog');

void showDeleteConfirmationDialog(BuildContext context, String email,
    String unparsedDocumentId, VoidCallback onDelete) async {
  _logger.info(
      'Showing delete confirmation dialog for document ID: $unparsedDocumentId');

  final confirmed = await showAppConfirmDialog(
    context,
    title: 'Remove Item',
    message: 'Are you sure you want to remove this item from the bag?',
  );

  if (!confirmed) {
    _logger.info('Delete action cancelled');
    return;
  }

  _logger.info('Confirmed delete for document ID: $unparsedDocumentId');
  await FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('cartItemsList')
      .doc(unparsedDocumentId)
      .delete();
  _logger.info(
      'Item deleted from Firestore for document ID: $unparsedDocumentId');
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Item removed from bag')));
  onDelete();
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('FetchData');

Future<Map<String, dynamic>?> fetchDocumentData(String docId) async {
  _logger.info('Fetching document data for docId: $docId');
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('items').doc(docId).get();
  _logger.info('Document data fetched for docId: $docId');
  return doc.data() as Map<String, dynamic>?;
}

Future<Map<String, dynamic>?> fetchCartData(
    String email, String unparsedDocumentId) async {
  _logger
      .info('Fetching cart data for email: $email, docId: $unparsedDocumentId');
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('cartItemsList')
      .doc(unparsedDocumentId)
      .get();
  _logger
      .info('Cart data fetched for email: $email, docId: $unparsedDocumentId');
  return doc.data() as Map<String, dynamic>?;
}

Future<String> getImageUrl(String imageLocation) async {
  _logger.info('Fetching image URL for location: $imageLocation');
  String url =
      await FirebaseStorage.instance.ref(imageLocation).getDownloadURL();
  _logger.info('Image URL fetched for location: $imageLocation');
  return url;
}

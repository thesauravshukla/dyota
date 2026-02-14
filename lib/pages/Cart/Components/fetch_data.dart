import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/services/image_cache_service.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('FetchData');

Future<Map<String, dynamic>?> fetchDocumentData(String docId) async {
  _logger.info('Fetching document data for docId: $docId');
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('items').doc(docId).get();
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
  return doc.data() as Map<String, dynamic>?;
}

Future<String> getImageUrl(String imageLocation) async {
  final url = await ImageCacheService.instance.getImageUrl(imageLocation);
  return url ?? '';
}

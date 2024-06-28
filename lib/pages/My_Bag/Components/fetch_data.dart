import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<Map<String, dynamic>?> fetchDocumentData(String docId) async {
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('items').doc(docId).get();
  return doc.data() as Map<String, dynamic>?;
}

Future<Map<String, dynamic>?> fetchCartData(
    String email, String unparsedDocumentId) async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(email)
      .collection('cartItemsList')
      .doc(unparsedDocumentId)
      .get();
  return doc.data() as Map<String, dynamic>?;
}

Future<String> getImageUrl(String imageLocation) async {
  return await FirebaseStorage.instance.ref(imageLocation).getDownloadURL();
}

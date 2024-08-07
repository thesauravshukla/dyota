import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger('FirestoreService');
  Future<List<String>> getDocumentIds(String collectionName,
      String checkCategory, List<String> subCategoryList) async {
    if (collectionName == "items") {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .where('category.value', isEqualTo: checkCategory)
          .where('subCategory.value', whereIn: subCategoryList)
          .get();
      List<String> documentIds =
          querySnapshot.docs.map((doc) => doc.id).toList();
      return documentIds;
    } else {
      _logger.severe("The collection is not 'items'.");
      return [];
    }
  }
}

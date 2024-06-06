import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getDocumentIds(String collectionName,
      String checkCategory, List<String> subCategoryList) async {
    try {
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
        print("The collection is not 'items'.");
        return [];
      }
    } catch (e) {
      print("Error fetching document IDs: $e");
      return [];
    }
  }
}

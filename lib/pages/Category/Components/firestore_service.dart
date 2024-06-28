import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Future<List<String>> getDocumentIds(
    String collection,
    String categoryName,
    List<String> selectedCategories,
  ) async {
    // Implement the logic to fetch document IDs based on the category and selected categories
    // This is a placeholder implementation
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where('category', isEqualTo: categoryName)
        .where('subCategory', arrayContainsAny: selectedCategories)
        .get();

    return querySnapshot.docs.map((doc) => doc.id).toList();
  }
}

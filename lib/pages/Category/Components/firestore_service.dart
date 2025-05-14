import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger('FirestoreService');

  Future<List<String>> getDocumentIds(
    String collectionName,
    String categoryName,
    List<String> subCategoryList,
  ) async {
    _logger.info(
        'getDocumentIds called with collectionName: $collectionName, categoryName: $categoryName, subCategoryList: $subCategoryList');

    if (collectionName == "items") {
      _logger.fine('Querying Firestore for collection: $collectionName');
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .where('category.value', isEqualTo: categoryName)
          .where('subCategory.value', whereIn: subCategoryList)
          .get();

      List<String> documentIds =
          querySnapshot.docs.map((doc) => doc.id).toList();
      _logger.info('Fetched document IDs: $documentIds');
      return documentIds;
    } else {
      _logger.severe("The collection is not 'items'.");
      return [];
    }
  }

  Future<DocumentSnapshot> getDocument(
      String collection, String documentId) async {
    _logger.info('Fetching document from $collection with ID: $documentId');
    return await _firestore.collection(collection).doc(documentId).get();
  }

  Future<List<Map<String, dynamic>>> getItemsWithPrice(
      List<String> documentIds) async {
    _logger.info('Fetching price information for ${documentIds.length} items');
    List<Map<String, dynamic>> itemsWithPrice = [];

    for (String id in documentIds) {
      DocumentSnapshot doc = await _firestore.collection('items').doc(id).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        itemsWithPrice.add({
          'id': id,
          'pricePerMetre': data['pricePerMetre']['value'],
        });
      }
    }

    return itemsWithPrice;
  }

  List<String> sortItemsByPrice(
      List<Map<String, dynamic>> itemsWithPrice, String sortOption) {
    _logger.info('Sorting items by: $sortOption');

    if (sortOption == 'Price: lowest to high') {
      itemsWithPrice.sort((a, b) => double.parse(a['pricePerMetre'].toString())
          .compareTo(double.parse(b['pricePerMetre'].toString())));
    } else if (sortOption == 'Price: high to low') {
      itemsWithPrice.sort((a, b) => double.parse(b['pricePerMetre'].toString())
          .compareTo(double.parse(a['pricePerMetre'].toString())));
    }

    return itemsWithPrice.map((item) => item['id'] as String).toList();
  }
}

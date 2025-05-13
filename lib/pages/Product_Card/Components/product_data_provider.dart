import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Product_Card/Components/product_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';

/// Provides methods for fetching and managing product data
class ProductDataProvider {
  final Logger _logger = Logger('ProductDataProvider');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Fetches the product data for a given document ID
  Future<ProductData> fetchProductData(String documentId) async {
    try {
      _logger.info('Fetching product data for documentId: $documentId');
      DocumentSnapshot doc =
          await _firestore.collection('items').doc(documentId).get();

      if (!doc.exists) {
        _logger.warning('Document does not exist for documentId: $documentId');
        return ProductData.empty(documentId);
      }

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String parentId = data['parentId'] ?? '';
      List<dynamic> imageLocations = data['imageLocation'] ?? [];
      String? categoryValue = data['category']?['value'];

      // Fetch all images from imageLocation array
      List<String> allImageUrls = await _fetchImageUrls(imageLocations);

      // Fetch variants (other products with the same parent ID)
      List<ProductVariant> variants =
          await _fetchVariants(documentId, parentId);

      _logger.info(
          'Product data fetched successfully for documentId: $documentId');

      return ProductData(
        documentId: documentId,
        allImageUrls: allImageUrls,
        variants: variants,
        categoryValue: categoryValue,
      );
    } catch (e) {
      _logger.severe(
          'Error fetching product data for documentId: $documentId', e);
      return ProductData.empty(documentId);
    }
  }

  /// Fetches image URLs from a list of image locations
  Future<List<String>> _fetchImageUrls(List<dynamic> imageLocations) async {
    List<String> urls = [];
    for (String imageLocation in imageLocations) {
      try {
        String imageUrl = await _storage.ref(imageLocation).getDownloadURL();
        urls.add(imageUrl);
      } catch (e) {
        _logger.warning(
            'Failed to fetch image URL for location: $imageLocation', e);
      }
    }
    return urls;
  }

  /// Fetches variants of a product (other products with the same parent ID)
  Future<List<ProductVariant>> _fetchVariants(
      String documentId, String parentId) async {
    List<ProductVariant> variants = [];

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('items')
          .where('parentId', isEqualTo: parentId)
          .where(FieldPath.documentId, isNotEqualTo: documentId)
          .get();

      for (var document in querySnapshot.docs) {
        Map<String, dynamic> docData = document.data() as Map<String, dynamic>;
        if (docData.containsKey('imageLocation')) {
          List<dynamic> docImageLocations = docData['imageLocation'];
          if (docImageLocations.isNotEmpty) {
            String imageUrl =
                await _storage.ref(docImageLocations[0]).getDownloadURL();
            variants.add(ProductVariant(
              documentId: document.id,
              imageUrl: imageUrl,
            ));
          }
        }
      }
    } catch (e) {
      _logger.warning('Error fetching product variants', e);
    }

    return variants;
  }

  /// Updates the recently viewed products list for the current user
  Future<void> updateRecentlyViewedProducts(String documentId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return;

      String email = user.email!;
      DocumentReference userDocRef = _firestore.collection('users').doc(email);

      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        List<dynamic> recentlyViewedProducts =
            userDoc['recentlyViewedProducts'] ?? [];

        // Don't add duplicates
        if (!recentlyViewedProducts.contains(documentId)) {
          // Limit to 5 items
          if (recentlyViewedProducts.length >= 5) {
            recentlyViewedProducts.removeAt(0);
          }
          recentlyViewedProducts.add(documentId);

          await userDocRef.update({
            'recentlyViewedProducts': recentlyViewedProducts,
          });
        }
      } else {
        // Create a new user document with the recently viewed product
        await userDocRef.set({
          'recentlyViewedProducts': [documentId],
        });
      }
    } catch (e) {
      _logger.severe('Error updating recently viewed products', e);
    }
  }

  /// Fetches the list of recently viewed products for the current user
  Future<List<RelatedProduct>> fetchRecentlyViewedProducts() async {
    List<RelatedProduct> recentlyViewed = [];

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return recentlyViewed;

      String email = user.email!;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(email).get();

      if (userDoc.exists) {
        List<dynamic> recentlyViewedProducts =
            userDoc['recentlyViewedProducts'] ?? [];

        for (String documentId in recentlyViewedProducts) {
          DocumentSnapshot doc =
              await _firestore.collection('items').doc(documentId).get();
          if (doc.exists) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            List<dynamic> imageLocations = data['imageLocation'] ?? [];
            if (imageLocations.isNotEmpty) {
              String imageUrl =
                  await _storage.ref(imageLocations[0]).getDownloadURL();
              recentlyViewed.add(RelatedProduct(
                imageUrl: imageUrl,
                documentId: documentId,
              ));
            }
          }
        }
      }
    } catch (e) {
      _logger.severe('Error fetching recently viewed products', e);
    }

    return recentlyViewed;
  }

  /// Fetches products that other users also viewed (same category)
  Future<List<RelatedProduct>> fetchRelatedProducts(
      String categoryValue) async {
    List<RelatedProduct> relatedProducts = [];

    try {
      if (categoryValue.isEmpty) return relatedProducts;

      QuerySnapshot querySnapshot = await _firestore
          .collection('items')
          .where('category.value', isEqualTo: categoryValue)
          .limit(10) // Limit to avoid too many results
          .get();

      for (var document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        List<dynamic> imageLocations = data['imageLocation'] ?? [];
        if (imageLocations.isNotEmpty) {
          String imageUrl =
              await _storage.ref(imageLocations[0]).getDownloadURL();
          relatedProducts.add(RelatedProduct(
            imageUrl: imageUrl,
            documentId: document.id,
          ));
        }
      }
    } catch (e) {
      _logger.severe('Error fetching related products', e);
    }

    return relatedProducts;
  }
}

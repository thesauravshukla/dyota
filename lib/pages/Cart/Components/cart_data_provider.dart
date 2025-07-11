import 'package:cloud_firestore/cloud_firestore.dart';

/// Provides data streams for cart-related information from Firestore.
class CartDataProvider {
  /// Returns a stream of the user document data
  Stream<DocumentSnapshot> getUserStream(String userEmail) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .snapshots();
  }

  /// Returns a stream of cart items for a specific user
  Stream<QuerySnapshot> getCartItemsStream(String userEmail) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('cartItemsList')
        .snapshots();
  }
}

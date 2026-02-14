import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:dyota/services/image_cache_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

/// Data model for a cart item with product details
class CartItem {
  final String documentId;
  final String imageUrl;
  final String productName;
  final List<double> allowedLengths;
  final String
      pricePerMetre; // Store as string to avoid decimal conversion issues
  final String
      taxPercentage; // Store as string to avoid decimal conversion issues

  CartItem({
    required this.documentId,
    required this.imageUrl,
    required this.productName,
    required this.allowedLengths,
    required this.pricePerMetre,
    required this.taxPercentage,
  });

  /// Creates a CartItem with default values
  factory CartItem.empty(String documentId) {
    return CartItem(
      documentId: documentId,
      imageUrl: '',
      productName: 'Unknown Product',
      allowedLengths: [],
      pricePerMetre: '0',
      taxPercentage: '0',
    );
  }
}

/// Manages cart operations including fetching product data and adding items to cart
class CartItemManager {
  final Logger _logger = Logger('CartItemManager');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImageCacheService _imageCache = ImageCacheService.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetches product data for the given document IDs
  Future<List<CartItem>> fetchCartItemsData(List<String> documentIds) async {
    List<CartItem> items = [];

    try {
      for (String docId in documentIds) {
        DocumentSnapshot doc =
            await _firestore.collection('items').doc(docId).get();

        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Get image URL
          List<dynamic> imageLocations = data['imageLocation'] ?? [];
          String imageUrl = '';

          if (imageLocations.isNotEmpty) {
            imageUrl = await _imageCache
                    .getImageUrl(imageLocations[0].toString()) ??
                '';
          }

          // Get allowed lengths array and convert to List<double>
          List<dynamic> allowedLengthsRaw = data['allowedLengths'] ?? [];
          List<double> allowedLengths = allowedLengthsRaw
              .map((length) => double.parse(length.toString()))
              .toList();

          // Get product name
          Map<String, dynamic> productNameMap = data['productName'] ?? {};
          String productName = productNameMap['value'] ?? 'Unknown Product';

          // Get price per metre
          String pricePerMetre =
              (data['pricePerMetre']?['value'] ?? '0').toString();

          // Get tax percentage
          String taxPercentage = (data['tax']?['value'] ?? '0').toString();

          items.add(CartItem(
            documentId: docId,
            imageUrl: imageUrl,
            productName: productName,
            allowedLengths: allowedLengths,
            pricePerMetre: pricePerMetre,
            taxPercentage: taxPercentage,
          ));
        } else {
          _logger.warning('Document does not exist: $docId');
        }
      }

      _logger.info(
          'Fetched cart items data successfully for ${items.length} items');
      return items;
    } catch (e) {
      _logger.severe('Error fetching cart items data', e);
      return [];
    }
  }

  /// Calculates the price for a given item and length
  String calculatePrice(CartItem item, double length) {
    var pricePerMetreDecimal = Decimal.parse(item.pricePerMetre);
    var lengthDecimal = Decimal.parse(length.toString());
    var price = pricePerMetreDecimal * lengthDecimal;
    return price.toString();
  }

  /// Calculates the tax for a given item and length
  String calculateTax(CartItem item, double length) {
    // First calculate price using Decimal
    final pricePerMetreDecimal = Decimal.parse(item.pricePerMetre);
    final lengthDecimal = Decimal.parse(length.toString());
    final price = pricePerMetreDecimal * lengthDecimal;

    // Now calculate tax using double to avoid Decimal/Rational issues
    final priceDouble = double.parse(price.toString());
    final taxPercentageDouble = double.parse(item.taxPercentage);
    final taxDouble = priceDouble * taxPercentageDouble / 100.0;

    // Return as string
    return taxDouble.toString();
  }

  /// Adds the selected items to the user's cart
  Future<bool> addItemsToCart(
      List<CartItem> items, List<double> selectedLengths) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      _logger.warning('User not logged in');
      return false;
    }

    final email = user.email!;

    try {
      for (int i = 0; i < items.length; i++) {
        if (i >= selectedLengths.length) continue;

        final item = items[i];
        final length = selectedLengths[i];

        if (length <= 0) continue;

        final price = calculatePrice(item, length);
        final tax = calculateTax(item, length);

        await _firestore
            .collection('users')
            .doc(email)
            .collection('cartItemsList')
            .doc('${item.documentId}-textile')
            .set({
          'itemType': {
            'displayName': 'Order Type',
            'value': 'Textile Order',
            'toDisplay': 1,
            'priority': 2,
          },
          'orderLength': {
            'displayName': 'Order Length',
            'value': length.toString(),
            'suffix': 'm',
            'toDisplay': 1,
            'priority': 3,
          },
          'price': {
            'displayName': 'Price',
            'prefix': 'Rs. ',
            'value': price,
            'toDisplay': 1,
            'priority': 4,
          },
          'tax': {
            'displayName': 'Tax',
            'prefix': 'Rs. ',
            'value': tax,
            'toDisplay': 1,
            'priority': 5,
          },
          'productName': {
            'displayName': 'Product Name',
            'value': item.productName,
            'toDisplay': 1,
            'priority': 1,
          },
        }, SetOptions(merge: true));

        _logger.info('Added item to cart: ${item.documentId}');
      }

      return true;
    } catch (e) {
      _logger.severe('Error adding items to cart', e);
      return false;
    }
  }

  /// Checks if the user is logged in
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }
}

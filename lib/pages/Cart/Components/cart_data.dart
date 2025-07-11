import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';

/// Encapsulates cart data with immutable properties.
/// Handles the calculation of total amount from cart items.
class CartData {
  final List<QueryDocumentSnapshot> items;
  final Decimal minimumOrderValue;
  final Decimal totalAmount;

  CartData({
    required this.items,
    required this.minimumOrderValue,
  }) : totalAmount = _calculateTotalAmount(items);

  /// Calculates the total amount from a list of cart items
  static Decimal _calculateTotalAmount(List<QueryDocumentSnapshot> items) {
    Decimal total = Decimal.zero;
    for (var doc in items) {
      Map<String, dynamic> priceMap = doc.get('price');
      total += Decimal.parse(priceMap['value'].toString());
    }
    return total;
  }
}

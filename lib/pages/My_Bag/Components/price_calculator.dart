import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';

class PriceCalculator {
  final List<QueryDocumentSnapshot> cartItems;

  PriceCalculator(this.cartItems);

  Decimal calculateSubtotal() {
    return cartItems.fold(Decimal.zero, (sum, doc) {
      final data = doc.data() as Map<String, dynamic>;
      final priceMap =
          data['price'] as Map<String, dynamic>? ?? {'value': '0.0'};
      return sum + Decimal.parse(priceMap['value'].toString());
    });
  }

  Decimal calculateTax() {
    return cartItems.fold(Decimal.zero, (sum, doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('tax') && data['tax'] is Map<String, dynamic>) {
        final taxMap = data['tax'] as Map<String, dynamic>;
        if (taxMap.containsKey('value')) {
          return sum + Decimal.parse(taxMap['value'].toString());
        }
      }
      return sum;
    });
  }

  Decimal get totalAmountDecimal {
    return calculateSubtotal() + calculateTax();
  }

  get totalAmount {
    final total = calculateSubtotal() + calculateTax();
    return total;
  }
}

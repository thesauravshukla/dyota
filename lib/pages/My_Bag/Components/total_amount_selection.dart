import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:dyota/pages/My_Bag/Components/payment_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TotalAmountSection extends StatelessWidget {
  final Decimal minimumOrderQuantity;

  const TotalAmountSection({Key? key, required this.minimumOrderQuantity})
      : super(key: key);

  Future<Decimal> _calculateSubtotal() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      return Decimal.zero;
    }

    final email = user.email!;
    final cartItemsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cartItemsList')
        .get();

    Decimal subtotal = cartItemsSnapshot.docs.fold(Decimal.zero, (sum, doc) {
      final data = doc.data();
      final priceMap =
          data['price'] as Map<String, dynamic>? ?? {'value': '0.0'};
      Decimal priceValue = Decimal.parse(priceMap['value'].toString());
      return sum + priceValue;
    });

    return subtotal;
  }

  Future<Decimal> _calculateTax() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      return Decimal.zero;
    }

    final email = user.email!;
    final cartItemsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cartItemsList')
        .get();

    Decimal totalTax = Decimal.zero;

    for (var doc in cartItemsSnapshot.docs) {
      final data = doc.data();
      if (data.containsKey('tax') && data['tax'] is Map<String, dynamic>) {
        final taxMap = data['tax'] as Map<String, dynamic>;
        if (taxMap.containsKey('value')) {
          Decimal taxValue = Decimal.parse(taxMap['value'].toString());
          totalTax += taxValue;
        }
      }
    }

    return totalTax;
  }

  Future<Decimal> _calculateTotalAmount() async {
    final subtotal = await _calculateSubtotal();
    final tax = await _calculateTax();
    return subtotal + tax;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Decimal>(
      future: _calculateTotalAmount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final totalAmount = snapshot.data ?? Decimal.zero;

        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Total amount:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Rs. ${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: totalAmount >= minimumOrderQuantity
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentPage()),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Proceed To Payment'),
              ),
            ],
          ),
        );
      },
    );
  }
}

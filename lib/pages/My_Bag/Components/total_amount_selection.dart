import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:dyota/pages/My_Bag/Components/payment_page.dart';
import 'package:dyota/pages/My_Bag/Components/price_calculator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TotalAmountSection extends StatelessWidget {
  final Decimal minimumOrderQuantity;

  const TotalAmountSection({Key? key, required this.minimumOrderQuantity})
      : super(key: key);

  Future<Decimal> _calculateTotalAmount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      return Decimal.zero;
    }

    final cartItemsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email!)
        .collection('cartItemsList')
        .get();

    final calculator = PriceCalculator(cartItemsSnapshot.docs);
    return calculator.totalAmountDecimal;
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
                  backgroundColor: Colors.black,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/My_Bag/Components/payment_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TotalAmountSection extends StatelessWidget {
  Future<double> _calculateTotalAmount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      return 0.0;
    }

    final email = user.email!;
    final cartItemsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('cartItemsList')
        .get();

    double totalAmount = 0.0;

    for (var doc in cartItemsSnapshot.docs) {
      final data = doc.data();
      if (data.containsKey('price') && data['price'] is Map<String, dynamic>) {
        final priceMap = data['price'] as Map<String, dynamic>;
        if (priceMap.containsKey('value')) {
          final priceValue =
              double.tryParse(priceMap['value'].toString()) ?? 0.0;
          totalAmount += priceValue;
        }
      }
    }

    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: _calculateTotalAmount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final totalAmount = snapshot.data ?? 0.0;

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentPage()),
                  );
                },
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

import 'package:dyota/pages/My_Bag/Components/promocodetile.dart';
import 'package:flutter/material.dart';

class PromoCodeModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example promo codes - replace with your actual data
    final List<Map<String, dynamic>> promoCodes = [
      {
        'discount': '10%',
        'title': 'Personal offer',
        'code': 'mypromocode2020',
        'daysRemaining': 6,
      },
      // Add more promo codes here
    ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Wrap(
        children: [
          Text('Your Promo Codes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ...promoCodes.map((promo) => PromoCodeTile(promo: promo)).toList(),
        ],
      ),
    );
  }
}

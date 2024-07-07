import 'package:flutter/material.dart';

class BestSellerHeader extends StatelessWidget {
  const BestSellerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Best Sellers',
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}

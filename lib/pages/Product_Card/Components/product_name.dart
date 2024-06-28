import 'package:flutter/material.dart';

class ProductName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Text(
        'Product Name', // Replace 'Product Name' with your dynamic product name variable if needed
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

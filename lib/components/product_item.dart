import 'package:dyota/pages/product_card.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final int index;

  const ProductItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // List of product names
    List<String> productNames = [
      "Item name #1",
      "Item name #2",
      "Item name #3",
      "Item name #4"
    ];

    return GestureDetector(
      // Wrap Card with GestureDetector
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ProductCard()), // Navigate to ProductCard page
        );
      },
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Colors.blue, // Placeholder for product images
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productNames[index % productNames.length],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text('From Price'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

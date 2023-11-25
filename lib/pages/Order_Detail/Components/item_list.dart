import 'package:dyota/components/item_card.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      // Example item
      {
        'title': 'Pullover',
        'subtitle': 'Mango',
        'color': 'Gray',
        'size': 'L',
        'price': '51\$',
        'imageUrl':
            'https://via.placeholder.com/150', // Replace with actual image URL
      },
      // You can add more items here...
    ];

    return Column(
      children: items.map((item) => ItemCard(item: item)).toList(),
    );
  }
}

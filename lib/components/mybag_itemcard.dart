import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace with your actual item data
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Placeholder(
                fallbackWidth: 100,
                fallbackHeight: 100), // Replace with actual image
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pullover',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Color: Black  Size: L'),
                  Text('1'),
                  Text('51\$', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Icon(Icons.more_vert),
          ],
        ),
      ),
    );
  }
}

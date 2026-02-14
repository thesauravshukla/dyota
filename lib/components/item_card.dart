import 'package:dyota/components/shared/app_image.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(8), // Reduced padding
        child: Row(
          mainAxisSize: MainAxisSize.min, // Make row take minimum space
          children: [
            AppImage(
              url: item['imageUrl'],
              width: 100,
              height: 100,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // Make column take minimum space
                children: [
                  Text(
                    item['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4), // Reduced spacing
                  Text(
                    item['subtitle'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4), // Reduced spacing
                  Text(
                    'Color: ${item['color']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4), // Reduced spacing
                  Text(
                    'Size: ${item['size']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4), // Reduced spacing
                  Text(
                    'Price: ${item['price']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

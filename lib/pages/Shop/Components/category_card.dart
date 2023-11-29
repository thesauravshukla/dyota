import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String status; // The text to display on the left side of the card

  const CategoryCard({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder for the right side image
    final String placeholderImage = 'https://via.placeholder.com/150';

    return Card(
      clipBehavior: Clip
          .antiAlias, // Ensuring the image respects the card's rounded corners
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners for the Card
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0), // Padding for the text
              child: Center(
                // Center the text vertically and horizontally
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 18, // Adjust the font size as needed
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Ink.image(
              image: NetworkImage(placeholderImage),
              fit: BoxFit.cover, // Cover the right half of the card
              height: 100, // Set a fixed height for the image
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0), // Black padding around the search bar
      color: Colors.black, // Background color for the padding
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white, // White color for the search bar
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(width: 10), // Spacing before the icon
            Icon(Icons.search, color: Colors.black),
            SizedBox(width: 10), // Spacing between icon and text
            Text(
              'Search...',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

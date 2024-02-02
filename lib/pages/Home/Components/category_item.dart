import 'package:dyota/pages/Category/category_page.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final int index;

  const CategoryItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // List of category names
    List<String> categoryNames = [
      "Category #1",
      "Category #2",
      "Category #3",
      "Category #4",
      "Category #5",
      "Category #6",
      "Category #7",
      "Category #8"
    ];

    return Column(
      children: [
        Expanded(
          child: IconButton(
            icon: Icon(Icons.category, size: 50),
            color: Colors.grey[800],
            onPressed: () {
              // Navigate to CategoryPage when a category is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryPage()),
              );
            },
          ),
        ),
        Text(
          categoryNames[index],
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }
}

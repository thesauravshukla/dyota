import 'package:dyota/pages/Shop/Components/category_card.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final List<String> statuses; // Add a statuses parameter

  // Modify the constructor to require the statuses list
  const CategoryList({Key? key, required this.statuses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a list of CategoryCard widgets using the statuses provided
    final List<Widget> cards =
        statuses.map((status) => CategoryCard(status: status)).toList();

    return ListView(
      children: cards,
    );
  }
}

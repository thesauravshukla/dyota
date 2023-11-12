import 'package:dyota/components/category_item.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, childAspectRatio: 1),
      itemCount: 8,
      itemBuilder: (context, index) => CategoryItem(index: index),
    );
  }
}
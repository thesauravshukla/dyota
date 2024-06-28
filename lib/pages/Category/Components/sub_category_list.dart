import 'package:dyota/pages/Category/Components/category_button.dart';
import 'package:flutter/material.dart';

class SubCategoryList extends StatelessWidget {
  final List<String> subCategories;
  final List<String> selectedCategories;
  final Function(String) onSelectCategory;

  const SubCategoryList({
    Key? key,
    required this.subCategories,
    required this.selectedCategories,
    required this.onSelectCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: subCategories.map((subCategory) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CategoryButton(
                label: subCategory,
                isSelected: selectedCategories.contains(subCategory),
                onTap: () => onSelectCategory(subCategory),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

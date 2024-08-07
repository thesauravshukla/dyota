import 'package:dyota/pages/Category/Components/category_button.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class SubCategoryList extends StatelessWidget {
  final List<String> subCategories;
  final List<String> selectedCategories;
  final Function(String) onSelectCategory;
  final Logger _logger = Logger('SubCategoryList');

  SubCategoryList({
    Key? key,
    required this.subCategories,
    required this.selectedCategories,
    required this.onSelectCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _logger.info(
        'Building SubCategoryList with ${subCategories.length} subcategories');
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: subCategories.map((subCategory) {
            _logger
                .fine('Building CategoryButton for subCategory: $subCategory');
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CategoryButton(
                label: subCategory,
                isSelected: selectedCategories.contains(subCategory),
                onTap: () {
                  _logger.info('SubCategory selected: $subCategory');
                  onSelectCategory(subCategory);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

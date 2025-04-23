import 'package:dyota/pages/Category/Components/category_button.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class SubCategoryList extends StatefulWidget {
  final List<String> subCategories;
  final List<String> selectedCategories;
  final Function(String) onSelectCategory;
  final Function(bool) onLoadingChanged;

  const SubCategoryList({
    Key? key,
    required this.subCategories,
    required this.selectedCategories,
    required this.onSelectCategory,
    required this.onLoadingChanged,
  }) : super(key: key);

  @override
  State<SubCategoryList> createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  final Logger _logger = Logger('SubCategoryList');
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initially set loading to false as this widget loads synchronously
    _isLoading = false;
    Future.microtask(() {
      if (mounted) widget.onLoadingChanged(_isLoading);
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.info(
        'Building SubCategoryList with ${widget.subCategories.length} subcategories');

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.subCategories.map((subCategory) {
            _logger
                .fine('Building CategoryButton for subCategory: $subCategory');
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CategoryButton(
                label: subCategory,
                isSelected: widget.selectedCategories.contains(subCategory),
                onTap: () {
                  _logger.info('SubCategory selected: $subCategory');
                  widget.onSelectCategory(subCategory);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

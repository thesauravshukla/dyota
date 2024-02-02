import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Category/Components/category_button.dart';
import 'package:dyota/pages/Category/Components/product_list_item.dart';
import 'package:dyota/pages/Filter/filter_screen.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isGridView = false;
  List<String> selectedCategories = [];
  String selectedSortOption = 'Price: lowest to high'; // Default sort option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Category Name'),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0), // Added padding here
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CategoryButton(
                    label: 'T-shirts',
                    isSelected: selectedCategories.contains('T-shirts'),
                    onTap: () => _selectCategory('T-shirts'),
                  ),
                  CategoryButton(
                    label: 'Crop tops',
                    isSelected: selectedCategories.contains('Crop tops'),
                    onTap: () => _selectCategory('Crop tops'),
                  ),
                  CategoryButton(
                    label: 'Sleeveless',
                    isSelected: selectedCategories.contains('Sleeveless'),
                    onTap: () => _selectCategory('Sleeveless'),
                  ),
                ],
              ),
            ),
            // Sorting and View toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton.icon(
                  icon: Icon(Icons.filter_list, color: Colors.black),
                  label: Text('Filters', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FilterScreen()),
                    );
                  },
                ),
                TextButton.icon(
                  icon: Icon(Icons.sort, color: Colors.black),
                  label: Text(selectedSortOption,
                      style: TextStyle(color: Colors.black)),
                  onPressed: () => _showSortOptions(context),
                ),
              ],
            ),
            // Product List
            buildGridView(),
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    // Replace with your actual GridView builder implementation
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10, // Replace with your actual item count
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductListItem(
              imageUrl:
                  "https://image.uniqlo.com/UQ/ST3/AsianCommon/imagesgoods/448447/item/goods_01_448447.jpg?width=750",
              title: "filler",
              brand: "filler",
              price: 0,
              discount: 20,
              rating: 4,
              reviewCount: 0), // Replace with your actual grid item widget
        );
      },
    );
  }

  void _selectCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Sort by',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              _buildSortOptionTile(context, 'Popular'),
              _buildSortOptionTile(context, 'Newest'),
              _buildSortOptionTile(context, 'Customer review'),
              _buildSortOptionTile(context, 'Price: lowest to high'),
              _buildSortOptionTile(context, 'Price: highest to low'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOptionTile(BuildContext context, String option) {
    return ListTile(
      title: Text(
        option,
        style: TextStyle(
          color: selectedSortOption == option ? Colors.white : Colors.black,
        ),
      ),
      onTap: () => _selectSortOption(option),
      selected: selectedSortOption == option,
      selectedTileColor: Colors.black,
    );
  }

  void _selectSortOption(String option) {
    Navigator.pop(context); // Close the bottom sheet
    setState(() {
      selectedSortOption = option; // Update the selected sort option
    });
  }
}

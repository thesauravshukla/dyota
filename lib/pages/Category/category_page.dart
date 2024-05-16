import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Category/Components/category_button.dart';
import 'package:dyota/pages/Category/Components/product_list_item.dart';
import 'package:dyota/pages/Filter/filter_screen.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  final String categoryDocumentId;

  const CategoryPage({Key? key, required this.categoryDocumentId})
      : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isGridView = false;
  List<String> selectedCategories = [];
  String selectedSortOption = 'Price: lowest to high'; // Default sort option
  String categoryName = '';
  List<String> subCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategoryData();
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
        return Container(
          height: 200,
          child: Center(
            child: Text("Sort Options will be displayed here"),
          ),
        );
      },
    );
  }

  Future<void> _fetchCategoryData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryDocumentId)
        .get();
    setState(() {
      categoryName = doc['name'];
      subCategories = List<String>.from(doc['subCategories']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(
          title: categoryName.isEmpty
              ? 'Loading...'
              : categoryName), // Use categoryName in the app bar title
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0), // Added padding here
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: subCategories.map((subCategory) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CategoryButton(
                        label: subCategory,
                        isSelected: selectedCategories.contains(subCategory),
                        onTap: () => _selectCategory(subCategory),
                      ),
                    );
                  }).toList(),
                ),
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
}

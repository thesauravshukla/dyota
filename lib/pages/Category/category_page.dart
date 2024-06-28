import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Category/Components/get_document_ids.dart';
import 'package:dyota/pages/Category/Components/product_list_item.dart';
import 'package:dyota/pages/Category/Components/sort_button.dart';
import 'package:dyota/pages/Category/Components/sub_category_list.dart';
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
  String selectedSortOption = 'Sort'; // Default sort option
  String categoryName = '';
  List<String> subCategories = [];
  List<String> itemDocumentIds = [];
  bool isLoading = true; // Added to track loading state

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
      _fetchItems(); // Fetch items after updating selected categories
    });
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: _buildSortOptions(context),
          ),
        );
      },
    );
  }

  List<Widget> _buildSortOptions(BuildContext context) {
    return [
      _buildSortOption(context, 'Price: lowest to high'),
      _buildSortOption(context, 'Price: high to low'),
    ];
  }

  Widget _buildSortOption(BuildContext context, String option) {
    return ListTile(
      title: Text(option),
      onTap: () {
        Navigator.pop(context);
        _fetchItems(sortOption: option);
      },
    );
  }

  Future<void> _fetchCategoryData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryDocumentId)
          .get();
      setState(() {
        categoryName = doc['name'];
        subCategories = List<String>.from(doc['subCategories']);
        selectedCategories = List<String>.from(subCategories);
        isLoading = false;
      });
      _fetchItems();
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchItems({String sortOption = 'Sort'}) async {
    setState(() {
      isLoading = true;
    });

    try {
      FirestoreService firestoreService = FirestoreService();
      List<String> documentIds = await firestoreService.getDocumentIds(
        'items',
        categoryName,
        selectedCategories,
      );

      List<Map<String, dynamic>> itemsWithPrice = [];
      for (String id in documentIds) {
        DocumentSnapshot doc =
            await FirebaseFirestore.instance.collection('items').doc(id).get();
        if (doc.exists && doc.data() != null) {
          itemsWithPrice.add({
            'id': id,
            'pricePerMetre': doc['pricePerMetre']['value'],
          });
        }
      }

      if (sortOption == 'Price: lowest to high') {
        itemsWithPrice
            .sort((a, b) => a['pricePerMetre'].compareTo(b['pricePerMetre']));
      } else if (sortOption == 'Price: high to low') {
        itemsWithPrice
            .sort((a, b) => b['pricePerMetre'].compareTo(a['pricePerMetre']));
      }

      setState(() {
        selectedSortOption = sortOption;
        itemDocumentIds =
            itemsWithPrice.map((item) => item['id'] as String).toList();
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(
          title: categoryName.isEmpty ? 'Loading...' : categoryName),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SubCategoryList(
              subCategories: subCategories,
              selectedCategories: selectedCategories,
              onSelectCategory: _selectCategory,
            ),
            SortButton(
              selectedSortOption: selectedSortOption,
              onShowSortOptions: () => _showSortOptions(context),
            ),
            isLoading ? CircularProgressIndicator() : buildGridView(),
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    if (itemDocumentIds.isEmpty) {
      return Text("No items to display");
    }
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemDocumentIds.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (BuildContext context, int index) {
        String documentId = itemDocumentIds[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductListItem(
            documentId: documentId,
          ),
        );
      },
    );
  }
}

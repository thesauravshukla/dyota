import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Category/Components/get_document_ids.dart';
import 'package:dyota/pages/Category/Components/product_list_item.dart';
import 'package:dyota/pages/Category/Components/sort_button.dart';
import 'package:dyota/pages/Category/Components/sub_category_list.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class CategoryPage extends StatefulWidget {
  final String categoryDocumentId;

  const CategoryPage({Key? key, required this.categoryDocumentId})
      : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final Logger _logger = Logger('CategoryPage');
  bool isGridView = false;
  List<String> selectedCategories = [];
  String selectedSortOption = 'Sort'; // Default sort option
  String categoryName = '';
  List<String> subCategories = [];
  List<String> itemDocumentIds = [];
  bool isLoading = true; // For overall data loading
  bool isSubCategoriesLoading = false;
  bool isProductListLoading = false;
  bool _disposed = false;

  bool get anyComponentLoading =>
      isLoading || isSubCategoriesLoading || isProductListLoading;

  @override
  void initState() {
    super.initState();
    try {
      _fetchCategoryData();
      _logger.info(
          'CategoryPage initialized with categoryDocumentId: ${widget.categoryDocumentId}');
    } catch (e) {
      _logger.severe('Error fetching category data', e);
      if (!_disposed) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _selectCategory(String category) {
    if (_disposed) return;

    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
      _logger.info('Selected categories updated: $selectedCategories');
    });
    _fetchItems(); // Fetch items after updating selected categories
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
        _logger.info('Sort option selected: $option');
        _fetchItems(sortOption: option);
      },
    );
  }

  void updateLoadingState({
    bool? subCategoriesLoading,
    bool? productListLoading,
  }) {
    if (_disposed) return;

    // Use Future.microtask to defer the setState until the current build phase is complete
    Future.microtask(() {
      if (!_disposed && mounted) {
        setState(() {
          if (subCategoriesLoading != null)
            isSubCategoriesLoading = subCategoriesLoading;
          if (productListLoading != null)
            isProductListLoading = productListLoading;
        });
      }
    });
  }

  Future<void> _fetchCategoryData() async {
    try {
      if (!_disposed) {
        setState(() {
          isLoading = true;
        });
      }

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryDocumentId)
          .get();

      if (!_disposed) {
        setState(() {
          categoryName = doc['name'];
          subCategories = List<String>.from(doc['subCategories']);
          selectedCategories = List<String>.from(subCategories);
          isLoading = false;
        });
      }

      _logger.info('Category data fetched successfully: $categoryName');
      _fetchItems();
    } catch (e) {
      _logger.severe('Error fetching category data', e);
      if (!_disposed) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchItems({String sortOption = 'Sort'}) async {
    if (!_disposed) {
      setState(() {
        isProductListLoading = true;
      });
    }

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
        itemsWithPrice.sort((a, b) =>
            double.parse(a['pricePerMetre'].toString())
                .compareTo(double.parse(b['pricePerMetre'].toString())));
      } else if (sortOption == 'Price: high to low') {
        itemsWithPrice.sort((a, b) =>
            double.parse(b['pricePerMetre'].toString())
                .compareTo(double.parse(a['pricePerMetre'].toString())));
      }

      if (!_disposed) {
        setState(() {
          selectedSortOption = sortOption;
          itemDocumentIds =
              itemsWithPrice.map((item) => item['id'] as String).toList();
          isProductListLoading = false;
        });
      }

      _logger.info('Items fetched and sorted by $sortOption');
    } catch (e) {
      _logger.severe('Error fetching items', e);
      if (!_disposed) {
        setState(() {
          isProductListLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: genericAppbar(
            title: categoryName.isEmpty ? 'Loading...' : categoryName),
        body: Column(
          children: <Widget>[
            if (anyComponentLoading)
              LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SubCategoryList(
                      subCategories: subCategories,
                      selectedCategories: selectedCategories,
                      onSelectCategory: _selectCategory,
                      onLoadingChanged: (isLoading) =>
                          updateLoadingState(subCategoriesLoading: isLoading),
                    ),
                    SortButton(
                      selectedSortOption: selectedSortOption,
                      onShowSortOptions: () => _showSortOptions(context),
                    ),
                    isLoading ? const Center(child: Text('')) : buildGridView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      _logger.severe('Error building CategoryPage widget', e);
      if (!_disposed) {
        setState(() {
          isLoading = false;
        });
      }
      return const Center(child: Text(''));
    }
  }

  Widget buildGridView() {
    if (itemDocumentIds.isEmpty) {
      _logger.info('No items to display');
      return Text("");
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      cacheExtent: 1000,
      itemCount: itemDocumentIds.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            onLoadingChanged: (isLoading) =>
                updateLoadingState(productListLoading: isLoading),
          ),
        );
      },
    );
  }
}

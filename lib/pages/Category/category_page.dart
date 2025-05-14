import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Category/Components/category_data.dart';
import 'package:dyota/pages/Category/Components/category_data_provider.dart';
import 'package:dyota/pages/Category/Components/category_loading_state.dart';
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
  late CategoryData _categoryData;
  late CategoryLoadingState _loadingState;
  late CategoryDataProvider _dataProvider;

  @override
  void initState() {
    super.initState();
    _categoryData = CategoryData(categoryDocumentId: widget.categoryDocumentId);
    _loadingState = CategoryLoadingState();
    _dataProvider = CategoryDataProvider(
      categoryData: _categoryData,
      loadingState: _loadingState,
    );

    try {
      _dataProvider.fetchCategoryData();
      _logger.info(
          'CategoryPage initialized with categoryDocumentId: ${widget.categoryDocumentId}');
    } catch (e) {
      _logger.severe('Error initializing category page', e);
    }

    // Set up listeners
    _categoryData.addListener(_onDataChanged);
    _loadingState.addListener(_onLoadingChanged);
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onLoadingChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _selectCategory(String category) {
    _dataProvider.selectCategory(category);
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
        _dataProvider.fetchItems(sortOption: option);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: genericAppbar(
            title: _categoryData.categoryName.isEmpty
                ? 'Loading...'
                : _categoryData.categoryName),
        body: Column(
          children: <Widget>[
            // Show loading indicator only when genuinely loading
            if (_loadingState.anyComponentLoading &&
                _categoryData.itemDocumentIds.isEmpty)
              LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Only show subcategories after they've been loaded
                    if (_categoryData.subCategories.isNotEmpty)
                      SubCategoryList(
                        subCategories: _categoryData.subCategories,
                        selectedCategories: _categoryData.selectedCategories,
                        onSelectCategory: _selectCategory,
                        onLoadingChanged: (isLoading) =>
                            _loadingState.updateLoadingState(
                                subCategoriesLoading: isLoading),
                      ),
                    // Only show sort button if items are available
                    if (_categoryData.itemDocumentIds.isNotEmpty ||
                        !_loadingState.isLoading)
                      SortButton(
                        selectedSortOption: _categoryData.selectedSortOption,
                        onShowSortOptions: () => _showSortOptions(context),
                      ),
                    // Show loading or grid
                    _buildGridView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      _logger.severe('Error building CategoryPage widget', e);
      return Scaffold(
        appBar: genericAppbar(title: 'Error'),
        body: Column(
          children: [
            LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
            ),
            Expanded(
              child: Center(
                child: Text('Error loading content. Please try again.'),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildGridView() {
    // During initial loading, show empty space instead of a second loading indicator
    if (_loadingState.isLoading) {
      return SizedBox(height: 200); // Just some space, no loading indicator
    }

    // After loading, if no items found
    if (_categoryData.itemDocumentIds.isEmpty) {
      _logger.info('No items to display');
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(Icons.info_outline, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                _categoryData.selectedCategories.isEmpty
                    ? "Please select at least one subcategory to view items"
                    : "No items found for the selected subcategories",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      cacheExtent: 1000,
      itemCount: _categoryData.itemDocumentIds.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (BuildContext context, int index) {
        String documentId = _categoryData.itemDocumentIds[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductListItem(
            documentId: documentId,
            onLoadingChanged: (isLoading) =>
                _loadingState.updateLoadingState(productListLoading: isLoading),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _categoryData.removeListener(_onDataChanged);
    _loadingState.removeListener(_onLoadingChanged);
    _dataProvider.markDisposed();
    _dataProvider.dispose();
    super.dispose();
  }
}

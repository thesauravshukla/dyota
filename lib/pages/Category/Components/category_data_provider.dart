import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Category/Components/category_data.dart';
import 'package:dyota/pages/Category/Components/category_loading_state.dart';
import 'package:dyota/pages/Category/Components/firestore_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class CategoryDataProvider with ChangeNotifier {
  final CategoryData _categoryData;
  final CategoryLoadingState _loadingState;
  final FirestoreService _firestoreService;
  final Logger _logger = Logger('CategoryDataProvider');
  bool _disposed = false;

  CategoryDataProvider({
    required CategoryData categoryData,
    required CategoryLoadingState loadingState,
  })  : _categoryData = categoryData,
        _loadingState = loadingState,
        _firestoreService = FirestoreService();

  bool get disposed => _disposed;

  Future<void> fetchCategoryData() async {
    if (_disposed) return;

    try {
      _loadingState.setLoading(true);

      DocumentSnapshot doc = await _firestoreService.getDocument(
          'categories', _categoryData.categoryDocumentId);

      if (_disposed) return;

      final data = doc.data() as Map<String, dynamic>;
      final String name = data['name'];
      final List<String> subCategories =
          List<String>.from(data['subCategories']);

      _categoryData.updateCategoryName(name);
      _categoryData.updateSubCategories(subCategories);

      // Always select all categories by default
      _categoryData.updateSelectedCategories(List.from(subCategories));

      // Keep loading true until items are fetched
      _logger.info(
          'Category data fetched successfully: ${_categoryData.categoryName}');

      // Fetch items while still in loading state
      await fetchItems();

      // Finally set loading to false after everything is done
      _loadingState.setLoading(false);
    } catch (e) {
      _logger.severe('Error fetching category data', e);
      if (!_disposed) {
        _loadingState.setLoading(false);
      }
    }
  }

  Future<void> fetchItems({String sortOption = 'Sort'}) async {
    if (_disposed) return;

    _loadingState.setProductListLoading(true);

    try {
      // If no subcategories are selected, clear the items and return
      if (_categoryData.selectedCategories.isEmpty) {
        if (!_disposed) {
          _categoryData.updateSortOption(sortOption);
          _categoryData.updateItemDocumentIds([]);
          _loadingState.setProductListLoading(false);
          _loadingState.setLoading(false);
          _loadingState.setSubCategoriesLoading(false);
        }
        _logger.info('No subcategories selected, showing no items');
        return;
      }

      List<String> documentIds = await _firestoreService.getDocumentIds(
        'items',
        _categoryData.categoryName,
        _categoryData.selectedCategories,
      );

      List<Map<String, dynamic>> itemsWithPrice =
          await _firestoreService.getItemsWithPrice(documentIds);

      List<String> sortedIds =
          _firestoreService.sortItemsByPrice(itemsWithPrice, sortOption);

      if (!_disposed) {
        _categoryData.updateSortOption(sortOption);
        _categoryData.updateItemDocumentIds(sortedIds);

        // Ensure we always set loading to false even if not all items have loaded
        _loadingState.setProductListLoading(false);
        _loadingState.setLoading(false);
        _loadingState.setSubCategoriesLoading(false);
      }

      _logger.info('Items fetched and sorted by $sortOption');
    } catch (e) {
      _logger.severe('Error fetching items', e);
      if (!_disposed) {
        _loadingState.setProductListLoading(false);
        _loadingState.setLoading(false);
        _loadingState.setSubCategoriesLoading(false);
      }
    }
  }

  void selectCategory(String category) {
    if (_disposed) return;

    _categoryData.toggleCategorySelection(category);
    _logger.info(
        'Selected categories updated: ${_categoryData.selectedCategories}');
    fetchItems();
  }

  void markDisposed() {
    _disposed = true;
    _categoryData.markDisposed();
    _loadingState.markDisposed();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

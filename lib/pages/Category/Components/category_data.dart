import 'package:flutter/foundation.dart';

class CategoryData with ChangeNotifier {
  final String _categoryDocumentId;
  String _categoryName = '';
  List<String> _subCategories = [];
  List<String> _selectedCategories = [];
  List<String> _itemDocumentIds = [];
  String _selectedSortOption = 'Sort';
  bool _disposed = false;

  CategoryData({required String categoryDocumentId})
      : _categoryDocumentId = categoryDocumentId;

  String get categoryDocumentId => _categoryDocumentId;
  String get categoryName => _categoryName;
  List<String> get subCategories => List.unmodifiable(_subCategories);
  List<String> get selectedCategories => List.unmodifiable(_selectedCategories);
  List<String> get itemDocumentIds => List.unmodifiable(_itemDocumentIds);
  String get selectedSortOption => _selectedSortOption;
  bool get disposed => _disposed;

  void updateCategoryName(String name) {
    if (_disposed) return;
    _categoryName = name;
    notifyListeners();
  }

  void updateSubCategories(List<String> categories) {
    if (_disposed) return;
    _subCategories = List.from(categories);
    notifyListeners();
  }

  void updateSelectedCategories(List<String> selected) {
    if (_disposed) return;
    _selectedCategories = List.from(selected);
    notifyListeners();
  }

  void toggleCategorySelection(String category) {
    if (_disposed) return;

    List<String> updated = List.from(_selectedCategories);
    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }

    _selectedCategories = updated;
    notifyListeners();
  }

  void updateItemDocumentIds(List<String> ids) {
    if (_disposed) return;
    _itemDocumentIds = List.from(ids);
    notifyListeners();
  }

  void updateSortOption(String option) {
    if (_disposed) return;
    _selectedSortOption = option;
    notifyListeners();
  }

  void markDisposed() {
    _disposed = true;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

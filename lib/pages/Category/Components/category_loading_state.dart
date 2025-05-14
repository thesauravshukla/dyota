import 'package:flutter/foundation.dart';

class CategoryLoadingState with ChangeNotifier {
  bool _isLoading = true;
  bool _isSubCategoriesLoading = false;
  bool _isProductListLoading = false;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  bool get isSubCategoriesLoading => _isSubCategoriesLoading;
  bool get isProductListLoading => _isProductListLoading;
  bool get disposed => _disposed;

  bool get anyComponentLoading =>
      _isLoading || _isSubCategoriesLoading || _isProductListLoading;

  void setLoading(bool value) {
    if (_disposed) return;
    _isLoading = value;
    notifyListeners();
  }

  void setSubCategoriesLoading(bool value) {
    if (_disposed) return;
    _isSubCategoriesLoading = value;
    notifyListeners();
  }

  void setProductListLoading(bool value) {
    if (_disposed) return;
    _isProductListLoading = value;
    notifyListeners();
  }

  void updateLoadingState({
    bool? subCategoriesLoading,
    bool? productListLoading,
  }) {
    if (_disposed) return;

    if (subCategoriesLoading != null) {
      _isSubCategoriesLoading = subCategoriesLoading;
    }

    if (productListLoading != null) {
      _isProductListLoading = productListLoading;
    }

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

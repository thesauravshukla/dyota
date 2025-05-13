import 'package:dyota/pages/Product_Card/Components/cart_item_manager.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// A view model to manage the state and business logic for the AddToCartButton.
class AddToCartViewModel with ChangeNotifier {
  final CartItemManager _cartManager = CartItemManager();
  final Logger _logger = Logger('AddToCartViewModel');
  final List<String> documentIds;

  // State
  List<CartItem> _cartItems = [];
  List<bool> _selectedItems = [];
  List<double> _selectedLengths = [];
  Map<int, String> _validationErrors = {};
  bool _isLoading = true;

  // Getters
  List<CartItem> get cartItems => _cartItems;
  List<bool> get selectedItems => _selectedItems;
  List<double> get selectedLengths => _selectedLengths;
  Map<int, String> get validationErrors => _validationErrors;
  bool get isLoading => _isLoading;

  AddToCartViewModel({required this.documentIds}) {
    _initializeSelections();
    _loadData();
  }

  void _initializeSelections() {
    _selectedItems = List<bool>.filled(documentIds.length, false);
    _selectedLengths = List<double>.filled(documentIds.length, 0);
  }

  /// Loads all cart items data from the CartItemManager
  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cartItems = await _cartManager.fetchCartItemsData(documentIds);

      // Initialize selected lengths to first allowed length for each item
      for (int i = 0; i < _cartItems.length; i++) {
        if (_cartItems[i].allowedLengths.isNotEmpty) {
          _selectedLengths[i] = _cartItems[i].allowedLengths.first;
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _logger.severe('Error loading cart items data', e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggles the selection state of an item
  void toggleItemSelection(int index) {
    if (index < 0 || index >= _selectedItems.length) return;

    _selectedItems[index] = !_selectedItems[index];
    notifyListeners();
  }

  /// Updates the selected length for an item
  void updateSelectedLength(int index, double length) {
    if (index < 0 || index >= _selectedLengths.length) return;

    _selectedLengths[index] = length;
    notifyListeners();
  }

  /// Validates all inputs and returns true if valid
  bool validateInputs() {
    Map<int, String> errors = {};

    for (int i = 0; i < _selectedItems.length; i++) {
      if (_selectedItems[i]) {
        if (i >= _cartItems.length) continue;

        List<double> allowedLengths = _cartItems[i].allowedLengths;

        if (!allowedLengths.contains(_selectedLengths[i])) {
          errors[i] = 'Please select a valid length from the allowed values';
        }
      }
    }

    _validationErrors = errors;
    notifyListeners();
    return errors.isEmpty;
  }

  /// Adds selected items to cart
  Future<bool> addToCart() async {
    if (!validateInputs()) return false;

    // Filter selected items
    List<CartItem> selectedCartItems = [];
    List<double> selectedCartLengths = [];

    for (int i = 0; i < _selectedItems.length; i++) {
      if (_selectedItems[i] && i < _cartItems.length) {
        selectedCartItems.add(_cartItems[i]);
        selectedCartLengths.add(_selectedLengths[i]);
      }
    }

    return await _cartManager.addItemsToCart(
        selectedCartItems, selectedCartLengths);
  }

  /// Checks if the user is logged in
  bool isUserLoggedIn() {
    return _cartManager.isUserLoggedIn();
  }
}

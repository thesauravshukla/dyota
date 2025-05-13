import 'package:dyota/pages/Product_Card/Components/cart_item_manager.dart';
import 'package:dyota/pages/Product_Card/Components/image_selector.dart';
import 'package:dyota/pages/Product_Card/Components/length_slider.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// Button that allows users to add products to cart by selecting variants and lengths
class AddToCartButton extends StatefulWidget {
  final List<String> documentIds;

  const AddToCartButton({
    Key? key,
    required this.documentIds,
  }) : super(key: key);

  @override
  AddToCartButtonState createState() => AddToCartButtonState();
}

class AddToCartButtonState extends State<AddToCartButton> {
  final Logger _logger = Logger('AddToCartButton');
  final CartItemManager _cartManager = CartItemManager();

  bool _showDetails = false;
  bool _isLoading = true;
  List<CartItem> _cartItems = [];
  List<bool> _selectedItems = [];
  List<double> _selectedLengths = [];
  Map<int, String> _validationErrors = {};

  @override
  void initState() {
    super.initState();
    _logger.info(
        'AddToCartButton initialized with documentIds: ${widget.documentIds}');
    _initializeSelections();
    _loadData();
  }

  void _initializeSelections() {
    _selectedItems = List<bool>.filled(widget.documentIds.length, false);
    _selectedLengths = List<double>.filled(widget.documentIds.length, 0);
  }

  Future<void> _loadData() async {
    try {
      final cartItems =
          await _cartManager.fetchCartItemsData(widget.documentIds);

      // Initialize selected lengths to first allowed length for each item
      final updatedLengths = List<double>.from(_selectedLengths);
      for (int i = 0; i < cartItems.length; i++) {
        if (cartItems[i].allowedLengths.isNotEmpty) {
          updatedLengths[i] = cartItems[i].allowedLengths.first;
        }
      }

      setState(() {
        _cartItems = cartItems;
        _selectedLengths = updatedLengths;
        _isLoading = false;
      });
    } catch (e) {
      _logger.severe('Error loading cart items data', e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleItemSelection(int index) {
    if (index < 0 || index >= _selectedItems.length) return;

    setState(() {
      _selectedItems[index] = !_selectedItems[index];
    });
    _logger
        .info('Image selected: $index, isSelected: ${_selectedItems[index]}');
  }

  void _updateSelectedLength(int index, double length) {
    if (index < 0 || index >= _selectedLengths.length) return;

    setState(() {
      _selectedLengths[index] = length;
    });
    _logger.info('Length updated: $index, value: $length');
  }

  bool _validateInputs() {
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

    setState(() {
      _validationErrors = errors;
    });

    _logger.info('Inputs validated with errors: $_validationErrors');
    return errors.isEmpty;
  }

  Future<void> _addToCart() async {
    if (!_cartManager.isUserLoggedIn()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You need to be logged in to add items to the cart')),
      );
      _logger.warning('User not logged in');
      return;
    }

    if (!_validateInputs()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please correct the errors before adding to cart')),
      );
      _logger.warning('Validation errors: $_validationErrors');
      return;
    }

    // Filter selected items
    List<CartItem> selectedCartItems = [];
    List<double> selectedCartLengths = [];

    for (int i = 0; i < _selectedItems.length; i++) {
      if (_selectedItems[i] && i < _cartItems.length) {
        selectedCartItems.add(_cartItems[i]);
        selectedCartLengths.add(_selectedLengths[i]);
      }
    }

    final result = await _cartManager.addItemsToCart(
        selectedCartItems, selectedCartLengths);

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Items added to cart')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding items to cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ExpansionTile(
        title: const Text('Add to Cart'),
        initiallyExpanded: _showDetails,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _showDetails = expanded;
          });
          _logger.info('ExpansionTile expanded: $expanded');
        },
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tap the designs to place order',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ..._buildProductSelections(),
          _buildAddToCartButton(),
        ],
      ),
    );
  }

  List<Widget> _buildProductSelections() {
    return List.generate(_cartItems.length, (index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(color: Colors.grey),
          ImageSelector(
            imageUrl: _cartItems[index].imageUrl,
            isSelected: _selectedItems[index],
            onTap: () => _toggleItemSelection(index),
          ),
          const Divider(color: Colors.grey),
          if (_selectedItems[index])
            LengthSlider(
              allowedLengths: _cartItems[index].allowedLengths,
              selectedLength: _selectedLengths[index],
              onChanged: (value) => _updateSelectedLength(index, value),
              validationError: _validationErrors[index],
            ),
        ],
      );
    });
  }

  Widget _buildAddToCartButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ElevatedButton(
          onPressed: _addToCart,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
          ),
          child: const Text('Add Selected Designs to Cart'),
        ),
      ),
    );
  }
}

// Flutter and Dart imports
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

// Firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// External package imports
import 'package:decimal/decimal.dart';

// App-wide components
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/components/shared/app_empty_state.dart';
import 'package:dyota/components/shared/app_loading_indicator.dart';

// Local components and models
import 'package:dyota/pages/Cart/Components/cart_data.dart';
import 'package:dyota/pages/Cart/Components/cart_data_provider.dart';
import 'package:dyota/pages/Cart/Components/itemcard.dart';
import 'package:dyota/pages/Cart/Components/loading_state.dart';
import 'package:dyota/pages/Cart/Components/total_amount_selection.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final Logger _logger = Logger('Cart');
  final LoadingState _loadingState = LoadingState();
  final CartDataProvider _cartDataProvider = CartDataProvider();
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _initializeLoadingState();
    _setupSafetyTimeouts();
  }

  void _initializeLoadingState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!_isDisposed()) {
        setState(() {
          _loadingState.isInitialDataLoading = false;
        });
      }
    });
  }

  void _setupSafetyTimeouts() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isDisposed() && _loadingState.anyComponentLoading) {
        _logger.warning('Forced reset of loading states due to timeout');
        _resetAllLoadingStates();
      }
    });
  }

  bool _isDisposed() {
    return _disposed || !mounted;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _updateLoadingState({
    bool? itemCardsLoading,
    bool? totalAmountLoading,
  }) {
    if (_isDisposed()) return;
    if (_loadingState.isInitialDataLoading) return;

    if (_loadingState.shouldSkipRedundantUpdate(
        itemCardsLoading: itemCardsLoading,
        totalAmountLoading: totalAmountLoading)) {
      return;
    }

    _logCurrentLoadingStates();

    if (_loadingState.shouldDebounceUpdate()) {
      return;
    }

    _applyLoadingStateUpdate(itemCardsLoading, totalAmountLoading);
  }

  void _logCurrentLoadingStates() {
    _logger.info('Current loading states - '
        'Items: ${_loadingState.isItemCardsLoading}, '
        'Total: ${_loadingState.isTotalAmountLoading}, '
        'Initial: ${_loadingState.isInitialDataLoading}');
  }

  void _applyLoadingStateUpdate(
      bool? itemCardsLoading, bool? totalAmountLoading) {
    Future.microtask(() {
      if (!_isDisposed()) {
        setState(() {
          if (itemCardsLoading != null) {
            _loadingState.isItemCardsLoading = itemCardsLoading;
            _logger.info('Updated itemCardsLoading to: $itemCardsLoading');
          }
          if (totalAmountLoading != null) {
            _loadingState.isTotalAmountLoading = totalAmountLoading;
            _logger.info('Updated totalAmountLoading to: $totalAmountLoading');
          }
        });
      }
    });
  }

  void _resetAllLoadingStates() {
    if (_isDisposed()) return;

    setState(() {
      _loadingState.resetAllLoadingStates();
      _logger.info('Reset all loading states to false');
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.info('Building Cart widget');

    if (!_isUserLoggedIn()) {
      return _buildScaffold(
        context,
        const Center(child: Text('Please log in to view your bag.')),
      );
    }

    return _buildScaffold(
      context,
      _buildMainContent(),
    );
  }

  bool _isUserLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      _logger.warning('User not logged in or email is null');
      return false;
    }
    return true;
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        if (_loadingState.anyComponentLoading) _buildProgressIndicator(),
        Expanded(
          child: _loadingState.isInitialDataLoading
              ? const SizedBox()
              : _buildBagContent(_getCurrentUserEmail()),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return const AppLoadingBar();
  }

  String _getCurrentUserEmail() {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  Widget _buildBagContent(String userEmail) {
    _logger.info('Building bag content for user: $userEmail');
    return StreamBuilder<DocumentSnapshot>(
      stream: _cartDataProvider.getUserStream(userEmail),
      builder: (context, userSnapshot) {
        return _buildUserContent(context, userSnapshot, userEmail);
      },
    );
  }

  Widget _buildUserContent(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> userSnapshot, String userEmail) {
    if (!userSnapshot.hasData) {
      _setTotalAmountLoadingIfNeeded(true);
      return const SizedBox();
    }

    final minimumOrderValue = _getMinimumOrderValue(userSnapshot);
    return _buildCartItemsList(userEmail, minimumOrderValue);
  }

  void _setTotalAmountLoadingIfNeeded(bool isLoading) {
    if (!_loadingState.isTotalAmountLoading && isLoading) {
      _logger.info('No user data, setting totalAmountLoading to true');
      _updateLoadingState(totalAmountLoading: isLoading);
    }
  }

  Decimal _getMinimumOrderValue(AsyncSnapshot<DocumentSnapshot> snapshot) {
    return Decimal.parse(
        (snapshot.data?['minimumOrderValue'] ?? 5000).toString());
  }

  Widget _buildCartItemsList(String userEmail, Decimal minimumOrderValue) {
    return StreamBuilder<QuerySnapshot>(
      stream: _cartDataProvider.getCartItemsStream(userEmail),
      builder: (context, snapshot) {
        try {
          if (_isWaitingForCartItems(snapshot)) {
            _setItemCardsLoadingIfNeeded(true);
            return const SizedBox();
          }

          _resetLoadingStatesIfDataLoaded(snapshot);

          if (snapshot.hasError) {
            _logger.severe('Error fetching cart data: ${snapshot.error}');
            return const AppEmptyState(message: 'Error loading data');
          }

          if (_isCartEmpty(snapshot)) {
            return const AppEmptyState(message: 'Your bag is empty.');
          }

          final cartData = CartData(
            items: snapshot.data!.docs,
            minimumOrderValue: minimumOrderValue,
          );

          return _buildCartContent(cartData);
        } catch (e) {
          _logger.severe('Error in cart items StreamBuilder: $e');
          return const AppEmptyState(message: 'Error loading data');
        }
      },
    );
  }

  bool _isWaitingForCartItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.connectionState == ConnectionState.waiting &&
        !snapshot.hasData;
  }

  void _setItemCardsLoadingIfNeeded(bool isLoading) {
    if (!_loadingState.isItemCardsLoading && isLoading) {
      _logger.info('Waiting for cart items, setting itemCardsLoading to true');
      _updateLoadingState(itemCardsLoading: isLoading);
    }
  }

  void _resetLoadingStatesIfDataLoaded(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData &&
        (_loadingState.isItemCardsLoading ||
            _loadingState.isTotalAmountLoading)) {
      _logger.info('Cart data loaded, resetting loading states');
      Future.microtask(() {
        if (mounted) {
          _resetAllLoadingStates();
        }
      });
    }
  }

  bool _isCartEmpty(AsyncSnapshot<QuerySnapshot> snapshot) {
    return !snapshot.hasData || snapshot.data!.docs.isEmpty;
  }

  Widget _buildCartContent(CartData cartData) {
    final itemCards = _buildItemCards(cartData.items);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ...itemCards,
          if (_shouldShowMinimumOrderWarning(cartData))
            _buildMinimumOrderWarning(cartData.minimumOrderValue),
          _buildTotalAmountSection(cartData),
        ],
      ),
    );
  }

  List<Widget> _buildItemCards(List<QueryDocumentSnapshot> documents) {
    return documents.map<Widget>((document) {
      return ItemCard(
        key: ValueKey(document.id),
        documentId: document.id,
        onDelete: () {
          if (!_disposed) {
            setState(() {});
          }
        },
        onLoadingChanged: (isLoading) =>
            _updateLoadingState(itemCardsLoading: isLoading),
      );
    }).toList();
  }

  bool _shouldShowMinimumOrderWarning(CartData cartData) {
    return cartData.totalAmount < cartData.minimumOrderValue;
  }

  Widget _buildMinimumOrderWarning(Decimal minimumOrderValue) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.red.shade400),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Minimum order value should be Rs. ${minimumOrderValue.toString()}',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmountSection(CartData cartData) {
    return TotalAmountSection(
      minimumOrderQuantity: cartData.minimumOrderValue,
      totalAmount: cartData.totalAmount,
      onLoadingChanged: (isLoading) =>
          _updateLoadingState(totalAmountLoading: isLoading),
    );
  }


  Widget _buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: genericAppbar(title: 'My Bag', showBackButton: false),
      body: body,
    );
  }
}

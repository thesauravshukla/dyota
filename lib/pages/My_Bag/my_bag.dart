import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Home/home_page.dart';
import 'package:dyota/pages/My_Bag/Components/itemcard.dart';
import 'package:dyota/pages/My_Bag/Components/total_amount_selection.dart';
import 'package:dyota/pages/Profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class MyBag extends StatefulWidget {
  @override
  _MyBagState createState() => _MyBagState();
}

class _MyBagState extends State<MyBag> {
  final Logger _logger = Logger('MyBag');
  bool isItemCardsLoading = false;
  bool isTotalAmountLoading = false;
  bool isInitialDataLoading = true;
  bool _disposed = false;
  DateTime _lastUpdateTime = DateTime.now();

  bool get anyComponentLoading =>
      isItemCardsLoading || isTotalAmountLoading || isInitialDataLoading;

  @override
  void initState() {
    super.initState();
    // Set initial data loading to false after a short delay
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!_disposed && mounted) {
        setState(() {
          isInitialDataLoading = false;
        });
      }
    });

    // Safety timeout to ensure loading states are eventually reset
    Future.delayed(Duration(seconds: 5), () {
      if (!_disposed && mounted && anyComponentLoading) {
        _logger.warning('Forced reset of loading states due to timeout');
        resetAllLoadingStates();
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void updateLoadingState({
    bool? itemCardsLoading,
    bool? totalAmountLoading,
  }) {
    if (_disposed) return;

    // Skip updates if we're in initial loading state to prevent build loops
    if (isInitialDataLoading) return;

    // Skip redundant updates that don't change state
    if ((itemCardsLoading != null && itemCardsLoading == isItemCardsLoading) &&
        (totalAmountLoading != null &&
            totalAmountLoading == isTotalAmountLoading)) {
      return;
    }

    // Log current loading states for debugging
    _logger.info('Current loading states - '
        'Items: $isItemCardsLoading, '
        'Total: $isTotalAmountLoading, '
        'Initial: $isInitialDataLoading');

    // Debounce loading state updates to prevent UI flickering
    final now = DateTime.now();
    if (now.difference(_lastUpdateTime).inMilliseconds < 300) {
      return; // Skip frequent updates
    }
    _lastUpdateTime = now;

    // Use a single microtask for state updates to batch changes
    Future.microtask(() {
      if (!_disposed && mounted) {
        setState(() {
          if (itemCardsLoading != null) {
            isItemCardsLoading = itemCardsLoading;
            _logger.info('Updated itemCardsLoading to: $itemCardsLoading');
          }
          if (totalAmountLoading != null) {
            isTotalAmountLoading = totalAmountLoading;
            _logger.info('Updated totalAmountLoading to: $totalAmountLoading');
          }
        });
      }
    });
  }

  // Add a method to force reset all loading states
  void resetAllLoadingStates() {
    if (_disposed || !mounted) return;

    setState(() {
      isItemCardsLoading = false;
      isTotalAmountLoading = false;
      isInitialDataLoading = false;
      _logger.info('Reset all loading states to false');
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.info('Building MyBag widget');
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      _logger.warning('User not logged in or email is null');
      return _buildScaffold(
        context,
        Center(child: Text('Please log in to view your bag.')),
      );
    }

    return _buildScaffold(
      context,
      Column(
        children: [
          // Show linear progress indicator for ANY loading state
          if (anyComponentLoading)
            LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
            ),
          Expanded(
            child: isInitialDataLoading
                ? const SizedBox() // Empty SizedBox during initial loading
                : _buildBagContent(user.email!),
          ),
        ],
      ),
    );
  }

  // Extract content building to simplify the main build method
  Widget _buildBagContent(String userEmail) {
    _logger.info('Building bag content for user: $userEmail');

    // Use a single StreamBuilder for user data
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          if (!isTotalAmountLoading) {
            _logger.info('No user data, setting totalAmountLoading to true');
            updateLoadingState(totalAmountLoading: true);
          }
          return const SizedBox();
        }

        final minimumOrderValue = Decimal.parse(
            (userSnapshot.data?['minimumOrderValue'] ?? 5000).toString());

        // Use a single StreamBuilder for cart items
        return _buildCartItemsList(userEmail, minimumOrderValue);
      },
    );
  }

  // Extract cart items list building to further simplify
  Widget _buildCartItemsList(String userEmail, Decimal minimumOrderValue) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('cartItemsList')
          .snapshots(),
      builder: (context, snapshot) {
        try {
          // Set loading state only if we're waiting for initial data
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            if (!isItemCardsLoading) {
              _logger.info(
                  'Waiting for cart items, setting itemCardsLoading to true');
              updateLoadingState(itemCardsLoading: true);
            }
            return const SizedBox();
          }

          // Always ensure loading states are reset when we have data
          if (snapshot.hasData) {
            if (isItemCardsLoading || isTotalAmountLoading) {
              _logger.info('Cart data loaded, resetting loading states');
              // Use a slight delay to avoid UI flicker
              Future.microtask(() {
                if (mounted) {
                  resetAllLoadingStates();
                }
              });
            }
          }

          if (snapshot.hasError) {
            _logger.severe('Error fetching cart data: ${snapshot.error}');
            return Center(child: Text('Error loading data'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            _logger.info('No cart items found or bag is empty');
            return Center(child: Text('Your bag is empty.'));
          }

          // Calculate total amount once here
          Decimal totalAmount = Decimal.zero;
          for (var doc in snapshot.data!.docs) {
            Map<String, dynamic> priceMap = doc.get('price');
            totalAmount += Decimal.parse(priceMap['value'].toString());
          }

          // Build item cards from snapshot data
          List<Widget> itemCards = snapshot.data!.docs.map<Widget>((document) {
            return ItemCard(
              documentId: document.id,
              onDelete: () {
                if (!_disposed) {
                  setState(() {});
                }
              },
              onLoadingChanged: (isLoading) =>
                  updateLoadingState(itemCardsLoading: isLoading),
            );
          }).toList();

          _logger.info(
              'Data fetched successfully, returning item cards and total');
          return ListView(
            children: [
              ...itemCards,
              // Show minimum order warning if needed
              if (totalAmount < minimumOrderValue)
                Padding(
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
                ),
              // Add total amount section
              TotalAmountSection(
                minimumOrderQuantity: minimumOrderValue,
                totalAmount: totalAmount, // Pass the pre-calculated total
                onLoadingChanged: (isLoading) =>
                    updateLoadingState(totalAmountLoading: isLoading),
              ),
            ],
          );
        } catch (e) {
          _logger.severe('Error in cart items StreamBuilder: $e');
          return Center(child: Text('Error loading data'));
        }
      },
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyBag()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  Scaffold _buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: genericAppbar(title: 'My Bag', showBackButton: false),
      body: body,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1, // Set the current index as needed
        onItemTapped: (index) => _onItemTapped(context, index),
      ),
    );
  }
}

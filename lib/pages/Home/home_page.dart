import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/pages/Home/Components/app_bar_component.dart';
import 'package:dyota/pages/Home/Components/best_seller_header.dart';
import 'package:dyota/pages/Home/Components/category_grid_component.dart';
import 'package:dyota/pages/Home/Components/category_header_component.dart';
import 'package:dyota/pages/Home/Components/product_grid_component.dart';
import 'package:dyota/pages/My_Bag/my_bag.dart';
import 'package:dyota/pages/Profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Logger _logger = Logger('HomePage');
  bool isProductsLoading = false;
  bool isCategoriesLoading = false;
  bool isInitialDataLoading = true;
  bool _disposed = false;
  DateTime _lastUpdateTime = DateTime.now();
  Future<List<String>> _homePageDocumentsFuture = Future.value([]);
  bool _futureInitialized = false;

  bool get anyComponentLoading =>
      isProductsLoading || isCategoriesLoading || isInitialDataLoading;

  @override
  void initState() {
    super.initState();
    // Initialize the future
    _homePageDocumentsFuture = getDocumentIdsShownOnHomePage();
    _futureInitialized = true;

    // Set initial data loading to false after a short delay
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!_disposed && mounted) {
        setState(() {
          isInitialDataLoading = false;
        });
      }
    });

    // Safety timeout to ensure all loading states are reset eventually
    Future.delayed(Duration(seconds: 5), () {
      if (!_disposed && mounted && anyComponentLoading) {
        _logger.warning('Forced reset of loading states due to timeout');
        setState(() {
          isProductsLoading = false;
          isCategoriesLoading = false;
          isInitialDataLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void updateLoadingState({
    bool? productsLoading,
    bool? categoriesLoading,
  }) {
    if (_disposed) return;

    // Skip updates if we're in initial loading state
    if (isInitialDataLoading) return;

    // Skip redundant updates that don't change state
    if ((productsLoading != null && productsLoading == isProductsLoading) &&
        (categoriesLoading != null &&
            categoriesLoading == isCategoriesLoading)) {
      return;
    }

    // Log current loading states for debugging
    _logger.info('Current loading states - '
        'Products: $isProductsLoading, '
        'Categories: $isCategoriesLoading, '
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
          if (productsLoading != null) {
            isProductsLoading = productsLoading;
            _logger.info('Updated productsLoading to: $productsLoading');
          }
          if (categoriesLoading != null) {
            isCategoriesLoading = categoriesLoading;
            _logger.info('Updated categoriesLoading to: $categoriesLoading');
          }
        });
      }
    });
  }

  Future<List<String>> getDocumentIdsShownOnHomePage() async {
    List<String> documentIds = [];

    // Only set loading state if not already loading
    if (!isProductsLoading) {
      updateLoadingState(productsLoading: true);
    }

    try {
      // Reference to the Firestore collection
      CollectionReference itemsCollection =
          FirebaseFirestore.instance.collection('items');

      // Query to get documents where isShownOnHomePage is 1
      QuerySnapshot querySnapshot =
          await itemsCollection.where('isShownOnHomePage', isEqualTo: 1).get();

      // Iterate through each document and add the document ID to the list
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        documentIds.add(doc.id);
      }

      updateLoadingState(productsLoading: false);
      return documentIds;
    } catch (e) {
      _logger.severe('Error fetching documents: $e');
      updateLoadingState(productsLoading: false);
      return [];
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
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

  @override
  Widget build(BuildContext context) {
    _logger.info('Building HomePage');
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          // Show linear progress indicator for ANY loading state
          if (anyComponentLoading)
            LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // This will trigger a rebuild with a new future
                setState(() {
                  _homePageDocumentsFuture = getDocumentIdsShownOnHomePage();
                  isProductsLoading = true;
                });
                await Future.delayed(const Duration(milliseconds: 1500));
                if (mounted) {
                  setState(() {
                    isProductsLoading = false;
                  });
                }
              },
              child: FutureBuilder<List<String>>(
                future: _homePageDocumentsFuture,
                builder: (context, snapshot) {
                  // Handle any initialization issues
                  if (!_futureInitialized) {
                    _logger.warning('Future not initialized, initializing now');
                    _homePageDocumentsFuture = getDocumentIdsShownOnHomePage();
                    _futureInitialized = true;
                    return const SizedBox(); // Use a consistent loading approach
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  if (snapshot.hasError) {
                    _logger.severe('Error in FutureBuilder', snapshot.error);
                    return const Center(child: Text('Error loading data'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    _logger.info('No items to display');
                    return const Center(child: Text('No items to display'));
                  }

                  List<String> documentIds = snapshot.data!;
                  _logger.info('Document IDs to display: $documentIds');
                  try {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.grey[300],
                            child: Column(
                              children: [
                                CategoryHeader(),
                                CategoryGrid(
                                  onLoadingChanged: (isLoading) =>
                                      updateLoadingState(
                                          categoriesLoading: isLoading),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Column(
                              children: [
                                BestSellerHeader(),
                                ProductGrid(
                                  documentIds: documentIds,
                                  onLoadingChanged: (isLoading) =>
                                      updateLoadingState(
                                          productsLoading: isLoading),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    _logger.severe(
                        'Error building widget tree for homepage:', e);
                    return const Center(child: Text('Error loading page'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 0, // Set the current index as needed
        onItemTapped: (index) => _onItemTapped(context, index),
      ),
    );
  }
}

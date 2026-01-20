import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Home/Components/app_bar_component.dart';
import 'package:dyota/pages/Home/Components/best_seller_header.dart';
import 'package:dyota/pages/Home/Components/category_grid_component.dart';
import 'package:dyota/pages/Home/Components/category_header_component.dart';
import 'package:dyota/pages/Home/Components/product_grid_component.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Logger _logger = Logger('HomePage');
  final LoadingState _loadingState = LoadingState();
  late final HomepageDataProvider _dataProvider;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _dataProvider = HomepageDataProvider();
    _initializeData();
    _setupSafetyTimeouts();
  }

  void _initializeData() {
    _dataProvider.initialize();

    // Set initial data loading to false after a short delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!_isDisposed()) {
        setState(() {
          _loadingState.isInitialDataLoading = false;
        });
      }
    });
  }

  void _setupSafetyTimeouts() {
    // Safety timeout to ensure all loading states are reset eventually
    Future.delayed(const Duration(seconds: 5), () {
      if (!_isDisposed() && _loadingState.anyComponentLoading) {
        _logger.warning('Forced reset of loading states due to timeout');
        setState(() {
          _loadingState.resetAllLoadingStates();
        });
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

  Future<void> _refreshData() async {
    setState(() {
      _loadingState.isProductsLoading = true;
    });

    await _dataProvider.refreshData();

    if (mounted) {
      setState(() {
        _loadingState.isProductsLoading = false;
      });
    }
  }

  void _updateLoadingState({
    bool? productsLoading,
    bool? categoriesLoading,
  }) {
    if (_isDisposed() || _loadingState.isInitialDataLoading) return;

    if (_loadingState.shouldSkipRedundantUpdate(
        productsLoading: productsLoading,
        categoriesLoading: categoriesLoading)) {
      return;
    }

    _logCurrentLoadingStates();

    if (_loadingState.shouldDebounceUpdate()) {
      return;
    }

    _applyLoadingStateUpdate(productsLoading, categoriesLoading);
  }

  void _logCurrentLoadingStates() {
    _logger.info('Current loading states - '
        'Products: ${_loadingState.isProductsLoading}, '
        'Categories: ${_loadingState.isCategoriesLoading}, '
        'Initial: ${_loadingState.isInitialDataLoading}');
  }

  void _applyLoadingStateUpdate(
      bool? productsLoading, bool? categoriesLoading) {
    Future.microtask(() {
      if (!_isDisposed()) {
        setState(() {
          if (productsLoading != null) {
            _loadingState.isProductsLoading = productsLoading;
            _logger.info('Updated productsLoading to: $productsLoading');
          }
          if (categoriesLoading != null) {
            _loadingState.isCategoriesLoading = categoriesLoading;
            _logger.info('Updated categoriesLoading to: $categoriesLoading');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.info('Building HomePage');
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        if (_loadingState.anyComponentLoading) _buildProgressIndicator(),
        Expanded(
          child: _buildRefreshableContent(context),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      backgroundColor: Colors.grey[200],
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.brown),
    );
  }

  Widget _buildRefreshableContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<List<String>>(
        future: _dataProvider.homePageDocumentsFuture,
        builder: (context, snapshot) {
          return _buildFutureContent(context, snapshot);
        },
      ),
    );
  }

  Widget _buildFutureContent(
      BuildContext context, AsyncSnapshot<List<String>> snapshot) {
    if (!_dataProvider.isInitialized) {
      _logger.warning('Future not initialized, initializing now');
      _dataProvider.initialize();
      return const SizedBox();
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

    return _buildHomepageContent(snapshot.data!);
  }

  Widget _buildHomepageContent(List<String> documentIds) {
    _logger.info('Document IDs to display: $documentIds');
    try {
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildCategoriesSection(),
            _buildProductsSection(documentIds),
          ],
        ),
      );
    } catch (e) {
      _logger.severe('Error building widget tree for homepage:', e);
      return const Center(child: Text('Error loading page'));
    }
  }

  Widget _buildCategoriesSection() {
    return Container(
      color: Colors.grey[300],
      child: Column(
        children: [
          const CategoryHeader(),
          CategoryGrid(
            onLoadingChanged: (isLoading) =>
                _updateLoadingState(categoriesLoading: isLoading),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(List<String> documentIds) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        children: [
          const BestSellerHeader(),
          ProductGrid(
            documentIds: documentIds,
            onLoadingChanged: (isLoading) =>
                _updateLoadingState(productsLoading: isLoading),
          ),
        ],
      ),
    );
  }
}

class LoadingState {
  bool isProductsLoading = false;
  bool isCategoriesLoading = false;
  bool isInitialDataLoading = true;
  DateTime _lastUpdateTime = DateTime.now();

  bool get anyComponentLoading =>
      isProductsLoading || isCategoriesLoading || isInitialDataLoading;

  void resetAllLoadingStates() {
    isProductsLoading = false;
    isCategoriesLoading = false;
    isInitialDataLoading = false;
  }

  bool shouldSkipRedundantUpdate({
    bool? productsLoading,
    bool? categoriesLoading,
  }) {
    return (productsLoading != null && productsLoading == isProductsLoading) &&
        (categoriesLoading != null && categoriesLoading == isCategoriesLoading);
  }

  bool shouldDebounceUpdate() {
    final now = DateTime.now();
    if (now.difference(_lastUpdateTime).inMilliseconds < 300) {
      return true; // Skip frequent updates
    }
    _lastUpdateTime = now;
    return false;
  }
}

class HomepageDataProvider {
  bool isInitialized = false;
  late Future<List<String>> homePageDocumentsFuture;

  void initialize() {
    homePageDocumentsFuture = _fetchHomePageDocuments();
    isInitialized = true;
  }

  Future<void> refreshData() async {
    homePageDocumentsFuture = _fetchHomePageDocuments();
    await Future.delayed(const Duration(milliseconds: 1500));
  }

  Future<List<String>> _fetchHomePageDocuments() async {
    List<String> documentIds = [];

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

      return documentIds;
    } catch (e) {
      return [];
    }
  }
}

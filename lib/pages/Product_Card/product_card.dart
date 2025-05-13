import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Product_Card/Components/add_to_cart_button.dart';
import 'package:dyota/pages/Product_Card/Components/dynamic_fields_display.dart';
import 'package:dyota/pages/Product_Card/Components/image_carousel.dart';
import 'package:dyota/pages/Product_Card/Components/more_colours_section.dart';
import 'package:dyota/pages/Product_Card/Components/order_swatches.dart';
import 'package:dyota/pages/Product_Card/Components/product_data.dart';
import 'package:dyota/pages/Product_Card/Components/product_data_provider.dart';
import 'package:dyota/pages/Product_Card/Components/product_description.dart';
import 'package:dyota/pages/Product_Card/Components/product_loading_state.dart';
import 'package:dyota/pages/Product_Card/Components/product_name.dart';
import 'package:dyota/pages/Product_Card/Components/product_navigation.dart';
import 'package:dyota/pages/Product_Card/Components/recently_viewed_section.dart';
import 'package:dyota/pages/Product_Card/Components/support_section.dart';
import 'package:dyota/pages/Product_Card/Components/users_also_viewed_section.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ProductCard extends StatefulWidget {
  final String documentId;

  const ProductCard({super.key, required this.documentId});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final Logger _logger = Logger('ProductCard');
  final ProductLoadingState _loadingState = ProductLoadingState();
  final ProductDataProvider _dataProvider = ProductDataProvider();

  int selectedImageIndex = 0;
  int selectedNavIndex = 0;
  int selectedVariantIndex = 0;

  bool _disposed = false;
  String _currentDocumentId = '';

  ProductData? _productData;
  List<RelatedProduct> _recentlyViewed = [];
  List<RelatedProduct> _relatedProducts = [];

  @override
  void initState() {
    super.initState();
    _currentDocumentId = widget.documentId;
    _logger
        .info('ProductCard initialized with documentId: $_currentDocumentId');

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadProductData(_currentDocumentId);
    await _updateRecentlyViewedProducts(_currentDocumentId);
    await _loadRecentlyViewedProducts();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  bool _isDisposed() {
    return _disposed || !mounted;
  }

  Future<void> _loadProductData(String documentId) async {
    if (_isDisposed()) return;

    try {
      final productData = await _dataProvider.fetchProductData(documentId);

      if (_isDisposed()) return;

      setState(() {
        _productData = productData;
        _loadingState.updateWith(mainLoading: false);
        selectedImageIndex = 0; // Reset image carousel index
      });

      if (productData.categoryValue != null) {
        await _loadRelatedProducts(productData.categoryValue!);
      }
    } catch (e) {
      _logger.severe('Error loading product data: $e');
      if (!_isDisposed()) {
        setState(() {
          _loadingState.updateWith(mainLoading: false);
        });
      }
    }
  }

  Future<void> _updateRecentlyViewedProducts(String documentId) async {
    await _dataProvider.updateRecentlyViewedProducts(documentId);
  }

  Future<void> _loadRecentlyViewedProducts() async {
    if (_isDisposed()) return;

    setState(() {
      _loadingState.updateWith(recentlyViewedLoading: true);
    });

    try {
      final recentlyViewed = await _dataProvider.fetchRecentlyViewedProducts();

      if (_isDisposed()) return;

      setState(() {
        _recentlyViewed = recentlyViewed;
        _loadingState.updateWith(recentlyViewedLoading: false);
      });
    } catch (e) {
      _logger.severe('Error loading recently viewed products: $e');
      if (!_isDisposed()) {
        setState(() {
          _loadingState.updateWith(recentlyViewedLoading: false);
        });
      }
    }
  }

  Future<void> _loadRelatedProducts(String categoryValue) async {
    if (_isDisposed()) return;

    setState(() {
      _loadingState.updateWith(usersAlsoViewedLoading: true);
    });

    try {
      final relatedProducts =
          await _dataProvider.fetchRelatedProducts(categoryValue);

      if (_isDisposed()) return;

      setState(() {
        _relatedProducts = relatedProducts;
        _loadingState.updateWith(usersAlsoViewedLoading: false);
      });
    } catch (e) {
      _logger.severe('Error loading related products: $e');
      if (!_isDisposed()) {
        setState(() {
          _loadingState.updateWith(usersAlsoViewedLoading: false);
        });
      }
    }
  }

  void _updateLoadingState({
    bool? nameLoading,
    bool? descriptionLoading,
    bool? dynamicFieldsLoading,
    bool? carouselLoading,
    bool? moreColoursLoading,
  }) {
    if (_isDisposed()) return;

    // Skip debounced updates
    if (_loadingState.shouldDebounceUpdate()) return;

    // Use Future.microtask to defer the setState until the current build phase is complete
    Future.microtask(() {
      if (!_isDisposed()) {
        setState(() {
          _loadingState.updateWith(
            nameLoading: nameLoading,
            descriptionLoading: descriptionLoading,
            dynamicFieldsLoading: dynamicFieldsLoading,
            carouselLoading: carouselLoading,
            moreColoursLoading: moreColoursLoading,
          );
        });
      }
    });
  }

  void _handleImageThumbnailTap(int index) {
    if (_isDisposed()) return;
    setState(() {
      selectedImageIndex = index;
    });
    _logger.info('Image thumbnail tapped, new index: $index');
  }

  void _handleVariantTap(int index) {
    if (_isDisposed() ||
        _productData == null ||
        index >= _productData!.variants.length) return;

    setState(() {
      selectedVariantIndex = index;
      _currentDocumentId = _productData!.variants[index].documentId;
    });

    _loadProductData(_currentDocumentId);
    _updateRecentlyViewedProducts(_currentDocumentId);

    _logger.info('Variant tapped, new documentId: $_currentDocumentId');
  }

  void _handleRelatedProductTap(String documentId) {
    ProductNavigation.navigateToProduct(context, documentId);
  }

  void _handleNavigation(int index) {
    setState(() {
      selectedNavIndex = index;
    });
    ProductNavigation.navigateToMainSection(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Product Card'),
      body: _buildBody(),
      bottomNavigationBar: ProductBottomNavigationBar(
        selectedIndex: selectedNavIndex,
        onItemTapped: _handleNavigation,
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        if (_loadingState.anyComponentLoading) _buildProgressIndicator(),
        Expanded(
          child: _buildContent(),
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

  Widget _buildContent() {
    if (_productData == null || _productData!.variants.isEmpty) {
      return const Center(child: Text(''));
    }

    return _buildProductDetails();
  }

  Widget _buildProductDetails() {
    if (_productData == null) return const SizedBox();

    List<String> documentIds = _getVariantDocumentIds();

    return ListView(
      addAutomaticKeepAlives: true,
      cacheExtent: 1000,
      children: <Widget>[
        ProductName(
          documentId: _currentDocumentId,
          onLoadingChanged: (isLoading) =>
              _updateLoadingState(nameLoading: isLoading),
        ),
        ProductDescription(
          documentId: _currentDocumentId,
          onLoadingChanged: (isLoading) =>
              _updateLoadingState(descriptionLoading: isLoading),
        ),
        _buildImageCarousel(),
        const SizedBox(height: 20),
        _buildVariantsSection(),
        DynamicFieldsDisplay(
          documentId: _currentDocumentId,
          onLoadingChanged: (isLoading) =>
              _updateLoadingState(dynamicFieldsLoading: isLoading),
        ),
        OrderSwatchesButton(documentIds: documentIds),
        AddToCartButton(documentIds: documentIds),
        const SupportSection(),
        if (_relatedProducts.isNotEmpty) _buildRelatedProductsSection(),
        const SizedBox(height: 20),
        if (_recentlyViewed.isNotEmpty) _buildRecentlyViewedSection(),
      ],
    );
  }

  List<String> _getVariantDocumentIds() {
    if (_productData == null) return [];

    final variants = _productData!.variants;
    final List<String> documentIds = [_currentDocumentId];

    for (var variant in variants) {
      documentIds.add(variant.documentId);
    }

    return documentIds;
  }

  Widget _buildImageCarousel() {
    if (_productData == null || _productData!.allImageUrls.isEmpty) {
      return const SizedBox();
    }

    return ImageCarousel(
      allImageUrls: _productData!.allImageUrls,
      selectedImageIndex: selectedImageIndex,
      onThumbnailTap: _handleImageThumbnailTap,
      onLoadingChanged: (isLoading) =>
          _updateLoadingState(carouselLoading: isLoading),
    );
  }

  Widget _buildVariantsSection() {
    if (_productData == null || _productData!.variants.isEmpty) {
      return const SizedBox();
    }

    // Create a list of image details in the format expected by MoreColoursSection
    final List<Map<String, String>> imageDetails = [
      {
        'imageUrl': _productData!.allImageUrls.first,
        'documentId': _currentDocumentId
      }
    ];

    for (var variant in _productData!.variants) {
      imageDetails.add({
        'imageUrl': variant.imageUrl,
        'documentId': variant.documentId,
      });
    }

    return MoreColoursSection(
      imageDetails: imageDetails,
      selectedParentImageIndex: selectedVariantIndex,
      onThumbnailTap: _handleVariantTap,
      onLoadingChanged: (isLoading) =>
          _updateLoadingState(moreColoursLoading: isLoading),
    );
  }

  Widget _buildRelatedProductsSection() {
    // Convert RelatedProduct objects to the expected format
    final List<Map<String, String>> relatedProductDetails =
        _relatedProducts.map((p) => p.toMap()).toList();

    return UsersAlsoViewedSection(
      usersAlsoViewedDetails: relatedProductDetails,
      onThumbnailTap: (index) =>
          _handleRelatedProductTap(_relatedProducts[index].documentId),
      onLoadingChanged: (isLoading) {
        if (_isDisposed()) return;
        setState(() {
          _loadingState.updateWith(usersAlsoViewedLoading: isLoading);
        });
      },
    );
  }

  Widget _buildRecentlyViewedSection() {
    // Convert RelatedProduct objects to the expected format
    final List<Map<String, String>> recentlyViewedDetails =
        _recentlyViewed.map((p) => p.toMap()).toList();

    return RecentlyViewedSection(
      recentlyViewedDetails: recentlyViewedDetails,
      onThumbnailTap: (index) =>
          _handleRelatedProductTap(_recentlyViewed[index].documentId),
      onLoadingChanged: (isLoading) {
        if (_isDisposed()) return;
        setState(() {
          _loadingState.updateWith(recentlyViewedLoading: isLoading);
        });
      },
    );
  }
}

class ProductBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const ProductBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white54,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Bag'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}

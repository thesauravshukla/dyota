import 'package:dyota/components/shared/app_image.dart';
import 'package:dyota/pages/Category/Components/product_item_data.dart';
import 'package:dyota/pages/Product_Card/product_card.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ProductListItem extends StatefulWidget {
  final String documentId;
  final Function(bool)? onLoadingChanged;

  const ProductListItem({
    Key? key,
    required this.documentId,
    this.onLoadingChanged,
  }) : super(key: key);

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem>
    with AutomaticKeepAliveClientMixin {
  final Logger _logger = Logger('ProductListItem');
  late ProductItemData _productItemData;
  bool _hasNotifiedLoading = false;

  @override
  bool get wantKeepAlive => true; // Keep the widget alive when scrolling

  @override
  void initState() {
    super.initState();
    _productItemData = ProductItemData(documentId: widget.documentId);
    _productItemData.addListener(_onDataChanged);
    _fetchData();

    // Set initial loading state
    Future.microtask(() {
      if (mounted && !_hasNotifiedLoading && widget.onLoadingChanged != null) {
        _hasNotifiedLoading = true;
        widget.onLoadingChanged!(true);
      }
    });
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {
        // Force rebuild when data changes
      });
    }

    // Notify parent about loading state changes
    if (mounted && widget.onLoadingChanged != null) {
      if (_productItemData.isLoading && !_hasNotifiedLoading) {
        _hasNotifiedLoading = true;
        widget.onLoadingChanged!(true);
      } else if (!_productItemData.isLoading && _hasNotifiedLoading) {
        _hasNotifiedLoading = false;
        widget.onLoadingChanged!(false);
      }
    }
  }

  Future<void> _fetchData() async {
    try {
      await _productItemData.fetchData();
    } finally {
      // Ensure we set loading to false even if there was an error
      if (mounted && widget.onLoadingChanged != null && _hasNotifiedLoading) {
        widget.onLoadingChanged!(false);
        _hasNotifiedLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    // Show loading state
    if (_productItemData.isLoading) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    // Show product card if we have both data and image
    if (_productItemData.productData != null &&
        _productItemData.imageUrl != null) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductCard(documentId: widget.documentId)),
          );
        },
        child: _buildProductCard(),
      );
    }

    // Show error state if we have data but no image, or vice versa
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(height: 4),
            Text(
              'Error loading product',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.topRight,
            children: [
              AppImage(
                url: _productItemData.imageUrl!,
                width: double.infinity,
                height: 96,
              ),
              if (_productItemData.discount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '-${_productItemData.discount.toInt()}%',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Flexible(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _productItemData.brand,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    _productItemData.title,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    _productItemData.price,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (widget.onLoadingChanged != null && _productItemData.isLoading) {
      Future.microtask(() {
        widget.onLoadingChanged!(false);
      });
    }
    _productItemData.removeListener(_onDataChanged);
    _productItemData.dispose();
    super.dispose();
  }
}

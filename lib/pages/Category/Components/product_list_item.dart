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
    if (mounted && widget.onLoadingChanged != null && _hasNotifiedLoading) {
      widget.onLoadingChanged!(
          false); // Always notify as not loading when data changes
      _hasNotifiedLoading = false; // Reset notification flag
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

    if (_productItemData.isLoading) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

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

    return Container(); // Fallback empty container
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
              Image.network(
                _productItemData.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 96, // Fixed height for the image
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
                      color: Colors.grey[600],
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

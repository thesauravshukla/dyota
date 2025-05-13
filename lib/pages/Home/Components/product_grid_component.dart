import 'package:dyota/pages/Category/Components/product_list_item.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ProductGrid extends StatefulWidget {
  final List<String> documentIds;
  final Function(bool)? onLoadingChanged;

  const ProductGrid({
    Key? key,
    required this.documentIds,
    this.onLoadingChanged,
  }) : super(key: key);

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final Logger _logger = Logger('ProductGrid');
  final LoadingTracker _loadingTracker = LoadingTracker();

  @override
  void initState() {
    super.initState();
    _notifyInitialLoadingState();
  }

  void _notifyInitialLoadingState() {
    if (!_loadingTracker.hasNotifiedLoading &&
        widget.onLoadingChanged != null) {
      _loadingTracker.hasNotifiedLoading = true;
      _loadingTracker.isLoading = true;
      widget.onLoadingChanged!(true);
    }
  }

  void _onProductLoadingChanged(bool isLoading) {
    if (isLoading) {
      _incrementLoadingCount();
    } else {
      _decrementLoadingCount();
    }

    _updateParentLoadingState();
  }

  void _incrementLoadingCount() {
    _loadingTracker.loadingItemCount++;
  }

  void _decrementLoadingCount() {
    _loadingTracker.loadingItemCount = _loadingTracker.loadingItemCount > 0
        ? _loadingTracker.loadingItemCount - 1
        : 0;
  }

  void _updateParentLoadingState() {
    bool newLoadingState = _loadingTracker.loadingItemCount > 0;
    if (_loadingTracker.isLoading != newLoadingState) {
      _loadingTracker.isLoading = newLoadingState;
      widget.onLoadingChanged?.call(newLoadingState);
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger
        .info('Building ProductGrid with ${widget.documentIds.length} items');
    return _buildProductGrid();
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.documentIds.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: _buildProductItem,
    );
  }

  Widget _buildProductItem(BuildContext context, int index) {
    _logger.fine(
        'Building ProductListItem for documentId: ${widget.documentIds[index]}');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ProductListItem(
        documentId: widget.documentIds[index],
        onLoadingChanged: _onProductLoadingChanged,
      ),
    );
  }
}

class LoadingTracker {
  bool isLoading = false;
  bool hasNotifiedLoading = false;
  int loadingItemCount = 0;
}

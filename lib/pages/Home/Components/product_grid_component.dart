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
  bool _isLoading = false;
  bool _loadingNotified = false;
  int _loadingItemCount = 0;

  @override
  void initState() {
    super.initState();

    // Only send a single initial loading notification
    if (!_loadingNotified && widget.onLoadingChanged != null) {
      _loadingNotified = true;
      _isLoading = true;
      widget.onLoadingChanged!(true);
    }
  }

  void _updateLoadingState(bool isLoading) {
    if (isLoading) {
      _loadingItemCount++;
    } else {
      _loadingItemCount = _loadingItemCount > 0 ? _loadingItemCount - 1 : 0;
    }

    bool newLoadingState = _loadingItemCount > 0;
    if (_isLoading != newLoadingState) {
      _isLoading = newLoadingState;
      widget.onLoadingChanged?.call(newLoadingState);
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger
        .info('Building ProductGrid with ${widget.documentIds.length} items');

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.documentIds.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        _logger.fine(
            'Building ProductListItem for documentId: ${widget.documentIds[index]}');
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductListItem(
            documentId: widget.documentIds[index],
            onLoadingChanged: _updateLoadingState,
          ),
        );
      },
    );
  }
}

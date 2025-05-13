import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Product_Card/Components/firestore_data_loader.dart';
import 'package:flutter/material.dart';

class ProductName extends StatefulWidget {
  final String documentId;
  final Function(bool) onLoadingChanged;

  const ProductName({
    Key? key,
    required this.documentId,
    required this.onLoadingChanged,
  }) : super(key: key);

  @override
  State<ProductName> createState() => _ProductNameState();
}

class _ProductNameState extends State<ProductName>
    with AutomaticKeepAliveClientMixin {
  late FirestoreDataLoader<String> _dataLoader;

  @override
  bool get wantKeepAlive => true; // Keep this widget alive when scrolling

  @override
  void initState() {
    super.initState();
    _dataLoader = FirestoreDataLoader<String>(
      documentId: widget.documentId,
      onLoadingChanged: widget.onLoadingChanged,
      converter: _extractProductName,
    );
    _dataLoader.setInitialLoadingState(mounted);
  }

  String _extractProductName(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return data['productName']['value'] ?? 'Unknown Product';
  }

  @override
  void didUpdateWidget(ProductName oldWidget) {
    super.didUpdateWidget(oldWidget);
    _dataLoader.updateDocumentId(widget.documentId, mounted);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return _dataLoader.buildWithData(
      context: context,
      mounted: mounted,
      collection: 'items',
      builder: (productName) => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Text(
          productName,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      errorBuilder: (error) => Center(child: Text('Error: $error')),
      loadingBuilder: () =>
          Container(height: 40), // Empty container while loading
      emptyBuilder: () => const Center(child: Text('Product not found.')),
    );
  }

  @override
  void dispose() {
    _dataLoader.handleDispose(mounted);
    super.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Product_Card/product_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  bool _isLoading = true;
  bool _hasNotifiedLoading = false;
  Map<String, dynamic>? _productData;
  String? _imageUrl;

  @override
  bool get wantKeepAlive => true; // Keep the widget alive when scrolling

  @override
  void initState() {
    super.initState();
    _fetchData();

    // Set initial loading state
    Future.microtask(() {
      if (mounted && !_hasNotifiedLoading && widget.onLoadingChanged != null) {
        _hasNotifiedLoading = true;
        widget.onLoadingChanged!(true);
      }
    });
  }

  Future<void> _fetchData() async {
    try {
      // Fetch product data
      final data = await fetchProductData();

      // Get image URL
      List<dynamic> imageLocations = data['imageLocation'];
      String imagePath = imageLocations[0];
      final imageUrl = await getImageUrl(imagePath);

      if (mounted) {
        setState(() {
          _productData = data;
          _imageUrl = imageUrl;
          _isLoading = false;
        });

        if (widget.onLoadingChanged != null) {
          Future.microtask(() {
            if (mounted) widget.onLoadingChanged!(false);
          });
        }
      }
    } catch (e) {
      _logger.severe('Error fetching product data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (widget.onLoadingChanged != null) {
          Future.microtask(() {
            if (mounted) widget.onLoadingChanged!(false);
          });
        }
      }
    }
  }

  Future<Map<String, dynamic>> fetchProductData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('items')
        .doc(widget.documentId)
        .get();
    return doc.data() as Map<String, dynamic>;
  }

  Future<String> getImageUrl(String path) async {
    String url = await FirebaseStorage.instance.ref(path).getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    if (_isLoading) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    if (_productData != null && _imageUrl != null) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductCard(documentId: widget.documentId)),
          );
        },
        child: buildProductCard(_imageUrl!, _productData!),
      );
    }

    return Container(); // Fallback empty container
  }

  Widget buildProductCard(String imageUrl, Map<String, dynamic> data) {
    String getFieldValue(Map<String, dynamic> field) {
      String value = field['value'] ?? '';
      String prefix = field['prefix'] ?? '';
      String suffix = field['suffix'] ?? '';
      return '$prefix$value$suffix';
    }

    String brand = getFieldValue(data['subCategory']);
    String title = getFieldValue(data['printType']);
    String price = getFieldValue(data['pricePerMetre']);
    double discount = 0; // Assuming discount is not provided in the data

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
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 96, // Fixed height for the image
              ),
              if (discount > 0)
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
                      '-${discount.toInt()}%',
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
                    brand,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    price,
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
    if (widget.onLoadingChanged != null && _isLoading) {
      Future.microtask(() {
        widget.onLoadingChanged!(false);
      });
    }
    super.dispose();
  }
}

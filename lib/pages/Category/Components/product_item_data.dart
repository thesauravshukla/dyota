import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/services/image_cache_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class ProductItemData with ChangeNotifier {
  final String _documentId;
  final Logger _logger = Logger('ProductItemData');
  bool _isLoading = true;
  bool _disposed = false;
  Map<String, dynamic>? _productData;
  String? _imageUrl;

  ProductItemData({required String documentId}) : _documentId = documentId;

  String get documentId => _documentId;
  bool get isLoading => _isLoading;
  bool get disposed => _disposed;
  Map<String, dynamic>? get productData => _productData;
  String? get imageUrl => _imageUrl;

  Future<void> fetchData() async {
    if (_disposed) return;

    try {
      final data = await _fetchProductData();
      final String imagePath = _getImagePath(data);
      final String imageUrl = await _getImageUrl(imagePath);

      if (!_disposed) {
        _productData = data;
        _imageUrl = imageUrl;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _logger.severe('Error fetching product data: $e');
      if (!_disposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<Map<String, dynamic>> _fetchProductData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('items')
        .doc(_documentId)
        .get();
    return doc.data() as Map<String, dynamic>;
  }

  String _getImagePath(Map<String, dynamic> data) {
    List<dynamic> imageLocations = data['imageLocation'];
    return imageLocations[0];
  }

  Future<String> _getImageUrl(String path) async {
    return await ImageCacheService.instance.getImageUrl(path) ?? '';
  }

  String getFieldValue(Map<String, dynamic> field) {
    String value = field['value'] ?? '';
    String prefix = field['prefix'] ?? '';
    String suffix = field['suffix'] ?? '';
    return '$prefix$value$suffix';
  }

  String get brand =>
      _productData != null ? getFieldValue(_productData!['subCategory']) : '';
  String get title =>
      _productData != null ? getFieldValue(_productData!['printType']) : '';
  String get price =>
      _productData != null ? getFieldValue(_productData!['pricePerMetre']) : '';
  // Assuming discount is not provided in the data
  double get discount => 0;

  void markDisposed() {
    _disposed = true;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

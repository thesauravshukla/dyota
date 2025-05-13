import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents the data for a product and its variants/related products
class ProductData {
  final String documentId;
  final List<String> allImageUrls;
  final List<ProductVariant> variants;
  final String? categoryValue;

  ProductData({
    required this.documentId,
    required this.allImageUrls,
    required this.variants,
    this.categoryValue,
  });

  /// Creates a copy of this ProductData with some fields replaced
  ProductData copyWith({
    String? documentId,
    List<String>? allImageUrls,
    List<ProductVariant>? variants,
    String? categoryValue,
  }) {
    return ProductData(
      documentId: documentId ?? this.documentId,
      allImageUrls: allImageUrls ?? this.allImageUrls,
      variants: variants ?? this.variants,
      categoryValue: categoryValue ?? this.categoryValue,
    );
  }

  /// Creates an empty product data instance with the given document ID
  static ProductData empty(String documentId) {
    return ProductData(
      documentId: documentId,
      allImageUrls: [],
      variants: [],
    );
  }
}

/// Represents a variant of a product (e.g., different color)
class ProductVariant {
  final String documentId;
  final String imageUrl;

  ProductVariant({
    required this.documentId,
    required this.imageUrl,
  });
}

/// Represents a product that was recently viewed or related to the current product
class RelatedProduct {
  final String documentId;
  final String imageUrl;

  RelatedProduct({
    required this.documentId,
    required this.imageUrl,
  });

  /// Creates a RelatedProduct from a map containing imageUrl and documentId
  static RelatedProduct fromMap(Map<String, String> map) {
    return RelatedProduct(
      documentId: map['documentId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  /// Converts this RelatedProduct to a Map
  Map<String, String> toMap() {
    return {
      'documentId': documentId,
      'imageUrl': imageUrl,
    };
  }
}

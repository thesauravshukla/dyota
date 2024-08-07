import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Product_Card/product_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ProductListItem extends StatelessWidget {
  final String documentId;
  final Logger _logger = Logger('ProductListItem');

  ProductListItem({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  Future<Map<String, dynamic>> fetchProductData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('items')
        .doc(documentId)
        .get();
    return doc.data() as Map<String, dynamic>;
  }

  Future<String> getImageUrl(String path) async {
    String url = await FirebaseStorage.instance.ref(path).getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchProductData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var data = snapshot.data!;
          String imagePath = data['imageLocation'];

          return FutureBuilder<String>(
            future: getImageUrl(imagePath),
            builder: (context, imageSnapshot) {
              if (imageSnapshot.connectionState == ConnectionState.done &&
                  imageSnapshot.hasData) {
                String imageUrl = imageSnapshot.data!;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductCard(documentId: documentId)),
                    );
                  },
                  child: buildProductCard(imageUrl, data),
                );
              } else if (imageSnapshot.hasError) {
                throw Exception(
                    'Error in imageSnapshot: ${imageSnapshot.error}');
              } else {
                return Container();
              }
            },
          );
        } else if (snapshot.hasError) {
          throw Exception('Error in snapshot: ${snapshot.error}');
        } else {
          return Container();
        }
      },
    );
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
}

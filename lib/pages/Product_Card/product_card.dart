import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Product_Card/Components/add_to_cart_button.dart';
import 'package:dyota/pages/Product_Card/Components/dynamic_fields_display.dart';
import 'package:dyota/pages/Product_Card/Components/image_placeholder.dart';
import 'package:dyota/pages/Product_Card/Components/image_thumbnails.dart';
import 'package:dyota/pages/Product_Card/Components/order_swatches.dart';
import 'package:dyota/pages/Product_Card/Components/product_name.dart';
import 'package:dyota/pages/Product_Card/Components/shipping_info.dart';
import 'package:dyota/pages/Product_Card/Components/support_section.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProductCard extends StatefulWidget {
  final String documentId;

  const ProductCard({super.key, required this.documentId});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final Logger logger = Logger();
  int selectedImageIndex = 0;
  List<Map<String, String>> imageDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    logger.i('ProductCard initialized with documentId: ${widget.documentId}');
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      logger.i('Fetching images for documentId: ${widget.documentId}');
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.documentId)
          .get();
      if (doc.exists) {
        logger.i('Document exists for documentId: ${widget.documentId}');
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String parentId = data['parentId'];
        String initialImageLocation = data['imageLocation'];

        String initialImageUrl = await FirebaseStorage.instance
            .ref(initialImageLocation)
            .getDownloadURL();
        List<Map<String, String>> details = [
          {'imageUrl': initialImageUrl, 'documentId': widget.documentId}
        ];

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('items')
            .where('parentId', isEqualTo: parentId)
            .where(FieldPath.documentId, isNotEqualTo: widget.documentId)
            .get();
        for (var document in querySnapshot.docs) {
          Map<String, dynamic> docData =
              document.data() as Map<String, dynamic>;
          if (docData.containsKey('imageLocation')) {
            String imageUrl = await FirebaseStorage.instance
                .ref(docData['imageLocation'])
                .getDownloadURL();
            details.add({'imageUrl': imageUrl, 'documentId': document.id});
          }
        }

        setState(() {
          imageDetails = details;
          isLoading = false;
        });
        logger.i(
            'Images fetched successfully for documentId: ${widget.documentId}');
      } else {
        logger
            .w('Document does not exist for documentId: ${widget.documentId}');
      }
    } catch (e) {
      logger.e('Error fetching images for documentId: ${widget.documentId}', e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Product Card'),
      body: Column(
        children: [
          if (isLoading)
            LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
            ),
          Expanded(
            child: imageDetails.isEmpty
                ? Center(child: Text(''))
                : ListView(
                    children: <Widget>[
                      ProductName(),
                      ImagePlaceholder(
                          imageUrl: imageDetails[selectedImageIndex]
                              ['imageUrl']!),
                      ImageThumbnails(
                        imageDetails: imageDetails,
                        selectedImageIndex: selectedImageIndex,
                        onThumbnailTap: (index) {
                          setState(() {
                            selectedImageIndex = index;
                          });
                          logger.i(
                              'Thumbnail tapped, selectedImageIndex: $selectedImageIndex');
                        },
                      ),
                      DynamicFieldsDisplay(
                          documentId: imageDetails[selectedImageIndex]
                              ['documentId']!),
                      OrderSwatchesButton(
                          documentIds: imageDetails
                              .map((detail) => detail['documentId']!)
                              .toList()),
                      AddToCartButton(
                        documentIds: imageDetails
                            .map((detail) => detail['documentId']!)
                            .toList(),
                      ),
                      const ShippingInfo(),
                      const SupportSection(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

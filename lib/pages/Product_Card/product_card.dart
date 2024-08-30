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
import 'package:logging/logging.dart';

class ProductCard extends StatefulWidget {
  final String documentId;

  const ProductCard({super.key, required this.documentId});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final Logger _logger = Logger('ProductCard');
  int selectedImageIndex = 0;
  int selectedParentImageIndex = 0; // New variable for parent images
  List<Map<String, String>> imageDetails = [];
  List<String> allImageUrls = [];
  bool isLoading = true;
  late String currentDocumentId;

  @override
  void initState() {
    super.initState();
    currentDocumentId = widget.documentId;
    _logger
        .info('ProductCard initialized with documentId: ${widget.documentId}');
    fetchImages(widget.documentId);
  }

  Future<void> fetchImages(String documentId) async {
    try {
      _logger.info('Fetching images for documentId: $documentId');
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('items')
          .doc(documentId)
          .get();
      if (doc.exists) {
        _logger.info('Document exists for documentId: $documentId');
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String parentId = data['parentId'];
        List<dynamic> imageLocations = data['imageLocation'];

        // Fetch all images from imageLocation array
        List<String> fetchedImageUrls = [];
        for (String imageLocation in imageLocations) {
          String imageUrl = await FirebaseStorage.instance
              .ref(imageLocation)
              .getDownloadURL();
          fetchedImageUrls.add(imageUrl);
        }

        String initialImageLocation = imageLocations[0];
        String initialImageUrl = await FirebaseStorage.instance
            .ref(initialImageLocation)
            .getDownloadURL();
        List<Map<String, String>> details = [
          {'imageUrl': initialImageUrl, 'documentId': documentId}
        ];

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('items')
            .where('parentId', isEqualTo: parentId)
            .where(FieldPath.documentId, isNotEqualTo: documentId)
            .get();
        for (var document in querySnapshot.docs) {
          Map<String, dynamic> docData =
              document.data() as Map<String, dynamic>;
          if (docData.containsKey('imageLocation')) {
            List<dynamic> docImageLocations = docData['imageLocation'];
            String imageUrl = await FirebaseStorage.instance
                .ref(docImageLocations[0])
                .getDownloadURL();
            details.add({'imageUrl': imageUrl, 'documentId': document.id});
          }
        }

        setState(() {
          allImageUrls = fetchedImageUrls;
          imageDetails = details;
          isLoading = false;
          selectedImageIndex = 0;
        });
        _logger.info('Images fetched successfully for documentId: $documentId');
      } else {
        _logger.warning('Document does not exist for documentId: $documentId');
      }
    } catch (e) {
      _logger.severe('Error fetching images for documentId: $documentId', e);
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
                          imageUrl: allImageUrls[selectedImageIndex]),
                      // Carousel for all images in imageLocation array
                      ImageThumbnails(
                        imageDetails: allImageUrls
                            .map((url) => {
                                  'imageUrl': url,
                                  'documentId': currentDocumentId
                                })
                            .toList(),
                        selectedImageIndex: selectedImageIndex,
                        onThumbnailTap: (index) {
                          setState(() {
                            selectedImageIndex = index;
                          });
                          _logger.info(
                              'Thumbnail tapped, selectedImageIndex: $selectedImageIndex');
                        },
                      ),
                      // Empty box of size 20
                      Divider(), // Inserted line below the "More Colours" text

                      // Section for images with the same parentId
                      Container(
                        color: Colors.grey[100], // Different background color
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'More Colours',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ImageThumbnails(
                              imageDetails: imageDetails,
                              selectedImageIndex:
                                  selectedParentImageIndex, // Use new variable
                              onThumbnailTap: (index) {
                                setState(() {
                                  selectedParentImageIndex =
                                      index; // Update new variable
                                  currentDocumentId =
                                      imageDetails[index]['documentId']!;
                                  fetchImages(currentDocumentId);
                                });
                                _logger.info(
                                    'Thumbnail tapped, new documentId: $currentDocumentId');
                              },
                            ),
                          ],
                        ),
                      ),
                      DynamicFieldsDisplay(documentId: currentDocumentId),
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

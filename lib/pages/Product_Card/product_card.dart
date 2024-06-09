import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Product_Card/Components/add_to_cart_button.dart';
import 'package:dyota/pages/Product_Card/Components/dynamic_fields_display.dart';
import 'package:dyota/pages/Product_Card/Components/order_swatches.dart';
import 'package:dyota/pages/Product_Card/Components/shipping_info.dart';
import 'package:dyota/pages/Product_Card/Components/support_section.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String documentId;

  const ProductCard({super.key, required this.documentId});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int selectedImageIndex = 0;
  double readValue = 0.0;
  double pickValue = 0.0;
  List<Map<String, String>> imageDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      // Fetch the initial document
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.documentId)
          .get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String parentId = data['parentId'];
        String initialImageLocation = data['imageLocation'];

        // Fetch the initial image URL from Firestore Storage
        String initialImageUrl = await FirebaseStorage.instance
            .ref(initialImageLocation)
            .getDownloadURL();
        List<Map<String, String>> details = [
          {'imageUrl': initialImageUrl, 'documentId': widget.documentId}
        ];

        // Fetch all documents with the same parentId and different documentId
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
      }
    } catch (e) {
      print('Error fetching images: $e');
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
                ? Center(child: Text('No images available'))
                : ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Text(
                          'Product Name', // Replace 'Product Name' with your dynamic product name variable if needed
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ImagePlaceholder(
                            imageUrl: imageDetails[selectedImageIndex]
                                ['imageUrl']!),
                      ),
                      SizedBox(
                        height: 80,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  List.generate(imageDetails.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImageIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selectedImageIndex == index
                                            ? Colors.black
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Image.network(
                                      imageDetails[index]['imageUrl']!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
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

class ImagePlaceholder extends StatelessWidget {
  final String imageUrl;

  const ImagePlaceholder({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(imageUrl, fit: BoxFit.cover);
  }
}

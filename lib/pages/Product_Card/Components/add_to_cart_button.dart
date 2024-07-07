import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:dyota/pages/Product_Card/Components/image_selector.dart';
import 'package:dyota/pages/Product_Card/Components/length_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddToCartButton extends StatefulWidget {
  final List<String> documentIds;

  const AddToCartButton({
    Key? key,
    required this.documentIds,
  }) : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  bool showDetails = false;
  late List<bool> selectedImages;
  late List<double> selectedLengths;
  List<String> imageUrls = [];
  Map<String, int> minimumOrderLengths = {};
  Map<int, String> validationErrors = {};

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
    selectedImages = List<bool>.filled(widget.documentIds.length, false);
    selectedLengths = List<double>.filled(widget.documentIds.length, 0);
  }

  Future<void> fetchImageUrls() async {
    List<String> urls = [];
    for (String docId in widget.documentIds) {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('items').doc(docId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String imageLocation = data['imageLocation'];
        String imageUrl =
            await FirebaseStorage.instance.ref(imageLocation).getDownloadURL();
        urls.add(imageUrl);
        int minimumOrderLength = data['minimumOrderLength']['value'] ?? 0;
        minimumOrderLengths[docId] = minimumOrderLength;
        selectedLengths[widget.documentIds.indexOf(docId)] =
            minimumOrderLength.toDouble();
      }
    }
    setState(() {
      imageUrls = urls;
    });
  }

  void validateInputs() {
    Map<int, String> errors = {};
    for (int i = 0; i < selectedLengths.length; i++) {
      if (selectedImages[i] &&
          selectedLengths[i] < minimumOrderLengths[widget.documentIds[i]]!) {
        errors[i] =
            'Order length should be at least ${minimumOrderLengths[widget.documentIds[i]]}';
      }
    }
    setState(() {
      validationErrors = errors;
    });
  }

  Future<void> _addToCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('You need to be logged in to add items to the cart')),
      );
      return;
    }

    final email = user.email;

    for (int i = 0; i < selectedImages.length; i++) {
      if (selectedImages[i]) {
        // Fetch the price per metre from the document
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('items')
            .doc(widget.documentIds[i])
            .get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String pricePerMetre = data['pricePerMetre']['value'];
        var pricePerMetreDouble = Decimal.parse(pricePerMetre);
        var selectedLengthsDouble =
            Decimal.parse(selectedLengths[i].toString());

        // Calculate the price based on the selected length
        Decimal price = (pricePerMetreDouble * selectedLengthsDouble);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .collection('cartItemsList')
            .doc(widget.documentIds[i] +
                '-textile') // Set the document ID to itemDocumentId
            .set({
          'itemType': {
            'displayName': 'Order Type',
            'value': 'Textile Order',
            'toDisplay': 1,
            'priority': 1,
          },
          'orderLength': {
            'displayName': 'Order Length',
            'value': selectedLengths[i].toString(),
            'suffix': "m",
            'toDisplay': 1,
            'priority': 2,
          },
          'price': {
            'displayName': 'Price',
            'prefix': "Rs. ",
            'value': price.toString(),
            'toDisplay': 1,
            'priority': 3,
          },
        }, SetOptions(merge: true));
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Items added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ExpansionTile(
        title: const Text('Add to Cart'),
        initiallyExpanded: showDetails,
        onExpansionChanged: (bool expanded) {
          setState(() {
            showDetails = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tap the designs to place order',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ...imageUrls.map((imageUrl) {
            int index = imageUrls.indexOf(imageUrl);
            int minOrderLength =
                minimumOrderLengths[widget.documentIds[index]]!;
            int maxOrderLength = minOrderLength + 100;
            List<int> labels = List.generate(
                6,
                (i) =>
                    minOrderLength +
                    (i * (maxOrderLength - minOrderLength) ~/ 5));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Divider(color: Colors.grey),
                ImageSelector(
                  imageUrl: imageUrl,
                  isSelected: selectedImages[index],
                  onTap: () {
                    setState(() {
                      selectedImages[index] = !selectedImages[index];
                    });
                  },
                ),
                Divider(color: Colors.grey),
                if (selectedImages[index])
                  LengthSlider(
                    minOrderLength: minOrderLength,
                    maxOrderLength: maxOrderLength,
                    selectedLength: selectedLengths[index],
                    labels: labels,
                    onChanged: (value) {
                      setState(() {
                        selectedLengths[index] = value;
                      });
                    },
                    validationError: validationErrors[index],
                  ),
              ],
            );
          }).toList(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  validateInputs();
                  if (validationErrors.isEmpty) {
                    _addToCart();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Please correct the errors before adding to cart')),
                    );
                  }
                },
                child: const Text('Add Selected Designs to Cart'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

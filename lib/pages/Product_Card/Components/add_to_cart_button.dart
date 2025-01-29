import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:dyota/pages/Product_Card/Components/image_selector.dart';
import 'package:dyota/pages/Product_Card/Components/length_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

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
  final Logger _logger = Logger('AddToCartButton');
  bool showDetails = false;
  late List<bool> selectedImages;
  late List<double> selectedLengths;
  List<String> imageUrls = [];
  Map<String, int> minimumOrderLengths = {};
  Map<int, String> validationErrors = {};

  @override
  void initState() {
    super.initState();
    _logger.info(
        'AddToCartButton initialized with documentIds: ${widget.documentIds}');
    fetchImageUrls();
    selectedImages = List<bool>.filled(widget.documentIds.length, false);
    selectedLengths = List<double>.filled(widget.documentIds.length, 0);
  }

  Future<void> fetchImageUrls() async {
    List<String> urls = [];
    try {
      for (String docId in widget.documentIds) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('items')
            .doc(docId)
            .get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          List<dynamic> imageLocations = data['imageLocation'];
          String imageLocation = imageLocations[0];
          String imageUrl = await FirebaseStorage.instance
              .ref(imageLocation)
              .getDownloadURL();
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
      _logger.info('Image URLs fetched successfully');
    } catch (e) {
      _logger.severe('Error fetching image URLs', e);
    }
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
    _logger.info('Inputs validated with errors: $validationErrors');
  }

  Future<void> _addToCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('You need to be logged in to add items to the cart')),
      );
      _logger.warning('User not logged in');
      return;
    }

    final email = user.email;

    try {
      for (int i = 0; i < selectedImages.length; i++) {
        if (selectedImages[i]) {
          DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection('items')
              .doc(widget.documentIds[i])
              .get();
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Get the price per metre and tax
          String pricePerMetre = data['pricePerMetre']['value'];
          var pricePerMetreDouble = Decimal.parse(pricePerMetre);
          var selectedLengthsDouble =
              Decimal.parse(selectedLengths[i].toString());

          // Calculate the price based on the selected length
          Decimal price = (pricePerMetreDouble * selectedLengthsDouble);

          // Calculate the tax
          String taxPercentageStr = data['tax']['value'];
          Decimal taxPercentage = Decimal.parse(taxPercentageStr);
          Decimal tax =
              price * (taxPercentage / Decimal.fromInt(100)).toDecimal();

          // Get the product name from the productName field
          Map<String, dynamic> productNameMap =
              data['productName'] as Map<String, dynamic>;
          String productName = productNameMap['value'] ?? 'Unknown Product';

          await FirebaseFirestore.instance
              .collection('users')
              .doc(email)
              .collection('cartItemsList')
              .doc(widget.documentIds[i] + '-textile')
              .set({
            'itemType': {
              'displayName': 'Order Type',
              'value': 'Textile Order',
              'toDisplay': 1,
              'priority': 2,
            },
            'orderLength': {
              'displayName': 'Order Length',
              'value': selectedLengths[i].toString(),
              'suffix': "m",
              'toDisplay': 1,
              'priority': 3,
            },
            'price': {
              'displayName': 'Price',
              'prefix': "Rs. ",
              'value': price.toString(),
              'toDisplay': 1,
              'priority': 4,
            },
            'tax': {
              'displayName': 'Tax',
              'prefix': "Rs. ",
              'value': tax.toString(),
              'toDisplay': 1,
              'priority': 5,
            },
            'productName': {
              'displayName': 'Product Name',
              'value': productName,
              'toDisplay': 1,
              'priority': 1,
            },
          }, SetOptions(merge: true));
          _logger.info('Item added to cart: ${widget.documentIds[i]}');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Items added to cart')),
      );
    } catch (e) {
      _logger.shout('Error adding items to cart', e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding items to cart')),
      );
    }
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
          _logger.info('ExpansionTile expanded: $expanded');
        },
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
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
                const Divider(color: Colors.grey),
                ImageSelector(
                  imageUrl: imageUrl,
                  isSelected: selectedImages[index],
                  onTap: () {
                    setState(() {
                      selectedImages[index] = !selectedImages[index];
                    });
                    _logger.info(
                        'Image selected: $index, documentId: ${widget.documentIds[index]}, isSelected: ${selectedImages[index]}');
                  },
                ),
                const Divider(color: Colors.grey),
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
                      _logger.info('LengthSlider changed: $value');
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
                      const SnackBar(
                          content: Text(
                              'Please correct the errors before adding to cart')),
                    );
                    _logger.warning('Validation errors: $validationErrors');
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                ),
                child: const Text('Add Selected Designs to Cart'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
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
          },
          'orderLength': {
            'displayName': 'Order Length',
            'value': selectedLengths[i],
            'toDisplay': 1,
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImages[index] = !selectedImages[index];
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Image.network(
                          imageUrl,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (selectedImages[index])
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_circle,
                              color: Colors.white, size: 30),
                        ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey),
                if (selectedImages[index])
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Order Length',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: double
                              .infinity, // Increase the width of the slider box
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200], // Background color
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.black,
                                  inactiveTrackColor:
                                      Colors.black.withOpacity(0.3),
                                  trackShape: RoundedRectSliderTrackShape(),
                                  trackHeight: 8.0,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 12.0),
                                  thumbColor: Colors.black,
                                  overlayColor: Colors.black.withAlpha(32),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 28.0),
                                  tickMarkShape: RoundSliderTickMarkShape(),
                                  activeTickMarkColor: Colors.black,
                                  inactiveTickMarkColor:
                                      Colors.black.withOpacity(0.3),
                                  valueIndicatorShape:
                                      PaddleSliderValueIndicatorShape(),
                                  valueIndicatorColor: Colors.black,
                                  valueIndicatorTextStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Slider(
                                  value: selectedLengths[index],
                                  min: minOrderLength.toDouble(),
                                  max: maxOrderLength
                                      .toDouble(), // Ensure max is greater than min
                                  divisions: 50, // Adjust based on your needs
                                  label:
                                      selectedLengths[index].round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      selectedLengths[index] = value;
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: labels
                                      .map((label) => Column(
                                            children: [
                                              Text('$label m',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              Container(
                                                width: 1,
                                                height: 8,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Current Order Length: ${selectedLengths[index].toStringAsFixed(2)} m',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (validationErrors.containsKey(index))
                          Text(
                            validationErrors[index]!,
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          ),
                      ],
                    ),
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

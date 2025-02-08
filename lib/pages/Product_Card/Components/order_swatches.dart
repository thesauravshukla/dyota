import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class OrderSwatchesButton extends StatefulWidget {
  final List<String> documentIds;

  const OrderSwatchesButton({Key? key, required this.documentIds})
      : super(key: key);

  @override
  _OrderSwatchesButtonState createState() => _OrderSwatchesButtonState();
}

class _OrderSwatchesButtonState extends State<OrderSwatchesButton> {
  List<bool> _selectedImages = [];
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    List<String> urls = [];
    for (String docId in widget.documentIds) {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('items').doc(docId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> imageLocations = data['imageLocation'];
        String imageLocation = imageLocations[0];
        String imageUrl =
            await FirebaseStorage.instance.ref(imageLocation).getDownloadURL();
        urls.add(imageUrl);
      }
    }
    setState(() {
      _imageUrls = urls;
      _selectedImages = List<bool>.filled(_imageUrls.length, false);
    });
  }

  Future<void> _addSwatchesToCart() async {
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

    for (int i = 0; i < _selectedImages.length; i++) {
      if (_selectedImages[i]) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .collection('cartItemsList')
            .doc(widget.documentIds[i] + '-swatches')
            .set({
          'itemType': {
            'displayName': 'Order Type',
            'value': 'Swatches',
            'toDisplay': 1,
            'priority': 1,
          },
          'price': {
            'displayName': 'Price',
            'prefix': 'Rs. ',
            'value': '0',
            'toDisplay': 1,
            'priority': 2,
          },
        });
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Swatches added to cart')),
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
        title: const Text('Order Swatches'),
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tap the designs to select them ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            children: List<Widget>.generate(_imageUrls.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImages[index] = !_selectedImages[index];
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedImages[index]
                              ? Colors.black
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Opacity(
                        opacity: _selectedImages[index] ? 0.5 : 1,
                        child: Image.network(
                          _imageUrls[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (_selectedImages[index])
                      Icon(Icons.check_circle, color: Colors.black, size: 30),
                    if (_selectedImages[index])
                      Icon(Icons.check, color: Colors.white, size: 24),
                  ],
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedImages.any((selected) => selected)) {
                    _addSwatchesToCart();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Please select at least one swatch')),
                    );
                  }
                },
                child: const Text('Add Swatches To Cart'),
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

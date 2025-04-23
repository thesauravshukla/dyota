import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/generic_appbar.dart';
import 'package:dyota/pages/Home/home_page.dart';
import 'package:dyota/pages/My_Bag/my_bag.dart';
import 'package:dyota/pages/Product_Card/Components/add_to_cart_button.dart';
import 'package:dyota/pages/Product_Card/Components/dynamic_fields_display.dart';
import 'package:dyota/pages/Product_Card/Components/image_carousel.dart';
import 'package:dyota/pages/Product_Card/Components/more_colours_section.dart';
import 'package:dyota/pages/Product_Card/Components/order_swatches.dart';
import 'package:dyota/pages/Product_Card/Components/product_description.dart';
import 'package:dyota/pages/Product_Card/Components/product_name.dart';
import 'package:dyota/pages/Product_Card/Components/recently_viewed_section.dart';
import 'package:dyota/pages/Product_Card/Components/support_section.dart';
import 'package:dyota/pages/Product_Card/Components/users_also_viewed_section.dart';
import 'package:dyota/pages/Profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int selectedImageIndex = 0; // For the image carousel
  int selectedNavIndex = 0; // For the bottom navigation bar
  int selectedParentImageIndex = 0; // New variable for parent images
  List<Map<String, String>> imageDetails = [];
  List<String> allImageUrls = [];
  List<Map<String, String>> recentlyViewedDetails = [];
  List<Map<String, String>> usersAlsoViewedDetails = [];
  bool isLoading = true;
  bool isNameLoading = false;
  bool isDescriptionLoading = false;
  bool isDynamicFieldsLoading = false;
  bool isCarouselLoading = false;
  bool isMoreColoursLoading = false;
  bool isRecentlyViewedLoading = false;
  bool isUsersAlsoViewedLoading = false;
  bool _disposed = false;
  late String currentDocumentId;
  String? currentCategoryValue;

  bool get anyComponentLoading =>
      isLoading ||
      isNameLoading ||
      isDescriptionLoading ||
      isDynamicFieldsLoading ||
      isCarouselLoading ||
      isMoreColoursLoading ||
      isRecentlyViewedLoading ||
      isUsersAlsoViewedLoading;

  @override
  void initState() {
    super.initState();
    currentDocumentId = widget.documentId;
    _logger
        .info('ProductCard initialized with documentId: ${widget.documentId}');
    fetchImages(widget.documentId);
    updateRecentlyViewedProducts(widget.documentId);
    fetchRecentlyViewedProducts();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
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
        currentCategoryValue = data['category']['value'];

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

        if (!_disposed) {
          setState(() {
            allImageUrls = fetchedImageUrls;
            imageDetails = details;
            isLoading = false;
            selectedImageIndex = 0; // Reset image carousel index
          });
        }
        _logger.info('Images fetched successfully for documentId: $documentId');
        fetchUsersAlsoViewedProducts(currentCategoryValue!);
      } else {
        _logger.warning('Document does not exist for documentId: $documentId');
        if (!_disposed) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      _logger.severe('Error fetching images for documentId: $documentId', e);
      if (!_disposed) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateRecentlyViewedProducts(String documentId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email!;
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(email);

        DocumentSnapshot userDoc = await userDocRef.get();
        if (userDoc.exists) {
          List<dynamic> recentlyViewedProducts =
              userDoc['recentlyViewedProducts'] ?? [];

          if (!recentlyViewedProducts.contains(documentId)) {
            if (recentlyViewedProducts.length >= 5) {
              recentlyViewedProducts.removeAt(0);
            }
            recentlyViewedProducts.add(documentId);

            await userDocRef.update({
              'recentlyViewedProducts': recentlyViewedProducts,
            });
          }
        } else {
          await userDocRef.set({
            'recentlyViewedProducts': [documentId],
          });
        }
      }
    } catch (e) {
      _logger.severe('Error updating recently viewed products', e);
    }
  }

  Future<void> fetchRecentlyViewedProducts() async {
    try {
      if (!_disposed) {
        setState(() {
          isRecentlyViewedLoading = true;
        });
      }

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email!;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .get();

        if (userDoc.exists) {
          List<dynamic> recentlyViewedProducts =
              userDoc['recentlyViewedProducts'] ?? [];
          List<Map<String, String>> details = [];

          for (String documentId in recentlyViewedProducts) {
            DocumentSnapshot doc = await FirebaseFirestore.instance
                .collection('items')
                .doc(documentId)
                .get();
            if (doc.exists) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              List<dynamic> imageLocations = data['imageLocation'];
              String imageUrl = await FirebaseStorage.instance
                  .ref(imageLocations[0])
                  .getDownloadURL();
              details.add({'imageUrl': imageUrl, 'documentId': documentId});
            }
          }

          if (!_disposed) {
            setState(() {
              recentlyViewedDetails = details;
              isRecentlyViewedLoading = false;
            });
          }
        } else if (!_disposed) {
          setState(() {
            isRecentlyViewedLoading = false;
          });
        }
      } else if (!_disposed) {
        setState(() {
          isRecentlyViewedLoading = false;
        });
      }
    } catch (e) {
      _logger.severe('Error fetching recently viewed products', e);
      if (!_disposed) {
        setState(() {
          isRecentlyViewedLoading = false;
        });
      }
    }
  }

  Future<void> fetchUsersAlsoViewedProducts(String categoryValue) async {
    try {
      if (!_disposed) {
        setState(() {
          isUsersAlsoViewedLoading = true;
        });
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('category.value', isEqualTo: categoryValue)
          .get();

      List<Map<String, String>> details = [];
      for (var document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        List<dynamic> imageLocations = data['imageLocation'];
        String imageUrl = await FirebaseStorage.instance
            .ref(imageLocations[0])
            .getDownloadURL();
        details.add({'imageUrl': imageUrl, 'documentId': document.id});
      }

      if (!_disposed) {
        setState(() {
          usersAlsoViewedDetails = details;
          isUsersAlsoViewedLoading = false;
        });
      }
    } catch (e) {
      _logger.severe('Error fetching users also viewed products', e);
      if (!_disposed) {
        setState(() {
          isUsersAlsoViewedLoading = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyBag()),
          (Route<dynamic> route) => false,
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
          (Route<dynamic> route) => false,
        );
        break;
    }
  }

  void updateLoadingState({
    bool? nameLoading,
    bool? descriptionLoading,
    bool? dynamicFieldsLoading,
    bool? carouselLoading,
    bool? moreColoursLoading,
  }) {
    if (_disposed) return;

    // Use Future.microtask to defer the setState until the current build phase is complete
    // This avoids "setState() called when widget tree was locked" errors
    Future.microtask(() {
      if (!_disposed && mounted) {
        setState(() {
          if (nameLoading != null) isNameLoading = nameLoading;
          if (descriptionLoading != null)
            isDescriptionLoading = descriptionLoading;
          if (dynamicFieldsLoading != null)
            isDynamicFieldsLoading = dynamicFieldsLoading;
          if (carouselLoading != null) isCarouselLoading = carouselLoading;
          if (moreColoursLoading != null)
            isMoreColoursLoading = moreColoursLoading;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Product Card'),
      body: Column(
        children: [
          if (anyComponentLoading)
            LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
            ),
          Expanded(
            child: imageDetails.isEmpty
                ? Center(child: Text(''))
                : ListView(
                    addAutomaticKeepAlives: true,
                    cacheExtent: 1000,
                    children: <Widget>[
                      ProductName(
                        documentId: currentDocumentId,
                        onLoadingChanged: (isLoading) =>
                            updateLoadingState(nameLoading: isLoading),
                      ),
                      ProductDescription(
                        documentId: currentDocumentId,
                        onLoadingChanged: (isLoading) =>
                            updateLoadingState(descriptionLoading: isLoading),
                      ),
                      ImageCarousel(
                        allImageUrls: allImageUrls,
                        selectedImageIndex: selectedImageIndex,
                        onThumbnailTap: (index) {
                          if (_disposed) return;
                          setState(() {
                            selectedImageIndex = index;
                          });
                          _logger.info(
                              'Thumbnail tapped, selectedImageIndex: $selectedImageIndex');
                        },
                        onLoadingChanged: (isLoading) =>
                            updateLoadingState(carouselLoading: isLoading),
                      ),
                      // Empty box of size 20
                      SizedBox(height: 20),
                      MoreColoursSection(
                        imageDetails: imageDetails,
                        selectedParentImageIndex: selectedParentImageIndex,
                        onThumbnailTap: (index) {
                          if (_disposed) return;
                          setState(() {
                            selectedParentImageIndex = index;
                            currentDocumentId =
                                imageDetails[index]['documentId']!;
                            fetchImages(currentDocumentId);
                            updateRecentlyViewedProducts(currentDocumentId);
                          });
                          _logger.info(
                              'Thumbnail tapped, new documentId: $currentDocumentId');
                        },
                        onLoadingChanged: (isLoading) =>
                            updateLoadingState(moreColoursLoading: isLoading),
                      ),
                      DynamicFieldsDisplay(
                        documentId: currentDocumentId,
                        onLoadingChanged: (isLoading) =>
                            updateLoadingState(dynamicFieldsLoading: isLoading),
                      ),
                      OrderSwatchesButton(
                          documentIds: imageDetails
                              .map((detail) => detail['documentId']!)
                              .toList()),
                      AddToCartButton(
                        documentIds: imageDetails
                            .map((detail) => detail['documentId']!)
                            .toList(),
                      ),
                      const SupportSection(),
                      // Users Also Viewed Section
                      if (usersAlsoViewedDetails.isNotEmpty)
                        UsersAlsoViewedSection(
                          usersAlsoViewedDetails: usersAlsoViewedDetails,
                          onThumbnailTap: (index) {
                            String documentId =
                                usersAlsoViewedDetails[index]['documentId']!;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductCard(documentId: documentId),
                              ),
                            );
                          },
                          onLoadingChanged: (isLoading) {
                            if (_disposed) return;
                            setState(() {
                              isUsersAlsoViewedLoading = isLoading;
                            });
                          },
                        ),
                      SizedBox(height: 20),
                      // Recently Viewed Section
                      if (recentlyViewedDetails.isNotEmpty)
                        RecentlyViewedSection(
                          recentlyViewedDetails: recentlyViewedDetails,
                          onThumbnailTap: (index) {
                            String documentId =
                                recentlyViewedDetails[index]['documentId']!;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductCard(documentId: documentId),
                              ),
                            );
                          },
                          onLoadingChanged: (isLoading) {
                            if (_disposed) return;
                            setState(() {
                              isRecentlyViewedLoading = isLoading;
                            });
                          },
                        ),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedNavIndex, // Use separate variable for nav index
        onItemTapped: (index) {
          if (_disposed) return;
          setState(() {
            selectedNavIndex = index; // Update the nav index
          });
          _onItemTapped(index);
        },
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white54,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Bag'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}

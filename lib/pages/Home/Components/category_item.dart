import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/components/shared/app_image.dart';
import 'package:dyota/pages/Category/category_page.dart';
import 'package:dyota/services/image_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class CategoryItem extends StatelessWidget {
  final int index;
  final Logger _logger = Logger('CategoryItem');

  CategoryItem({super.key, required this.index});

  Future<String> getImageUrl(String imageName) async {
    return await ImageCacheService.instance
            .getImageUrl('categoryPhotos/$imageName') ??
        '';
  }

  Future<List<Map<String, String>>> getCategoryData() async {
    // Fetch category names, image file names, and document IDs from Firestore
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'] as String,
        'imageFileName': doc['imageFileName'] as String,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
        future: getCategoryData(),
        builder: (context, categorySnapshot) {
          if (categorySnapshot.connectionState == ConnectionState.waiting) {
            return Text(''); // Show nothing while waiting for the data
          } else if (categorySnapshot.hasError) {
            throw Exception(
                'Error in categorySnapshot: ${categorySnapshot.error}');
          } else if (!categorySnapshot.hasData ||
              categorySnapshot.data!.isEmpty) {
            _logger.warning('No data found');
            return Text(''); // Handle the case where there is no data
          } else {
            List<Map<String, String>> categoryData = categorySnapshot.data!;

            return FutureBuilder<String>(
                future: getImageUrl(categoryData[index]['imageFileName']!),
                builder: (context, imageSnapshot) {
                  if (imageSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: Text('')); // Show nothing when loading
                  } else if (imageSnapshot.hasError) {
                    throw Exception(
                        'Error in imageSnapshot: ${imageSnapshot.error}');
                  } else if (!imageSnapshot.hasData) {
                    _logger.warning('No image found');
                    return const Center(
                        child: Text('')); // Show no data on screen
                  } else {
                    String imageUrl = imageSnapshot
                        .data!; // The image URL from Firebase Storage
                    return Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to CategoryPage when a category is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryPage(
                                    categoryDocumentId: categoryData[index]
                                        ['id']!, // Pass the document ID
                                  ),
                                ),
                              );
                            },
                            child: AppImage(
                              url: imageUrl,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                8.0), // Add space between the image and the text
                        Text(
                          categoryData[index]['name']!,
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        SizedBox(height: 18.0), // Add space below the text
                      ],
                    );
                  }
                });
          }
        });
  }
}

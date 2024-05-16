import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Category/category_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final int index;

  const CategoryItem({super.key, required this.index});

  Future<String> getImageUrl(String imageName) async {
    // Get the download URL from Firebase Storage
    final ref =
        FirebaseStorage.instance.ref().child('categoryPhotos/$imageName');
    return await ref.getDownloadURL();
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
          return CircularProgressIndicator(); // Show a loading indicator while waiting for the data
        } else if (categorySnapshot.hasError) {
          return Text(
              'Error: ${categorySnapshot.error}'); // Handle the error state
        } else if (!categorySnapshot.hasData ||
            categorySnapshot.data!.isEmpty) {
          return Text(
              'No categories found'); // Handle the case where there is no data
        } else {
          List<Map<String, String>> categoryData = categorySnapshot.data!;

          return FutureBuilder<String>(
            future: getImageUrl(categoryData[index]['imageFileName']!),
            builder: (context, imageSnapshot) {
              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator while waiting for the data
              } else if (imageSnapshot.hasError) {
                return Text(
                    'Error: ${imageSnapshot.error}'); // Handle the error state
              } else if (!imageSnapshot.hasData) {
                return Text(
                    'No image found'); // Handle the case where there is no data
              } else {
                String imageUrl =
                    imageSnapshot.data!; // The image URL from Firebase Storage
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              15.0), // Set the border radius here
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                            8.0), // Add space between the image and the text
                    Text(
                      categoryData[index]['name']!,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    SizedBox(height: 18.0), // Add space below the text
                  ],
                );
              }
            },
          );
        }
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Home/Components/category_item.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  Future<List<DocumentSnapshot>> getCategoryDocuments() async {
    // Fetch category documents from Firestore
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: getCategoryDocuments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting for the data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle the error state
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(
              'No categories found'); // Handle the case where there is no data
        } else {
          List<DocumentSnapshot> categoryDocuments = snapshot.data!;

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
            ),
            itemCount: categoryDocuments
                .length, // Set item count based on the number of documents
            itemBuilder: (context, index) => CategoryItem(index: index),
          );
        }
      },
    );
  }
}

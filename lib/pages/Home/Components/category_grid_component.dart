import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Home/Components/category_item.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class CategoryGrid extends StatefulWidget {
  final Function(bool)? onLoadingChanged;

  const CategoryGrid({super.key, this.onLoadingChanged});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  final Logger _logger = Logger('CategoryGridComponent');
  Future<List<DocumentSnapshot>> _categoryDocumentsFuture = Future.value([]);
  bool _loadingNotified = false;

  @override
  void initState() {
    super.initState();
    // Memoize the future to prevent rebuilds from recreating it
    _categoryDocumentsFuture = getCategoryDocuments();
  }

  Future<List<DocumentSnapshot>> getCategoryDocuments() async {
    // Only signal loading if we haven't already
    if (!_loadingNotified) {
      _loadingNotified = true;
      widget.onLoadingChanged?.call(true);
    }

    try {
      // Fetch category documents from Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      // Signal loading finished
      widget.onLoadingChanged?.call(false);
      return snapshot.docs;
    } catch (e) {
      // Signal loading finished even on error
      widget.onLoadingChanged?.call(false);
      _logger.severe('Error fetching categories: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _categoryDocumentsFuture, // Use the memoized future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(); // Show nothing while waiting for the data
        } else if (snapshot.hasError) {
          _logger.severe('Error in snapshot: ${snapshot.error}');
          return Text(''); // Handle the error state
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          _logger.severe('No data found');
          return Text(''); // Handle the case where there is no data
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

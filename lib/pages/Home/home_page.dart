import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Home/Components/app_bar_component.dart';
import 'package:dyota/pages/Home/Components/best_seller_header.dart';
import 'package:dyota/pages/Home/Components/category_grid_component.dart';
import 'package:dyota/pages/Home/Components/category_header_component.dart';
import 'package:dyota/pages/Home/Components/product_grid_component.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final Logger _logger = Logger('HomePage');

  Future<List<String>> getDocumentIdsShownOnHomePage() async {
    List<String> documentIds = [];
    try {
      // Reference to the Firestore collection
      CollectionReference itemsCollection =
          FirebaseFirestore.instance.collection('items');

      // Query to get documents where isShownOnHomePage is 1
      QuerySnapshot querySnapshot =
          await itemsCollection.where('isShownOnHomePage', isEqualTo: 1).get();

      // Iterate through each document and add the document ID to the list
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        documentIds.add(doc.id);
      }
      _logger.info('Successfully fetched document IDs: $documentIds');
    } catch (e) {
      _logger.severe('Error fetching document IDs', e);
      rethrow;
    }
    return documentIds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder<List<String>>(
        future: getDocumentIdsShownOnHomePage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
            );
          }
          if (snapshot.hasError) {
            _logger.severe('Error in FutureBuilder', snapshot.error);
            return const Center(child: Text(''));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            _logger.info('No items to display');
            return const Center(child: Text(''));
          }

          List<String> documentIds = snapshot.data!;
          _logger.info('Document IDs to display: $documentIds');
          try {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[300],
                    child: Column(
                      children: [
                        CategoryHeader(),
                        CategoryGrid(),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Column(
                      children: [
                        BestSellerHeader(),
                        ProductGrid(documentIds: documentIds),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } catch (e) {
            _logger.severe('Error building widget tree', e);
            return const Center(child: Text(''));
          }
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyota/pages/Home/Components/app_bar_component.dart';
import 'package:dyota/pages/Home/Components/best_seller_header.dart';
import 'package:dyota/pages/Home/Components/category_grid_component.dart';
import 'package:dyota/pages/Home/Components/category_header_component.dart';
import 'package:dyota/pages/Home/Components/product_grid_component.dart';
import 'package:dyota/pages/My_Bag/my_bag.dart';
import 'package:dyota/pages/Profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final Logger _logger = Logger('HomePage');

  Future<List<String>> getDocumentIdsShownOnHomePage() async {
    List<String> documentIds = [];

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

    return documentIds;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyBag()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder<List<String>>(
        future: getDocumentIdsShownOnHomePage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text(''));
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
            _logger.severe('Error building widget tree for homepage:', e);
            return const Center(child: Text(''));
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 0, // Set the current index as needed
        onItemTapped: (index) => _onItemTapped(context, index),
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
      selectedItemColor: Colors.white,
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

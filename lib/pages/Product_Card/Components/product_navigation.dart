import 'package:dyota/pages/Home/home_page.dart';
import 'package:dyota/pages/My_Bag/my_bag.dart';
import 'package:dyota/pages/Product_Card/product_card.dart';
import 'package:dyota/pages/Profile/profile_page.dart';
import 'package:flutter/material.dart';

/// Handles navigation from the Product Card to other screens
class ProductNavigation {
  /// Navigates to the specified main app section (Home, Bag, Profile)
  static void navigateToMainSection(BuildContext context, int index) {
    final navigationTargets = [
      const HomePage(),
      MyBag(),
      const ProfileScreen(),
    ];

    if (index >= 0 && index < navigationTargets.length) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => navigationTargets[index]),
        (Route<dynamic> route) => false,
      );
    }
  }

  /// Navigates to another product card
  static void navigateToProduct(BuildContext context, String documentId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProductCard(documentId: documentId),
      ),
    );
  }
}

/// Custom bottom navigation bar for the Product Card screen
class ProductBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const ProductBottomNavigationBar({
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

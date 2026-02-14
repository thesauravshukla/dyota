import 'package:dyota/pages/Home/home_page.dart';
import 'package:dyota/pages/Cart/cart.dart';
import 'package:dyota/pages/Product_Card/product_card.dart';
import 'package:dyota/pages/Profile/profile_page.dart';
import 'package:flutter/material.dart';

/// Handles navigation from the Product Card to other screens.
class ProductNavigation {
  static void navigateToMainSection(BuildContext context, int index) {
    final targets = [
      const HomePage(),
      Cart(),
      const ProfileScreen(),
    ];

    if (index >= 0 && index < targets.length) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => targets[index]),
        (_) => false,
      );
    }
  }

  static void navigateToProduct(BuildContext context, String documentId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ProductCard(documentId: documentId),
      ),
    );
  }
}

import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/pages/Home/Components/app_bar_component.dart';
import 'package:dyota/pages/Home/Components/category_grid_component.dart';
import 'package:dyota/pages/Home/Components/category_header_component.dart';
import 'package:dyota/pages/Home/Components/offer_banner_component.dart';
import 'package:dyota/pages/Home/Components/product_grid_component.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OfferBanner(
                text: 'Special Offer Banner',
                color: const Color.fromARGB(255, 242, 101, 101)),
            Container(
              color: Colors.grey[300],
              child: Column(
                children: [
                  CategoryHeader(),
                  CategoryGrid(),
                ],
              ),
            ),
            ProductGrid(),
            OfferBanner(
                text: 'Offer #2 blah blah blah blah blah blah',
                color: Colors.yellowAccent[700]),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

import 'package:dyota/pages/Home/Components/app_bar_component.dart';
import 'package:dyota/pages/Home/Components/category_grid_component.dart';
import 'package:dyota/pages/Home/Components/category_header_component.dart';
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
          ],
        ),
      ),
    );
  }
}

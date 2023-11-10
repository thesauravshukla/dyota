import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 80.0),
          child: Text('dyota',
              style: TextStyle(fontFamily: 'AlfaSlab', fontSize: 25.0)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16.0),
            child: IconButton(
                icon: Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {}),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 15.0),
                  child: Container(
                    height: 35.0,
                    width: 298.31,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black),
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildOfferBanner(context),
            Container(
              color: Colors.grey[300], // Grey background for categories
              child: Column(
                children: [
                  _buildCategoryHeader(context),
                  _buildCategoryGrid(context),
                ],
              ),
            ),
            _buildProductGrid(context),
            _buildSecondOfferBanner(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildOfferBanner(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Special Offer Banner',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Categories',
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, childAspectRatio: 1),
      itemCount: 8,
      itemBuilder: (context, index) => CategoryItem(index: index),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.75),
      itemCount: 4,
      itemBuilder: (context, index) => ProductItem(index: index),
    );
  }

  Widget _buildSecondOfferBanner(BuildContext context) {
    return Container(
      color: Colors.yellowAccent[700],
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Offer #2 blah blah blah blah blah blah',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket), label: 'Shop'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Bag'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border), label: 'Favorites'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  final int index;

  CategoryItem({required this.index});

  @override
  Widget build(BuildContext context) {
    List<String> categoryNames = [
      "Category #1",
      "Category #2",
      "Category #3",
      "Category #4",
      "Category #5",
      "Category #6",
      "Category #7",
      "Category #8"
    ];
    return Column(
      children: [
        Expanded(
          child: IconButton(
            icon: Icon(Icons.category, size: 50),
            color: Colors.grey[800],
            onPressed: () {},
          ),
        ),
        Text(
          categoryNames[index],
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }
}

class ProductItem extends StatelessWidget {
  final int index;

  ProductItem({required this.index});

  @override
  Widget build(BuildContext context) {
    List<String> productNames = [
      "Item name #1",
      "Item name #2",
      "Item name #3",
      "Item name #4"
    ];
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.blue, // Placeholder for product images
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productNames[index % productNames.length],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('From Price'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

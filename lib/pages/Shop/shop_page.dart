import 'package:dyota/pages/Shop/Components/category_appbar.dart';
import 'package:dyota/pages/Shop/Components/category_list.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  @override
  _MyShopState createState() => _MyShopState();
}

class _MyShopState extends State<ShopPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CategoryAppBar(tabController: _tabController),
      body: TabBarView(
        controller: _tabController,
        children: [
          CategoryList(
            statuses: [
              'New Arrival',
              'Popular',
              'Sale',
              'Trending',
              'Last Chance',
            ],
          ),
          CategoryList(
            statuses: [
              'New Arrival',
              'Popular',
              'Sale',
              'Trending',
              'Last Chance',
            ],
          ),
          CategoryList(
            statuses: [
              'New Arrival',
              'Popular',
              'Sale',
              'Trending',
              'Last Chance',
            ],
          ),
        ],
      ),
    );
  }
}

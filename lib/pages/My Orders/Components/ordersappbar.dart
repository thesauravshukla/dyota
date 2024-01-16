import 'package:flutter/material.dart';

class OrdersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  OrdersAppBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(color: Colors.white),
      backgroundColor: Colors.black,
      title: Text(
        'My Orders',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.black),
          onPressed: () {
            // Handle search action
          },
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {
            // Handle more actions
          },
        ),
      ],
      bottom: OrdersTabBar(tabController: tabController),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}

class OrdersTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  OrdersTabBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: Colors.white, // Set text color to black
      indicatorColor: Colors.white,
      unselectedLabelColor: Colors.white,
      labelStyle: TextStyle(fontSize: 16.0), // Set highlight color to white
      tabs: <Widget>[
        Tab(text: 'Delivered'),
        Tab(text: 'Processing'),
        Tab(text: 'Cancelled'),
        // Add more tabs if you have them
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

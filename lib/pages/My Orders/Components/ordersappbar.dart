import 'package:dyota/pages/My%20Orders/Components/ordersapptoolbar.dart';
import 'package:flutter/material.dart';

class OrdersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  OrdersAppBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(color: Colors.black),
      backgroundColor: Colors.white,
      title: Text(
        'My Orders',
        style: TextStyle(color: Colors.black),
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

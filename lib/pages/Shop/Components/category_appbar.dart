import 'package:dyota/pages/Shop/Components/category_app_toolbar.dart';
import 'package:flutter/material.dart';

class CategoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  CategoryAppBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(color: Colors.black),
      backgroundColor: Colors.white,
      title: Text(
        'Shop',
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
      bottom: CategoryTabBar(tabController: tabController),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}

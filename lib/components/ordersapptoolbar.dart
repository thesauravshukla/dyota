import 'package:flutter/material.dart';

import 'rounded_rect_tab_indicator.dart';

class OrdersTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  OrdersTabBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      tabs: [
        Tab(text: 'Delivered'),
        Tab(text: 'Processing'),
        Tab(text: 'Cancelled'),
      ],
      indicator: PaddedRoundedRectTabIndicator(
        color: Colors.black,
        radius: 40,
        padding: EdgeInsets.symmetric(vertical: 4),
        width: 100,
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.black,
      labelStyle: TextStyle(fontSize: 16),
      unselectedLabelStyle: TextStyle(fontSize: 16),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kTextTabBarHeight);
}

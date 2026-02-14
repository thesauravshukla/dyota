import 'package:flutter/material.dart';

import 'rounded_rect_tab_indicator.dart';

class OrdersTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const OrdersTabBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      tabs: [
        Tab(text: 'Delivered'),
        Tab(text: 'Pending'),
        Tab(text: 'Cancelled'),
      ],
      indicator: PaddedRoundedRectTabIndicator(
        color: Theme.of(context).colorScheme.primary,
        radius: 40,
        padding: EdgeInsets.symmetric(vertical: 4),
        width: 100,
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Theme.of(context).colorScheme.primary,
      unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
      labelStyle: TextStyle(fontSize: 16),
      unselectedLabelStyle: TextStyle(fontSize: 16),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kTextTabBarHeight);
}

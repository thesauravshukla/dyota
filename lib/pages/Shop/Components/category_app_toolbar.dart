import 'package:flutter/material.dart';

import 'rounded_rect_tab_indicator.dart';

class CategoryTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const CategoryTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      tabs: const [
        Tab(text: 'Men'),
        Tab(text: 'Women'),
        Tab(text: 'Children'),
      ],
      indicator: const PaddedRoundedRectTabIndicator(
        color: Colors.black,
        radius: 40,
        padding: EdgeInsets.symmetric(vertical: 4),
        width: 100,
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.black,
      labelStyle: const TextStyle(fontSize: 16),
      unselectedLabelStyle: const TextStyle(fontSize: 16),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}

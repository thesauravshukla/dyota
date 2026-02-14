import 'package:flutter/material.dart';

class OrdersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const OrdersAppBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(),
      title: const Text('My Orders'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
          tooltip: 'Search orders',
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurface),
          tooltip: 'More options',
          onPressed: () {},
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
      labelColor: Theme.of(context).colorScheme.primary,
      indicatorColor: Theme.of(context).colorScheme.primary,
      unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
      labelStyle: TextStyle(fontSize: 16.0),
      tabs: const <Widget>[
        Tab(text: 'Delivered'),
        Tab(text: 'Pending'),
        Tab(text: 'Cancelled'),
        // Add more tabs if you have them
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

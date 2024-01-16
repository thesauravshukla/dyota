import 'package:dyota/pages/My%20Orders/Components/orderlist.dart';
import 'package:dyota/pages/My%20Orders/Components/ordersappbar.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
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
      appBar: OrdersAppBar(tabController: _tabController),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OrderList(status: 'Delivered'),
          OrderList(status: 'Processing'),
          OrderList(status: 'Cancelled'),
          // Add more pages if you have them
        ],
      ),
    );
  }
}

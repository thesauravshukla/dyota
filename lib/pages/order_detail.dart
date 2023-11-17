import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/components/order_appbar.dart';
import 'package:dyota/components/order_list_view.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderAppBar(),
      body: OrderListView(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

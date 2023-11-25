import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/pages/Order_Detail/Components/order_list_view.dart';
import 'package:flutter/material.dart';

import '../../components/generic_appbar.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Orders'),
      body: OrderListView(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

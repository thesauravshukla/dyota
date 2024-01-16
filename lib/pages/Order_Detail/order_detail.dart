import 'package:dyota/components/bottom_navigation_bar_component.dart';
import 'package:dyota/pages/Order_Detail/Components/order_list_view.dart';
import 'package:flutter/material.dart';

import '../../components/generic_appbar.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: genericAppbar(title: 'Orders'),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          OrderListView(),
          // Add more pages if you have them
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

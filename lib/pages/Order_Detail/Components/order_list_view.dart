import 'package:dyota/pages/Order_Detail/Components/action_buttons.dart';
import 'package:dyota/pages/Order_Detail/Components/item_list.dart';
import 'package:dyota/pages/Order_Detail/Components/order_header.dart';
import 'package:dyota/pages/Order_Detail/Components/order_information.dart';
import 'package:flutter/material.dart';

class OrderListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        OrderHeader(),
        ItemList(),
        OrderInformation(),
        ActionButtons(),
      ],
    );
  }
}

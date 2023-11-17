import 'package:dyota/components/action_buttons.dart';
import 'package:dyota/components/item_list.dart';
import 'package:dyota/components/order_header.dart';
import 'package:dyota/components/order_information.dart';
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

import 'package:dyota/pages/My_Orders/Components/order_card.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  final String status;

  const OrderList({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return OrderCard(status: status);
      },
    );
  }
}

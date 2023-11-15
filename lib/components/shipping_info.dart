import 'package:flutter/material.dart';

class ShippingInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        title: Text('Shipping info'),
        onTap: () {
          // TODO: Handle shipping info tap
        },
      ),
    );
  }
}

import 'package:dyota/components/detail_item.dart';
import 'package:flutter/material.dart';

class ProductDetailsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          DetailItem(title: 'title1', value: 'value1'),
          DetailItem(title: 'title2', value: 'value2'),
          DetailItem(title: 'title3', value: 'value3'),
          DetailItem(title: 'title4', value: 'value4'),
          DetailItem(title: 'title5', value: 'value5'),
        ],
      ),
    );
  }
}

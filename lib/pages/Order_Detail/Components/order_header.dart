import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = TextStyle(color: Colors.grey[600]);
    TextStyle detailStyle = TextStyle(color: Colors.black, fontSize: 16);
    TextStyle statusStyle = TextStyle(
        color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order №1947034',
                style: detailStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '05-12-2019',
                style: headingStyle,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Tracking number: ',
                style: headingStyle,
              ),
              Text(
                'IW3475453455',
                style: detailStyle,
              ),
              Spacer(),
              Text(
                'Delivered',
                style: statusStyle,
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('3 items',
              style: detailStyle.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

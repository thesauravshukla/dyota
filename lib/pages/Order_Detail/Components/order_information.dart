import 'package:flutter/material.dart';

class OrderInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle =
        TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold);
    TextStyle detailStyle = TextStyle(color: Theme.of(context).colorScheme.onSurface);

    Widget infoRow(String heading, String detail) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$heading: ', style: headingStyle),
          Expanded(child: Text(detail, style: detailStyle)),
        ],
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order information',
              style: headingStyle.copyWith(color: Theme.of(context).colorScheme.onSurface)),
          SizedBox(height: 15),
          infoRow('Shipping Address',
              '3 Newbridge Court, Chino Hills, CA 91709, United States'),
          SizedBox(height: 15),
          infoRow('Payment method', 'Mastercard **** 3947'),
          SizedBox(height: 15),
          infoRow('Delivery method', 'FedEx, 3 days, 15\$'),
          SizedBox(height: 15),
          infoRow('Discount', '10%, Personal promo code'),
          SizedBox(height: 15),
          infoRow('Total Amount', '133\$'),
        ],
      ),
    );
  }
}

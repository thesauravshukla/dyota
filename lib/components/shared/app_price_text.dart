import 'package:flutter/material.dart';

class AppPriceText extends StatelessWidget {
  final dynamic amount;
  final TextStyle? style;

  const AppPriceText({Key? key, required this.amount, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(_format(), style: style);
  }

  String _format() {
    if (amount is double) {
      return 'Rs. ${amount.toStringAsFixed(2)}';
    }
    return 'Rs. $amount';
  }
}

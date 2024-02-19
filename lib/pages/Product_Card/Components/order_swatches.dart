import 'package:flutter/material.dart';

class OrderSwatchesButton extends StatelessWidget {
  const OrderSwatchesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Handle add to cart button press
        },
        child: Text('ORDER SWATCHES'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 15),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PaymentSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.credit_card,
                    color: Colors.black), // Replace with your card brand icon
                SizedBox(width: 8),
                Text('**** **** **** 3947'),
              ],
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement change payment logic
              },
              style: TextButton.styleFrom(
                primary: Colors
                    .black, // This is the color of the text (button label)
              ),
              child: Text('Change'),
            ),
          ],
        ),
      ),
    );
  }
}

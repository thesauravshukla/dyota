import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String status;

  const OrderCard({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners for the Card
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Order No. 1947034',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Tracking number: IW3475453455'),
            SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Quantity: 3'),
                Text(
                  'Total Amount: 112\$',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Handle details action
              },
              child: Text('Details'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle status action
                },
                style: TextButton.styleFrom(
                  foregroundColor:
                      status == 'Delivered' ? Colors.green : Colors.black,
                ),
                child: Text(status),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

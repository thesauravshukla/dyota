import 'package:flutter/material.dart';

class TotalAmountSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Total amount:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('124\$',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Colors.black, // Button color
              onPrimary: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text('CHECK OUT'),
          ),
        ],
      ),
    );
  }
}

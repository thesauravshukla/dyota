import 'package:flutter/material.dart';

class AddressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      elevation: 2, // A little shadow
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Align items at the start of cross axis
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black, // Default text color
                    height: 1.5, // Line height
                    fontSize: 16, // Font size for address text
                  ),
                  children: [
                    TextSpan(
                      text: 'Jane Doe\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          '3 Newbridge Court\nChino Hills, CA 91709, United States',
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // TODO: Implement change address logic
              },
              child: Padding(
                padding: EdgeInsets.only(
                    top: 4.0), // Align with the first line of text
                child: Text(
                  'Change',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

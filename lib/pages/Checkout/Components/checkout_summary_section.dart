import 'package:dyota/pages/Settings/Components/section_title.dart';
import 'package:flutter/material.dart';

class SummarySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: 'Summary'),
          SizedBox(height: 12), // Increased line spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order:', style: TextStyle(fontSize: 16)),
              Text('112', style: TextStyle(fontSize: 16)),
            ],
          ),
          SizedBox(height: 12), // Increased line spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery:', style: TextStyle(fontSize: 16)),
              Text('15', style: TextStyle(fontSize: 16)),
            ],
          ),
          SizedBox(height: 12), // Increased spacing before the total
          Divider(thickness: 1), // A divider line to separate the summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Summary:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('127',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 24), // Space after the summary for the submit button
        ],
      ),
    );
  }
}
